import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';
import AdminPlayoffsMatches from './extraplayoff/AdminPlayoffsMatches';

export default function AdminPlayoffsExtras({ config, profile }) {
  // --- NUEVO ESTADO PARA SLIDEDOWN ---
  const [showConfig, setShowConfig] = useState(false);

  const [nombreTorneo, setNombreTorneo] = useState('');
  const [temporadaId, setTemporadaId] = useState('');
  const [tipoFormat, setTipoFormat] = useState('ida');
  const [streamPuntos, setStreamPuntos] = useState(false);
  const [loading, setLoading] = useState(false);
  const [seasons, setSeasons] = useState([]);
  const [torneoPartidos, setTorneoPartidos] = useState(null);

  // --- ESTADOS PARA DINAMISMO ---
  const [numGrupos, setNumGrupos] = useState(2);
  const [pasanPorGrupo, setPasanPorGrupo] = useState(2);

  const [todosLosPerfiles, setTodosLosPerfiles] = useState([]);
  const [busqueda, setBusqueda] = useState('');
  const [seleccionados, setSeleccionados] = useState([]);
  const [listaExtras, setListaExtras] = useState([]);

  const [torneoEnGestion, setTorneoEnGestion] = useState(null);
  const [gruposGestion, setGruposGestion] = useState([]);
  const [partidosGestion, setPartidosGestion] = useState([]);

  const [ocultarRetirados, setOcultarRetirados] = useState(true);

  // --- ESTADOS PARA INTERCAMBIO ---
  const [swapP1, setSwapP1] = useState('');
  const [swapP2, setSwapP2] = useState('');

  const [fechasConfig, setFechasConfig] = useState({});
  const [configElims, setConfigElims] = useState({
    dieciseisavos: 'ida', // Añadir esta línea
    octavos: 'ida',
    cuartos: 'ida',
    semis: 'ida',
    final: 'ida'
  });

  useEffect(() => {
    fetchSeasons();
    fetchProfiles();
    fetchTorneosExtra();
  }, []);

  // --- TODAS TUS FUNCIONES ORIGINALES (SIN CAMBIOS) ---
  const actualizarConfigRonda = async (torneoId, campo, valor) => {
    const { error } = await supabase.from('playoffs_extra').update({ [campo]: valor }).eq('id', torneoId);
    if (error) alert("Error al actualizar la configuración de ronda");
    else fetchTorneosExtra();
  };

  const maxGruposPosibles = Math.max(1, Math.floor(seleccionados.length / pasanPorGrupo));

  useEffect(() => {
    if (numGrupos > maxGruposPosibles) setNumGrupos(maxGruposPosibles);
  }, [seleccionados.length, pasanPorGrupo]);

  const toLocalISO = (dateStr) => {
    if (!dateStr) return "";
    const d = new Date(dateStr);
    const tzoffset = d.getTimezoneOffset() * 60000;
    return new Date(d.getTime() - tzoffset).toISOString().slice(0, 16);
  };

  const handleDateChange = (key, field, newValue) => {
    let newFechas = { ...fechasConfig };
    if (!newFechas[key]) newFechas[key] = { start_at: '', end_at: '' };
    newFechas[key][field] = newValue;
    if (field === 'end_at') {
      const allKeys = obtenerKeysCalendario();
      const currentIndex = allKeys.indexOf(key);
      if (currentIndex !== -1 && currentIndex < allKeys.length - 1) {
        const nextKey = allKeys[currentIndex + 1];
        if (!newFechas[nextKey]) newFechas[nextKey] = { start_at: '', end_at: '' };
        const oldStart = new Date(newFechas[nextKey].start_at).getTime();
        const oldEnd = new Date(newFechas[nextKey].end_at).getTime();
        const duration = isNaN(oldEnd - oldStart) ? (7 * 24 * 60 * 60 * 1000) : (oldEnd - oldStart);
        newFechas[nextKey].start_at = newValue;
        newFechas[nextKey].end_at = new Date(new Date(newValue).getTime() + duration).toISOString();
      }
    }
    setFechasConfig(newFechas);
  };

  const fetchSeasons = async () => {
    const { data } = await supabase.from('season_rules').select('season').order('season', { ascending: false });
    if (data) { setSeasons(data); if (data.length > 0) setTemporadaId(data[0].season); }
  };

  const fetchProfiles = async () => {
    const { data } = await supabase.from('profiles').select('id, nick').order('nick', { ascending: true });
    if (data) setTodosLosPerfiles(data);
  };

  const fetchTorneosExtra = async () => {
    const { data } = await supabase.from('playoffs_extra').select('*').order('created_at', { ascending: false });
    if (data) setListaExtras(data);
  };

  const verEsquema = async (torneo) => {
    setLoading(true);
    setTorneoEnGestion(torneo);
    setFechasConfig(torneo.config_fechas || {});
    setConfigElims(torneo.config_eliminatorias || { octavos: 'ida', cuartos: 'ida', semis: 'ida', final: 'ida' });
    const { data: grp } = await supabase.from('extra_groups').select('*').eq('extra_id', torneo.id).order('nombre_grupo', { ascending: true });
    const { data: mat } = await supabase.from('extra_matches').select('*, p1:profiles!player1_id(nick), p2:profiles!player2_id(nick)').eq('extra_id', torneo.id);
    setGruposGestion(grp || []);
    setPartidosGestion(mat || []);
    setLoading(false);
  };

  const guardarCalendario = async () => {
    const { error } = await supabase.from('playoffs_extra').update({ config_fechas: fechasConfig, config_eliminatorias: configElims }).eq('id', torneoEnGestion.id);
    if (error) alert("Error al guardar fechas");
    else { alert("✅ Calendario y Formatos actualizados"); fetchTorneosExtra(); }
  };

  const obtenerJugadoresUnicosPorGrupo = (grupoId) => {
    const jugadores = [];
    const idsAgregados = new Set();
    partidosGestion.filter(m => m.group_id === grupoId).forEach(m => {
      if (m.player1_id && !idsAgregados.has(m.player1_id)) { idsAgregados.add(m.player1_id); jugadores.push({ id: m.player1_id, nick: m.p1?.nick }); }
      if (m.player2_id && !idsAgregados.has(m.player2_id)) { idsAgregados.add(m.player2_id); jugadores.push({ id: m.player2_id, nick: m.p2?.nick }); }
    });
    return jugadores;
  };

  const calcularMaxJornadasGrupos = () => {
    let max = 0;
    gruposGestion.forEach(g => {
      const n = obtenerJugadoresUnicosPorGrupo(g.id).length;
      if (n > max) max = n;
    });
    if (max < 2) return 0;

    // Si N es impar (ej: 3), hay N jornadas (3).
    // Si N es par (ej: 4), hay N-1 jornadas (3).
    const jornadasBase = max % 2 !== 0 ? max : max - 1;
    return torneoEnGestion.tipo_format === 'ida_vuelta' ? jornadasBase * 2 : jornadasBase;
  };

  const obtenerFasesReales = (totalQuePasan) => {
    if (totalQuePasan > 16) return ['dieciseisavos', 'octavos', 'cuartos', 'semis', 'final'];
    if (totalQuePasan > 8) return ['octavos', 'cuartos', 'semis', 'final'];
    if (totalQuePasan > 4) return ['cuartos', 'semis', 'final'];
    if (totalQuePasan > 2) return ['semis', 'final'];
    return ['final'];
  };

  const obtenerKeysCalendario = () => {
    if (!torneoEnGestion) return [];
    const keys = [...Array(totalJornadas).keys()].map(i => `j${i + 1}`);
    const nGrupos = torneoEnGestion.num_grupos || 2;
    const pGrupo = torneoEnGestion.pasan_por_grupo || 2;
    const totalPasan = nGrupos * pGrupo;
    const fases = obtenerFasesReales(totalPasan);
    const configActual = torneoEnGestion.config_eliminatorias || configElims;
    fases.forEach(f => {
      if (configActual[f] === 'ida_vuelta') { keys.push(`${f}_ida`); keys.push(`${f}_vuelta`); }
      else { keys.push(f); }
    });
    return keys;
  };

  const copiarFechasDeAnterior = (phaseKey) => {
    const allKeys = obtenerKeysCalendario();
    const currentIndex = allKeys.indexOf(phaseKey);

    if (currentIndex <= 0) return; // No hay anterior

    const prevKey = allKeys[currentIndex - 1];
    const prevData = fechasConfig[prevKey];

    if (!prevData || !prevData.start_at || !prevData.end_at) {
      alert("La fase anterior no tiene fechas válidas para copiar.");
      return;
    }

    setFechasConfig(prev => ({
      ...prev,
      [phaseKey]: {
        start_at: prevData.start_at,
        end_at: prevData.end_at
      }
    }));
  };

  const obtenerOpcionesRondaSimple = (torneo) => {
    if (!torneo) return [];

    // 1. Extraemos las jornadas directamente de la configuración de fechas guardada en el torneo
    // Esto es más seguro porque no depende de si el "Esquema" está abierto o no.
    const configFechas = torneo.config_fechas || {};

    // Filtramos todas las keys que empiecen por "j" seguida de un número (j1, j2, j3...)
    const jornadasKeys = Object.keys(configFechas)
      .filter(key => /^j\d+$/.test(key))
      .sort((a, b) => {
        // Orden numérico: j1, j2, j10...
        return parseInt(a.substring(1)) - parseInt(b.substring(1));
      });

    // 2. Calculamos las fases de eliminatorias como ya hacías
    const totalPasan = (torneo.num_grupos || 2) * (torneo.pasan_por_grupo || 2);
    const fases = obtenerFasesReales(totalPasan);
    const configElimsActual = torneo.config_eliminatorias || {};

    const eliminatoriasKeys = [];
    fases.forEach(f => {
      if (configElimsActual[f] === 'ida_vuelta') {
        eliminatoriasKeys.push(`${f}_ida`);
        eliminatoriasKeys.push(`${f}_vuelta`);
      } else {
        eliminatoriasKeys.push(f);
      }
    });

    // Retornamos la unión de jornadas + eliminatorias
    return [...jornadasKeys, ...eliminatoriasKeys];
  };

  const crearPlayoffExtra = async () => {
    if (!nombreTorneo || seleccionados.length < 2) return alert("Faltan datos.");
    const startTorneo = prompt("Inicio del torneo", new Date().toISOString().slice(0, 16));
    if (!startTorneo) return;
    setLoading(true);

    try {
      // 1. PREPARACIÓN INICIAL
      const jugadoresIds = [...seleccionados].sort(() => Math.random() - 0.5);
      const totalPasan = numGrupos * pasanPorGrupo;
      const fases = obtenerFasesReales(totalPasan);

      // 2. CÁLCULO DE FECHAS AUTOMÁTICO
      const maxJugadoresEnUnGrupo = Math.ceil(jugadoresIds.length / numGrupos);
      const jornadasBase = maxJugadoresEnUnGrupo % 2 !== 0 ? maxJugadoresEnUnGrupo : maxJugadoresEnUnGrupo - 1;
      const jornadasLiguillaTotales = tipoFormat === 'ida_vuelta' ? jornadasBase * 2 : jornadasBase;

      let autoFechas = {};
      let currentStart = new Date(startTorneo);

      for (let i = 1; i <= jornadasLiguillaTotales; i++) {
        let currentEnd = new Date(currentStart.getTime() + (7 * 24 * 60 * 60 * 1000));
        autoFechas[`j${i}`] = { start_at: currentStart.toISOString(), end_at: currentEnd.toISOString() };
        currentStart = currentEnd;
      }

      fases.forEach(f => {
        const slots = configElims[f] === 'ida_vuelta' ? [`${f}_ida`, `${f}_vuelta`] : [f];
        slots.forEach(s => {
          let end = new Date(currentStart.getTime() + (7 * 24 * 60 * 60 * 1000));
          autoFechas[s] = { start_at: currentStart.toISOString(), end_at: end.toISOString() };
          currentStart = end;
        });
      });

      // 3. CREAR EL TORNEO EN LA DB
      const { data: torneo, error: errT } = await supabase.from('playoffs_extra').insert([{
        nombre: nombreTorneo, season_id: temporadaId, tipo_format: tipoFormat, config_eliminatorias: configElims,
        config_fechas: autoFechas, num_grupos: numGrupos, pasan_por_grupo: pasanPorGrupo, estado: 'activo',
        use_auto_round: true, current_round: 'j1', stream_puntos: streamPuntos
      }]).select().single();

      if (errT) throw errT;

      // 4. GENERAR GRUPOS Y PARTIDOS DE LIGUILLA
      let startIndex = 0;
      let idsGruposCreados = [];
      for (let i = 0; i < numGrupos; i++) {
        const tamanoGrupo = Math.ceil((jugadoresIds.length - startIndex) / (numGrupos - i));
        const jugadoresDelGrupo = jugadoresIds.slice(startIndex, startIndex + tamanoGrupo);
        startIndex += tamanoGrupo;

        const { data: grupo } = await supabase.from('extra_groups').insert([{
          extra_id: torneo.id,
          nombre_grupo: `Grupo ${String.fromCharCode(65 + i)}`
        }]).select().single();
        idsGruposCreados.push(grupo.id);

        const tempJug = [...jugadoresDelGrupo];
        if (tempJug.length % 2 !== 0) tempJug.push(null);
        const rounds = tempJug.length - 1;
        const matchesLiguilla = [];
        for (let r = 0; r < rounds; r++) {
          for (let idx = 0; idx < tempJug.length / 2; idx++) {
            const p1 = tempJug[idx]; const p2 = tempJug[tempJug.length - 1 - idx];
            if (p1 && p2) {
              matchesLiguilla.push({ extra_id: torneo.id, group_id: grupo.id, player1_id: p1, player2_id: p2, is_played: false, numero_jornada: r + 1, fase: `j${r + 1}` });
              if (tipoFormat === 'ida_vuelta') matchesLiguilla.push({ extra_id: torneo.id, group_id: grupo.id, player1_id: p2, player2_id: p1, is_played: false, numero_jornada: r + 1 + rounds, fase: `j${r + 1 + rounds}` });
            }
          }
          tempJug.splice(1, 0, tempJug.pop());
        }
        if (matchesLiguilla.length > 0) await supabase.from('extra_matches').insert(matchesLiguilla);
      }

      // 5. GENERAR CUADRO DE ELIMINATORIAS (ALGORITMO UNIVERSAL)
      const mapeoSlots = { 'dieciseisavos': 16, 'octavos': 8, 'cuartos': 4, 'semis': 2, 'final': 1 };
      const primeraFase = fases[0];
      const numPartidosR1 = mapeoSlots[primeraFase] || 4;
      const esIVR1 = configElims[primeraFase] === 'ida_vuelta';

      // 1. Lista de clasificados REALES (evita duplicados de IDs)
      let clasificadosReales = [];
      for (let pIdx = 1; pIdx <= pasanPorGrupo; pIdx++) {
        for (let gIdx = 0; gIdx < idsGruposCreados.length; gIdx++) {
          clasificadosReales.push({ gId: idsGruposCreados[gIdx], pos: pIdx });
        }
      }

      // 2. Generar el orden de las semillas (Seeding profesional)
      // Para 4 partidos devuelve: [1, 8, 5, 4, 3, 6, 7, 2]
      const generarOrdenSemillas = (nPartidos) => {
        let semillas = [1, 2];
        while (semillas.length < nPartidos * 2) {
          let nuevaRonda = [];
          let siguienteSuma = semillas.length + 1;
          for (let i = 0; i < semillas.length; i++) {
            nuevaRonda.push(semillas[i]);
            nuevaRonda.push(siguienteSuma + (semillas.length - semillas[i]));
          }
          semillas = nuevaRonda;
        }
        return semillas;
      };

      const ordenSemillas = generarOrdenSemillas(numPartidosR1);
      const partidosR1Insert = [];

      // 3. Emparejar semillas con clasificados reales
      for (let i = 0; i < numPartidosR1; i++) {
        // Obtenemos los números de semilla para este partido (ej: 1 y 8)
        const seed1Num = ordenSemillas[i * 2];
        const seed2Num = ordenSemillas[i * 2 + 1];

        // Buscamos si existe un clasificado para esa posición de semilla
        // Restamos 1 porque el array empieza en 0
        const s1 = clasificadosReales[seed1Num - 1] || null;
        const s2 = clasificadosReales[seed2Num - 1] || null;

        partidosR1Insert.push({
          playoff_extra_id: torneo.id,
          numero_jornada: esIVR1 ? `${primeraFase.toUpperCase()} IDA` : primeraFase.toUpperCase(),
          group_id_p1: s1?.gId || null,
          posicion_p1: s1?.pos || null,
          group_id_p2: s2?.gId || null,
          posicion_p2: s2?.pos || null,
        });

        if (esIVR1) {
          partidosR1Insert.push({
            playoff_extra_id: torneo.id,
            numero_jornada: `${primeraFase.toUpperCase()} VUELTA`,
            group_id_p1: s2?.gId || null,
            posicion_p1: s2?.pos || null,
            group_id_p2: s1?.gId || null,
            posicion_p2: s1?.pos || null,
          });
        }
      }

      const { data: insertsR1, error: errR1 } = await supabase
        .from('extra_playoffs_matches')
        .insert(partidosR1Insert)
        .select()
        .order('id', { ascending: true });

      if (errR1) throw errR1;

      // 6. GENERAR RONDAS SIGUIENTES (Herencia de ganadores)
      let padres = insertsR1.filter(m => !m.numero_jornada.toUpperCase().includes('VUELTA'));

      for (let fIdx = 1; fIdx < fases.length; fIdx++) {
        const faseAct = fases[fIdx];
        const esIV = configElims[faseAct] === 'ida_vuelta';
        const sigRonda = [];

        for (let j = 0; j < padres.length; j += 2) {
          sigRonda.push({
            playoff_extra_id: torneo.id,
            numero_jornada: esIV ? `${faseAct.toUpperCase()} IDA` : faseAct.toUpperCase(),
            p1_from_match_id: padres[j].id,
            p2_from_match_id: padres[j + 1] ? padres[j + 1].id : null
          });
          if (esIV) {
            sigRonda.push({
              playoff_extra_id: torneo.id,
              numero_jornada: `${faseAct.toUpperCase()} VUELTA`,
              p1_from_match_id: padres[j + 1] ? padres[j + 1].id : null,
              p2_from_match_id: padres[j].id
            });
          }
        }

        if (sigRonda.length > 0) {
          const { data: creados } = await supabase
            .from('extra_playoffs_matches')
            .insert(sigRonda)
            .select()
            .order('id', { ascending: true });
          padres = creados.filter(m => !m.numero_jornada.toUpperCase().includes('VUELTA'));
        }
      }

      // FINALIZACIÓN
      setNombreTorneo(''); setSeleccionados([]); fetchTorneosExtra(); setShowConfig(false);
      alert("✅ Torneo creado con éxito. Cuadro de " + numPartidosR1 + " partidos generado con Seeding.");

    } catch (error) {
      console.error(error);
      alert("Error crítico en la generación: " + error.message);
    } finally {
      setLoading(false);
    }
  };

  const perfilesFiltrados = todosLosPerfiles.filter(p => {
    // 1. Filtro por búsqueda de texto
    const coincideBusqueda = p.nick?.toLowerCase().includes(busqueda.toLowerCase());

    // 2. Lógica para detectar si es retirado
    const esRetirado = p.nick?.toLowerCase().startsWith("retirado");

    // 3. Aplicamos el filtro del checkbox
    if (ocultarRetirados) {
      return coincideBusqueda && !esRetirado;
    }
    return coincideBusqueda;
  });

  const intercambiarJugadores = async () => {
    if (!swapP1 || !swapP2 || swapP1 === swapP2) return alert("Selecciona dos jugadores distintos");
    if (!confirm("¿Seguro que quieres intercambiar a estos dos jugadores?")) return;

    setLoading(true);
    const torneoId = torneoEnGestion.id;

    try {
      // PASO 1: "Vaciamos" al Jugador 1 poniéndolo a NULL temporalmente
      // Esto es legal porque tus columnas permiten NULL (según el .sql)
      await supabase.from('extra_matches').update({ player1_id: null }).eq('extra_id', torneoId).eq('player1_id', swapP1);
      await supabase.from('extra_matches').update({ player2_id: null }).eq('extra_id', torneoId).eq('player2_id', swapP1);

      // PASO 2: Donde esté el Jugador 2, ponemos al Jugador 1
      await supabase.from('extra_matches').update({ player1_id: swapP1 }).eq('extra_id', torneoId).eq('player1_id', swapP2);
      await supabase.from('extra_matches').update({ player2_id: swapP1 }).eq('extra_id', torneoId).eq('player2_id', swapP2);

      // PASO 3: Donde dejamos los huecos (NULL), ponemos al Jugador 2
      await supabase.from('extra_matches').update({ player1_id: swapP2 }).eq('extra_id', torneoId).is('player1_id', null);
      await supabase.from('extra_matches').update({ player2_id: swapP2 }).eq('extra_id', torneoId).is('player2_id', null);

      alert("✅ ¡Intercambio completado con éxito!");
      setSwapP1('');
      setSwapP2('');
      verEsquema(torneoEnGestion);

    } catch (err) {
      console.error("Error en el intercambio:", err);
      alert("Hubo un problema con la base de datos. Verifica que los jugadores no tengan resultados ya anotados.");
    } finally {
      setLoading(false);
    }
  };


  const totalJornadas = torneoEnGestion ? calcularMaxJornadasGrupos() : 0;

  return (
    <div style={{ marginTop: '20px', display: 'flex', flexDirection: 'column', gap: '20px', fontFamily: 'sans-serif' }}>

      {/* BOTÓN PARA ABRIR/CERRAR CONFIGURACIÓN */}
      <button
        onClick={() => setShowConfig(!showConfig)}
        style={{
          width: 'fit-content',
          padding: '10px 20px',
          background: showConfig ? '#e74c3c' : '#2ecc71',
          color: 'white',
          border: 'none',
          borderRadius: '8px',
          cursor: 'pointer',
          fontWeight: 'bold',
          alignSelf: 'flex-start'
        }}
      >
        {showConfig ? '✕ Cerrar Configuración' : '🏆 Crear Nuevo Playoff Extra'}
      </button>

      {/* CONTENEDOR CON EFECTO SLIDEDOWN */}
      <div style={{
        overflow: 'hidden',
        maxHeight: showConfig ? '2000px' : '0',
        opacity: showConfig ? 1 : 0,
        transition: 'all 0.5s ease-in-out',
        background: '#1e1e1e',
        borderRadius: '12px',
        color: 'white'
      }}>
        <div style={{ padding: '20px' }}>
          <h3 style={{ marginTop: 0, color: '#2ecc71' }}>🏆 Configurar Playoff Extra</h3>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px', marginBottom: '15px' }}>
            <input type="text" value={nombreTorneo} onChange={(e) => setNombreTorneo(e.target.value)} placeholder="Nombre del Torneo" style={{ gridColumn: '1 / -1', padding: '12px', borderRadius: '8px', background: '#2d2d2d', color: 'white', border: '1px solid #444' }} />
            <select value={temporadaId} onChange={(e) => setTemporadaId(e.target.value)} style={{ padding: '10px', borderRadius: '8px', background: '#2d2d2d', color: 'white' }}>
              {seasons.map(s => <option key={s.season} value={s.season}>Temporada {s.season}</option>)}
            </select>
            <select value={tipoFormat} onChange={(e) => setTipoFormat(e.target.value)} style={{ padding: '10px', borderRadius: '8px', background: '#2d2d2d', color: 'white' }}>
              <option value="ida">Liguilla: Solo Ida</option>
              <option value="ida_vuelta">Liguilla: Ida y Vuelta</option>
            </select>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
              <label style={{ fontSize: '0.65rem', color: '#aaa' }}>Pasan por grupo:</label>
              <select value={pasanPorGrupo} onChange={e => setPasanPorGrupo(parseInt(e.target.value))} style={{ padding: '10px', borderRadius: '8px', background: '#2d2d2d', color: 'white' }}>
                {[1, 2, 3, 4].map(n => <option key={n} value={n}>{n} Jugadores</option>)}
              </select>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
              <label style={{ fontSize: '0.65rem', color: '#aaa' }}>Número de Grupos (Máx {maxGruposPosibles}):</label>
              <input type="number" min="1" max={maxGruposPosibles} value={numGrupos} onChange={e => setNumGrupos(parseInt(e.target.value))} style={{ padding: '10px', borderRadius: '8px', background: '#2d2d2d', color: 'white', border: '1px solid #444' }} />
            </div>
          </div>

          <div style={{ marginBottom: '15px', padding: '10px', background: '#2ecc7122', borderRadius: '8px', border: '1px solid #2ecc7144', fontSize: '0.8rem' }}>
            ℹ️ Pasan <strong>{numGrupos * pasanPorGrupo}</strong> jugadores a la Playoff. Fase inicial: <strong>{obtenerFasesReales(numGrupos * pasanPorGrupo)[0]}</strong>.
          </div>

          <div style={{ background: '#252525', padding: '15px', borderRadius: '10px', marginBottom: '15px' }}>
            <p style={{ margin: '0 0 10px 0', fontSize: '0.8rem', color: '#3498db' }}>Formato de Eliminatorias (Global):</p>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(120px, 1fr))', gap: '10px' }}>
              {['dieciseisavos', 'octavos', 'cuartos', 'semis', 'final'].map(fase => (
                <div key={fase}>
                  <label style={{ fontSize: '0.65rem', display: 'block', textTransform: 'capitalize' }}>{fase}</label>
                  <select value={configElims[fase]} onChange={(e) => setConfigElims({ ...configElims, [fase]: e.target.value })} style={{ width: '100%', padding: '5px', background: '#333', color: 'white', fontSize: '0.75rem' }}>
                    <option value="ida">Solo Ida</option>
                    <option value="ida_vuelta">Ida y Vuelta</option>
                  </select>
                </div>
              ))}
            </div>
          </div>

          <div style={{ background: '#2d2d2d', padding: '15px', borderRadius: '10px' }}>
            <input type="text" placeholder="Buscar por nick..." value={busqueda} onChange={e => setBusqueda(e.target.value)} style={{ width: '100%', padding: '10px', marginBottom: '10px', borderRadius: '6px', background: '#3d3d3d', color: 'white', border: 'none' }} />
            <label style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              fontSize: '0.75rem',
              color: '#aaa',
              marginBottom: '15px',
              cursor: 'pointer'
            }}>
              <input
                type="checkbox"
                checked={ocultarRetirados}
                onChange={(e) => setOcultarRetirados(e.target.checked)}
              />
              Ocultar usuarios retirados
            </label>
            <div style={{ maxHeight: '200px', overflowY: 'auto', display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))', gap: '8px' }}>
              {perfilesFiltrados.map(p => (
                <div key={p.id} onClick={() => setSeleccionados(prev => prev.includes(p.id) ? prev.filter(i => i !== p.id) : [...prev, p.id])} style={{ padding: '10px', borderRadius: '6px', cursor: 'pointer', fontSize: '0.8rem', background: seleccionados.includes(p.id) ? '#2ecc71' : '#3d3d3d', color: seleccionados.includes(p.id) ? '#000' : '#fff' }}>{p.nick}</div>
              ))}
            </div>
          </div>
          <button onClick={crearPlayoffExtra} disabled={loading} style={{ width: '100%', marginTop: '20px', padding: '15px', borderRadius: '10px', background: '#2ecc71', color: 'white', fontWeight: 'bold', border: 'none', cursor: 'pointer' }}>{loading ? 'Generando...' : '🚀 Crear Torneo'}</button>
        </div>
      </div>

      {/* SECCIÓN DE GESTIÓN (SIN TOCAR) */}
      <div style={{ padding: '20px', background: '#fff', borderRadius: '12px', border: '1px solid #ddd' }}>
        <h4 style={{ marginTop: 0 }}>📂 Gestión de Playoff Extra</h4>
        {listaExtras.map(t => (
          <div key={t.id} style={{ background: '#f9f9f9', padding: '15px', borderRadius: '10px', marginBottom: '10px', border: '1px solid #eee' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <div>
                <strong>{t.nombre} <span style={{ fontSize: '0.7rem', color: '#666' }}>({t.num_grupos} grupos / pasan {t.num_grupos * t.pasan_por_grupo})</span></strong>
                <div style={{ display: 'flex', alignItems: 'center', gap: '15px', marginTop: '10px', background: '#fff', padding: '10px', borderRadius: '8px', border: '1px solid #ddd' }}>
                  <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.75rem', cursor: 'pointer', fontWeight: 'bold' }}>
                    <input type="checkbox" checked={t.use_auto_round} onChange={e => actualizarConfigRonda(t.id, 'use_auto_round', e.target.checked)} />
                    Ronda por Fecha Actual
                  </label>
                  {!t.use_auto_round && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span style={{ fontSize: '0.7rem', color: '#777' }}>Round Manual:</span>
                      <select value={t.current_round} onChange={e => actualizarConfigRonda(t.id, 'current_round', e.target.value)} style={{ fontSize: '0.75rem', padding: '3px 8px', borderRadius: '4px' }}>
                        {obtenerOpcionesRondaSimple(t).map(op => <option key={op} value={op}>{op.toUpperCase().replace('_', ' ')}</option>)}
                      </select>
                    </div>
                  )}
                  {t.use_auto_round && <span style={{ fontSize: '0.7rem', color: '#2ecc71' }}>✨ Automático</span>}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '15px', marginTop: '10px', background: '#fff', padding: '10px', borderRadius: '8px', border: '1px solid #ddd' }}>
                  <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.75rem', cursor: 'pointer', fontWeight: 'bold', color: '#2980b9' }}>
                    <input
                      type="checkbox"
                      checked={t.stream_puntos}
                      onChange={e => actualizarConfigRonda(t.id, 'stream_puntos', e.target.checked)}
                    />
                    Streams cuentan para puntos en liga
                  </label>
                </div>
                {/* --- LIMITAR GOLES (FAIR PLAY) --- */}
                <div style={{ display: 'flex', alignItems: 'center', gap: '15px', marginTop: '10px', background: '#fffbf0', padding: '5px 10px', borderRadius: '8px', border: '1px solid #ffeeba' }}>
                  <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.75rem', cursor: 'pointer', fontWeight: 'bold', color: '#856404', whiteSpace: 'nowrap' }}>
                    <input type="checkbox" checked={t.limit_ga_enabled} onChange={e => actualizarConfigRonda(t.id, 'limit_ga_enabled', e.target.checked)} />
                    ¿Limitar Goles?
                  </label>
                  {t.limit_ga_enabled && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span style={{ fontSize: '0.7rem', color: '#856404', fontWeight: 'bold' }}>Máx:</span>
                      <input
                        type="number"
                        min="1"
                        value={t.max_ga_playoff || 0}
                        onChange={e => actualizarConfigRonda(t.id, 'max_ga_playoff', parseInt(e.target.value) || 0)}
                        style={{ width: '45px', fontSize: '0.75rem', padding: '2px', borderRadius: '4px', border: '1px solid #ccc' }}
                      />
                    </div>
                  )}
                </div>
              </div>
              <div style={{ display: 'flex', gap: '5px' }}>
                <button onClick={() => verEsquema(t)} style={{ background: '#3498db', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}>Esquema</button>
                <button onClick={() => setTorneoPartidos(torneoPartidos?.id === t.id ? null : t)} style={{ background: '#9b59b6', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}>Partidos</button>
                <button onClick={() => { if (confirm('¿Borrar?')) supabase.from('playoffs_extra').delete().eq('id', t.id).then(fetchTorneosExtra) }} style={{ background: '#e74c3c', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}>Eliminar</button>
              </div>
            </div>
            {torneoPartidos?.id === t.id && (
              <div style={{ marginTop: '15px', padding: '15px', background: '#fdfaff', border: '1px solid #9b59b6', borderRadius: '8px' }}>
                <AdminPlayoffsMatches torneo={t} profiles={todosLosPerfiles} onClose={() => setTorneoPartidos(null)} />
              </div>
            )}
            {torneoEnGestion?.id === t.id && (
              <div style={{ marginTop: '15px', padding: '15px', background: '#fff', border: '1px solid #3498db', borderRadius: '8px' }}>
                <h5 style={{ margin: '0 0 10px 0' }}>🗓️ Calendario de Fases</h5>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', maxWidth: '550px' }}>
                  {obtenerKeysCalendario().map((phaseKey, idx) => (
                    <div key={phaseKey} style={{ fontSize: '0.75rem', padding: '10px', background: '#f8f9fa', borderRadius: '6px', border: '1px solid #eee' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
                        {/* NOMBRE DE LA FASE Y BOTÓN COPIAR */}
                        <div style={{ width: '120px', display: 'flex', flexDirection: 'column', gap: '4px' }}>
                          {idx > 0 && (
                            <button
                              onClick={() => copiarFechasDeAnterior(phaseKey)}
                              style={{
                                width: 'fit-content',
                                fontSize: '0.6rem',
                                padding: '2px 5px',
                                background: '#ebedef',
                                border: '1px solid #ccc',
                                borderRadius: '3px',
                                cursor: 'pointer',
                                color: '#666'
                              }}
                            >📋</button>
                          )}
                        </div>
                        <div style={{ fontWeight: 'bold', width: '100px', textTransform: 'uppercase', color: '#555' }}>{phaseKey.replace('_', ' ')}</div>
                        <div style={{ display: 'flex', flex: 1, gap: '10px' }}>
                          <input type="datetime-local" value={toLocalISO(fechasConfig[phaseKey]?.start_at)} onChange={e => handleDateChange(phaseKey, 'start_at', new Date(e.target.value).toISOString())} style={{ width: '100%', padding: '4px' }} />
                          <input type="datetime-local" value={toLocalISO(fechasConfig[phaseKey]?.end_at)} onChange={e => handleDateChange(phaseKey, 'end_at', new Date(e.target.value).toISOString())} style={{ width: '100%', padding: '4px' }} />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
                <button onClick={guardarCalendario} style={{ marginTop: '15px', background: '#2ecc71', color: 'white', border: 'none', padding: '10px', borderRadius: '6px', cursor: 'pointer', width: '100%', fontWeight: 'bold' }}>Guardar Calendario y Formatos</button>
                <div style={{
                  marginTop: '25px',
                  padding: '15px',
                  background: '#fff3cd',
                  border: '1px solid #ffeeba',
                  borderRadius: '8px'
                }}>
                  <h5 style={{ margin: '0 0 10px 0', color: '#856404' }}>🔄 Intercambiar Jugadores (Swap)</h5>
                  <p style={{ fontSize: '0.7rem', margin: '0 0 10px 0' }}>
                    Esto intercambiará todas las apariciones del Jugador 1 por las del Jugador 2 en este torneo liguilla.
                  </p>
                  <div style={{ display: 'flex', gap: '10px', alignItems: 'center' }}>
                    <select
                      value={swapP1}
                      onChange={e => setSwapP1(e.target.value)}
                      style={{ flex: 1, padding: '8px', fontSize: '0.8rem' }}
                    >
                      <option value="">-- Jugador 1 --</option>
                      {todosLosPerfiles.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
                    </select>

                    <span style={{ fontWeight: 'bold' }}>↔️</span>

                    <select
                      value={swapP2}
                      onChange={e => setSwapP2(e.target.value)}
                      style={{ flex: 1, padding: '8px', fontSize: '0.8rem' }}
                    >
                      <option value="">-- Jugador 2 --</option>
                      {todosLosPerfiles.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
                    </select>

                    <button
                      onClick={intercambiarJugadores}
                      disabled={loading || !swapP1 || !swapP2}
                      style={{
                        padding: '8px 15px',
                        background: '#856404',
                        color: 'white',
                        border: 'none',
                        borderRadius: '4px',
                        cursor: 'pointer',
                        fontWeight: 'bold'
                      }}
                    >
                      {loading ? '...' : 'Sustituir'}
                    </button>
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '10px', marginTop: '20px' }}>
                  {gruposGestion.map(g => (
                    <div key={g.id} style={{ padding: '10px', background: '#f0f4f8', borderRadius: '8px' }}>
                      <div style={{ fontWeight: 'bold', fontSize: '0.8rem' }}>{g.nombre_grupo}</div>
                      {[0, 1, 2, 3].map(i => {
                        const jug = obtenerJugadoresUnicosPorGrupo(g.id)[i];
                        return (
                          <select key={i} value={jug?.id || ''} disabled
                            style={{
                              width: '100%',
                              marginTop: '4px',
                              fontSize: '0.75rem',
                              backgroundColor: '#e9ecef', // Color grisáceo para indicar que está bloqueado
                              cursor: 'not-allowed'       // Cursor de "prohibido" al pasar por encima
                            }}
                          >
                            <option value="">-- Vacío --</option>
                            {todosLosPerfiles.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
                          </select>
                        );
                      })}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}