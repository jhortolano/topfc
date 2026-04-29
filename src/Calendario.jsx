import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import CalendarioExtraPlayoff from './extraplayoff/CalendarioExtraPlayoff'
import CalendarioPromocion from './utils/CalendarioPromocion'


// --- HELPER DE CACHÉ ---
// Busca en sessionStorage; si no existe, ejecuta fetchFn, guarda y devuelve el resultado.
// sessionStorage se borra al cerrar/recargar la pestaña, por lo que los datos
// siempre se refrescan en la siguiente visita.
/*
const getOrFetch = async (key, fetchFn) => {
  try {
    const cached = sessionStorage.getItem(key);
    if (cached) return JSON.parse(cached);
  } catch (_) {
    // Si sessionStorage falla (modo privado, cuota llena) simplemente ignoramos el caché
  }
  const data = await fetchFn();
  try {
    sessionStorage.setItem(key, JSON.stringify(data));
  } catch (_) {}
  return data;
};
*/

// --- HELPER DE CACHÉ EN MEMORIA ---
// Al usar window.apiCache, los datos persisten mientras te mueves por la app,
// pero desaparecen completamente al pulsar F5 o recargar.
const getOrFetch = async (key, fetchFn) => {
  if (!window.apiCache) {
    window.apiCache = {};
  }

  if (window.apiCache[key]) {
    return window.apiCache[key];
  }

  const data = await fetchFn();
  window.apiCache[key] = data;
  return data;
};

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
      const data = await getOrFetch('seasons_list_cal', async () => {
        const { data: rows } = await supabase.from('matches').select('season');
        return rows ? [...new Set(rows.map(d => d.season))].sort((a, b) => b - a) : [];
      });
      setSeasons(data);
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

// --- NUEVO SELECTOR DE CATEGORÍAS CON MEMORIA ---
function CategorySelector({ current, onChange, season }) {
  const [categories, setCategories] = useState([]);
  const [activeTab, setActiveTab] = useState('div');
  const [lastSelected, setLastSelected] = useState({ div: null, po: null });
  const [hasPromo, setHasPromo] = useState(false);

  useEffect(() => {
    async function load() {
      if (!season) return;

      const all = await getOrFetch(`cal_cats_${season}`, async () => {
        // 1. Cargar Divisiones de Liga
        const { data: divData } = await supabase.from('matches').select('division').eq('season', season);
        const uniqueDivs = divData ? [...new Set(divData.map(d => d.division))].sort((a, b) => a - b) : [];

        // 2. Cargar Playoffs Normales
        const { data: pData } = await supabase.from('playoffs').select('*').eq('season', season);
        const formattedPlayoffs = pData ? pData.map(p => ({ id: p.id, label: p.name.toUpperCase(), type: 'po' })) : [];

        // 3. Cargar Playoffs Extra
        const { data: extraData } = await supabase.from('playoffs_extra').select('id, nombre').eq('season_id', season);
        const formattedExtras = extraData ? extraData.map(e => ({ id: e.id, label: e.nombre.toUpperCase(), type: 'extra' })) : [];

        // 4. Verificar si existen Promociones
        const { count } = await supabase
          .from('promo_matches')
          .select('*', { count: 'exact', head: true })
          .eq('season', season);

        return {
          cats: [
            ...uniqueDivs.map(d => ({ id: d, label: `DIV ${d}`, type: 'div' })),
            ...formattedPlayoffs,
            ...formattedExtras
          ],
          hasPromo: count > 0
        };
      });

      setCategories(all.cats);
      setHasPromo(all.hasPromo);

      // Gestionar pestaña activa según la categoría actual
      const currentCat = all.cats.find(c => c.id === current);
      if (currentCat) {
        const type = currentCat.type === 'div' ? 'div' : 'po';
        setActiveTab(type);
        setLastSelected(prev => ({ ...prev, [type]: currentCat.id }));
      } else if (current === 'promo') {
        setActiveTab('promo');
      }
    }
    load();
  }, [season, current]);

  const filteredCategories = categories.filter(cat =>
    activeTab === 'div' ? cat.type === 'div' : (cat.type === 'po' || cat.type === 'extra')
  );

  const hasLigas = categories.some(c => c.type === 'div');
  const hasPlayoffs = categories.some(c => c.type === 'po' || c.type === 'extra');

  const handleTabChange = (tab) => {
    setActiveTab(tab);
    if (tab === 'promo') {
      onChange('promo');
    } else if (lastSelected[tab]) {
      onChange(lastSelected[tab]);
    } else {
      const first = categories.find(c => tab === 'div' ? c.type === 'div' : (c.type === 'po' || c.type === 'extra'));
      if (first) onChange(first.id);
    }
  };

  const handleCategoryClick = (cat) => {
    const type = cat.type === 'div' ? 'div' : 'po';
    setLastSelected(prev => ({ ...prev, [type]: cat.id }));
    onChange(cat.id);
  };

  return (
    <div style={{ flex: 1 }}>
      <div style={{ display: 'flex', gap: '10px', marginBottom: '10px', borderBottom: '1px solid #eee', paddingBottom: '8px', flexWrap: 'wrap' }}>
        {hasLigas && (
          <button onClick={() => handleTabChange('div')} style={{
            padding: '6px 12px', borderRadius: '8px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
            background: activeTab === 'div' ? '#2ecc71' : 'transparent', color: activeTab === 'div' ? 'white' : '#64748b'
          }}> ⚽ LIGA </button>
        )}
        {hasPlayoffs && (
          <button onClick={() => handleTabChange('po')} style={{
            padding: '6px 12px', borderRadius: '8px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
            background: activeTab === 'po' ? '#34495e' : 'transparent', color: activeTab === 'po' ? 'white' : '#64748b'
          }}> 🏆 PLAYOFFS </button>
        )}
        {hasPromo && (
          <button onClick={() => handleTabChange('promo')} style={{
            padding: '6px 12px', borderRadius: '8px', border: 'none', fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
            background: activeTab === 'promo' ? '#e17055' : 'transparent', color: activeTab === 'promo' ? 'white' : '#64748b'
          }}> 🔥 PROMOCIÓN </button>
        )}
      </div>

      {activeTab !== 'promo' && (
        <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
          {filteredCategories.map(cat => (
            <button key={cat.id} onClick={() => handleCategoryClick(cat)} style={{
              padding: '5px 12px', borderRadius: '15px', border: 'none', fontSize: '0.65rem', fontWeight: 'bold', cursor: 'pointer',
              background: current === cat.id ? (cat.type === 'div' ? '#2ecc71' : '#34495e') : '#ecf0f1',
              color: current === cat.id ? 'white' : '#7f8c8d'
            }}> {cat.label} </button>
          ))}
        </div>
      )}
    </div>
  );
}

