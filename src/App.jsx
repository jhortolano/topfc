import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import AdminPanel from './AdminPanel'

const globalStyles = `
  * { box-sizing: border-box; }
  body { 
    background-color: #f0f2f5 !important; 
    color: #2c3e50 !important; 
    margin: 0;
    padding: 0;
    font-family: -apple-system, system-ui, sans-serif;
    overflow-x: hidden;
  }
  input, select, button { color: #2c3e50; font-size: 16px; }
  input { background-color: white !important; color: black !important; }
  .table-container {
    width: 100%;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    margin-top: 10px;
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
    const { data } = await supabase.from('profiles').select('nick').eq('id', session.user.id).single()
    if (data) setProfile(data)
  }

  if (!session) return <Login />
  return <Dashboard profile={profile} config={config} onConfigChange={fetchConfig} />
}

// --- SELECTORES ---
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

// --- TABS ---
function ProximoPartido({ profile, config }) {
  const [partidos, setPartidos] = useState([])
  const [tiempoAgotado, setTiempoAgotado] = useState(false)

  useEffect(() => {
    const cargar = async () => {
      const { data: week } = await supabase.from('weeks_schedule').select('*').eq('season', config.current_season).eq('week', config.current_week).single();
      if (week) {
        const ahora = new Date(new Date().toLocaleString("en-US", {timeZone: "Europe/Madrid"}));
        setTiempoAgotado(ahora > new Date(week.end_at));
        const { data } = await supabase.from('partidos_detallados').select('*').eq('season', config.current_season).eq('week', config.current_week).or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);
        setPartidos(data || []);
      }
    }
    if (profile && config) cargar();
  }, [profile, config])

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
      {tiempoAgotado && <div style={{ background: '#e74c3c', color: 'white', padding: '10px', borderRadius: '8px', textAlign: 'center', fontSize: '0.8rem', fontWeight: 'bold' }}>PLAZO CERRADO</div>}
      {partidos.map(p => <TarjetaResultado key={p.id} partido={p} onUpdated={() => {}} bloqueado={tiempoAgotado} />)}
    </div>
  )
}

function TarjetaResultado({ partido, bloqueado }) {
  const [gL, setGL] = useState('');
  const [gV, setGV] = useState('');
  return (
    <div style={{ background: '#2c3e50', color: 'white', padding: '15px', borderRadius: '12px', textAlign: 'center' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '10px' }}>
        <div style={{ flex: 1, fontSize: '0.85rem', textAlign: 'right' }}>{partido.local_nick}</div>
        <div style={{ background: '#34495e', padding: '5px 10px', borderRadius: '8px', border: '1px solid #2ecc71', minWidth: '60px', fontWeight: 'bold' }}>
          {partido.is_played ? `${partido.home_score} - ${partido.away_score}` : 'vs'}
        </div>
        <div style={{ flex: 1, fontSize: '0.85rem', textAlign: 'left' }}>{partido.visitante_nick}</div>
      </div>
    </div>
  )
}

function Clasificacion({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [lista, setLista] = useState([]);
  useEffect(() => {
    async function fetch() {
      const { data } = await supabase.from('clasificacion').select('*').eq('season', vS).eq('division', vD).order('pts', { ascending: false });
      if (data) setLista(data)
    }
    if (vS) fetch();
  }, [vS, vD]);

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <DivisionSelector season={vS} current={vD} onChange={setVD} />
        <SeasonSelector current={vS} onChange={setVS} />
      </div>
      <div className="table-container">
        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem' }}>
          <thead><tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
            <th style={{ padding: '8px', textAlign: 'left' }}>Nick</th><th>PTS</th><th>PJ</th><th>DG</th>
          </tr></thead>
          <tbody>{lista.map((j, i) => (
            <tr key={i} style={{ borderBottom: '1px solid #eee' }}>
              <td style={{ padding: '8px', textAlign: 'left', fontWeight: 'bold' }}>{j.nick}</td>
              <td style={{ fontWeight: 'bold' }}>{j.pts}</td><td>{j.pj}</td><td>{j.dg}</td>
            </tr>
          ))}</tbody>
        </table>
      </div>
    </div>
  )
}

function CalendarioCompleto({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(1);
  const [partidos, setPartidos] = useState([]);
  useEffect(() => {
    async function fetch() {
      const { data } = await supabase.from('partidos_detallados').select('*').eq('season', vS).eq('division', vD).order('week', { ascending: true });
      if (data) setPartidos(data)
    }
    if (vS) fetch();
  }, [vS, vD]);

  const jornadas = [...new Set(partidos.map(p => p.week))];
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <DivisionSelector season={vS} current={vD} onChange={setVD} />
        <SeasonSelector current={vS} onChange={setVS} />
      </div>
      {jornadas.map(n => (
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
      ))}
    </div>
  )
}

// --- DASHBOARD ---
function Dashboard({ profile, config, onConfigChange }) {
  const [activeTab, setActiveTab] = useState('partido')
  const tabs = [
    { id: 'partido', label: 'MÍO' },
    { id: 'clasificacion', label: 'TABLA' },
    { id: 'calendario', label: 'CALENDARIO' },
  ];
  if (profile?.nick === 'horto') tabs.push({ id: 'admin', label: 'ADMIN' });

  return (
    <div style={{ width: '100%', maxWidth: '900px', margin: '0 auto', padding: '10px' }}>
      <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
        <h1 style={{ color: '#2ecc71', margin: 0, fontSize: '1.5rem' }}>TOPFC</h1>
        <div style={{ textAlign: 'right', fontSize: '0.8rem' }}>
          <strong>{profile?.nick}</strong> <button onClick={() => supabase.auth.signOut()} style={{ padding: '2px 5px' }}>Salir</button>
        </div>
      </header>

      <div style={{ display: 'flex', gap: '5px', borderBottom: '1px solid #eee', marginBottom: '15px', overflowX: 'auto' }}>
        {tabs.map(t => (
          <div key={t.id} onClick={() => setActiveTab(t.id)} style={{
            padding: '10px', cursor: 'pointer', borderBottom: activeTab === t.id ? '3px solid #2ecc71' : '3px solid transparent',
            color: activeTab === t.id ? '#2ecc71' : '#95a5a6', fontSize: '0.8rem', fontWeight: 'bold', whiteSpace: 'nowrap'
          }}>{t.label}</div>
        ))}
      </div>

      <main style={{ background: 'white', padding: '15px', borderRadius: '12px', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
        {activeTab === 'partido' && <ProximoPartido profile={profile} config={config} />}
        {activeTab === 'clasificacion' && <Clasificacion config={config} />}
        {activeTab === 'calendario' && <CalendarioCompleto config={config} />}
        {activeTab === 'admin' && <AdminPanel config={config} onConfigChange={onConfigChange} />}
      </main>
    </div>
  )
}

function Login() {
  const [identifier, setIdentifier] = useState(''), [password, setPassword] = useState(''), [loading, setLoading] = useState(false);
  const handle = async (e) => {
    e.preventDefault(); setLoading(true);
    let email = identifier;
    if (!identifier.includes('@')) {
      const { data } = await supabase.from('profiles').select('email').eq('nick', identifier).single();
      if (data) email = data.email;
    }
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) alert(error.message);
    setLoading(false);
  }
  return (
    <div style={{ padding: '50px 20px', textAlign: 'center' }}>
      <h1 style={{ color: '#2ecc71', fontSize: '3rem' }}>TOPFC</h1>
      <form onSubmit={handle} style={{ display: 'flex', flexDirection: 'column', gap: '10px', maxWidth: '300px', margin: '0 auto' }}>
        <input type="text" placeholder="Email o Nick" value={identifier} onChange={e => setIdentifier(e.target.value)} style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} />
        <input type="password" placeholder="Contraseña" value={password} onChange={e => setPassword(e.target.value)} style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} />
        <button type="submit" disabled={loading} style={{ background: '#2ecc71', color: 'white', padding: '12px', borderRadius: '8px', border: 'none', fontWeight: 'bold' }}>ENTRAR</button>
      </form>
    </div>
  )
}

export default App;