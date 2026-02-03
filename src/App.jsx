import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import AdminPanel from './AdminPanel'

// Inyectamos un estilo global para resetear el comportamiento del modo oscuro del navegador
const globalStyles = `
  body { 
    background-color: #f0f2f5 !important; 
    color: #2c3e50 !important; 
    margin: 0;
    font-family: sans-serif;
  }
  input, select, button { color: #2c3e50; }
  /* Forzamos que los inputs tengan fondo blanco siempre */
  input { background-color: white !important; color: black !important; }
`;

function App() {
  const [session, setSession] = useState(null)
  const [profile, setProfile] = useState(null)
  const [config, setConfig] = useState(null)

  useEffect(() => {
    // Aplicar estilos globales
    const styleSheet = document.createElement("style");
    styleSheet.innerText = globalStyles;
    document.head.appendChild(styleSheet);

    supabase.auth.getSession().then(({ data: { session } }) => setSession(session))
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => setSession(session))
    fetchConfig()
    return () => subscription.unsubscribe()
  }, [])

  useEffect(() => {
    const interval = setInterval(() => {
      fetchConfig()
    }, 60000)
    return () => clearInterval(interval)
  }, [])

  const fetchConfig = async () => {
    const { data } = await supabase.from('config').select('*').eq('id', 1).maybeSingle()
    if (data) setConfig(data)
  }

  useEffect(() => {
    if (session) getProfile()
  }, [session])

  async function getProfile() {
    const { data } = await supabase.from('profiles').select('nick').eq('id', session.user.id).single()
    if (data) setProfile(data)
  }

  if (!session) return <Login />
  return <Dashboard profile={profile} config={config} onConfigChange={fetchConfig} />
}

// --- SELECTOR DE DIVISIÓN ---
function DivisionSelector({ current, onChange, season }) {
  const [divisions, setDivisions] = useState([])

  useEffect(() => {
    async function loadDivisions() {
      if (!season) return;
      const { data } = await supabase.from('matches').select('division').eq('season', season)
      if (data) {
        const unique = [...new Set(data.map(d => d.division))].sort((a, b) => a - b)
        setDivisions(unique)
        if (unique.length > 0 && !unique.includes(current)) {
          onChange(unique[0])
        }
      }
    }
    loadDivisions()
  }, [season])

  if (divisions.length <= 1) return null;

  return (
    <div style={{ display: 'flex', gap: '8px', marginBottom: '15px' }}>
      {divisions.map(d => (
        <button
          key={d}
          onClick={() => onChange(d)}
          style={{
            padding: '6px 14px',
            borderRadius: '20px',
            border: 'none',
            background: current === d ? '#2ecc71' : '#ecf0f1',
            color: current === d ? 'white' : '#7f8c8d',
            cursor: 'pointer',
            fontSize: '0.75rem',
            fontWeight: 'bold'
          }}
        >
          DIVISIÓN {d}
        </button>
      ))}
    </div>
  )
}

// --- SELECTOR DE TEMPORADA ---
function SeasonSelector({ current, onChange }) {
  const [seasons, setSeasons] = useState([])
  useEffect(() => {
    async function loadSeasons() {
      const { data } = await supabase.from('matches').select('season')
      if (data) {
        const unique = [...new Set(data.map(d => d.season))].sort((a, b) => b - a)
        setSeasons(unique)
      }
    }
    loadSeasons()
  }, [])

  return (
    <div style={{ marginBottom: '20px', textAlign: 'right' }}>
      <label style={{ fontSize: '0.8rem', marginRight: '8px', color: '#95a5a6' }}>Temporada:</label>
      <select 
        value={current || ''} 
        onChange={(e) => onChange(parseInt(e.target.value))} 
        style={{ padding: '5px 10px', borderRadius: '4px', border: '1px solid #ddd', fontSize: '0.85rem', background: 'white', color: '#2c3e50' }}
      >
        {seasons.map(s => <option key={s} value={s}>T{s}</option>)}
      </select>
    </div>
  )
}

