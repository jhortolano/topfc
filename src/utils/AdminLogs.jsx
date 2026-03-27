import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

export default function AdminLogs() {
  const [logs, setLogs] = useState([])
  const [loading, setLoading] = useState(true)
  const [isOpen, setIsOpen] = useState(false)

  useEffect(() => {
    fetchLogs()
  }, [])

  async function fetchLogs() {
    try {
      setLoading(true)

      // Consultamos partidos de Liga
      const { data: liga } = await supabase
        .from('matches')
        .select('home_score, away_score, updated_at, division, profiles!home_team(nick), visitor:profiles!away_team(nick)')
        .eq('is_played', true)
        .order('updated_at', { ascending: false })
        .limit(20)

      // Consultamos partidos de Extra Champions
      const { data: playoff } = await supabase
        .from('playoff_matches')
        .select('home_score, away_score, updated_at, playoff:playoff_id(name), profiles!home_team(nick), visitor:profiles!away_team(nick)')
        .eq('played', true)
        .order('updated_at', { ascending: false })
        .limit(20)

      // Consultamos partidos de Extra Champions
      const { data: extra } = await supabase
        .from('extra_playoffs_matches')
        .select('score1, score2, updated_at, playoffs_extra:playoff_extra_id(nombre), profiles!player1_id(nick), visitor:profiles!player2_id(nick)')
        .eq('is_played', true)
        .order('updated_at', { ascending: false })
        .limit(20)

      const { data: extraM } = await supabase
        .from('extra_matches')
        .select('score1, score2, updated_at, playoffs_extra:extra_id(nombre), profiles!player1_id(nick), visitor:profiles!player2_id(nick)')
        .eq('is_played', true)
        .order('updated_at', { ascending: false })
        .limit(20)

      // Combinar y formatear
      const combined = [
        ...(liga || []).map(m => ({
          tipo: `Div${m.division}`,
          p1: m.profiles?.nick,
          p2: m.visitor?.nick,
          res: `${m.home_score} - ${m.away_score}`,
          fecha: new Date(m.updated_at)
        })),
        ...(playoff || []).map(m => ({
          tipo: m.playoff?.name || 'Playoff',
          p1: m.profiles?.nick,
          p2: m.visitor?.nick,
          res: `${m.home_score} - ${m.away_score}`,
          fecha: new Date(m.updated_at)
        })),
        ...(extraM || []).map(m => ({
          tipo: m.playoffs_extra?.nombre || 'Playoff',
          p1: m.profiles?.nick,
          p2: m.visitor?.nick,
          res: `${m.score1} - ${m.score2}`,
          fecha: new Date(m.updated_at)
        })),
        ...(extra || []).map(m => ({
          tipo: m.playoffs_extra?.nombre || 'Playoff',
          p1: m.profiles?.nick,
          p2: m.visitor?.nick,
          res: `${m.score1} - ${m.score2}`,
          fecha: new Date(m.updated_at)
        }))
      ].sort((a, b) => b.fecha - a.fecha).slice(0, 20)

      setLogs(combined)
    } catch (error) {
      console.error("Error cargando logs:", error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) return <div style={{ fontSize: '0.8rem', color: '#666' }}>Cargando actividad...</div>

  return (
    <div style={{ background: '#f8fafc', padding: '12px', borderRadius: '8px', border: '1px solid #e2e8f0', marginTop: '15px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }} onClick={() => setIsOpen(!isOpen)}>
          <span style={{ fontSize: '0.8rem' }}>{isOpen ? '▼' : '▶'}</span>
          <h3 style={{ margin: 0, fontSize: '0.9rem', color: '#2c3e50', userSelect: 'none' }}>Logs de Actividad</h3>
        </div>
        <div style={{ display: 'flex', gap: '8px' }}>
          {loading && <span style={{ fontSize: '0.7rem', color: '#666' }}>Cargando...</span>}
          <button onClick={(e) => { e.stopPropagation(); fetchLogs(); }} style={{ fontSize: '0.7rem', cursor: 'pointer', background: 'white', border: '1px solid #ccc', borderRadius: '4px' }}>🔄</button>
        </div>
      </div>

      {isOpen && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', marginTop: '12px' }}>
          {logs.length === 0 ? (
            <p style={{ fontSize: '0.75rem', color: '#94a3b8' }}>No hay actividad reciente.</p>
          ) : (
            logs.map((log, i) => (
              <div key={i} style={{ fontSize: '0.75rem', padding: '6px', background: 'white', borderRadius: '4px', boxShadow: '0 1px 2px rgba(0,0,0,0.05)', borderLeft: '3px solid #3498db' }}>
                <span style={{ fontWeight: 'bold', color: '#3498db', marginRight: '5px' }}>[{log.tipo}]</span>
                <span>Partido: <b>{log.p1}</b> vs <b>{log.p2}</b></span>
                <span style={{ marginLeft: '8px', color: '#27ae60', fontWeight: 'bold' }}>({log.res})</span>
                <span style={{ float: 'right', color: '#95a5a6', fontSize: '0.65rem' }}>
                  {log.fecha.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </span>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  )
}