import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import ReactMarkdown from 'react-markdown'

const Avatar = ({ url }) => (
  <div style={{
    width: '35px', height: '35px', borderRadius: '50%', overflow: 'hidden',
    background: '#34495e', border: '2px solid #2ecc71', flexShrink: 0
  }}>
    {url ? (
      <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
    ) : (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.8rem', color: '#7f8c8d' }}>👤</div>
    )}
  </div>
);

function TarjetaResultado({ partido, onUpdated }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');
  const [enviando, setEnviando] = useState(false);
  const [urlStream, setUrlStream] = useState('');


  useEffect(() => {
    const cargarStreams = async () => {
      const { data } = await supabase
        .from(isPlayoff ? 'match_playoff_streams' : 'match_streams')
        .select('stream_url')
        .eq(isPlayoff ? 'playoff_match_id' : 'match_id', partido.id)
        .maybeSingle();

      if (data) setUrlStream(data.stream_url || '');
    };
    cargarStreams();
  }, [partido.id]);

  // Identificamos si es un partido de playoff
  const isPlayoff = !!partido.playoff_id;
  const tabla = isPlayoff ? 'playoff_matches' : 'matches';
  const yaJugado = partido.played === true || partido.is_played === true;
  const [jugadoLocal, setJugadoLocal] = useState(yaJugado);

  // Esto asegura que si cambias de jornada, el estado se resetee
  useEffect(() => {
    // Detección universal para el reseteo
    const yaJugado = partido.played === true || partido.is_played === true;

    setJugadoLocal(yaJugado);
    setGL(partido.home_score ?? '');
    setGV(partido.away_score ?? '');
  }, [partido]);

  const guardar = async () => {
    if (gL === '' || gV === '') return alert("Introduce los goles");
    setEnviando(true);

    try {
      const scoreL = parseInt(gL);
      const scoreV = parseInt(gV);

      // En playoff_matches_detallados (vista), los IDs reales son local_id y visitante_id
      // Intentamos capturar el ID de cualquier fuente posible (Vista o Tabla base)
      const idLocal = partido.local_id || partido.home_team;
      const idVisitante = partido.visitante_id || partido.away_team;

      if (!idLocal || !idVisitante) {
        console.error("Contenido de partido:", partido); // Para debug
        throw new Error("Faltan IDs de los equipos.");
      }

      // Datos según tabla (played vs is_played)
      const datosAEnviar = isPlayoff
        ? { home_score: scoreL, away_score: scoreV, played: true }
        : { home_score: scoreL, away_score: scoreV, is_played: true };

      const { error: errorUpdate } = await supabase
        .from(tabla)
        .update(datosAEnviar)
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      // Guardar URL del stream (tanto para Liga como para Playoff)
      if (urlStream) {
        const tablaStream = isPlayoff ? 'match_playoff_streams' : 'match_streams';
        const columnaId = isPlayoff ? 'playoff_match_id' : 'match_id';

        await supabase.from(tablaStream).upsert({
          [columnaId]: partido.id,
          stream_url: urlStream,
          updated_at: new Date().toISOString()
        });
      }
      setJugadoLocal(true);
      if (isPlayoff) {
        // 1. Intentar actualizar el ganador_id en el partido actual si la columna existe
        await supabase.from('playoff_matches').update({ winner_id: null }).eq('id', partido.id);

        const pId = String(partido.playoff_id);
        const mOrder = parseInt(partido.match_order);
        const faseActualNombre = partido.round;
        const faseBase = faseActualNombre.split(' (')[0].trim();
        const esDoble = faseActualNombre.includes('(Ida)') || faseActualNombre.includes('(Vuelta)');

        const { data: enfrentamientos } = await supabase
          .from('playoff_matches')
          .select('*')
          .eq('playoff_id', pId)
          .eq('match_order', String(mOrder))
          .ilike('round', `${faseBase}%`);

        let ganadorId = null;

        if (!esDoble) {
          if (scoreL > scoreV) ganadorId = idLocal;
          else if (scoreV > scoreL) ganadorId = idVisitante;
        } else {
          const ida = enfrentamientos.find(m => m.round.includes('(Ida)'));
          const vuelta = enfrentamientos.find(m => m.round.includes('(Vuelta)'));

          const idaFinal = ida?.id === partido.id ? { ...ida, home_score: scoreL, away_score: scoreV, played: true } : ida;
          const vueltaFinal = vuelta?.id === partido.id ? { ...vuelta, home_score: scoreL, away_score: scoreV, played: true } : vuelta;

          if (idaFinal?.played && vueltaFinal?.played) {
            const globalLocal = (idaFinal.home_score || 0) + (vueltaFinal.away_score || 0);
            const globalVisitante = (idaFinal.away_score || 0) + (vueltaFinal.home_score || 0);

            if (globalLocal > globalVisitante) ganadorId = idaFinal.home_team;
            else if (globalVisitante > globalLocal) ganadorId = idaFinal.away_team;
          }
        }

        // 3. EJECUTAR PROMOCIÓN
        if (ganadorId) {
          const ordenRondas = ["Dieciseisavos", "Octavos", "Cuartos", "Semifinales", "Final"];
          const idx = ordenRondas.findIndex(r => r.toLowerCase() === faseBase.toLowerCase());
          const sigRonda = ordenRondas[idx + 1];

          if (sigRonda) {
            const sigMatchOrder = Math.floor(mOrder / 2);
            const esLocalNext = mOrder % 2 === 0;
            const columnaDestino = esLocalNext ? 'home_team' : 'away_team';

            // IMPORTANTE: Usamos un try/catch específico para la promoción
            // para que si falla el RLS del siguiente partido, al menos el resultado actual se guarde
            try {
              const { error: errorNext } = await supabase
                .from('playoff_matches')
                .update({ [columnaDestino]: ganadorId })
                .eq('playoff_id', pId)
                .eq('match_order', String(sigMatchOrder))
                .ilike('round', `${sigRonda}%`);

              if (errorNext) console.warn("RLS bloqueó la promoción automática. El admin deberá asignar al ganador.");
            } catch (e) {
              console.error("Error promocionando:", e);
            }
          }
        }
      }

      if (onUpdated) onUpdated();
      alert("Guardado y actualizado.");
    } catch (err) {
      console.error(err);
      alert(err.message);
    } finally {
      setEnviando(false);
    }
  };

  return (
    <div style={{
      background: isPlayoff ? '#3a2c50' : '#2c3e50', // Color lila oscuro si es playoff
      color: 'white', padding: '15px', borderRadius: '12px', textAlign: 'center', position: 'relative',
      border: isPlayoff ? '1px solid #9b59b6' : 'none'
    }}>
      {/* ETIQUETA SUPERIOR DINÁMICA */}
      <div style={{ position: 'absolute', top: '5px', left: '10px', fontSize: '0.6rem', color: isPlayoff ? '#d6a2e8' : '#2ecc71', fontWeight: 'bold', textTransform: 'uppercase' }}>
        {isPlayoff ? `${partido.playoff_name} - ${partido.round}` : `JORNADA ${partido.week}`}
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '15px', marginBottom: '10px', marginTop: '15px' }}>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.local_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.local_nick}
          </div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center' }}>
          {jugadoLocal ? (
            <div style={{
              background: '#34495e', padding: '8px 15px', borderRadius: '8px',
              border: `2px solid ${isPlayoff ? '#9b59b6' : '#2ecc71'}`,
              fontWeight: 'bold', fontSize: '1.2rem', minWidth: '60px'
            }}>
              {gL} - {gV}  {/* <-- Usamos los estados locales para respuesta inmediata */}
            </div>
          ) : (
            <div style={{ display: 'flex', gap: '5px', alignItems: 'center' }}>
              <input type="number" min="0" value={gL} onChange={e => setGL(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
              <span style={{ fontWeight: 'bold', fontSize: '1.2rem' }}>-</span>
              <input type="number" min="0" value={gV} onChange={e => setGV(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
            </div>
          )}
        </div>

        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.visitante_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.visitante_nick}
          </div>
        </div>
      </div>

      {/* SECCIÓN DE STREAM */}
      {(jugadoLocal ? !!urlStream : true) && (
        <div style={{
          marginTop: '15px', marginBottom: '10px', paddingTop: '10px',
          borderTop: '1px solid rgba(255,255,255,0.1)', display: 'flex',
          flexDirection: 'column', gap: '4px'
        }}>
          {/* Etiqueta que siempre aparece si hay algo que mostrar */}
          <label style={{ fontSize: '0.65rem', color: '#bdc3c7', textAlign: 'left', marginLeft: '2px' }}>
            Retransmisión:
          </label>

          {jugadoLocal ? (
            /* MODO LECTURA */
            urlStream && (
              urlStream.includes('http') ? (
                /* LINK VÁLIDO */
                <a
                  href={urlStream.trim()}
                  target="_blank"
                  rel="noopener noreferrer"
                  style={{
                    background: isPlayoff ? '#9b59b6' : '#2ecc71',
                    color: 'white', padding: '8px',
                    borderRadius: '6px', fontSize: '0.7rem', textDecoration: 'none',
                    fontWeight: 'bold', display: 'block', overflow: 'hidden',
                    textOverflow: 'ellipsis', whiteSpace: 'nowrap'
                  }}
                >
                  📺 {urlStream.replace('https://', '').replace('http://', '')}
                </a>
              ) : (
                /* TEXTO NO VÁLIDO CON AVISO A LA DERECHA */
                <div style={{
                  background: 'rgba(255,255,255,0.05)',
                  padding: '8px',
                  borderRadius: '6px',
                  fontSize: '0.7rem',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  border: '1px solid rgba(231, 76, 60, 0.3)'
                }}>
                  <span style={{ color: '#bdc3c7', fontStyle: 'italic', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {urlStream}
                  </span>
                  <span style={{
                    color: '#e74c3c',
                    fontWeight: 'bold',
                    fontSize: '0.6rem',
                    marginLeft: '10px',
                    whiteSpace: 'nowrap',
                    textTransform: 'uppercase'
                  }}>
                    ⚠️ Link no válido, no contará
                  </span>
                </div>
              )
            )
          ) : (
            /* MODO EDICIÓN */
            <input
              type="text"
              value={urlStream}
              onChange={e => setUrlStream(e.target.value)}
              placeholder="Link de Twitch/YouTube (Opcional)"
              style={{
                width: '100%', background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.2)', borderRadius: '6px',
                padding: '8px 10px', fontSize: '0.75rem', color: 'white'
              }}
            />
          )}
        </div>
      )}

      {!jugadoLocal && (
        <button onClick={guardar} disabled={enviando} style={{
          background: isPlayoff ? '#9b59b6' : '#2ecc71',
          color: 'white', border: 'none', padding: '12px', borderRadius: '8px',
          cursor: 'pointer', fontWeight: 'bold', width: '100%', marginTop: '10px', fontSize: '0.85rem'
        }}>
          {enviando ? 'GUARDANDO...' : 'POSTEAR RESULTADO'}
        </button>
      )}
    </div>
  )
}

function ProximoPartido({ profile, config, onUpdated }) {
  const [partidosLiga, setPartidosLiga] = useState([])
  const [partidosPlayoff, setPartidosPlayoff] = useState([])
  const [aviso, setAviso] = useState(null)
  const [loading, setLoading] = useState(true)
  const [encuestas, setEncuestas] = useState([]);
  const [votosPropios, setVotosPropios] = useState({}); // { encuesta_id: opcion_seleccionada }

  const cargar = async () => {
    if (!config || !profile) return;
    setLoading(true)

    try {
      // --- 0. CARGAR AVISO ---
      const { data: avisoData } = await supabase
        .from('avisos')
        .select('*')
        .eq('id', 1)
        .eq('mostrar', true) // Solo lo traemos si el checkbox está activo
        .maybeSingle();

      setAviso(avisoData);

      // --- 0.5 CARGAR ENCUESTAS ---
      const { data: encData } = await supabase
        .from('encuestas')
        .select('*')
        .eq('activa', true)
        .order('created_at', { ascending: false });

      if (encData && encData.length > 0) {
        setEncuestas(encData);

        // Cargar qué ha votado este usuario específicamente
        const { data: misVotos } = await supabase
          .from('votos_encuesta')
          .select('encuesta_id, opcion_index')
          .eq('usuario_id', profile.id)
          .in('encuesta_id', encData.map(e => e.id));

        const mapaVotos = {};
        misVotos?.forEach(v => mapaVotos[v.encuesta_id] = v.opcion_index);
        setVotosPropios(mapaVotos);
      }

      // --- 1. CARGAR PARTIDOS DE LIGA ---
      const { data: currentWeekData, error: weekError } = await supabase
        .from('weeks_schedule')
        .select('start_at, end_at')
        .eq('season', config.current_season)
        .eq('week', config.current_week)
        .maybeSingle();

      let ligaTemp = [];

      // Solo intentamos cargar partidos si encontramos la semana
      if (currentWeekData) {
        const { data: activeWeeks } = await supabase
          .from('weeks_schedule')
          .select('week')
          .eq('season', config.current_season)
          .eq('start_at', currentWeekData.start_at)
          .eq('end_at', currentWeekData.end_at);

        const weekNumbers = activeWeeks.map(w => w.week);

        const { data } = await supabase
          .from('partidos_detallados')
          .select('*')
          .eq('season', config.current_season)
          .in('week', weekNumbers)
          .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

        ligaTemp = data || [];
      } else {
        console.warn("No se encontró configuración de fechas para la semana actual.");
      }

      // --- 2. CARGAR PARTIDOS DE PLAYOFF ---
      const { data: playoffsActivos } = await supabase
        .from('playoffs')
        .select('id, name, current_round')
        .eq('season', config.current_season)
        .not('current_round', 'is', null)
        .neq('current_round', 'Finalizado');

      let playoffTemp = [];
      if (playoffsActivos && playoffsActivos.length > 0) {
        const idsActivos = playoffsActivos.map(p => p.id);

        // 1. Traemos todos los partidos detallados del usuario para estos playoffs
        const { data: todosMisPartidos } = await supabase
          .from('playoff_matches_detallados')
          .select('*')
          .in('playoff_id', idsActivos)
          .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

        if (todosMisPartidos) {
          playoffsActivos.forEach(po => {
            // 2. Buscamos el partido "referencia" que define las fechas actuales
            // Este es el partido que coincide con la current_round seleccionada en el admin
            const partidoReferencia = todosMisPartidos.find(
              m => m.playoff_id === po.id && m.round === po.current_round
            );

            if (partidoReferencia) {
              // 3. Filtramos todos los partidos que tengan las MISMAS fechas que el de referencia
              const partidosEnFecha = todosMisPartidos.filter(m =>
                m.playoff_id === po.id &&
                m.start_date === partidoReferencia.start_date &&
                m.end_date === partidoReferencia.end_date &&
                m.local_id !== null && // <--- El local debe existir
                m.visitante_id !== null // <--- El visitante debe existir
              );

              // 4. Los añadimos al listado temporal con el nombre del torneo
              const conNombre = partidosEnFecha.map(m => ({
                ...m,
                playoff_name: po.name
              }));

              playoffTemp = [...playoffTemp, ...conNombre];
            }
          });

          // Ordenamos por round para que si hay Ida y Vuelta, aparezcan en orden
          playoffTemp.sort((a, b) => a.round.localeCompare(b.round));
        }
      }

      setPartidosLiga(ligaTemp);
      setPartidosPlayoff(playoffTemp);

    } catch (error) {
      console.error("Error en carga:", error);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    cargar();
  }, [profile, config])

  if (loading) return <div style={{ fontSize: '0.8rem', color: '#95a5a6' }}>Cargando partidos...</div>

  const todosLosPartidos = [...partidosPlayoff, ...partidosLiga];

  const votar = async (encuestaId, opcionIndex) => {
    try {
      const { error } = await supabase
        .from('votos_encuesta')
        .upsert(
          {
            encuesta_id: encuestaId,
            usuario_id: profile.id,
            opcion_index: opcionIndex
          },
          { onConflict: 'encuesta_id, usuario_id' } // <-- ESTA LÍNEA ES LA CLAVE
        );

      if (error) throw error;

      setVotosPropios(prev => ({ ...prev, [encuestaId]: opcionIndex }));
    } catch (error) {
      console.error("Error completo:", error);
      alert("Error al guardar el voto: " + error.message);
    }
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>

      {/* SECCIÓN DE AVISO */}
      {aviso && (
        <div style={{
          background: '#fff3cd',
          border: '1px solid #ffeeba',
          padding: '20px',
          borderRadius: '12px',
          color: '#856404',
          boxShadow: '0 2px 5px rgba(0,0,0,0.05)'
        }}>
          <h2 style={{ margin: '0 0 10px 0', fontSize: '1.4rem', color: '#664d03' }}>
            {aviso.titulo}
          </h2>
          <div style={{ margin: 0, fontSize: '1rem', lineHeight: '1.4' }}>
            <ReactMarkdown>{aviso.contenido}</ReactMarkdown>
          </div>
        </div>
      )}

      {/* SECCIÓN DE ENCUESTAS */}
      {encuestas.map(enc => (
        <div key={enc.id} style={{
          background: '#ffffff',
          border: '1px solid #e1e8ed',
          padding: '15px',
          borderRadius: '12px',
          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
        }}>
          <h3 style={{ margin: '0 0 12px 0', fontSize: '1.1rem', color: '#2c3e50', display: 'flex', alignItems: 'center', gap: '8px' }}>
            📊 {enc.pregunta}
          </h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {enc.opciones.map((opcion, idx) => {
              const estaSeleccionado = votosPropios[enc.id] === idx;
              return (
                <button
                  key={idx}
                  onClick={() => votar(enc.id, idx)}
                  style={{
                    padding: '12px',
                    borderRadius: '8px',
                    border: estaSeleccionado ? '2px solid #3498db' : '1px solid #ced4da',
                    background: estaSeleccionado ? '#ebf5ff' : 'white',
                    color: estaSeleccionado ? '#2980b9' : '#495057',
                    fontWeight: estaSeleccionado ? 'bold' : 'normal',
                    cursor: 'pointer',
                    textAlign: 'left',
                    transition: 'all 0.2s ease',
                    fontSize: '0.9rem'
                  }}
                >
                  <span style={{ marginRight: '8px' }}>{estaSeleccionado ? '✅' : '⚪'}</span>
                  {opcion}
                </button>
              );
            })}
          </div>
          {votosPropios[enc.id] !== undefined && (
            <p style={{ fontSize: '0.7rem', color: '#95a5a6', marginTop: '10px', textAlign: 'center', fontStyle: 'italic' }}>
              Voto registrado. Puedes cambiarlo pulsando otra opción.
            </p>
          )}
        </div>
      ))}

      {todosLosPartidos.length === 0 ? (
        <div style={{ color: '#95a5a6', fontSize: '0.8rem', textAlign: 'center', padding: '20px' }}>
          No tienes partidos de Liga ni Playoff para esta semana.
        </div>
      ) : (
        todosLosPartidos.map(p => (
          <TarjetaResultado key={p.playoff_id ? `po-${p.id}` : `li-${p.id}`} partido={p} onUpdated={cargar} />
        ))
      )}
    </div>
  )
}

export default ProximoPartido;