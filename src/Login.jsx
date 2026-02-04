import { useState } from 'react'
import { supabase } from './supabaseClient'

function Login() {
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [nick, setNick] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleAuth = async (e) => {
    e.preventDefault();
    setLoading(true);

    if (isRegister) {
      // 1. REGISTRO EN SUPABASE AUTH
      // Guardamos el nick en user_metadata como respaldo
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: { nick: nick } 
        }
      });

      if (authError) {
        alert(authError.message);
      } else if (authData?.user) {
        // 2. INSERCIÓN MANUAL EN TABLA PROFILES
        // Usamos upsert para evitar errores si existe un trigger automático
        const { error: profileError } = await supabase
          .from('profiles')
          .upsert({ 
            id: authData.user.id, 
            nick: nick,
            email: email 
          }, { onConflict: 'id' });

        if (profileError) {
          console.error("Error al guardar el nick en profiles:", profileError.message);
        }
        
        alert("¡Registro completado! Si no accedes automáticamente, verifica tu email.");
      }
    } else {
      // LOGIN POR EMAIL O NICK
      let loginEmail = email;
      
      // Si no detecta una '@', busca el email asociado a ese nick
      if (!email.includes('@')) {
        const { data: profileData } = await supabase
          .from('profiles')
          .select('email')
          .eq('nick', email)
          .maybeSingle();
          
        if (profileData) loginEmail = profileData.email;
      }

      const { error } = await supabase.auth.signInWithPassword({ 
        email: loginEmail, 
        password 
      });

      if (error) alert("Error: " + error.message);
    }
    setLoading(false);
  }

  return (
    <div style={{ padding: '20px', textAlign: 'left' }}>
      <h1 style={{ color: '#2ecc71', fontSize: '3.5rem', marginBottom: '10px' }}>TOPFC</h1>
      <h2 style={{ fontSize: '1.2rem', marginBottom: '20px' }}>
        {isRegister ? 'Crear nueva cuenta' : 'Identifícate'}
      </h2>
      
      <form onSubmit={handleAuth} style={{ display: 'flex', flexDirection: 'column', gap: '10px', maxWidth: '300px' }}>
        {isRegister && (
          <input 
            type="text" 
            placeholder="Tu Nick (ej: horto)" 
            value={nick} 
            onChange={e => setNick(e.target.value)} 
            required
            style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
          />
        )}
        <input 
          type="text" 
          placeholder={isRegister ? "Email" : "Email o Nick"} 
          value={email} 
          onChange={e => setEmail(e.target.value)} 
          required
          style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
        />
        <input 
          type="password" 
          placeholder="Contraseña" 
          value={password} 
          onChange={e => setPassword(e.target.value)} 
          required
          style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
        />
        <button 
          type="submit" 
          disabled={loading} 
          style={{ 
            background: '#2ecc71', 
            color: 'white', 
            padding: '12px', 
            borderRadius: '8px', 
            border: 'none', 
            fontWeight: 'bold', 
            cursor: 'pointer' 
          }}
        >
          {loading ? 'CARGANDO...' : (isRegister ? 'REGISTRARME' : 'ENTRAR')}
        </button>
      </form>

      <p style={{ marginTop: '20px', fontSize: '0.9rem' }}>
        {isRegister ? '¿Ya tienes cuenta?' : '¿No tienes cuenta?'} 
        <button 
          onClick={() => setIsRegister(!isRegister)} 
          style={{ 
            background: 'none', 
            border: 'none', 
            color: '#2ecc71', 
            fontWeight: 'bold', 
            cursor: 'pointer', 
            marginLeft: '5px' 
          }}
        >
          {isRegister ? 'Inicia sesión' : 'Regístrate aquí'}
        </button>
      </p>
    </div>
  )
}

export default Login;