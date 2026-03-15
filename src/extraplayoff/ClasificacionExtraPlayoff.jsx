import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

const Avatar = ({ url, size = '24px' }) => (
  <div style={{
    width: size, height: size, borderRadius: '50%', background: '#34495e',
    border: '2px solid #2ecc71', flexShrink: 0, overflow: 'hidden'
  }}>
    {url ? <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} alt="avatar" /> :
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.6rem', color: '#7f8c8d' }}>👤</div>}
  </div>
);

export default function ClasificacionExtraPlayoff({ season, id }) {
  const [activeTab, setActiveTab] = useState('liguilla');
  const [grupos, setGrupos] = useState({});
  const [playoffMatches, setPlayoffMatches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [nombrePlayoff, setNombrePlayoff] = useState('');

  useEffect(() => {
    async function loadExtraData() {
      setLoading(true);
      const cleanId = id.toString().replace('extra-', '');

      try {
        const { data: extraInfo } = await supabase
          .from('playoffs_extra')
          .select('nombre')
          .eq('id', cleanId)
          .single();
        if (extraInfo) setNombrePlayoff(extraInfo.nombre);

        const { data: clasiData } = await supabase
          .from('extra_playoffs_clasificacion')
          .select('*')
          .eq('playoff_extra_id', cleanId);


        const grouped = clasiData?.reduce((acc, curr) => {
          const groupName = curr.nombre_grupo_texto || curr.nombre_grupo || 'General';
          if (!acc[groupName]) acc[groupName] = [];
          acc[groupName].push(curr);
          return acc;
        }, {}) || {};

        // ORDENACIÓN MANUAL POR GRUPO:
        // Recorremos cada grupo y ordenamos sus jugadores por puntos, DG y GF
        Object.keys(grouped).forEach(groupName => {
          grouped[groupName].sort((a, b) => {
            if (b.pts !== a.pts) return b.pts - a.pts; // 1º Puntos
            if (b.dg !== a.dg) return b.dg - a.dg;     // 2º Diferencia de Goles
            return b.gf - a.gf;                        // 3º Goles a Favor
          });
        });


        setGrupos(grouped);

        const { data: poMatches } = await supabase
          .from('v_extra_playoffs_bracket_dinamico')
          .select('*')
          .eq('playoff_extra_id', cleanId)
          .order('match_id', { ascending: true });
        setPlayoffMatches(poMatches || []);

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
                    {grupos[groupName].map((j, i) => (
                      <tr key={i} style={{ borderBottom: '1px solid #eee', textAlign: 'center' }}>
                        <td style={{ padding: '10px', textAlign: 'left', display: 'flex', alignItems: 'center', gap: '8px', fontWeight: '600' }}>
                          <Avatar url={j.avatar_url} />
                          {j.nick}
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
                    ))}
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
        <div style={{ textAlign: 'center', padding: '20px', color: '#7f8c8d', fontSize: '0.8rem' }}>
          {playoffMatches.length > 0 ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {playoffMatches.map((m, idx) => (
                <div key={idx} style={{ background: '#fff', padding: '10px', borderRadius: '8px', border: '1px solid #eee', marginBottom: '5px' }}>
                  <div style={{ fontSize: '0.6rem', color: '#bdc3c7', marginBottom: '5px' }}>{m.numero_jornada}</div>
                  <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '15px' }}>
                    {/* CAMBIADO: m.p1_nick y m.p2_nick */}
                    <span style={{ fontWeight: 'bold', color: '#2c3e50' }}>{m.p1_nick}</span>
                    <span style={{ background: '#34495e', color: 'white', padding: '2px 8px', borderRadius: '4px', minWidth: '40px' }}>
                      {m.is_played ? `${m.score1} - ${m.score2}` : 'vs'}
                    </span>
                    <span style={{ fontWeight: 'bold', color: '#2c3e50' }}>{m.p2_nick}</span>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p>Las eliminatorias aún no han comenzado o no hay partidos generados.</p>
          )}
        </div>
      )}
    </div>
  );
}