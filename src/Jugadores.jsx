import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- SELECTOR UNIFICADO: DIVISIONES + PLAYOFFS ---
function CategorySelector({ current, onChange, season }) {
  const [categories, setCategories] = useState([])

  useEffect(() => {
    async function load() {
      if (!season) return;

      // 1. Cargar Divisiones desde 'matches'
      const { data: divData } = await supabase.from('matches').select('division').eq('season', season)
      const uniqueDivs = divData ? [...new Set(divData.map(d => d.division))].sort((a, b) => a - b) : []

      // 2. Cargar Playoffs desde 'playoffs'
      const { data: poData } = await supabase.from('playoffs').select('id, name').eq('season', season)
      const formattedPlayoffs = poData ? poData.map(p => ({ id: p.id, name: p.name.toUpperCase() })) : []

      const allCategories = [
        ...uniqueDivs.map(d => ({ id: d, label: `DIV ${d}`, type: 'div' })),
        ...formattedPlayoffs.map(p => ({ id: p.id, label: p.name, type: 'po' }))
      ]

      setCategories(allCategories)

      // Si el actual no existe en la lista, poner el primero por defecto
      if (allCategories.length > 0 && !allCategories.find(c => c.id === current)) {
        onChange(allCategories[0].id)
      }
    }
    load()
  }, [season])

  if (categories.length <= 1 && categories[0]?.type === 'div') return null;

  return (
    <div style={{ display: 'flex', gap: '5px', marginBottom: '15px', flexWrap: 'wrap' }}>
      {categories.map(cat => (
        <button key={cat.id} onClick={() => onChange(cat.id)} style={{
          padding: '6px 12px', borderRadius: '15px', border: 'none',
          background: current === cat.id ? (cat.type === 'div' ? '#3498db' : '#34495e') : '#ecf0f1',
          color: current === cat.id ? 'white' : '#7f8c8d', fontSize: '0.75rem', fontWeight: 'bold', cursor: 'pointer'
        }}> {cat.label} </button>
      ))}
    </div>
  )
}

export default function Jugadores({ config }) {
  const [usuarios, setUsuarios] = useState([])
  const [filtro, setFiltro] = useState('')
  const [catActiva, setCatActiva] = useState(1) // Puede ser número (DIV) o string (UUID de Playoff)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchJugadores() {
      setLoading(true)
      let ids = []

      if (typeof catActiva === 'number') {
        // Lógica para Divisiones
        const { data: matches } = await supabase
          .from('matches')
          .select('home_team, away_team')
          .eq('season', config.current_season)
          .eq('division', catActiva)
        if (matches) ids = matches.flatMap(m => [m.home_team, m.away_team])
      } else {
        // Lógica para Playoffs
        const { data: poMatches } = await supabase
          .from('playoff_matches')
          .select('home_team, away_team')
          .eq('playoff_id', catActiva)
        if (poMatches) ids = poMatches.flatMap(m => [m.home_team, m.away_team])
      }

      // Limpiar IDs (quitar nulos/TBD/duplicados)
      const cleanIds = [...new Set(ids)].filter(id => id !== null)

      if (cleanIds.length > 0) {
        const { data: profiles } = await supabase
          .from('profiles')
          .select('nick, telegram_user, phone, avatar_url')
          .in('id', cleanIds)
          .order('nick', { ascending: true })
        setUsuarios(profiles || [])
      } else {
        setUsuarios([])
      }
      setLoading(false)
    }
    if (config?.current_season) fetchJugadores()
  }, [config, catActiva])

  const usuariosFiltrados = usuarios.filter(u => {
    // 1. Filtro por el texto del buscador
    const coincideTexto = u.nick?.toLowerCase().includes(filtro.toLowerCase());

    // 2. Filtro de usuarios retirados (NO mostrar si el nick empieza por "Retirado")
    const esRetirado = u.nick?.toLowerCase().startsWith("retirado");

    return coincideTexto && !esRetirado;
  });

  const abrirTelegram = (u) => {
    const cleanUser = u.telegram_user.replace('@', '');
    window.open(`https://t.me/${cleanUser}`, '_blank');
  };

  const abrirWhatsApp = (u) => {
    // Elimina cualquier carácter que no sea un número para la URL de WhatsApp
    const cleanPhone = u.phone.replace(/\D/g, '');
    window.open(`https://wa.me/${cleanPhone}`, '_blank');
  };

  return (
    <div>
      <h3 style={{ marginTop: 0, color: '#2c3e50', fontSize: '1.1rem' }}>Directorio de Jugadores</h3>

      <CategorySelector
        season={config?.current_season}
        current={catActiva}
        onChange={setCatActiva}
      />

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
              padding: '8px 12px', background: '#f8f9fa', borderRadius: '10px', border: '1px solid #eee'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <div style={{
                  width: '40px', height: '40px', borderRadius: '50%', overflow: 'hidden',
                  background: '#eee', border: '2px solid #fff', boxShadow: '0 2px 4px rgba(0,0,0,0.05)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0
                }}>
                  {u.avatar_url ? (
                    <img src={u.avatar_url} alt={u.nick} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                  ) : (
                    <span style={{ fontSize: '1.2rem', color: '#bdc3c7' }}>👤</span>
                  )}
                </div>
                <span style={{ fontWeight: 'bold', color: '#2c3e50', fontSize: '0.9rem' }}>{u.nick}</span>
              </div>

              <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                {u.telegram_user && (
                  <button
                    onClick={() => abrirTelegram(u)}
                    style={{
                      background: '#0088cc', color: 'white', border: 'none',
                      borderRadius: '12px', padding: '0 10px', height: '32px',
                      cursor: 'pointer', fontSize: '0.7rem', fontWeight: 'bold'
                    }}
                  >
                    <span>✈</span> Telegram
                  </button>
                )}

                {u.phone && (
                  <button
                    onClick={() => abrirWhatsApp(u)}
                    style={{
                      background: '#25D366', color: 'white', border: 'none',
                      borderRadius: '12px', padding: '0 10px', height: '32px',
                      cursor: 'pointer', fontSize: '0.7rem', fontWeight: 'bold'
                    }}
                  >
                    <span>📞</span> Whatsapp
                  </button>
                )}
              </div>
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