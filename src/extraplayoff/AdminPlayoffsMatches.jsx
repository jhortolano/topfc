import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';
import { verificarYObtenerRankingLiguilla, procesarYPublicarPlayoffs, promocionarGanadorPlayoff, analizarEstructuraPlayoffs } from '../utils/playoffLogic';

export default function AdminPlayoffsMatches({ torneo, profiles, onClose }) {
  const [partidos, setPartidos] = useState([]);
  const [editados, setEditados] = useState({});
  const [loading, setLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(null);
  const [isPublishing, setIsPublishing] = useState(false); // Nuevo estado para el botón

  const ORDEN_FASES = {
    'DIECISEISAVOS': 1,
    'OCTAVOS': 2,
    'CUARTOS': 3,
    'SEMIS': 4,
    'FINAL': 5
  };

  useEffect(() => {
    fetchPartidos();
  }, [torneo.id]);

  const fetchPartidos = async () => {
    setLoading(true);
    const cleanId = torneo.id.toString().replace('extra-', '');

    try {
      // 1. Cargar Liguilla
      const { data: liguilla, error: errL } = await supabase
        .from('extra_matches')
        .select(`
                *,
                p1:profiles!player1_id(nick),
                p2:profiles!player2_id(nick),
                extra_groups(nombre_grupo)
              `)
        .eq('extra_id', cleanId)
        .order('id', { ascending: true });

      if (errL) throw errL;

      // 2. Cargar Eliminatorias (para que se vean las fases)
      const { data: eliminatorias, error: errE } = await supabase
        .from('v_extra_playoffs_bracket_dinamico')
        .select('*')
        .eq('playoff_extra_id', cleanId);

      if (errE) throw errE;

      const liguillaNormalizada = (liguilla || []).map(p => ({
        ...p,
        unique_key: `lig-${p.id}`,
        esEliminatoria: false,
        grupo: p.extra_groups,
        display_nick1: p.p1?.nick || 'TBD',
        display_nick2: p.p2?.nick || 'TBD',
        fase_name: p.fase || p.numero_jornada
      }));

      const elimsNormalizadas = (eliminatorias || []).map((p, index) => ({
        ...p,
        unique_key: `el-${p.id || index}`,
        esEliminatoria: true,
        grupo: { nombre_grupo: "Eliminatorias" },
        display_nick1: p.p1_nick || 'TBD',
        display_nick2: p.p2_nick || 'TBD',
        fase_name: p.numero_jornada
      }));
      const listaCompleta = [...liguillaNormalizada, ...elimsNormalizadas]; // 1. La definimos
      setPartidos([...liguillaNormalizada, ...elimsNormalizadas]);
      setLoading(false);
      return listaCompleta;
    } catch (error) {
      setLoading(false);
      console.error("Error cargando partidos:", error);
      return [];
    }
  };

  const guardarCambios = async (uniqueKey, matchId) => {
    const cambios = editados[uniqueKey];
    if (!cambios || isSaving) return;

    setIsSaving(uniqueKey);
    const partidoOriginal = partidos.find(p => p.unique_key === uniqueKey);
    const tabla = partidoOriginal?.esEliminatoria ? 'extra_playoffs_matches' : 'extra_matches';
    const cleanId = torneo.id.toString().replace('extra-', '');

    const updateData = { ...cambios, is_played: true };

    try {
      const { error } = await supabase.from(tabla).update(updateData).eq('id', matchId);
      if (error) throw error;

      setEditados(prev => {
        const n = { ...prev };
        delete n[uniqueKey];
        return n;
      });

      const partidosActualizados = await fetchPartidos();

      if (partidoOriginal?.esEliminatoria) {
        // 4. CAMBIO CLAVE: Buscamos el partido directamente de lo que acaba de venir de la DB,
        // no de una variable inventada localmente.
        const partidoDeDB = partidosActualizados?.find(p => p.id === matchId);

        if (partidoDeDB) {
          await promocionarGanadorPlayoff(cleanId, partidoDeDB);
          // 5. Volvemos a refrescar para ver al ganador en la siguiente fase
          await fetchPartidos();
        }
      } else {
        const res = await procesarYPublicarPlayoffs(cleanId);
        if (res?.success) await fetchPartidos();
      }

    } catch (error) {
      alert("Error al guardar: " + error.message);
    } finally {
      setIsSaving(null);
    }
  };

  const resetPartido = async (uniqueKey, matchId) => {
    if (!confirm("¿Borrar el resultado?")) return;
    setIsSaving(uniqueKey);
    const partidoOriginal = partidos.find(p => p.unique_key === uniqueKey);
    const tabla = partidoOriginal?.esEliminatoria ? 'extra_playoffs_matches' : 'extra_matches';

    try {
      const { error } = await supabase
        .from(tabla)
        .update({ score1: null, score2: null, is_played: false })
        .eq('id', matchId);

      if (error) throw error;

      setEditados(prev => {
        const n = { ...prev };
        delete n[uniqueKey];
        return n;
      });
      await fetchPartidos();
    } catch (error) {
      alert("Error al resetear: " + error.message);
    } finally {
      setIsSaving(null);
    }
  };

  const handleLocalChange = (uniqueKey, campo, valor) => {
    setEditados(prev => ({
      ...prev,
      [uniqueKey]: { ...(prev[uniqueKey] || {}), [campo]: valor }
    }));
  };

  /**
     * NUEVA FUNCIÓN OPTIMIZADA
     * Busca la fecha en config_fechas normalizando la clave
     */
  const obtenerInfoFecha = (key) => {
    const config = torneo.config_fechas || {};
    if (!key) return null;

    // 1. Intentar búsqueda directa
    let rango = config[key];

    // 2. Si no existe, normalizar (Ej: de "OCTAVOS IDA" a "octavos_ida")
    if (!rango) {
      const normalKey = key.toLowerCase().replace(/\s+/g, '_');
      rango = config[normalKey];
    }

    // 3. Si sigue sin existir, buscar por aproximación (insensible a mayúsculas/guiones)
    if (!rango) {
      const searchKey = key.toLowerCase().replace(/[\s_]+/g, '');
      const foundKey = Object.keys(config).find(k =>
        k.toLowerCase().replace(/[\s_]+/g, '') === searchKey
      );
      if (foundKey) rango = config[foundKey];
    }

    if (!rango || !rango.start_at || !rango.end_at) return null;

    const f1 = new Date(rango.start_at);
    const f2 = new Date(rango.end_at);

    // Formato: 13 Mar al 20 Mar
    const opciones = { day: '2-digit', month: 'short' };
    return `${f1.toLocaleDateString('es-ES', opciones)} al ${f2.toLocaleDateString('es-ES', opciones)}`;
  };

  const obtenerGruposOrdenados = (nombres) => {
    return [...nombres].sort((a, b) => {
      if (a === "Eliminatorias") return 1;
      if (b === "Eliminatorias") return -1;
      return a.localeCompare(b);
    });
  };

  const obtenerLlavesOrdenadas = (keys, nombreGrupo) => {
    const config = torneo.config_fechas || {};

    return [...keys].sort((a, b) => {
      if (nombreGrupo === "Eliminatorias") {
        // Buscamos la coincidencia en nuestro mapa de orden (ignorando IDA/VUELTA)
        const pesoA = ORDEN_FASES[Object.keys(ORDEN_FASES).find(f => a.toUpperCase().includes(f))] || 99;
        const pesoB = ORDEN_FASES[Object.keys(ORDEN_FASES).find(f => b.toUpperCase().includes(f))] || 99;

        if (pesoA !== pesoB) return pesoA - pesoB;

        // Si son la misma fase (ej: Octavos IDA y Octavos VUELTA), IDA va primero
        if (a.includes('IDA') && b.includes('VUELTA')) return -1;
        if (a.includes('VUELTA') && b.includes('IDA')) return 1;
      }

      // --- SOLUCIÓN PARA LIGUILLA (J1, J2, J3...) ---
      // Extraemos solo los números de la llave (ej: "j1" -> 1, "j10" -> 10)
      const numA = parseInt(a.replace(/\D/g, ''));
      const numB = parseInt(b.replace(/\D/g, ''));

      // Si ambos tienen número (son tipo J1, J2...), ordenamos numéricamente
      if (!isNaN(numA) && !isNaN(numB)) {
        return numA - numB;
      }

      // Orden por fecha para la Liguilla normal
      const fechaA = config[a]?.start_at ? new Date(config[a].start_at).getTime() : 0;
      const fechaB = config[b]?.start_at ? new Date(config[b].start_at).getTime() : 0;
      return fechaA - fechaB;
    });
  };

  const partidosPorGrupoYFecha = partidos.reduce((acc, p) => {
    const nombreGrupo = p.grupo?.nombre_grupo || "Eliminatorias";
    const fecha = p.fase_name || "Sin Fecha";
    if (!acc[nombreGrupo]) acc[nombreGrupo] = {};
    if (!acc[nombreGrupo][fecha]) acc[nombreGrupo][fecha] = [];
    acc[nombreGrupo][fecha].push(p);
    return acc;
  }, {});

  if (loading) return <p style={{ padding: '20px' }}>Cargando gestión de partidos...</p>;

  return (
    <div style={{ color: '#333' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
        <h5 style={{ margin: 0, color: '#9b59b6' }}>📝 Gestión Manual de Resultados</h5>
        <button onClick={onClose} style={{ background: '#eee', border: 'none', cursor: 'pointer', padding: '5px 10px', borderRadius: '4px' }}>✕ Cerrar</button>
      </div>

      {obtenerGruposOrdenados(Object.keys(partidosPorGrupoYFecha)).map(nombreGrupo => (
        <div key={`grupo-${nombreGrupo}`} style={{ marginBottom: '30px', border: '1px solid #ddd', borderRadius: '8px', overflow: 'hidden' }}>
          <div style={{
            background: nombreGrupo === "Eliminatorias" ? "#34495e" : "#9b59b6",
            color: 'white', padding: '10px 15px', fontSize: '0.85rem', fontWeight: 'bold'
          }}>
            {nombreGrupo === "Eliminatorias" ? "FASE FINAL" : `GRUPO: ${nombreGrupo}`}
          </div>

          <div style={{ padding: '10px', background: '#fcfcfc' }}>
            {obtenerLlavesOrdenadas(Object.keys(partidosPorGrupoYFecha[nombreGrupo]), nombreGrupo).map(fechaKey => {
              const textoRango = obtenerInfoFecha(fechaKey);
              return (
                <div key={`fecha-${nombreGrupo}-${fechaKey}`} style={{ marginBottom: '15px' }}>
                  <div style={{ display: 'flex', alignItems: 'baseline', gap: '10px', borderBottom: '1px solid #eee', marginBottom: '8px' }}>
                    <span style={{ fontSize: '0.7rem', color: '#444', fontWeight: 'bold', textTransform: 'uppercase' }}>
                      🗓️ {fechaKey.replace('_', ' ')}
                    </span>
                    {textoRango && <span style={{ fontSize: '0.65rem', color: '#888' }}>({textoRango})</span>}
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    {partidosPorGrupoYFecha[nombreGrupo][fechaKey]
                      .sort((a, b) => a.id - b.id)
                      .map(m => {
                        const esBye = m.esEliminatoria && m.is_played && (m.player1_id === null || m.player2_id === null);
                        const tieneCambios = !!editados[m.unique_key];
                        const valP1 = editados[m.unique_key]?.score1 !== undefined ? editados[m.unique_key].score1 : (m.score1 ?? '');
                        const valP2 = editados[m.unique_key]?.score2 !== undefined ? editados[m.unique_key].score2 : (m.score2 ?? '');
                        const valStream = editados[m.unique_key]?.stream_url !== undefined ? editados[m.unique_key].stream_url : (m.stream_url || '');

                        return (
                          <div key={m.unique_key} style={{
                            display: 'grid',
                            gridTemplateColumns: '1.2fr 100px 1.2fr 1.5fr 80px',
                            gap: '10px',
                            alignItems: 'center',
                            // Cambiamos el fondo si es BYE para dar el distintivo visual
                            background: esBye ? '#f0f0f0' : (tieneCambios ? '#fffbe6' : '#fff'),
                            padding: '10px',
                            borderRadius: '8px',
                            border: '1px solid #eee',
                            fontSize: '0.85rem',
                            opacity: esBye ? 0.8 : 1 // Un poco de transparencia para denotar "bloqueado"
                          }}>
                            <div style={{
                              textAlign: 'right',
                              fontWeight: valP1 > valP2 ? 'bold' : 'normal',
                              color: esBye ? '#777' : 'inherit'
                            }}>{m.display_nick1}</div>
                            <div style={{ display: 'flex', gap: '5px', justifyContent: 'center' }}>
                              <input type="number" value={valP1}
                                disabled={esBye} // Deshabilitar si es BYE
                                onChange={e => handleLocalChange(m.unique_key, 'score1', e.target.value === '' ? null : parseInt(e.target.value))}
                                style={{ width: '40px', textAlign: 'center', cursor: esBye ? 'not-allowed' : 'auto' }}
                              />
                              <input
                                type="number"
                                value={valP2}
                                disabled={esBye} // Deshabilitar si es BYE
                                onChange={e => handleLocalChange(m.unique_key, 'score2', e.target.value === '' ? null : parseInt(e.target.value))}
                                style={{ width: '40px', textAlign: 'center', cursor: esBye ? 'not-allowed' : 'auto' }}
                              />
                            </div>
                            <div style={{
                              textAlign: 'left',
                              fontWeight: valP2 > valP1 ? 'bold' : 'normal',
                              color: esBye ? '#777' : 'inherit'
                            }}>
                              {m.display_nick2}
                              {esBye && <span style={{ fontSize: '0.6rem', marginLeft: '5px', color: '#9b59b6' }}>[BYE]</span>}
                            </div>
                            <input
                              type="text"
                              placeholder={esBye ? "No disponible" : "Stream..."}
                              value={valStream}
                              disabled={esBye} // Deshabilitar si es BYE
                              onChange={e => handleLocalChange(m.unique_key, 'stream_url', e.target.value)}
                              style={{ fontSize: '0.75rem', padding: '5px', cursor: esBye ? 'not-allowed' : 'auto' }}
                            />
                            <div style={{ display: 'flex', gap: '4px' }}>
                              {/* Si es BYE, no mostramos botones o los deshabilitamos */}
                              {!esBye && (
                                tieneCambios ? (
                                  <button onClick={() => guardarCambios(m.unique_key, m.id)} disabled={isSaving !== null} style={{ background: '#2ecc71', color: 'white', border: 'none', borderRadius: '4px', padding: '5px 8px', cursor: 'pointer' }}>
                                    {isSaving === m.unique_key ? '⏳' : '💾'}
                                  </button>
                                ) : (
                                  <button onClick={() => resetPartido(m.unique_key, m.id)} disabled={isSaving !== null} style={{ background: '#ff4d4f', color: 'white', border: 'none', borderRadius: '4px', padding: '5px 8px', cursor: 'pointer' }}>
                                    {isSaving === m.unique_key ? '⏳' : '🗑️'}
                                  </button>
                                )
                              )}
                              {esBye && (
                                <span title="Los BYE no se pueden editar" style={{ cursor: 'help', fontSize: '1rem', marginLeft: '10px' }}>🔒</span>
                              )}
                            </div>
                          </div>
                        );
                      })}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      ))}
    </div>
  );
}