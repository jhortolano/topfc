import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

export default function ClasificacionPromo({ season }) {
  const [matches, setMatches] = useState([]);
  const [profiles, setProfiles] = useState({});
  const [loading, setLoading] = useState(true);
  const [showInfo, setShowInfo] = useState({});

  useEffect(() => {
    async function loadPromoData() {
      setLoading(true);
      // 1. Obtener partidos de promoción
      const { data: matchData } = await supabase
        .from('promo_matches')
        .select('*')
        .eq('season', season);

      if (!matchData) return setLoading(false);

      // 2. Obtener perfiles de los jugadores involucrados
      const playerIds = [...new Set(matchData.flatMap(m => [m.player1_id, m.player2_id]))].filter(Boolean);
      const { data: profileData } = await supabase
        .from('profiles')
        .select('id, nick, avatar_url')
        .in('id', playerIds);

      const profileMap = {};
      profileData?.forEach(p => profileMap[p.id] = p);

      setProfiles(profileMap);
      setMatches(matchData);
      setLoading(false);
    }
    if (season) loadPromoData();
  }, [season]);

  const toggleInfo = (id) => {
    setShowInfo(prev => ({ ...prev, [id]: !prev[id] }));
  };

  // --- LÓGICA DE PROCESAMIENTO ---
  const procesarPromocion = () => {
    const terminadosPorDiv = {};
    const pendientesPorDiv = {};

    const enfrentamientos = {};
    matches.forEach(m => {
      const key = [m.player1_id, m.player2_id].sort().join('-') + `-div${m.division}`;
      if (!enfrentamientos[key]) enfrentamientos[key] = [];
      enfrentamientos[key].push(m);
    });

    Object.values(enfrentamientos).forEach(m_list => {
      const allPlayed = m_list.every(m => m.is_played);
      const divBase = m_list[0].division;

      // Fijamos a P1 y P2 según el PRIMER partido encontrado para tener una referencia estable
      const refP1 = m_list[0].player1_id;
      const refP2 = m_list[0].player2_id;

      if (allPlayed) {
        let totalP1 = 0;
        let totalP2 = 0;

        m_list.forEach(m => {
          // Si en este registro los IDs coinciden con nuestra referencia
          if (m.player1_id === refP1) {
            totalP1 += (m.score1 || 0);
            totalP2 += (m.score2 || 0);
          } else {
            // Si los IDs están invertidos en este registro, invertimos la suma de goles
            totalP1 += (m.score2 || 0);
            totalP2 += (m.score1 || 0);
          }
        });

        const ganador = totalP1 > totalP2 ? refP1 : refP2;
        const perdedor = totalP1 > totalP2 ? refP2 : refP1;

        // Texto del resultado global para el +info
        const resText = `${profiles[refP1]?.nick || '?'} ${totalP1} - ${totalP2} ${profiles[refP2]?.nick || '?'}`;

        if (!terminadosPorDiv[divBase]) terminadosPorDiv[divBase] = [];
        if (!terminadosPorDiv[divBase + 1]) terminadosPorDiv[divBase + 1] = [];

        terminadosPorDiv[divBase].push({ id: ganador, res: resText });
        terminadosPorDiv[divBase + 1].push({ id: perdedor, res: resText });
      } else {
        if (!pendientesPorDiv[divBase]) pendientesPorDiv[divBase] = [];
        if (!pendientesPorDiv[divBase].includes(refP1)) pendientesPorDiv[divBase].push(refP1);
        if (!pendientesPorDiv[divBase].includes(refP2)) pendientesPorDiv[divBase].push(refP2);
      }
    });

    return { terminadosPorDiv, pendientesPorDiv };
  };

  if (loading) return <div style={{ padding: '20px', textAlign: 'center' }}>Cargando promoción...</div>;

  const { terminadosPorDiv, pendientesPorDiv } = procesarPromocion();
  const allDivs = [...new Set([...Object.keys(terminadosPorDiv), ...Object.keys(pendientesPorDiv)])].sort();

  // Comprobamos si hay al menos un grupo de pendientes
  const tienePendientes = Object.keys(pendientesPorDiv).length > 0;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '30px', padding: '10px' }}>

      {/* SECCIÓN SUPERIOR: CONFIRMADOS */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', gap: '15px' }}>
        {allDivs.map(div => terminadosPorDiv[div] && (
          <div key={`term-${div}`} style={{ background: '#fff', borderRadius: '12px', border: '1px solid #e2e8f0', overflow: 'hidden' }}>
            <div style={{ background: '#34495e', color: 'white', padding: '8px 15px', fontWeight: 'bold', fontSize: '0.8rem' }}>
              DIVISIÓN {div}
            </div>
            <div style={{ padding: '10px' }}>
              {terminadosPorDiv[div].map((jug, idx) => (
                <div key={idx} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '5px 0', borderBottom: idx !== terminadosPorDiv[div].length - 1 ? '1px solid #f1f5f9' : 'none' }}>
                  <span style={{ fontWeight: '600', fontSize: '0.85rem' }}>{profiles[jug.id]?.nick}</span>
                  <button
                    onClick={() => toggleInfo(`${div}-${jug.id}`)}
                    style={{ background: 'none', border: 'none', color: '#94a3b8', fontSize: '0.6rem', cursor: 'pointer', textDecoration: 'underline' }}
                  >
                    {showInfo[`${div}-${jug.id}`] ? `(${jug.res})` : '+info'}
                  </button>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      {/* Solo mostramos el separador y la sección inferior si hay pendientes */}
      {tienePendientes && (
        <>
          <hr style={{ border: 'none', borderTop: '2px dashed #e2e8f0' }} />

          <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
            <h3 style={{ fontSize: '0.9rem', color: '#64748b', marginBottom: '5px' }}>JUGADORES A LA ESPERA DE PROMOCIÓN</h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '15px' }}>
              {allDivs.map(div => pendientesPorDiv[div] && (
                <div key={`pend-${div}`} style={{ background: '#f8fafc', borderRadius: '10px', padding: '12px', border: '1px solid #cbd5e1' }}>
                  <h4 style={{ margin: '0 0 10px 0', fontSize: '0.75rem', color: '#1e293b' }}>Promocionan a Div {div}</h4>
                  <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
                    {pendientesPorDiv[div].map(pId => (
                      <li key={pId} style={{ fontSize: '0.8rem', padding: '3px 0', color: '#475569', fontWeight: '500' }}>
                        • {profiles[pId]?.nick}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
}