// --- TAB 1: MIS PARTIDOS ---
function ProximoPartido({ profile, config }) {
  const [partidos, setPartidos] = useState([])
  const [loading, setLoading] = useState(true)
  const [tiempoAgotado, setTiempoAgotado] = useState(false)

  useEffect(() => {
    if (profile && config) cargarPartidos();
  }, [profile, config])

  const cargarPartidos = async () => {
    setLoading(true);
    const { data: currentWeekData } = await supabase
      .from('weeks_schedule')
      .select('start_at, end_at')
      .eq('season', config.current_season)
      .eq('week', config.current_week)
      .single();

    if (currentWeekData) {
      const ahoraMadrid = new Date(new Date().toLocaleString("en-US", {timeZone: "Europe/Madrid"}));
      setTiempoAgotado(ahoraMadrid > new Date(currentWeekData.end_at));

      const { data: linkedWeeks } = await supabase
        .from('weeks_schedule')
        .select('week')
        .eq('season', config.current_season)
        .eq('start_at', currentWeekData.start_at)
        .eq('end_at', currentWeekData.end_at);

      const weekNumbers = linkedWeeks.map(w => w.week);

      const { data: matches } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', config.current_season)
        .in('week', weekNumbers)
        .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

      setPartidos(matches || []);
    }
    setLoading(false);
  }

  if (loading) return <div style={{ textAlign: 'center', padding: '20px', color: '#2c3e50' }}>Cargando jornada...</div>
  if (partidos.length === 0) return <div style={{ padding: '40px', textAlign: 'center', color: '#7f8c8d' }}>No tienes partidos asignados esta semana.</div>

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
      {tiempoAgotado && (
        <div style={{ background: '#e74c3c', color: 'white', padding: '10px', borderRadius: '6px', textAlign: 'center', fontWeight: 'bold' }}>
          ⚠️ PLAZO CERRADO
        </div>
      )}
      {partidos.map(partido => (
        <div key={partido.id}>
          <div style={{ fontSize: '0.7rem', color: '#95a5a6', fontWeight: 'bold', marginBottom: '4px', textAlign: 'left' }}>
            DIVISIÓN {partido.division}
          </div>
          <TarjetaResultado partido={partido} onUpdated={cargarPartidos} bloqueado={tiempoAgotado} />
        </div>
      ))}
    </div>
  )
}

function TarjetaResultado({ partido, onUpdated, bloqueado }) {
  const [gL, setGL] = useState('');
  const [gV, setGV] = useState('');
  const [enviando, setEnviando] = useState(false);

  const guardar = async () => {
    if (gL === '' || gV === '') return alert("Introduce los goles");
    setEnviando(true);
    const { error } = await supabase
      .from('matches')
      .update({ home_score: parseInt(gL), away_score: parseInt(gV), is_played: true })
      .eq('id', partido.id);
    
    if (!error) onUpdated();
    setEnviando(false);
  }

  return (
    <div style={{ background: '#2c3e50', color: 'white', padding: '25px', borderRadius: '12px', textAlign: 'center' }}>
      <h3 style={{ color: '#2ecc71', marginTop: 0 }}>Jornada {partido.week}</h3>
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '15px', fontSize: '1.4rem', margin: '20px 0' }}>
        <div style={{ flex: 1, textAlign: 'right' }}>{partido.local_nick}</div>
        {partido.is_played ? (
          <div style={{ background: '#34495e', padding: '5px 15px', borderRadius: '8px', border: '2px solid #2ecc71', fontWeight: 'bold' }}>
            {partido.home_score} - {partido.away_score}
          </div>
        ) : (
          <div style={{ display: 'flex', gap: '10px' }}>
            <input type="number" value={gL} onChange={e => setGL(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '4px', border: 'none', background: 'white', color: 'black' }} />
            <span>-</span>
            <input type="number" value={gV} onChange={e => setGV(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '4px', border: 'none', background: 'white', color: 'black' }} />
          </div>
        )}
        <div style={{ flex: 1, textAlign: 'left' }}>{partido.visitante_nick}</div>
      </div>
      {!partido.is_played && !bloqueado && (
        <button onClick={guardar} disabled={enviando} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '10px 20px', borderRadius: '6px', cursor: 'pointer', fontWeight: 'bold' }}>
          POSTEAR RESULTADO
        </button>
      )}
    </div>
  )
}

