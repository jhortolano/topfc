import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- SELECTORES (Los necesitamos aquí también) ---
function DivisionSelector({ current, onChange, season }) {
  const [divisions, setDivisions] = useState([])
  useEffect(() => {
    async function load() {
      if (!season) return;
      const { data } = await supabase.from('matches').select('division').eq('season', season)
      if (data) {
        const unique = [...new Set(data.map(d => d.division))].sort((a, b) => a - b)
        setDivisions(unique)
        if (unique.length > 0 && !unique.includes(current)) onChange(unique[0])
      }
    }
    load()
  }, [season])
  if (divisions.length <= 1) return null;
  return (
    <div style={{ display: 'flex', gap: '5px', marginBottom: '10px', flexWrap: 'wrap' }}>
      {divisions.map(d => (
        <button key={d} onClick={() => onChange(d)} style={{
          padding: '5px 10px', borderRadius: '15px', border: 'none',
          background: current === d ? '#2ecc71' : '#ecf0f1',
          color: current === d ? 'white' : '#7f8c8d', fontSize: '0.7rem', fontWeight: 'bold'
        }}> DIV {d} </button>
      ))}
    </div>
  )
}

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
export default function Clasificacion({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [lista, setLista] = useState([]);

  useEffect(() => {
    async function fetch() {
      const { data } = await supabase
        .from('clasificacion')
        .select('*')
        .eq('season', vS)
        .eq('division', vD)
        .order('pts', { ascending: false });
      if (data) setLista(data)
    }
    if (vS) fetch();
  }, [vS, vD]);

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <DivisionSelector season={vS} current={vD} onChange={setVD} />
        <SeasonSelector current={vS} onChange={setVS} />
      </div>
      <div className="table-container">
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem' }}>
          <thead>
            <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
              <th style={{ padding: '8px', textAlign: 'left' }}>Jugador</th>
              <th title="Puntos">PTS</th>
              <th title="Partidos Jugados">PJ</th>
              <th title="Ganados">G</th>
              <th title="Perdidos">P</th>
              <th title="Goles a Favor">GF</th>
              <th title="Goles en Contra">GC</th>
              <th title="Diferencia de Goles">DG</th>
            </tr>
          </thead>
          <tbody>
            {lista.map((j, i) => (
              <tr key={i} style={{ borderBottom: '1px solid #eee', textAlign: 'center' }}>
                <td style={{ padding: '8px', textAlign: 'left', fontWeight: 'bold' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    {/* Contenedor de la imagen */}
                    <div style={{ 
                      width: '30px', 
                      height: '30px', 
                      borderRadius: '50%', 
                      overflow: 'hidden', 
                      background: '#eee', 
                      flexShrink: 0,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      border: '1px solid #ddd'
                    }}>
                      {j.avatar_url ? (
                        <img 
                          src={j.avatar_url} 
                          alt={j.nick} 
                          style={{ width: '100%', height: '100%', objectFit: 'cover' }} 
                        />
                      ) : (
                        <span style={{ fontSize: '0.8rem', color: '#bdc3c7' }}>👤</span>
                      )}
                    </div>
                    {/* Nombre del jugador */}
                    <span>{j.nick}</span>
                  </div>
                </td>
                <td style={{ fontWeight: 'bold', color: '#2ecc71' }}>{j.pts ?? 0}</td>
                <td>{j.pj ?? 0}</td>
                <td>{j.pg ?? 0}</td>
                <td>{j.pp ?? 0}</td>
                <td>{j.gf ?? 0}</td>
                <td>{j.gc ?? 0}</td>
                <td style={{ color: (j.dg || 0) > 0 ? '#2ecc71' : (j.dg || 0) < 0 ? '#e74c3c' : 'inherit' }}>
                  {(j.dg || 0) > 0 ? `+${j.dg}` : (j.dg || 0)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}