import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- SELECTORES (Copiados aquí para que el calendario funcione) ---
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
export default function CalendarioCompleto({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [partidos, setPartidos] = useState([]);

  useEffect(() => {
    async function fetch() {
      const { data } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', vS)
        .eq('division', vD)
        .order('week', { ascending: true });
      if (data) setPartidos(data)
    }
    if (vS) fetch();
  }, [vS, vD]);

  const jornadas = [...new Set(partidos.map(p => p.week))];

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <DivisionSelector season={vS} current={vD} onChange={setVD} />
        <SeasonSelector current={vS} onChange={setVS} />
      </div>
      {jornadas.length === 0 ? (
        <p style={{textAlign:'center', color:'#95a5a6', fontSize:'0.8rem'}}>No hay partidos.</p>
      ) : (
        jornadas.map(n => (
          <div key={n} style={{ marginBottom: '10px', border: '1px solid #eee', borderRadius: '8px' }}>
            <div style={{ background: '#f8f9fa', padding: '5px 10px', fontSize: '0.75rem', fontWeight: 'bold' }}>Jornada {n}</div>
            {partidos.filter(p => p.week === n).map(p => (
              <div key={p.id} style={{ display: 'flex', padding: '5px', fontSize: '0.75rem', borderBottom: '1px solid #fafafa' }}>
                <div style={{ flex: 1, textAlign: 'right' }}>{p.local_nick}</div>
                <div style={{ width: '50px', textAlign: 'center', fontWeight: 'bold' }}>{p.is_played ? `${p.home_score}-${p.away_score}` : 'vs'}</div>
                <div style={{ flex: 1, textAlign: 'left' }}>{p.visitante_nick}</div>
              </div>
            ))}
          </div>
        ))
      )}
    </div>
  )
}