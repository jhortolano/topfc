import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- REUTILIZAMOS SELECTOR DE DIVISIÓN ---
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
    <div style={{ display: 'flex', gap: '5px', marginBottom: '15px' }}>
      {divisions.map(d => (
        <button key={d} onClick={() => onChange(d)} style={{
          padding: '6px 12px', borderRadius: '15px', border: 'none',
          background: current === d ? '#3498db' : '#ecf0f1',
          color: current === d ? 'white' : '#7f8c8d', fontSize: '0.75rem', fontWeight: 'bold', cursor: 'pointer'
        }}> DIV {d} </button>
      ))}
    </div>
  )
}

export default function Jugadores({ config }) {
  const [usuarios, setUsuarios] = useState([])
  const [filtro, setFiltro] = useState('')
  const [divActiva, setDivActiva] = useState(1)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchJugadores() {
      setLoading(true)
      // Buscamos los IDs de los jugadores que participan en esta temporada y división
      const { data: matches } = await supabase
        .from('matches')
        .select('home_team, away_team')
        .eq('season', config.current_season)
        .eq('division', divActiva)

      if (matches) {
        // Unimos todos los IDs y eliminamos duplicados
        const ids = [...new Set(matches.flatMap(m => [m.home_team, m.away_team]))].filter(id => id !== null)
        
        // Traemos los perfiles de esos IDs
        const { data: profiles } = await supabase
        .from('profiles')
        .select('nick, telegram_user, phone') // Añadido phone
        .in('id', ids)
        .order('nick', { ascending: true })

        setUsuarios(profiles || [])
      }
      setLoading(false)
    }
    if (config?.current_season) fetchJugadores()
  }, [config, divActiva])

  // Filtrado dinámico por Nick
  const usuariosFiltrados = usuarios.filter(u => 
    u.nick?.toLowerCase().includes(filtro.toLowerCase())
  )

  const abrirTelegram = (u) => {
  if (u.telegram_user) {
    // Si tiene nick de telegram
    const cleanUser = u.telegram_user.replace('@', '');
    window.open(`https://t.me/${cleanUser}`, '_blank');
  } else if (u.phone) {
    // Si no tiene nick pero tiene teléfono
    const cleanPhone = u.phone.replace(/\D/g, ''); // Limpia espacios o símbolos
    window.open(`https://t.me/+${cleanPhone}`, '_blank');
  } else {
    alert("Este usuario no tiene contacto configurado");
  }
}

  return (
    <div>
      <h3 style={{ marginTop: 0, color: '#2c3e50', fontSize: '1.1rem' }}>Directorio de Jugadores</h3>
      
      <DivisionSelector season={config?.current_season} current={divActiva} onChange={setDivActiva} />

      <input 
        type="text" 
        placeholder="Buscar por nick..." 
        value={filtro}
        onChange={(e) => setFiltro(e.target.value)}
        style={{ 
          width: '100%', padding: '10px', borderRadius: '8px', 
          border: '1px solid #ddd', marginBottom: '15px', fontSize: '0.9rem' 
        }}
      />

      {loading ? (
        <p style={{ color: '#95a5a6', fontSize: '0.8rem' }}>Cargando jugadores...</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          {usuariosFiltrados.map((u, i) => (
            <div key={i} style={{ 
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '10px 15px', background: '#f8f9fa', borderRadius: '8px', border: '1px solid #eee'
            }}>
              <span style={{ fontWeight: 'bold', color: '#2c3e50' }}>{u.nick}</span>
              
              {(u.telegram_user || u.phone) ? (
                <button 
                  onClick={() => abrirTelegram(u)} // Pasamos el usuario entero
                  title={u.telegram_user ? `Telegram: ${u.telegram_user}` : `Teléfono: ${u.phone}`}
                  style={{ 
                    background: '#0088cc', color: 'white', border: 'none', 
                    borderRadius: '50%', width: '32px', height: '32px', 
                    display: 'flex', alignItems: 'center', justifyContent: 'center', 
                    cursor: 'pointer', fontSize: '1.1rem' 
                  }}
                >
                  <span style={{ transform: 'rotate(-20deg)', display: 'block', marginTop: '-2px' }}>✈</span>
                </button>
              ) : (
                <span style={{ fontSize: '0.7rem', color: '#bdc3c7', fontStyle: 'italic' }}>Sin contacto</span>
              )}
            </div>
          ))}
          {usuariosFiltrados.length === 0 && (
            <p style={{ textAlign: 'center', color: '#95a5a6', fontSize: '0.8rem' }}>No se han encontrado jugadores.</p>
          )}
        </div>
      )}
    </div>
  )
}