// --- TAB 2: CLASIFICACIÓN ---
function Clasificacion({ config }) {
  const [viewSeason, setViewSeason] = useState(config?.current_season)
  const [viewDiv, setViewDiv] = useState(1)
  const [lista, setLista] = useState([])

  useEffect(() => { if (config?.current_season) setViewSeason(config.current_season) }, [config])

  useEffect(() => {
    async function fetchClasificacion() {
      if (!viewSeason) return;
      const { data } = await supabase
        .from('clasificacion')
        .select('*')
        .eq('season', viewSeason)
        .eq('division', viewDiv)
        .order('pts', { ascending: false })
        .order('dg', { ascending: false });
      if (data) setLista(data)
    }
    fetchClasificacion()
  }, [viewSeason, viewDiv])

  return (
    <div style={{ color: '#2c3e50' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <DivisionSelector season={viewSeason} current={viewDiv} onChange={setViewDiv} />
        <SeasonSelector current={viewSeason} onChange={setViewSeason} />
      </div>
      <div style={{ overflowX: 'auto' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'center', fontSize: '0.9rem', color: '#2c3e50' }}>
          <thead>
            <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
              <th style={{ padding: '12px', textAlign: 'left' }}>Jugador</th>
              <th>PTS</th><th>PJ</th><th>PG</th><th>PE</th><th>PP</th><th>GF</th><th>GC</th><th>DG</th>
            </tr>
          </thead>
          <tbody>
            {lista.map((j, i) => (
              <tr key={j.user_id} style={{ borderBottom: '1px solid #eee', background: i < 3 ? '#f0fff4' : 'transparent' }}>
                <td style={{ padding: '12px', textAlign: 'left', fontWeight: 'bold' }}>{i === 0 && '👑 '}{j.nick}</td>
                <td style={{ fontWeight: 'bold' }}>{j.pts || 0}</td>
                <td>{j.pj || 0}</td><td>{j.pg || 0}</td><td>{j.pe || 0}</td><td>{j.pp || 0}</td>
                <td>{j.gf || 0}</td><td>{j.gc || 0}</td>
                <td style={{ fontWeight: 'bold', color: (j.dg || 0) >= 0 ? '#27ae60' : '#e74c3c' }}>{j.dg || 0}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

// --- TAB 3: CALENDARIO ---
function CalendarioCompleto({ config }) {
  const [viewSeason, setViewSeason] = useState(config?.current_season)
  const [viewDiv, setViewDiv] = useState(1)
  const [partidos, setPartidos] = useState([])

  useEffect(() => { if (config?.current_season) setViewSeason(config.current_season) }, [config])

  useEffect(() => {
    async function fetchPartidos() {
      if (!viewSeason) return;
      const { data } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', viewSeason)
        .eq('division', viewDiv)
        .order('week', { ascending: true })
      if (data) setPartidos(data)
    }
    fetchPartidos()
  }, [viewSeason, viewDiv])

  const jornadas = [...new Set(partidos.map(p => p.week))]

  return (
    <div style={{ color: '#2c3e50' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <DivisionSelector season={viewSeason} current={viewDiv} onChange={setViewDiv} />
        <SeasonSelector current={viewSeason} onChange={setViewSeason} />
      </div>
      {jornadas.map(num => (
        <div key={num} style={{ marginBottom: '20px', border: '1px solid #f1f1f1', borderRadius: '8px', overflow: 'hidden', background: 'white' }}>
          <h4 style={{ background: '#f8f9fa', margin: 0, padding: '10px 15px', fontSize: '0.9rem', borderBottom: '1px solid #f1f1f1', color: '#2c3e50' }}>Jornada {num}</h4>
          <div style={{ padding: '8px' }}>
            {partidos.filter(p => p.week === num).map(p => (
              <div key={p.id} style={{ display: 'flex', padding: '6px 0', borderBottom: '1px solid #fafafa', fontSize: '0.85rem' }}>
                <div style={{ flex: 1, textAlign: 'right', paddingRight: '15px' }}>{p.local_nick}</div>
                <div style={{ width: '60px', textAlign: 'center', fontWeight: 'bold', color: p.is_played ? '#2c3e50' : '#bdc3c7' }}>
                  {p.is_played ? `${p.home_score} - ${p.away_score}` : 'vs'}
                </div>
                <div style={{ flex: 1, textAlign: 'left', paddingLeft: '15px' }}>{p.visitante_nick}</div>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}

// --- TAB 4: FECHAS ---
function CalendarioFechas({ config }) {
  const [filas, setFilas] = useState([])
  useEffect(() => {
    if (config) {
      supabase.from('weeks_schedule').select('*').eq('season', config.current_season).order('week', { ascending: true }).then(({ data }) => {
        if (data) {
          const grupos = [];
          data.forEach(item => {
            const ultimo = grupos[grupos.length - 1];
            if (ultimo && ultimo.start_at === item.start_at && ultimo.end_at === item.end_at) {
              ultimo.weeks.push(item.week);
            } else {
              grupos.push({ weeks: [item.week], start_at: item.start_at, end_at: item.end_at });
            }
          });
          setFilas(grupos);
        }
      })
    }
  }, [config])

  const format = (d) => new Date(d).toLocaleString('es-ES', { 
    timeZone: 'Europe/Madrid', 
    day: '2-digit', 
    month: '2-digit', 
    year: 'numeric',
    hour: '2-digit', 
    minute: '2-digit' 
  });

  return (
    <div style={{ overflowX: 'auto', color: '#2c3e50' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.85rem', color: '#2c3e50' }}>
        <thead>
          <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #3498db' }}>
            <th style={{ padding: '12px' }}>Jornadas</th><th>Apertura</th><th>Cierre</th>
          </tr>
        </thead>
        <tbody>
          {filas.map((f, i) => (
            <tr key={i} style={{ borderBottom: '1px solid #eee', background: f.weeks.includes(config.current_week) ? '#e3f2fd' : 'transparent' }}>
              <td style={{ padding: '12px', textAlign: 'center', fontWeight: 'bold' }}>{f.weeks.join(', ')}</td>
              <td style={{ textAlign: 'center' }}>{format(f.start_at)}</td>
              <td style={{ textAlign: 'center' }}>{format(f.end_at)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

// --- DASHBOARD ---
function Dashboard({ profile, config, onConfigChange }) {
  const [activeTab, setActiveTab] = useState('partido')
  const tabStyle = (id) => ({
    padding: '12px 15px', cursor: 'pointer', borderBottom: activeTab === id ? '3px solid #2ecc71' : '3px solid transparent',
    fontWeight: 'bold', color: activeTab === id ? '#2ecc71' : '#95a5a6', whiteSpace: 'nowrap', transition: '0.2s'
  })

  return (
    <div style={{ maxWidth: '900px', margin: '0 auto', padding: '20px' }}>
      <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '25px' }}>
        <div>
            <h1 style={{ color: '#2ecc71', margin: 0, fontSize: '2.2rem' }}>TOPFC</h1>
            <span style={{ color: '#95a5a6', fontSize: '0.8rem', fontWeight: 'bold' }}>TEMPORADA {config?.current_season}</span>
        </div>
        <div style={{ textAlign: 'right', color: '#2c3e50' }}>
          <div style={{ fontSize: '0.9rem', marginBottom: '4px' }}>Hola, <strong>{profile?.nick}</strong></div>
          <button onClick={() => supabase.auth.signOut()} style={{ padding: '4px 8px', fontSize: '0.75rem', borderRadius: '4px', border: '1px solid #ddd', background: 'white', color: '#2c3e50', cursor: 'pointer' }}>Salir</button>
        </div>
      </header>

      <div style={{ display: 'flex', gap: '5px', borderBottom: '1px solid #eee', marginBottom: '25px', overflowX: 'auto', WebkitOverflowScrolling: 'touch' }}>
        <div style={tabStyle('partido')} onClick={() => setActiveTab('partido')}>Mis Partidos</div>
        <div style={tabStyle('clasificacion')} onClick={() => setActiveTab('clasificacion')}>Clasificación</div>
        <div style={tabStyle('partidos')} onClick={() => setActiveTab('partidos')}>Calendario</div>
        <div style={tabStyle('fechas')} onClick={() => setActiveTab('fechas')}>Fechas</div>
        {profile?.nick === 'horto' && <div style={tabStyle('admin')} onClick={() => setActiveTab('admin')}>⚙️ Admin</div>}
      </div>

      <main style={{ background: 'white', padding: '20px', borderRadius: '12px', boxShadow: '0 4px 20px rgba(0,0,0,0.06)', color: '#2c3e50' }}>
        {activeTab === 'partido' && <ProximoPartido profile={profile} config={config} />}
        {activeTab === 'clasificacion' && <Clasificacion config={config} />}
        {activeTab === 'partidos' && <CalendarioCompleto config={config} />}
        {activeTab === 'fechas' && <CalendarioFechas config={config} />}
        {activeTab === 'admin' && profile?.nick === 'horto' && <AdminPanel config={config} onConfigChange={onConfigChange} />}
      </main>
    </div>
  )
}

// --- LOGIN ---
function Login() {
  const [identifier, setIdentifier] = useState(''), [password, setPassword] = useState(''), [nick, setNick] = useState(''), [isRegistering, setIsRegistering] = useState(false), [loading, setLoading] = useState(false);
  
  const handleSubmit = async (e) => {
    e.preventDefault(); 
    setLoading(true); 
    let email = identifier;
    if (!isRegistering && !identifier.includes('@')) {
      const { data } = await supabase.from('profiles').select('email').eq('nick', identifier).single();
      if (data) email = data.email; else { alert("Nick no registrado"); setLoading(false); return; }
    }
    const { error } = isRegistering ? await supabase.auth.signUp({ email, password, options: { data: { nick_name: nick } } }) : await supabase.auth.signInWithPassword({ email, password });
    if (error) alert(error.message); 
    setLoading(false);
  }

  return (
    <div style={{ textAlign: 'center', marginTop: '60px' }}>
      <h1 style={{ color: '#2ecc71', fontSize: '3.5rem', marginBottom: '10px' }}>TOPFC</h1>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', width: '280px', margin: '0 auto', gap: '12px', padding: '25px', background: 'white', borderRadius: '12px', boxShadow: '0 8px 30px rgba(0,0,0,0.1)' }}>
        {isRegistering && <input type="text" placeholder="Tu Nick" value={nick} onChange={e => setNick(e.target.value)} required style={{ padding: '12px', borderRadius: '6px', border: '1px solid #ddd', background: 'white', color: 'black' }} />}
        <input type="text" placeholder="Email o Nick" value={identifier} onChange={e => setIdentifier(e.target.value)} required style={{ padding: '12px', borderRadius: '6px', border: '1px solid #ddd', background: 'white', color: 'black' }} />
        <input type="password" placeholder="Contraseña" value={password} onChange={e => setPassword(e.target.value)} required style={{ padding: '12px', borderRadius: '6px', border: '1px solid #ddd', background: 'white', color: 'black' }} />
        <button type="submit" disabled={loading} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '12px', borderRadius: '6px', fontWeight: 'bold', cursor: 'pointer' }}>
          {loading ? 'Cargando...' : isRegistering ? 'REGISTRARSE' : 'ENTRAR'}
        </button>
      </form>
      <button onClick={() => setIsRegistering(!isRegistering)} style={{ marginTop: '20px', background: 'none', border: 'none', color: '#3498db', cursor: 'pointer', fontSize: '0.9rem' }}>
        {isRegistering ? '¿Ya tienes cuenta? Inicia sesión' : '¿Eres nuevo? Crea tu nick'}
      </button>
    </div>
  )
}

export default App;