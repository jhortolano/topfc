import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import AdminPanel from './AdminPanel'
import Login from './Login'
import ProximoPartido from './Partido'
import Clasificacion from './Clasificacion'
import CalendarioCompleto from './Calendario'
import UserInfo from './UserInfo'
import Jugadores from './Jugadores'
import Normas from './Normas'
import AdminPlayoffs from './AdminPlayoffs'


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

const calcularJornadaReal = (schedule) => {
  const ahora = new Date();
  // Buscamos la jornada actual: aquella donde el final es mayor a "ahora"
  const encontrada = schedule.find(s => new Date(s.end_at) > ahora);
  if (encontrada) return encontrada.week;
  // Si todas han pasado, devolvemos la última
  return schedule.length > 0 ? schedule[schedule.length - 1].week : 1;
};

function App() {
  const [session, setSession] = useState(null)
  const [profile, setProfile] = useState(null)
  const [config, setConfig] = useState(null)
  const [isActivePlayer, setIsActivePlayer] = useState(false)
  const [loading, setLoading] = useState(true);

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
    // 1. Traer la config actual
    const { data: configData } = await supabase.from('config').select('*').eq('id', 1).maybeSingle();

    if (configData) {
      // 2. Si el modo automático está activo, verificamos la fecha
      if (configData.auto_week_by_date) {
        const { data: schedule } = await supabase
          .from('weeks_schedule')
          .select('week, end_at')
          .eq('season', configData.current_season)
          .order('week', { ascending: true });

        if (schedule && schedule.length > 0) {
          const jornadaQueToca = calcularJornadaReal(schedule);

          // 3. SOLO actualizamos si hay un cambio real
          if (jornadaQueToca !== configData.current_week) {
            console.log(`Actualizando jornada automática: ${configData.current_week} -> ${jornadaQueToca}`);

            const { error } = await supabase
              .from('config')
              .update({ current_week: jornadaQueToca })
              .eq('id', 1);

            if (!error) {
              configData.current_week = jornadaQueToca;
            }
          }
        }
      }
      setConfig(configData);
    }
  };

  useEffect(() => {
    if (session && config) { // Solo pedimos el perfil si ya tenemos la config
      getProfile()
    }
  }, [session, config])

  async function getProfile() {
    setLoading(true); // Empezamos a cargar
    if (!session?.user?.id || !config) return;

    // 1. Obtener perfil
    const { data: profileData } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', session.user.id)
      .single()

    if (profileData) setProfile(profileData)

    // 2. Verificar si es jugador activo usando los nombres de columna correctos
    const { data: matchesData, error } = await supabase
      .from('matches')
      .select('id')
      // CAMBIO AQUÍ: Usamos home_team y away_team en lugar de jugador1_id y jugador2_id
      .or(`home_team.eq.${session.user.id},away_team.eq.${session.user.id}`)
      .eq('season', config.current_season)
      .limit(1)

    if (error) {
      console.error("Error comprobando partidos:", error.message)
      setIsActivePlayer(false)
    } else {
      setIsActivePlayer(matchesData && matchesData.length > 0)
    }
    setLoading(false); // Terminamos de cargar
  }

  // 1. Si no hay sesión, al Login
  if (!session) return <Login />

  // 2. Comprobación estricta de confirmación
  // Comprobamos ambas propiedades por si acaso: email_confirmed_at y confirmed_at
  const isEmailConfirmed = session.user?.email_confirmed_at || session.user?.confirmed_at;

  if (!isEmailConfirmed) {
    return (
      <div style={{
        height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '20px', backgroundColor: '#f0f2f5'
      }}>
        <div style={{
          background: 'white', padding: '30px', borderRadius: '15px',
          boxShadow: '0 4px 15px rgba(0,0,0,0.1)', textAlign: 'center', maxWidth: '400px'
        }}>
          <div style={{ fontSize: '3rem', marginBottom: '15px' }}>📧</div>
          <h2 style={{ color: '#2c3e50', marginTop: 0 }}>¡Confirma tu email!</h2>
          <p style={{ color: '#7f8c8d', lineHeight: '1.5' }}>
            Para entrar en <b>TOPFC</b> debes validar tu cuenta.<br />
            Hemos enviado un enlace a:<br />
            <strong>{session.user.email}</strong>
          </p>

          <button
            onClick={async () => {
              // Forzamos un refresco de la sesión para ver si ya confirmó
              const { data } = await supabase.auth.refreshSession();
              if (data?.user?.email_confirmed_at) {
                setSession(data.session);
              } else {
                alert("Parece que aún no has pulsado el enlace del email.");
              }
            }}
            style={{
              background: '#2ecc71', color: 'white', border: 'none',
              padding: '10px 20px', borderRadius: '8px', cursor: 'pointer',
              fontWeight: 'bold', width: '100%', marginBottom: '10px'
            }}
          >
            YA HE CONFIRMADO (Actualizar)
          </button>

          <button
            onClick={() => supabase.auth.signOut()}
            style={{
              background: 'transparent', color: '#e74c3c', border: '1px solid #e74c3c',
              padding: '8px 20px', borderRadius: '8px', cursor: 'pointer',
              fontWeight: 'bold', width: '100%'
            }}
          >
            Cerrar sesión
          </button>
        </div>
      </div>
    );
  }

  // 3. Si todo está ok, al Dashboard
  if (loading) return <div style={{ textAlign: 'center', marginTop: '50px' }}>Cargando TOPFC...</div>;
  return <Dashboard profile={profile} config={config} onConfigChange={fetchConfig} getProfile={getProfile} isActivePlayer={isActivePlayer} />

}