// --- COMPONENTE PRINCIPAL ---
export default function CalendarioCompleto({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(() => {
    const cached = localStorage.getItem(`pref_cal_div_${config?.current_season}`);
    // Si es un número (division), lo parseamos; si es un UUID (playoff), lo dejamos como string
    return cached ? (isNaN(cached) ? cached : parseInt(cached)) : 1;
  });
  const [userNick, setUserNick] = useState(null);
  const [currentUserId, setCurrentUserId] = useState(null);
  const [playoffs, setPlayoffs] = useState([]);
  const [divisions, setDivisions] = useState([]);
  const [partidos, setPartidos] = useState([]);
  const [jornadasActivas, setJornadasActivas] = useState([]);
  const [fechasJornadas, setFechasJornadas] = useState({});
  const isExtraTab = vD === 'extra';
  const [extraPlayoffs, setExtraPlayoffs] = useState([]);
  const currentExtraPlayoff = extraPlayoffs.find(ep => ep.id === vD);
  const [reprogramaciones, setReprogramaciones] = useState([]);

  const formatShortDate = (dateStr) => {
    if (!dateStr) return '??/??';
    const d = new Date(dateStr);
    return d.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit' });
  };

  // Lógica para detectar la división del usuario logueado y cachearla
  useEffect(() => {
    async function checkUserContext() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      setCurrentUserId(user.id);

      const cacheKey = `pref_cal_div_${vS}`;
      const cachedValue = localStorage.getItem(cacheKey);

      if (!cachedValue) {
        // Solo consultamos la DB si no tenemos preferencia guardada
        const { data: userDiv } = await supabase
          .from('clasificacion')
          .select('division')
          .eq('season', vS)
          .eq('user_id', user.id)
          .maybeSingle();

        if (userDiv?.division) {
          setVD(userDiv.division);
          localStorage.setItem(cacheKey, userDiv.division);
        }
      }
    }
    if (vS) checkUserContext();
  }, [vS]);

  // Función para cambiar de pestaña y actualizar caché
  const handleTabChange = (newVD) => {
    setVD(newVD);
    localStorage.setItem(`pref_cal_div_${vS}`, newVD);
  };

  useEffect(() => {
    async function loadSelectors() {
      if (!vS) return;

      const selectorData = await getOrFetch(`cal_selectors_${vS}`, async () => {
        const [divRes, pRes, extraRes] = await Promise.all([
          supabase.from('matches').select('division').eq('season', vS),
          supabase.from('playoffs').select('*').eq('season', vS),
          supabase.from('playoffs_extra').select('id, nombre').eq('season_id', vS)
        ]);
        return {
          divs: divRes.data ? [...new Set(divRes.data.map(d => d.division))].sort((a, b) => a - b) : [],
          playoffs: pRes.data || [],
          extras: extraRes.data || []
        };
      });

      setDivisions(selectorData.divs);
      setPlayoffs(selectorData.playoffs);
      setExtraPlayoffs(selectorData.extras);
    }
    loadSelectors();
  }, [vS]);

  useEffect(() => {
    async function fetch() {
      if (!vS) return;

      if (vD === 'promo') return;

      const isPlayoff = typeof vD === 'string';

      if (!isPlayoff) {
        // --- LÓGICA LIGA ---
        const dataPartidos = await getOrFetch(`cal_partidos_${vS}_${vD}`, async () => {
          const { data } = await supabase
            .from('partidos_detallados')
            .select('*')
            .eq('season', vS)
            .eq('division', vD)
            .order('week', { ascending: true });
          return data || [];
        });
        setPartidos(dataPartidos);

        const dataFechas = await getOrFetch(`cal_fechas_${vS}`, async () => {
          const { data } = await supabase.from('weeks_schedule').select('*').eq('season', vS);
          return data || [];
        });
        if (dataFechas.length > 0) {
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

        const dataResched = await getOrFetch(`cal_resched_${vS}`, async () => {
          const { data } = await supabase
            .from('matches_rescheduled')
            .select('*')
            .eq('tipo_partido', 'liga');
          return data || [];
        });
        setReprogramaciones(dataResched);

        if (vS === config?.current_season && config.current_week > 0) {
          const curW = await getOrFetch(`cal_curweek_${vS}_${config.current_week}`, async () => {
            const { data } = await supabase
              .from('weeks_schedule')
              .select('start_at, end_at')
              .eq('season', vS)
              .eq('week', config.current_week)
              .single();
            return data || null;
          });
          if (curW) {
            const activeW = await getOrFetch(`cal_activeweeks_${vS}_${config.current_week}`, async () => {
              const { data } = await supabase
                .from('weeks_schedule')
                .select('week')
                .eq('season', vS)
                .eq('start_at', curW.start_at)
                .eq('end_at', curW.end_at);
              return data || [];
            });
            setJornadasActivas(activeW.map(w => w.week));
          }
        } else {
          setJornadasActivas([]);
        }

      } else {
        // --- LÓGICA PLAYOFF CON STREAMS SEPARADOS ---
        const partidosConStream = await getOrFetch(`cal_po_${vD}`, async () => {
          const [poRes, streamsRes] = await Promise.all([
            supabase.from('playoff_matches_detallados').select('*').eq('playoff_id', vD).order('start_date', { ascending: true }),
            supabase.from('match_playoff_streams').select('*')
          ]);
          const matches = poRes.data || [];
          const streams = streamsRes.data || [];
          return matches.map(m => ({
            ...m,
            stream_url: streams.find(s => s.playoff_match_id === m.id)?.stream_url || null
          }));
        });

        setPartidos(partidosConStream);

        // --- LÓGICA DE JORNADAS ACTIVAS ---
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

  useEffect(() => {
    async function getMyNick() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data } = await supabase
          .from('profiles')
          .select('nick')
          .eq('id', user.id)
          .single();
        if (data) setUserNick(data.nick);
      }
    }
    getMyNick();
  }, [supabase.auth]);

  const isPlayoffActive = typeof vD === 'string';
  const grupos = [...new Set(partidos.map(p => isPlayoffActive ? p.round : p.week))].filter(Boolean);

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '20px', gap: '15px' }}>
        {/* Usamos el nuevo componente selector */}
        <CategorySelector
          season={vS}
          current={vD}
          onChange={handleTabChange}
        />

        <div style={{ paddingTop: '5px' }}>
          <SeasonSelector current={vS} onChange={setVS} />
        </div>
      </div>

      {currentExtraPlayoff ? (
        /* SI ES EXTRA PLAYOFF: Mostramos su componente */
        <CalendarioExtraPlayoff season={vS} config={config} extraId={currentExtraPlayoff.id} />
      ) : vD === 'promo' ? (
        /* NUEVO: SI ES PROMOCIÓN */
        <CalendarioPromocion season={vS} />
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
                {partidosVisibles.map(p => {
                  const esMiPartido = userNick && (p.local_nick === userNick || p.visitante_nick === userNick);
                  return (
                    <div key={p.id} style={{ borderBottom: '1px solid #fafafa', position: 'relative', background: esMiPartido ? 'rgba(92, 203, 138, 0.04)' : 'transparent', borderLeft: esMiPartido ? '3px solid #2ecc71' : '3px solid transparent' }}>
                      {/* 1. FILA DE CONTENIDO (NICKS, MARCADOR Y TV) */}
                      <div style={{ display: 'flex', alignItems: 'center', padding: '8px 10px', fontSize: '0.75rem', gap: '10px', fontWeight: esMiPartido ? 'bold' : 'normal' }}>

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
                          {p.stream_url &&
                            p.stream_url.includes('http') &&
                            p.stream_url !== "https://www.twitch.tv/p/es-es/about/" && ( 
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
                            paddingBottom: '8px',
                            marginTop: '-4px',
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
                            color: '#e74c3c',
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
                  );
                }
                )}
              </div>
            )
          })
        )
      )}
    </div>
  )
}
