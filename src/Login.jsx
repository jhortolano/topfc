import { useState } from 'react'
import { supabase } from './supabaseClient'

const COUNTRIES = [
  { name: 'España', code: '+34', flag: '🇪🇸' },
  { name: 'Alemania', code: '+49', flag: '🇩🇪' },
  { name: 'Austria', code: '+43', flag: '🇦🇹' },
  { name: 'Bélgica', code: '+32', flag: '🇧🇪' },
  { name: 'Bulgaria', code: '+359', flag: '🇧🇬' },
  { name: 'Chipre', code: '+357', flag: '🇨🇾' },
  { name: 'Croacia', code: '+385', flag: '🇭🇷' },
  { name: 'Dinamarca', code: '+45', flag: '🇩🇰' },
  { name: 'Eslovaquia', code: '+421', flag: '🇸🇰' },
  { name: 'Eslovenia', code: '+386', flag: '🇸🇮' },
  { name: 'Estonia', code: '+372', flag: '🇪🇪' },
  { name: 'Finlandia', code: '+358', flag: '🇫🇮' },
  { name: 'Francia', code: '+33', flag: '🇫🇷' },
  { name: 'Grecia', code: '+30', flag: '🇬🇷' },
  { name: 'Hungría', code: '+36', flag: '🇭🇺' },
  { name: 'Irlanda', code: '+353', flag: '🇮🇪' },
  { name: 'Italia', code: '+39', flag: '🇮🇹' },
  { name: 'Letonia', code: '+371', flag: '🇱🇻' },
  { name: 'Lituania', code: '+370', flag: '🇱🇹' },
  { name: 'Luxemburgo', code: '+352', flag: '🇱🇺' },
  { name: 'Malta', code: '+356', flag: '🇲🇹' },
  { name: 'Países Bajos', code: '+31', flag: '🇳🇱' },
  { name: 'Polonia', code: '+48', flag: '🇵🇱' },
  { name: 'Portugal', code: '+351', flag: '🇵🇹' },
  { name: 'República Checa', code: '+420', flag: '🇨🇿' },
  { name: 'Rumanía', code: '+40', flag: '🇷🇴' },
  { name: 'Suecia', code: '+46', flag: '🇸🇪' },
  { name: 'Reino Unido', code: '+44', flag: '🇬🇧' },
  { name: 'Estados Unidos', code: '+1', flag: '🇺🇸' },
  { name: 'México', code: '+52', flag: '🇲🇽' },
  { name: 'Argentina', code: '+54', flag: '🇦🇷' },
  { name: 'Colombia', code: '+57', flag: '🇨🇴' },
];

// Estilo común para las etiquetas
const labelStyle = { 
  fontSize: '0.85rem', 
  fontWeight: 'bold', 
  color: '#34495e', 
  marginBottom: '4px',
  display: 'block'
};

