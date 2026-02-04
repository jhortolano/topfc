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
  const [jornadasActivas, setJornadasActivas] = useState([]);

useEffect(() => {
    async function fetch() {
      // 1. Cargar partidos
      const { data: dataPartidos } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', vS)
        .eq('division', vD)
        .order('week', { ascending: true });
      if (dataPartidos) setPartidos(dataPartidos);

      // 2. Detectar jornadas activas (resaltado)
      if (vS === config?.current_season) {
        // Buscamos las fechas de la jornada actual según config
        const { data: currentWeekData } = await supabase
          .from('weeks_schedule')
          .select('start_at, end_at')
          .eq('season', vS)
          .eq('week', config.current_week)
          .single();

        if (currentWeekData) {
          // Buscamos todas las jornadas que tengan esas mismas fechas
          const { data: activeWeeks } = await supabase
            .from('weeks_schedule')
            .select('week')
            .eq('season', vS)
            .eq('start_at', currentWeekData.start_at)
            .eq('end_at', currentWeekData.end_at);
          
          setJornadasActivas(activeWeeks.map(w => w.week));
        }
      } else {
        setJornadasActivas([]); // Si vemos otra temporada, no resaltamos nada
      }
    }
    if (vS) fetch();
  }, [vS, vD, config]); // Añadimos config a las dependencias

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
          jornadas.map(n => {
            const estaActiva = jornadasActivas.includes(n);
            
            return (
              <div key={n} style={{ 
                marginBottom: '10px', 
                border: estaActiva ? '2px solid #2ecc71' : '1px solid #eee', // Borde verde si está activa
                borderRadius: '8px',
                overflow: 'hidden',
                boxShadow: estaActiva ? '0 0 10px rgba(46, 204, 113, 0.2)' : 'none'
              }}>
                <div style={{ 
                  background: estaActiva ? '#2ecc71' : '#f8f9fa', // Fondo verde si está activa
                  color: estaActiva ? 'white' : '#2c3e50',       // Texto blanco si está activa
                  padding: '5px 10px', 
                  fontSize: '0.75rem', 
                  fontWeight: 'bold',
                  display: 'flex',
                  justifyContent: 'space-between'
                }}>
                  <span>Jornada {n}</span>
                  {estaActiva && <span>ACTUAL</span>}
                </div>
                
                {partidos.filter(p => p.week === n).map(p => (
                  <div key={p.id} style={{ display: 'flex', padding: '5px', fontSize: '0.75rem', borderBottom: '1px solid #fafafa' }}>
                    <div style={{ flex: 1, textAlign: 'right' }}>{p.local_nick}</div>
                    <div style={{ width: '50px', textAlign: 'center', fontWeight: 'bold' }}>{p.is_played ? `${p.home_score}-${p.away_score}` : 'vs'}</div>
                    <div style={{ flex: 1, textAlign: 'left' }}>{p.visitante_nick}</div>
                  </div>
                ))}
              </div>
            )
          })
      )}
    </div>
  )
}