function Dashboard({ profile, config, onConfigChange, getProfile, isActivePlayer }) {

  const isAdmin = profile?.is_admin === true;

  // 2. Inicializamos el estado con esa pestaña dinámica
  const [activeTab, setActiveTab] = useState(() => {
    // 1. Miramos si hay una pestaña guardada de antes
    const saved = localStorage.getItem('activeTab');
    if (saved) return saved;

    // 2. Si no hay nada guardado, usamos la lógica de "pestaña inicial"
    return (isActivePlayer || isAdmin) ? 'partido' : 'clasificacion';
  });

  useEffect(() => {
    localStorage.setItem('activeTab', activeTab);
  }, [activeTab]);

  // Definimos las pestañas base
  const tabs = [
    { id: 'partido', label: 'PARTIDO' },
    { id: 'clasificacion', label: 'CLASIFICACIÓN' },
    { id: 'calendario', label: 'CALENDARIO' },
  ];

  // Solo añadir JUGADORES si es activo o es el admin
  if (isActivePlayer || isAdmin) {
    tabs.push({ id: 'jugadores', label: 'JUGADORES' });
  }

  // Añadir NORMAS al final
  tabs.push({ id: 'normas', label: 'NORMAS' });

  // Añadir ADMIN solo si es administrador
  if (isAdmin) {
    tabs.push({ id: 'admin', label: 'ADMIN' });
    tabs.push({ id: 'admin_playoffs', label: 'ADMIN PLAYOFFS' });
  }

  return (
    <div style={{ width: '100%', maxWidth: '1000px', margin: '0', padding: '15px' }}>
      <header style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center', // Alineación vertical perfecta
        marginBottom: '20px',
        padding: '10px 0'
      }}>


        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          {/* LOGO DE LA LIGA */}
          <img
            src="/topfc.png"
            alt="Logo TOP FC"
            style={{
              width: '50px',
              height: '50px',
              objectFit: 'contain',
              filter: 'drop-shadow(0px 2px 4px rgba(0,0,0,0.1))' // Sombra suave
            }}
          />

          <div style={{ textAlign: 'left' }}>
            <h1 style={{
              color: '#2ecc71',
              margin: 0,
              fontSize: '1.8rem',
              lineHeight: '1',
              letterSpacing: '-1px'
            }}>TOPFC</h1>
            <div style={{
              color: '#95a5a6',
              fontSize: '0.75rem',
              fontWeight: 'bold',
              marginTop: '4px',
              textTransform: 'uppercase'
            }}>
              Temporada {config?.current_season || '-'}
            </div>
          </div>
        </div>

        {/* Nombre clickeable para ir al perfil */}
        {/* Nombre e Imagen clickeable para ir al perfil */}
        <div
          onClick={() => setActiveTab('perfil')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            cursor: 'pointer',
            padding: '5px',
            borderRadius: '8px',
            transition: 'background 0.2s'
          }}
        >
          <div style={{ textAlign: 'right' }}>
            <div style={{
              fontSize: '0.85rem',
              color: activeTab === 'perfil' ? '#2ecc71' : '#2c3e50',
              lineHeight: '1.2'
            }}>
              <strong>{profile?.nick}</strong>
            </div>
            <div style={{ fontSize: '0.65rem', color: '#95a5a6' }}>Mi Perfil</div>
          </div>

          {/* Miniatura del Avatar */}
          <div style={{
            width: '38px',
            height: '38px',
            borderRadius: '50%',
            overflow: 'hidden',
            background: '#eee',
            border: activeTab === 'perfil' ? '2px solid #2ecc71' : '2px solid #fff',
            boxShadow: '0 2px 5px rgba(0,0,0,0.1)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center'
          }}>
            {profile?.avatar_url ? (
              <img
                src={profile.avatar_url}
                alt="Avatar"
                style={{ width: '100%', height: '100%', objectFit: 'cover' }}
              />
            ) : (
              <span style={{ fontSize: '1.2rem' }}>👤</span>
            )}
          </div>
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
        {activeTab === 'admin_playoffs' && <AdminPlayoffs config={config} />}
        {activeTab === 'perfil' && <UserInfo profile={profile} onUpdate={getProfile} />}
        {activeTab === 'jugadores' && <Jugadores config={config} />}
        {activeTab === 'normas' && <Normas />}
      </main>
    </div>
  )
}


export default App;