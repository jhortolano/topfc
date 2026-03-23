import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import CalendarioExtraPlayoff from './extraplayoff/CalendarioExtraPlayoff'

// --- COMPONENTE PARA EL ZOOM ---
const AvatarConZoom = ({ url }) => {
  const [isTouched, setIsTouched] = useState(false);

  return (
    <div
      onTouchStart={() => setIsTouched(true)}
      onTouchEnd={() => setIsTouched(false)}
      onMouseEnter={e => {
        e.currentTarget.style.transform = 'scale(2.8)';
        e.currentTarget.style.zIndex = '100';
      }}
      onMouseLeave={e => {
        e.currentTarget.style.transform = 'scale(1)';
        e.currentTarget.style.zIndex = '1';
      }}
      style={{
        width: '24px', height: '24px', borderRadius: '50%',
        overflow: 'hidden', background: '#eee', border: '1px solid #ddd',
        flexShrink: 0, cursor: 'pointer', transition: 'transform 0.2s ease-in-out',
        position: 'relative',
        zIndex: isTouched ? 100 : 1,
        transform: isTouched ? 'scale(2.8)' : 'scale(1)'
      }}
    >
      {url ? (
        <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      ) : (
        <div style={{ fontSize: '0.6rem', color: '#bdc3c7', textAlign: 'center', lineHeight: '24px' }}>👤</div>
      )}
    </div>
  );
};

// --- SELECTORES ---
function SeasonSelector({ current, onChange }) {
  const [seasons, setSeasons] = useState([])
  useEffect(() => {
    async function load() {
      const { data } = await supabase.from('matches').select('season')
      if (data) setSeasons([...new Set(data.map(d => d.season))].sort((a, b) => b - a))
    }
    load()
  }, [])
  return (
    <select value={current || ''} onChange={(e) => onChange(parseInt(e.target.value))}
      style={{ padding: '4px', borderRadius: '4px', fontSize: '0.8rem', background: 'white' }}>
      {seasons.map(s => <option key={s} value={s}>T{s}</option>)}
    </select>
  )
}

