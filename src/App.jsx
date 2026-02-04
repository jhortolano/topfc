import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import AdminPanel from './AdminPanel'
import Login from './Login'
import ProximoPartido from './Partido'
import Clasificacion from './Clasificacion'
import CalendarioCompleto from './Calendario'
import UserInfo from './UserInfo'
import Jugadores from './Jugadores'


const globalStyles = `
  * { box-sizing: border-box; }
  body { 
    background-color: #f0f2f5 !important; 
    color: #2c3e50 !important; 
    margin: 0; padding: 0;
    font-family: -apple-system, system-ui, sans-serif;
    overflow-x: hidden; display: block;
  }
  input, select, button { color: #2c3e50; font-size: 16px; }
  input { background-color: white !important; color: black !important; }
  .table-container {
    width: 100%; overflow-x: auto;
    -webkit-overflow-scrolling: touch; margin-top: 10px;
  }
`;

function App() {
  const [session, setSession] = useState(null)
  const [profile, setProfile] = useState(null)
  const [config, setConfig] = useState(null)

  useEffect(() => {
    const styleSheet = document.createElement("style");
    styleSheet.innerText = globalStyles;
    document.head.appendChild(styleSheet);
    supabase.auth.getSession().then(({ data: { session } }) => setSession(session))
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => setSession(session))
    fetchConfig()
    return () => subscription.unsubscribe()
  }, [])

  const fetchConfig = async () => {
    const { data } = await supabase.from('config').select('*').eq('id', 1).maybeSingle()
    if (data) setConfig(data)
  }

  useEffect(() => { if (session) getProfile() }, [session])

  async function getProfile() {
    if (!session?.user?.id) return;
    const { data } = await supabase.from('profiles').select('*').eq('id', session.user.id).single()
    if (data) setProfile(data)
  }

  if (!session) return <Login />
  return <Dashboard profile={profile} config={config} onConfigChange={fetchConfig} getProfile={getProfile} />
}



function Dashboard({ profile, config, onConfigChange, getProfile }) {
  const [activeTab, setActiveTab] = useState('partido')
  const tabs = [
    { id: 'partido', label: 'PARTIDO' },
    { id: 'clasificacion', label: 'CLASIFICACIÓN' },
    { id: 'calendario', label: 'CALENDARIO' },
    { id: 'jugadores', label: 'JUGADORES' },
  ];
  if (profile?.nick === 'horto') tabs.push({ id: 'admin', label: 'ADMIN' });

  return (
    <div style={{ width: '100%', maxWidth: '1000px', margin: '0', padding: '15px' }}>
      <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '15px' }}>
        <div style={{ textAlign: 'left' }}>
          <h1 style={{ color: '#2ecc71', margin: 0, fontSize: '1.8rem', lineHeight: '1' }}>TOPFC</h1>
          <div style={{ color: '#95a5a6', fontSize: '0.75rem', fontWeight: 'bold', marginTop: '4px' }}>
            TEMPORADA {config?.current_season || '-'}
          </div>
        </div>
        
        {/* Nombre clickeable para ir al perfil */}
        <div 
          onClick={() => setActiveTab('perfil')} 
          style={{ textAlign: 'right', cursor: 'pointer', padding: '5px' }}
        >
          <div style={{ fontSize: '0.85rem', color: activeTab === 'perfil' ? '#2ecc71' : '#2c3e50' }}>
            <strong>{profile?.nick}</strong>
          </div>
          <div style={{ fontSize: '0.65rem', color: '#95a5a6' }}>Mi Perfil</div>
        </div>
      </header>

      <div style={{ display: 'flex', gap: '5px', borderBottom: '1px solid #eee', marginBottom: '15px', overflowX: 'auto', WebkitOverflowScrolling: 'touch' }}>
        {tabs.map(t => (
          <div key={t.id} onClick={() => setActiveTab(t.id)} style={{
            padding: '12px 10px', cursor: 'pointer', borderBottom: activeTab === t.id ? '3px solid #2ecc71' : '3px solid transparent',
            color: activeTab === t.id ? '#2ecc71' : '#95a5a6', fontSize: '0.8rem', fontWeight: 'bold', whiteSpace: 'nowrap'
          }}>{t.label}</div>
        ))}
      </div>

      <main style={{ background: 'white', padding: '15px', borderRadius: '12px', boxShadow: '0 2px 10px rgba(0,0,0,0.05)', textAlign: 'left' }}>
        {activeTab === 'partido' && (<ProximoPartido profile={profile} config={config} onUpdated={onConfigChange} />)}
        {activeTab === 'clasificacion' && <Clasificacion config={config} />}
        {activeTab === 'calendario' && <CalendarioCompleto config={config} />}
        {activeTab === 'admin' && <AdminPanel config={config} onConfigChange={onConfigChange} />}
        {activeTab === 'perfil' && <UserInfo profile={profile} onUpdate={getProfile} />}
        {activeTab === 'jugadores' && <Jugadores config={config} />}
      </main>
    </div>
  )
}


export default App;