function Login() {
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [nick, setNick] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState(''); // Nueva contraseña
  const [loading, setLoading] = useState(false);

  const [countryCode, setCountryCode] = useState('+34');
  const [phone, setPhone] = useState('');
  const [telegram, setTelegram] = useState('');

  const handleAuth = async (e) => {
    e.preventDefault();
    
    if (isRegister && password !== confirmPassword) {
      alert("Las contraseñas no coinciden. Por favor, verifícalas.");
      return;
    }

    setLoading(true);

    if (isRegister) {
      // 1. REGISTRO
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: { 
          data: { nick: nick },
          // EVITA QUE ENTRE DIRECTO SIN CONFIRMAR
          shouldCreateSession: false 
        }
      });

      if (authError) {
        alert(authError.message);
      } else if (authData?.user) {
        // 2. CREACIÓN DE PERFIL
        const fullPhone = phone ? `${countryCode}${phone.replace(/\s/g, '')}` : null;
        
        const { error: profileError } = await supabase
          .from('profiles')
          .upsert({ 
            id: authData.user.id, 
            nick: nick,
            email: email,
            phone: fullPhone,
            telegram_user: telegram || null
          }, { onConflict: 'id' });

        if (profileError) console.error("Error Perfil:", profileError.message);

        // 3. LIMPIEZA Y RETORNO AL LOGIN
        await supabase.auth.signOut(); // Asegura que no quede sesión colgada
        alert("¡Registro completado! Por favor, confirma tu correo electrónico antes de iniciar sesión.");
        
        // Limpiamos los campos y volvemos a la vista de login
        setNick('');
        setEmail('');
        setPassword('');
        setConfirmPassword('');
        setPhone('');
        setTelegram('');
        setIsRegister(false); // <--- ESTO te manda de vuelta a la pantalla de Login
      }
    } else {
      // LOGIN NORMAL
      let loginEmail = email;
      if (!email.includes('@')) {
        const { data: profileData } = await supabase
          .from('profiles').select('email').eq('nick', email).maybeSingle();
        if (profileData) loginEmail = profileData.email;
      }
      const { error } = await supabase.auth.signInWithPassword({ email: loginEmail, password });
      if (error) alert("Error: " + error.message);
    }
    setLoading(false);
  }

  return (
    <div style={{ padding: '20px', textAlign: 'left', maxWidth: '400px', margin: 'auto' }}>
      <h1 style={{ color: '#2ecc71', fontSize: '3.5rem', marginBottom: '10px' }}>TOPFC</h1>
      <h2 style={{ fontSize: '1.2rem', marginBottom: '20px' }}>
        {isRegister ? 'Crear nueva cuenta' : 'Identifícate'}
      </h2>
      
      <form onSubmit={handleAuth} style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
        
        {/* NICK */}
        {isRegister && (
          <div>
            <label style={labelStyle}>Nick de usuario:</label>
            <input 
              type="text" placeholder="ej: horto" 
              value={nick} onChange={e => setNick(e.target.value)} required
              style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
            />
          </div>
        )}
        
        {/* EMAIL O NICK LOGIN */}
        <div>
          <label style={labelStyle}>{isRegister ? 'Correo electrónico:' : 'Email o Nick:'}</label>
          <input 
            type="text" placeholder={isRegister ? "usuario@email.com" : "Tu email o nick"} 
            value={email} onChange={e => setEmail(e.target.value)} required
            style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
          />
        </div>

        {isRegister && (
          <>
            {/* PAÍS Y TELÉFONO */}
            <div>
              <label style={labelStyle}>Teléfono móvil (Opcional):</label>
              <div style={{ display: 'flex', gap: '5px' }}>
                <select 
                  value={countryCode} 
                  onChange={e => setCountryCode(e.target.value)}
                  style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd', background: 'white', width: '130px' }}
                >
                  {COUNTRIES.map(c => (
                    <option key={c.code + c.name} value={c.code}>
                      {c.flag} {c.code}
                    </option>
                  ))}
                </select>
                <input 
                  type="tel" placeholder="600000000" 
                  value={phone} onChange={e => setPhone(e.target.value)}
                  style={{ flex: 1, padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
                />
              </div>
            </div>
            
            {/* TELEGRAM */}
            <div>
              <label style={labelStyle}>Usuario de Telegram (Opcional):</label>
              <input 
                type="text" placeholder="@tu_usuario" 
                value={telegram} onChange={e => setTelegram(e.target.value)}
                style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
              />
            </div>
          </>
        )}

        {/* CONTRASEÑA */}
        <div>
          <label style={labelStyle}>Contraseña:</label>
          <input 
            type="password" placeholder="••••••••" 
            value={password} onChange={e => setPassword(e.target.value)} required
            style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }} 
          />
        </div>

        {/* CONFIRMAR CONTRASEÑA */}
        {isRegister && (
          <div>
            <label style={labelStyle}>Repite la contraseña:</label>
            <input 
              type="password" placeholder="••••••••" 
              value={confirmPassword} onChange={e => setConfirmPassword(e.target.value)} required
              style={{ 
                width: '100%', padding: '12px', borderRadius: '8px', 
                border: isRegister && confirmPassword && password !== confirmPassword ? '1px solid #e74c3c' : '1px solid #ddd' 
              }} 
            />
            {isRegister && confirmPassword && password !== confirmPassword && (
              <span style={{ color: '#e74c3c', fontSize: '0.75rem', marginTop: '4px', display: 'block' }}>
                Las contraseñas no coinciden
              </span>
            )}
          </div>
        )}
        
        <button 
          type="submit" 
          disabled={loading} 
          style={{ 
            background: '#2ecc71', color: 'white', padding: '14px', borderRadius: '8px', 
            border: 'none', fontWeight: 'bold', cursor: 'pointer', fontSize: '1rem', marginTop: '10px' 
          }}
        >
          {loading ? 'CARGANDO...' : (isRegister ? 'CREAR CUENTA' : 'INICIAR SESIÓN')}
        </button>
      </form>

      <p style={{ marginTop: '20px', fontSize: '0.9rem', textAlign: 'center' }}>
        {isRegister ? '¿Ya tienes cuenta?' : '¿No tienes cuenta?'} 
        <button onClick={() => setIsRegister(!isRegister)} style={{ background: 'none', border: 'none', color: '#2ecc71', fontWeight: 'bold', cursor: 'pointer', marginLeft: '5px' }}>
          {isRegister ? 'Inicia sesión' : 'Regístrate aquí'}
        </button>
      </p>
    </div>
  )
}

export default Login;