// --- COMPONENTE PRINCIPAL ---
export default function CalendarioCompleto({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [playoffs, setPlayoffs] = useState([]);
  const [divisions, setDivisions] = useState([]);
  const [partidos, setPartidos] = useState([]);
  const [jornadasActivas, setJornadasActivas] = useState([]);
  const [fechasJornadas, setFechasJornadas] = useState({});
  const isExtraTab = vD === 'extra';
  const [extraPlayoffs, setExtraPlayoffs] = useState([]); // Nuevo estado
  const currentExtraPlayoff = extraPlayoffs.find(ep => ep.id === vD);
  const [reprogramaciones, setReprogramaciones] = useState([]);

  const formatShortDate = (dateStr) => {
    if (!dateStr) return '??/??';
    const d = new Date(dateStr);
    return d.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit' });
  };

  useEffect(() => {
    async function loadSelectors() {
      if (!vS) return;
      const { data: divData } = await supabase.from('matches').select('division').eq('season', vS);
      if (divData) {
        const uniqueDivs = [...new Set(divData.map(d => d.division))].sort((a, b) => a - b);
        setDivisions(uniqueDivs);
      }
      const { data: pData } = await supabase.from('playoffs').select('*').eq('season', vS);
      setPlayoffs(pData || []);

      const { data: extraData } = await supabase
        .from('playoffs_extra')
        .select('id, nombre')
        .eq('season_id', vS);
      setExtraPlayoffs(extraData || []);

    }
    loadSelectors();
  }, [vS]);

  useEffect(() => {
    async function fetch() {
      if (!vS) return;
      const isPlayoff = typeof vD === 'string';

      if (!isPlayoff) {
        // --- LÓGICA LIGA ---
        const { data: dataPartidos } = await supabase
          .from('partidos_detallados')
          .select('*')
          .eq('season', vS)
          .eq('division', vD)
          .order('week', { ascending: true });
        setPartidos(dataPartidos || []);

        const { data: dataFechas } = await supabase.from('weeks_schedule').select('*').eq('season', vS);
        if (dataFechas) {
          const mapa = {};
          dataFechas.forEach(f => {
            mapa[f.week] = {
              inicio: new Date(f.start_at).toLocaleString([], { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' }),
              fin: new Date(f.end_at).toLocaleString([], { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' }),
              raw_inicio: f.start_at
            };
          });
          setFechasJornadas(mapa);
        }

        const { data: dataResched } = await supabase
          .from('matches_rescheduled')
          .select('*')
          .eq('tipo_partido', 'liga');
        setReprogramaciones(dataResched || []);

        if (vS === config?.current_season && config.current_week > 0) {
          const { data: curW } = await supabase.from('weeks_schedule').select('start_at, end_at').eq('season', vS).eq('week', config.current_week).single();
          if (curW) {
            const { data: activeW } = await supabase.from('weeks_schedule').select('week').eq('season', vS).eq('start_at', curW.start_at).eq('end_at', curW.end_at);
            setJornadasActivas(activeW.map(w => w.week));
          }
        } else { setJornadasActivas([]); }

      } else {
        // --- LÓGICA PLAYOFF CON STREAMS SEPARADOS ---
        // 1. Traemos los partidos de la vista
        const { data: dataPlayoff } = await supabase
          .from('playoff_matches_detallados')
          .select('*')
          .eq('playoff_id', vD)
          .order('start_date', { ascending: true });

        // 2. Traemos todos los streams de la tabla de streams
        const { data: dataStreams } = await supabase
          .from('match_playoff_streams')
          .select('*');

        // 3. Cruzamos los datos manualmente (Match ID -> Stream URL)
        const partidosConStream = dataPlayoff?.map(m => {
          // Buscamos si este partido (m.id) tiene un stream en dataStreams
          // NOTA: Asegúrate de que la columna en la tabla de streams se llame 'match_id'
          const streamEncontrado = dataStreams?.find(s => s.playoff_match_id === m.id);
          return {
            ...m,
            stream_url: streamEncontrado ? streamEncontrado.stream_url : null
          };
        }) || [];

        setPartidos(partidosConStream);

        // --- LÓGICA DE JORNADAS ACTIVAS (IGUAL QUE ANTES) ---
        const currentPO = playoffs.find(p => p.id === vD);
        if (currentPO && partidosConStream.length > 0) {
          const refMatch = partidosConStream.find(m => m.round === currentPO.current_round);
          if (refMatch && refMatch.start_date && refMatch.end_date) {
            const rondasConMismaFecha = partidosConStream
              .filter(m => m.start_date === refMatch.start_date && m.end_date === refMatch.end_date)
              .map(m => m.round);
            setJornadasActivas([...new Set(rondasConMismaFecha)]);
          } else {
            setJornadasActivas([currentPO.current_round]);
          }
        }
      }
    }
    fetch();
  }, [vS, vD, config, playoffs]);

  const isPlayoffActive = typeof vD === 'string';
  const grupos = [...new Set(partidos.map(p => isPlayoffActive ? p.round : p.week))].filter(Boolean);

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '15px', gap: '10px' }}>
        <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
          {divisions.map(d => (
            <button key={d} onClick={() => setVD(d)} style={{
              padding: '5px 12px', borderRadius: '15px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
              background: vD === d ? '#2ecc71' : '#ecf0f1', color: vD === d ? 'white' : '#7f8c8d'
            }}> DIV {d} </button>
          ))}
          {playoffs.map(po => (
            <button key={po.id} onClick={() => setVD(po.id)} style={{
              padding: '5px 12px', borderRadius: '15px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
              background: vD === po.id ? '#34495e' : '#ecf0f1', color: vD === po.id ? 'white' : '#7f8c8d'
            }}> {po.name.toUpperCase()} </button>
          ))}
          {extraPlayoffs.map(ep => (
            <button
              key={ep.id}
              onClick={() => setVD(ep.id)} // Guardamos el ID en vD
              style={{
                padding: '5px 12px', borderRadius: '15px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
                background: vD === ep.id ? '#e67e22' : '#ecf0f1',
                color: vD === ep.id ? 'white' : '#7f8c8d'
              }}
            >
              {ep.nombre.toUpperCase()}
            </button>
          ))}
        </div>
        <SeasonSelector current={vS} onChange={setVS} />
      </div>

      {currentExtraPlayoff ? (
        /* SI ES EXTRA PLAYOFF: Mostramos su componente */
        <CalendarioExtraPlayoff season={vS} config={config} extraId={currentExtraPlayoff.id} />
      ) : (
        /* SI NO ES EXTRA (Liga o Playoff normal): Mostramos el código original */
        grupos.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#95a5a6', fontSize: '0.8rem' }}>No hay partidos.</p>
        ) : (
          grupos.map(n => {
            const partidosDelGrupo = partidos.filter(p => (isPlayoffActive ? p.round : p.week) === n);

            const counts = isPlayoffActive ? partidos.reduce((acc, p) => { acc[p.round] = (acc[p.round] || 0) + 1; return acc; }, {}) : {};
            const maxP = Math.max(...Object.values(counts), 0);
            const esPrimeraFase = isPlayoffActive && counts[n] === maxP;

            const partidosVisibles = esPrimeraFase
              ? partidosDelGrupo.filter(p =>
                p.local_nick && p.local_nick !== 'TBD' && p.local_nick !== 'BYE' &&
                p.visitante_nick && p.visitante_nick !== 'TBD' && p.visitante_nick !== 'BYE'
              )
              : partidosDelGrupo;

            if (partidosVisibles.length === 0) return null;

            const estaActiva = jornadasActivas.includes(n);
            const primerP = partidosVisibles[0];
            const fechaRef = isPlayoffActive && primerP ? {
              inicio: new Date(primerP.start_date).toLocaleString([], { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' }),
              fin: new Date(primerP.end_date).toLocaleString([], { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' })
            } : fechasJornadas[n];

            return (
              <div key={n} style={{
                marginBottom: '10px', border: estaActiva ? '2px solid #2ecc71' : '1px solid #eee',
                borderRadius: '8px', overflow: 'hidden', boxShadow: estaActiva ? '0 0 10px rgba(46, 204, 113, 0.1)' : 'none'
              }}>
                <div style={{
                  background: estaActiva ? '#2ecc71' : '#f8f9fa', color: estaActiva ? 'white' : '#2c3e50',
                  padding: '8px 10px', fontSize: '0.75rem', fontWeight: 'bold', display: 'flex', flexDirection: 'column', gap: '2px'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span>{isPlayoffActive ? n : `Jornada ${n}`}</span>
                    {estaActiva && <span style={{ fontSize: '0.6rem', background: 'rgba(255,255,255,0.2)', padding: '2px 6px', borderRadius: '4px' }}>ACTUAL</span>}
                  </div>
                  {fechaRef && (
                    <div style={{ fontSize: '0.65rem', fontWeight: 'normal', opacity: 0.8 }}>
                      {fechaRef.inicio}  -  {fechaRef.fin}
                    </div>
                  )}
                </div>
                {partidosVisibles.map(p => (
                  <div key={p.id} style={{ borderBottom: '1px solid #fafafa', position: 'relative' }}>
                    {/* 1. FILA DE CONTENIDO (NICKS, MARCADOR Y TV) */}
                    <div style={{ display: 'flex', alignItems: 'center', padding: '8px 10px', fontSize: '0.75rem', gap: '10px' }}>

                      {/* Local */}
                      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '8px', textAlign: 'right' }}>
                        <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{p.local_nick || 'TBD'}</span>
                        <AvatarConZoom url={p.local_avatar} />
                      </div>

                      {/* Marcador */}
                      <div style={{ width: '45px', textAlign: 'center', fontWeight: 'bold', background: '#f8f9fa', borderRadius: '4px', padding: '2px 0' }}>
                        {(p.is_played || p.played) || (p.home_score !== null && p.away_score !== null)
                          ? `${p.home_score}-${p.away_score}`
                          : 'vs'}
                      </div>

                      {/* Visitante */}
                      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-start', gap: '8px', textAlign: 'left' }}>
                        <AvatarConZoom url={p.visitante_avatar} />
                        <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{p.visitante_nick || 'TBD'}</span>
                      </div>

                      {/* Icono TV (A la derecha del todo) */}
                      <div style={{ width: '20px', display: 'flex', justifyContent: 'center' }}>
                        {p.stream_url && p.stream_url.includes('http') && (
                          <a href={p.stream_url} target="_blank" rel="noopener noreferrer" title="Ver retransmisión"
                            style={{ textDecoration: 'none', fontSize: '0.9rem', cursor: 'pointer', filter: 'grayscale(0.2)' }}>
                            📺
                          </a>
                        )}
                      </div>
                    </div>

                    {/* 2. FILA DE REPROGRAMACIÓN (FUERA DEL FLEX PARA QUE VAYA DEBAJO) */}
                    {!isPlayoffActive && reprogramaciones.find(r => r.match_id === p.id) && (() => {
                      const resched = reprogramaciones.find(r => r.match_id === p.id);
                      return (
                        <div style={{
                          width: '100%',
                          textAlign: 'center',
                          paddingBottom: '8px', // Espacio abajo para que no pegue a la siguiente fila
                          marginTop: '-4px',    // Para que no quede un hueco enorme
                          pointerEvents: 'none'
                        }}>
                          <span style={{
                            fontSize: '0.55rem',
                            color: '#e67e22',
                            fontStyle: 'italic',
                            whiteSpace: 'nowrap',
                            background: 'rgba(255,255,255,0.8)',
                            padding: '2px 4px',
                            borderRadius: '4px',
                            display: 'inline-block'
                          }}>
                            (Reprogramado de {formatShortDate(resched.fecha_inicio)} a {formatShortDate(resched.fecha_fin)})
                          </span>
                        </div>
                      );
                    })()}
                    {/* 3. FILA DE ESTADO "NO JUGADO" (Cuando hay goles pero el flag es falso/null) */}
                    {(!(p.is_played || p.played)) && (p.home_score !== null && p.away_score !== null) && (
                      <div style={{
                        width: '100%',
                        textAlign: 'center',
                        paddingBottom: '8px',
                        marginTop: '-4px',
                        pointerEvents: 'none'
                      }}>
                        <span style={{
                          fontSize: '0.55rem',
                          color: '#e74c3c', // Un rojo suave para indicar la inconsistencia
                          fontWeight: 'bold',
                          textTransform: 'uppercase',
                          letterSpacing: '0.5px',
                          background: 'rgba(255,255,255,0.9)',
                          padding: '2px 6px',
                          borderRadius: '4px',
                          border: '1px solid #fab1a0',
                          display: 'inline-block'
                        }}>
                          ⚠️ No Jugado
                        </span>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )
          })
        )
      )}
    </div>
  )
}