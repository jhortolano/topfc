import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

// --- HELPER DE CACHÉ ---
// Busca en sessionStorage; si no existe, ejecuta fetchFn, guarda y devuelve el resultado.
// sessionStorage se borra al cerrar/recargar la pestaña, por lo que los datos
// siempre se refrescan en la siguiente visita.
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

const Avatar = ({ url, size = '24px' }) => {
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
        width: size, height: size, borderRadius: '50%', background: '#34495e',
        border: '2px solid #2ecc71', flexShrink: 0, overflow: 'hidden',
        cursor: 'pointer', transition: 'transform 0.2s ease-in-out',
        position: 'relative', zIndex: isTouched ? 100 : 1,
        transform: isTouched ? 'scale(2.8)' : 'scale(1)'
      }}
    >
      {url ? (
        <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} alt="avatar" />
      ) : (
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.6rem', color: '#7f8c8d' }}>👤</div>
      )}
    </div>
  );
};

export default function ClasificacionExtraPlayoff({ season, id }) {
  const [activeTab, setActiveTab] = useState('liguilla');
  const [grupos, setGrupos] = useState({});
  const [playoffMatches, setPlayoffMatches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [nombrePlayoff, setNombrePlayoff] = useState('');
  const [collapsedRounds, setCollapsedRounds] = useState({});
  const [currentUserId, setCurrentUserId] = useState(null);

  const renderExtraBrackets = () => {
    const rondasOrden = ["DIECISEISAVOS", "OCTAVOS", "CUARTOS", "SEMIFINALES", "FINAL"];

    const getBaseRound = (name) => {
      if (!name) return "OTRA";
      const n = name.toUpperCase();
      if (n.includes("DIECISEISAVOS")) return "DIECISEISAVOS";
      if (n.includes("OCTAVOS")) return "OCTAVOS";
      if (n.includes("CUARTOS")) return "CUARTOS";
      if (n.includes("SEMIS") || n.includes("SEMIFINAL")) return "SEMIFINALES";
      if (n.includes("FINAL")) return "FINAL";
      return n;
    };

    // Función para cambiar el estado de visible/oculto
    const toggleRound = (round) => {
      setCollapsedRounds(prev => ({
        ...prev,
        [round]: !prev[round]
      }));
    };

    const rondasDetectadas = [...new Set(playoffMatches.map(m => getBaseRound(m.numero_jornada)))];
    const rondasUnicas = rondasDetectadas.sort((a, b) => {
      const indexA = rondasOrden.indexOf(a);
      const indexB = rondasOrden.indexOf(b);
      return (indexA === -1 ? 99 : indexA) - (indexB === -1 ? 99 : indexB);
    });

    const bracketData = {};
    rondasUnicas.forEach(baseRound => {
      const matchesInRound = playoffMatches.filter(m => getBaseRound(m.numero_jornada) === baseRound);
      const enfrentamientos = [];
      const idsProcesados = new Set();
      matchesInRound.forEach(m => {
        if (idsProcesados.has(m.id)) return;
        const pareja = matchesInRound.filter(pm => {
          if (idsProcesados.has(pm.id)) return false;
          return (pm.p1_nick === m.p1_nick && pm.p2_nick === m.p2_nick) ||
            (pm.p1_nick === m.p2_nick && pm.p2_nick === m.p1_nick);
        });
        enfrentamientos.push(pareja);
        pareja.forEach(p => idsProcesados.add(p.id));
      });
      bracketData[baseRound] = enfrentamientos;
    });

    return (
      <div style={{
        display: 'flex', gap: '15px', overflowX: 'auto', padding: '20px',
        background: '#f8fafc', borderRadius: '12px', minHeight: '450px',
        border: '1px solid #e2e8f0'
      }}>
        {rondasUnicas.map((round) => {
          const isCollapsed = collapsedRounds[round];

          return (
            <div key={round} style={{
              display: 'flex',
              flexDirection: 'column',
              width: isCollapsed ? '40px' : '220px',
              transition: 'all 0.3s ease',
              flexShrink: 0
            }}>
              {/* TÍTULO CLICKABLE */}
              <h4
                onClick={() => toggleRound(round)}
                style={{
                  fontSize: '0.65rem',
                  color: isCollapsed ? '#94a3b8' : '#2ecc71',
                  textAlign: 'center',
                  marginBottom: '15px',
                  textTransform: 'uppercase',
                  fontWeight: '900',
                  letterSpacing: '1px',
                  cursor: 'pointer',
                  padding: '10px 5px',
                  background: isCollapsed ? '#cbd5e1' : 'transparent',
                  border: isCollapsed ? '1px solid #94a3b8' : 'none',
                  color: isCollapsed ? '#475569' : '#2ecc71',
                  borderRadius: '8px',
                  writingMode: isCollapsed ? 'vertical-lr' : 'horizontal-tb',
                  transform: isCollapsed ? 'rotate(180deg)' : 'none',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  userSelect: 'none'
                }}
              >
                {isCollapsed ? `+ ${round}` : `▼ ${round}`}
              </h4>

              {/* CONTENIDO (Solo se ve si no está colapsado) */}
              {!isCollapsed && (
                <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-around', flexGrow: 1 }}>
                  {bracketData[round].map((pair, idx) => {
                    const m1 = pair[0];
                    const m2 = pair[1];
                    let g1 = m1.score1 || 0;
                    let g2 = m1.score2 || 0;
                    if (m2) {
                      if (m2.p1_nick === m1.p1_nick) { g1 += (m2.score1 || 0); g2 += (m2.score2 || 0); }
                      else { g1 += (m2.score2 || 0); g2 += (m2.score1 || 0); }
                    }
                    const finalizado = m1.is_played && (m2 ? m2.is_played : true);

                    return (
                      <div key={idx} style={{
                        background: '#fff', borderRadius: '10px', padding: '10px',
                        boxShadow: '0 2px 10px rgba(0,0,0,0.05)', border: '1px solid #e2e8f0',
                        margin: '10px 0', borderLeft: '4px solid #34495e',
                        position: 'relative'
                      }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '5px' }}>
                          <Avatar url={m1.p1_avatar} size="20px" />
                          <span style={{ fontSize: '0.7rem', fontWeight: g1 > g2 && finalizado ? 'bold' : '500', color: '#2c3e50' }}>{m1.p1_nick}</span>
                          <span style={{ fontSize: '0.75rem', color: '#2ecc71', fontWeight: 'bold' }}>{finalizado ? g1 : '-'}</span>
                        </div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                          <Avatar url={m1.p2_avatar} size="20px" />
                          <span style={{ fontSize: '0.7rem', fontWeight: g2 > g1 && finalizado ? 'bold' : '500', color: '#2c3e50' }}>{m1.p2_nick}</span>
                          <span style={{ fontSize: '0.75rem', color: '#2ecc71', fontWeight: 'bold' }}>{finalizado ? g2 : '-'}</span>
                        </div>
                        {m2 && (
                          <div style={{ marginTop: '8px', paddingTop: '5px', borderTop: '1px solid #f1f5f9', display: 'flex', justifyContent: 'space-between', fontSize: '0.5rem', color: '#94a3b8' }}>
                            <span>IDA: {m1.score1}-{m1.score2}</span>
                            <span>VTA: {m2.score1}-{m2.score2}</span>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </div>
    );
  };

  useEffect(() => {
    async function getSession() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) setCurrentUserId(user.id);
    }
    getSession();
  }, []);

  useEffect(() => {
    async function loadExtraData() {
      setLoading(true);
      const cleanId = id.toString().replace('extra-', '');

      try {
        // --- QUERY 1: Nombre del playoff (cacheado por ID) ---
        const extraInfo = await getOrFetch(`extra_info_${cleanId}`, async () => {
          const { data } = await supabase
            .from('playoffs_extra')
            .select('nombre')
            .eq('id', cleanId)
            .single();
          return data || null;
        });
        if (extraInfo) setNombrePlayoff(extraInfo.nombre);

        // --- QUERY 2: Clasificación de liguilla (cacheada por ID) ---
        const clasiData = await getOrFetch(`extra_clasi_${cleanId}`, async () => {
          const { data } = await supabase
            .from('extra_playoffs_clasificacion')
            .select('*')
            .eq('playoff_extra_id', cleanId);
          return data || [];
        });

        const grouped = clasiData.reduce((acc, curr) => {
          const groupName = curr.nombre_grupo_texto || curr.nombre_grupo || 'General';
          if (!acc[groupName]) acc[groupName] = [];
          acc[groupName].push(curr);
          return acc;
        }, {});

        Object.keys(grouped).forEach(groupName => {
          grouped[groupName].sort((a, b) => {
            if (b.pts !== a.pts) return b.pts - a.pts;
            if (b.dg !== a.dg) return b.dg - a.dg;
            return b.gf - a.gf;
          });
        });

        setGrupos(grouped);

        // --- QUERY 3: Partidos del bracket (cacheados por ID) ---
        const matches = await getOrFetch(`extra_bracket_${cleanId}`, async () => {
          const { data } = await supabase
            .from('v_extra_playoffs_bracket_dinamico')
            .select('*')
            .eq('playoff_extra_id', cleanId)
            .order('id', { ascending: true });
          return data || [];
        });

        setPlayoffMatches(matches);

        // --- LÓGICA DE AUTO-COLAPSADO ---
        if (matches.length > 0) {
          const rondasOrden = ["DIECISEISAVOS", "OCTAVOS", "CUARTOS", "SEMIFINALES", "FINAL"];

          const getBaseRound = (name) => {
            if (!name) return "OTRA";
            const n = name.toUpperCase();
            if (n.includes("DIECISEISAVOS")) return "DIECISEISAVOS";
            if (n.includes("OCTAVOS")) return "OCTAVOS";
            if (n.includes("CUARTOS")) return "CUARTOS";
            if (n.includes("SEMIS") || n.includes("SEMIFINAL")) return "SEMIFINALES";
            if (n.includes("FINAL")) return "FINAL";
            return n;
          };

          const rondasUnicas = [...new Set(matches.map(m => getBaseRound(m.numero_jornada)))];
          const initialCollapsed = {};

          rondasUnicas.forEach(ronda => {
            // No colapsar nunca por defecto Semis ni Final
            if (ronda === "SEMIFINALES" || ronda === "FINAL") {
              initialCollapsed[ronda] = false;
              return;
            }

            const partidosDeRonda = matches.filter(m => getBaseRound(m.numero_jornada) === ronda);
            // Verificamos si todos los partidos de esta ronda tienen is_played = true
            const todosJugados = partidosDeRonda.every(m => m.is_played);

            if (todosJugados && partidosDeRonda.length > 0) {
              initialCollapsed[ronda] = true;
            }
          });

          setCollapsedRounds(initialCollapsed);
        }

      } catch (err) {
        console.error("Error cargando datos:", err);
      } finally {
        setLoading(false);
      }
    }

    if (id) loadExtraData();
  }, [id]);

  if (loading) return <div style={{ padding: '20px', fontSize: '0.8rem', color: '#7f8c8d' }}>Cargando clasificación...</div>;

  return (
    <div style={{ padding: '10px' }}>
      <h3 style={{ fontSize: '1.1rem', color: '#2c3e50', textAlign: 'center', marginBottom: '20px', textTransform: 'uppercase' }}>
        {nombrePlayoff}
      </h3>

      <div style={{ display: 'flex', justifyContent: 'center', gap: '10px', marginBottom: '20px' }}>
        <button
          onClick={() => setActiveTab('liguilla')}
          style={{
            padding: '8px 16px', borderRadius: '20px', border: 'none',
            background: activeTab === 'liguilla' ? '#2ecc71' : '#ecf0f1',
            color: activeTab === 'liguilla' ? 'white' : '#7f8c8d',
            cursor: 'pointer', fontWeight: 'bold', fontSize: '0.7rem'
          }}
        >
          LIGUILLA
        </button>
        <button
          onClick={() => setActiveTab('playoff')}
          style={{
            padding: '8px 16px', borderRadius: '20px', border: 'none',
            background: activeTab === 'playoff' ? '#34495e' : '#ecf0f1',
            color: activeTab === 'playoff' ? 'white' : '#7f8c8d',
            cursor: 'pointer', fontWeight: 'bold', fontSize: '0.7rem'
          }}
        >
          ELIMINATORIAS
        </button>
      </div>

      {activeTab === 'liguilla' && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '25px' }}>
          {Object.keys(grupos).length > 0 ? Object.keys(grupos).sort().map(groupName => (
            <div key={groupName}>
              <h4 style={{ fontSize: '0.75rem', color: '#95a5a6', marginBottom: '8px', paddingLeft: '5px', textTransform: 'uppercase' }}>
                {groupName}
              </h4>
              <div style={{ background: '#fff', borderRadius: '8px', boxShadow: '0 2px 4px rgba(0,0,0,0.05)', overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.7rem' }}>
                  <thead>
                    <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
                      <th style={{ padding: '12px 5px', width: '20px' }}></th>
                      <th style={{ padding: '12px 10px', textAlign: 'left' }}>JUGADOR</th>
                      <th style={{ padding: '10px' }}>PTS</th>
                      <th style={{ padding: '10px' }}>PJ</th>
                      <th style={{ padding: '10px' }}>PG</th>
                      <th style={{ padding: '10px' }}>PE</th>
                      <th style={{ padding: '10px' }}>PP</th>
                      <th style={{ padding: '10px' }}>GF</th>
                      <th style={{ padding: '10px' }}>GC</th>
                      <th style={{ padding: '10px' }}>DG</th>
                    </tr>
                  </thead>
                  <tbody>
                    {grupos[groupName].map((j, i) => {
                      const esMiFila = currentUserId && j.user_id === currentUserId;
                      return (
                        <tr key={i} style={{ borderBottom: '1px solid #eee', textAlign: 'center', background: esMiFila ? 'rgba(46, 204, 113, 0.08)' : 'transparent', borderLeft: esMiFila ? '4px solid #2ecc71' : '4px solid transparent', transition: 'background 0.3s ease' }}>
                          <td style={{ padding: '10px 5px', color: '#95a5a6', fontSize: '0.65rem', fontWeight: 'bold', width: '20px' }}>
                            {i + 1}
                          </td>
                          <td style={{ padding: '10px', textAlign: 'left', display: 'flex', alignItems: 'center', gap: '8px', fontWeight: esMiFila ? '900' : '600' }}>
                            <Avatar url={j.avatar_url} />
                            <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                              {j.nick} {esMiFila && <span style={{ fontSize: '0.55rem', color: '#2ecc71', marginLeft: '4px' }}></span>}
                            </span>
                          </td>
                          <td style={{ fontWeight: 'bold', color: '#2ecc71', fontSize: '0.8rem' }}>{j.pts}</td>
                          <td>{j.pj}</td>
                          <td style={{ color: '#27ae60' }}>{j.pg}</td>
                          <td style={{ color: '#f39c12' }}>{j.pe}</td>
                          <td style={{ color: '#e74c3c' }}>{j.pp}</td>
                          <td>{j.gf}</td>
                          <td>{j.gc}</td>
                          <td style={{ fontWeight: 'bold' }}>{j.dg}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          )) : (
            <div style={{ textAlign: 'center', color: '#bdc3c7', fontSize: '0.8rem' }}>No hay datos de liguilla disponibles.</div>
          )}
        </div>
      )}

      {activeTab === 'playoff' && (
        <div style={{ marginTop: '10px' }}>
          {playoffMatches.length > 0 ? renderExtraBrackets() : (
            <p style={{ textAlign: 'center', color: '#7f8c8d', fontSize: '0.8rem' }}>
              Las eliminatorias aún no han comenzado.
            </p>
          )}
        </div>
      )}
    </div>
  );
}
