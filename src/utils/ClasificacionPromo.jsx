import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

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

export default function ClasificacionPromo({ season }) {
  const [matches, setMatches] = useState([]);
  const [profiles, setProfiles] = useState({});
  const [loading, setLoading] = useState(true);
  const [showInfo, setShowInfo] = useState({});

  useEffect(() => {
    async function loadPromoData() {
      setLoading(true);

      // 1. Obtener partidos de promoción (cacheados por temporada)
      const matchData = await getOrFetch(`promo_matches_${season}`, async () => {
        const { data } = await supabase
          .from('promo_matches')
          .select('*')
          .eq('season', season);
        return data || [];
      });

      if (!matchData.length) return setLoading(false);

      // 2. Obtener perfiles de los jugadores involucrados (cacheados por temporada)
      const playerIds = [...new Set(matchData.flatMap(m => [m.player1_id, m.player2_id]))].filter(Boolean);

      const profileData = await getOrFetch(`promo_profiles_${season}`, async () => {
        const { data } = await supabase
          .from('profiles')
          .select('id, nick, avatar_url')
          .in('id', playerIds);
        return data || [];
      });

      const profileMap = {};
      profileData.forEach(p => profileMap[p.id] = p);

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
    const originalDivMap = {}; // Guardaremos aquí: { playerId: divisionOrigen }

    const enfrentamientos = {};
    matches.forEach(m => {
      const key = [m.player1_id, m.player2_id].sort().join('-') + `-div${m.division}`;
      if (!enfrentamientos[key]) enfrentamientos[key] = [];
      enfrentamientos[key].push(m);

      // Guardamos de qué división venía cada uno (si no lo hemos guardado ya)
      if (m.player1_id && !originalDivMap[m.player1_id]) originalDivMap[m.player1_id] = m.divplayer1;
      if (m.player2_id && !originalDivMap[m.player2_id]) originalDivMap[m.player2_id] = m.divplayer2;
    });

    Object.values(enfrentamientos).forEach(m_list => {
      const allPlayed = m_list.every(m => m.is_played);
      const divBase = m_list[0].division;

      const refP1 = m_list[0].player1_id;
      const refP2 = m_list[0].player2_id;

      if (allPlayed) {
        let totalP1 = 0;
        let totalP2 = 0;

        m_list.forEach(m => {
          if (m.player1_id === refP1) {
            totalP1 += (m.score1 || 0);
            totalP2 += (m.score2 || 0);
          } else {
            totalP1 += (m.score2 || 0);
            totalP2 += (m.score1 || 0);
          }
        });

        const ganador = totalP1 > totalP2 ? refP1 : refP2;
        const perdedor = totalP1 > totalP2 ? refP2 : refP1;
        const resText = `${profiles[refP1]?.nick || '?'} ${totalP1} - ${totalP2} ${profiles[refP2]?.nick || '?'}`;

        if (!terminadosPorDiv[divBase]) terminadosPorDiv[divBase] = [];
        if (!terminadosPorDiv[divBase + 1]) terminadosPorDiv[divBase + 1] = [];

        // Guardamos el ID y su división de origen
        terminadosPorDiv[divBase].push({
          id: ganador,
          res: resText,
          fromDiv: originalDivMap[ganador]
        });
        terminadosPorDiv[divBase + 1].push({
          id: perdedor,
          res: resText,
          fromDiv: originalDivMap[perdedor]
        });
      } else {
        if (!pendientesPorDiv[divBase]) pendientesPorDiv[divBase] = [];
        // Para pendientes, guardamos objetos con ID y origen
        if (!pendientesPorDiv[divBase].some(p => p.id === refP1))
          pendientesPorDiv[divBase].push({ id: refP1, fromDiv: originalDivMap[refP1] });
        if (!pendientesPorDiv[divBase].some(p => p.id === refP2))
          pendientesPorDiv[divBase].push({ id: refP2, fromDiv: originalDivMap[refP2] });
      }
    });

    return { terminadosPorDiv, pendientesPorDiv };
  };

  const renderStatusIcon = (fromDiv, toDiv) => {
    // En divisiones, menor número significa categoría superior (Div 1 > Div 2)
    if (!fromDiv) return <span style={{ color: '#94a3b8', marginRight: '5px' }}>•</span>;

    if (fromDiv > toDiv) {
      return <span style={{ color: '#2ecc71', marginRight: '5px', fontWeight: 'bold' }}>↑</span>; // Sube
    } else if (fromDiv < toDiv) {
      return <span style={{ color: '#e74c3c', marginRight: '5px', fontWeight: 'bold' }}>↓</span>; // Baja
    } else {
      return <span style={{ color: '#94a3b8', marginRight: '5px', fontWeight: 'bold' }}>-</span>; // Se mantiene
    }
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
                  <div style={{ display: 'flex', alignItems: 'center' }}>
                    {renderStatusIcon(jug.fromDiv, parseInt(div))}
                    <span style={{ fontWeight: '600', fontSize: '0.85rem' }}>{profiles[jug.id]?.nick}</span>
                  </div>
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
                    {pendientesPorDiv[div].map(p => (
                      <li key={p.id} style={{ fontSize: '0.8rem', padding: '3px 0', color: '#475569', fontWeight: '500', display: 'flex', alignItems: 'center' }}>
                        {renderStatusIcon(p.fromDiv, parseInt(div))}
                        {profiles[p.id]?.nick}
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
