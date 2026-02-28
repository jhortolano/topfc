import { useState, useEffect } from 'react'
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

const NICK_BLACKLIST = ['bye', 'tbd', 'null'];
const NICK_FORBIDDEN_PREFIX = 'retirado';

// Estilo común para las etiquetas
const labelStyle = {
  fontSize: '0.85rem',
  fontWeight: 'bold',
  color: '#34495e',
  marginBottom: '4px',
  display: 'block'
};

const mostrarPrivacidad = (e) => {
  e.preventDefault();
  alert(
    "INFORMACIÓN BÁSICA SOBRE PROTECCIÓN DE DATOS\n\n" +
    "- Responsable: Administrador de TOP FC\n" +
    "- Finalidad: Gestión de la liga y permitir el contacto entre jugadores para disputar partidos.\n" +
    "- Datos tratados: Nick, Email, WhatsApp y Telegram.\n" +
    "- Legitimación: Tu consentimiento al marcar la casilla.\n" +
    "- Destinatarios: Los datos solo serán visibles para otros usuarios registrados de la liga.\n" +
    "- Derechos: Puedes solicitar el acceso, rectificación o borrado de tus datos contactando con el administrador."
  );
};

const normalizeNick = (text) => {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]/g, ''); // Elimina cualquier cosa que NO sea letra o número
};

function Login() {
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [nick, setNick] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState(''); // Nueva contraseña
  const [loading, setLoading] = useState(false);

  const [allowRegistration, setAllowRegistration] = useState(true);
  const [checkingConfig, setCheckingConfig] = useState(true);

  const [countryCode, setCountryCode] = useState('+34');
  const [phone, setPhone] = useState('');
  const [telegram, setTelegram] = useState('');

  const [acceptTerms, setAcceptTerms] = useState(false);

  // Este código lee la base de datos al abrir la página
  useEffect(() => {
    async function checkConfig() {
      const { data } = await supabase.from('config').select('allow_registration').single();
      if (data) setAllowRegistration(data.allow_registration);
      setCheckingConfig(false);
    }
    checkConfig();
  }, []);

  const handleAuth = async (e) => {
    e.preventDefault();

    if (isRegister && password !== confirmPassword) {
      alert("Las contraseñas no coinciden. Por favor, verifícalas.");
      return;
    }

    if (isRegister && !acceptTerms) {
      alert("Debes aceptar la política de tratamiento de datos para continuar.");
      return;
    }

    if (isRegister) {
      const nickLower = nick.trim().toLowerCase();

      // 1. Comprobar si es una palabra prohibida exacta
      if (NICK_BLACKLIST.includes(nickLower)) {
        alert(`El nick "${nick}" no está permitido.`);
        setLoading(false);
        return;
      }

      // 2. Comprobar si empieza por "retirado"
      if (nickLower.startsWith(NICK_FORBIDDEN_PREFIX)) {
        alert(`El nick no puede empezar por "${NICK_FORBIDDEN_PREFIX}".`);
        setLoading(false);
        return;
      }

      // 3. (Opcional) Evitar nicks demasiado cortos
      if (nickLower.length < 3) {
        alert("El nick debe tener al menos 3 caracteres.");
        setLoading(false);
        return;
      }
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
        console.error("DEBUG AUTH ERROR:", authError); // AÑADIR ESTO
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
        // 1. Simplemente quitamos espacios a los lados y pasamos a minúsculas
        // pero MANTENEMOS los puntos y signos que el usuario haya puesto.
        const searchInput = email.trim();

        // 2. Buscamos usando ILIKE (que ya ignora mayúsculas/minúsculas)
        const { data: profileData } = await supabase
          .from('profiles')
          .select('email')
          .ilike('nick', searchInput) // Busca exactamente el texto pero ignora Mayus/Minus
          .maybeSingle();

        if (profileData) {
          loginEmail = profileData.email;
        } else {
          // 3. SEGUNDO INTENTO: Por si el usuario no puso el punto
          // Usamos el normalizeNick que ya tienes para una búsqueda más abierta
          const cleanInput = normalizeNick(email);
          const { data: fuzzyData } = await supabase
            .from('profiles')
            .select('email')
            .ilike('nick', `%${cleanInput}%`)
            .maybeSingle();

          if (fuzzyData) loginEmail = fuzzyData.email;
        }
      }

      const { error } = await supabase.auth.signInWithPassword({ email: loginEmail, password });
      if (error) {
        alert("Error: " + error.message);
        setLoading(false); // <--- Muy importante aquí
        return;
      }
    }
    setLoading(false);
  }

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '80vh',
      padding: '20px'
    }}>
      {/* LOGO */}
      <div style={{ display: 'flex', justifyContent: 'center', marginBottom: '20px', marginTop: '10px' }}>
        <img src="/topfc.png" alt="TOP FC Logo" style={{ width: '200px', height: 'auto', objectFit: 'contain', filter: 'drop-shadow(0px 4px 8px rgba(0,0,0,0.1))' }} />
      </div>

      <h2 style={{ fontSize: '1.2rem', marginBottom: '20px' }}>
        {isRegister ? 'Crear nueva cuenta' : 'Identifícate'}
      </h2>

      {/* --- BLOQUE DINÁMICO --- */}
      {isRegister && !allowRegistration ? (
        /* 1. MOSTRAR AVISO SI ESTÁ CERRADO EL REGISTRO */
        <div style={{
          background: '#f8d7da', color: '#721c24', padding: '20px', borderRadius: '12px',
          textAlign: 'center', border: '1px solid #f5c6cb', maxWidth: '400px'
        }}>
          <p style={{ fontWeight: 'bold', marginBottom: '10px' }}>🚫 Inscripciones cerradas</p>
          <p style={{ fontSize: '0.9rem' }}>No están abiertas las inscripciones para la liga actualmente. Contacta con un administrador.</p>
          <button
            onClick={() => setIsRegister(false)}
            style={{ marginTop: '15px', background: '#721c24', color: 'white', border: 'none', padding: '8px 15px', borderRadius: '6px', cursor: 'pointer', fontWeight: 'bold' }}
          >
            VOLVER AL LOGIN
          </button>
        </div>
      ) : (
        /* 2. MOSTRAR EL FORMULARIO SI ES LOGIN O SI EL REGISTRO ESTÁ ABIERTO */
        <form onSubmit={handleAuth} style={{ display: 'flex', flexDirection: 'column', gap: '15px', width: '100%', maxWidth: '400px' }}>

          {/* NICK (Solo en registro) */}
          {isRegister && (
            <div>
              <label style={labelStyle}>Nick de usuario:</label>
              <input
                type="text" placeholder="ej: user1"
                value={nick} onChange={e => setNick(e.target.value)} required
                style={{ width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }}
              />
            </div>
          )}

          {/* EMAIL */}
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
              {/* TELÉFONO (Solo en registro) */}
              <div>
                <label style={labelStyle}>Whatsapp (Opcional):</label>
                <div style={{ display: 'flex', gap: '5px' }}>
                  <select
                    value={countryCode}
                    onChange={e => setCountryCode(e.target.value)}
                    style={{ padding: '12px', borderRadius: '8px', border: '1px solid #ddd', background: 'white', width: '130px' }}
                  >
                    {COUNTRIES.map(c => (
                      <option key={c.code + c.name} value={c.code}>{c.flag} {c.code}</option>
                    ))}
                  </select>
                  <input
                    type="tel" placeholder="600000000"
                    value={phone} onChange={e => setPhone(e.target.value)}
                    style={{ flex: 1, padding: '12px', borderRadius: '8px', border: '1px solid #ddd' }}
                  />
                </div>
              </div>

              {/* TELEGRAM (Solo en registro) */}
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

          {/* REPETIR CONTRASEÑA (Solo en registro) */}
          {isRegister && (
            <div>
              <label style={labelStyle}>Repite la contraseña:</label>
              <input
                type="password" placeholder="••••••••"
                value={confirmPassword} onChange={e => setConfirmPassword(e.target.value)} required
                style={{
                  width: '100%', padding: '12px', borderRadius: '8px',
                  border: confirmPassword && password !== confirmPassword ? '1px solid #e74c3c' : '1px solid #ddd'
                }}
              />
              {confirmPassword && password !== confirmPassword && (
                <span style={{ color: '#e74c3c', fontSize: '0.75rem', marginTop: '4px', display: 'block' }}>
                  Las contraseñas no coinciden
                </span>
              )}
            </div>
          )}

          {isRegister && (
            <div style={{
              display: 'flex',
              alignItems: 'flex-start',
              gap: '10px',
              margin: '10px 0',
              background: '#f8f9fa',
              padding: '10px',
              borderRadius: '8px',
              border: '1px solid #eee'
            }}>
              <input
                type="checkbox"
                id="terms"
                checked={acceptTerms}
                onChange={(e) => setAcceptTerms(e.target.checked)}
                style={{ marginTop: '4px', cursor: 'pointer' }}
              />
              <label htmlFor="terms" style={{ fontSize: '0.75rem', color: '#7f8c8d', lineHeight: '1.2' }}>
                Acepto que mis datos (Nick, Email, WhatsApp y Telegram) sean visibles para otros participantes
                de la liga con el fin de facilitar la organización y contacto de los partidos.
                <button
                  onClick={mostrarPrivacidad}
                  style={{
                    background: 'none', border: 'none', color: '#2ecc71',
                    textDecoration: 'underline', cursor: 'pointer', padding: '0 5px', fontSize: '0.75rem'
                  }}
                >
                  Leer más información.
                </button>
              </label>
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
      )}

      {/* BOTÓN PARA CAMBIAR ENTRE LOGIN/REGISTRO */}
      <p style={{ marginTop: '20px', fontSize: '0.9rem', textAlign: 'center' }}>
        {isRegister ? '¿Ya tienes cuenta?' : '¿No tienes cuenta?'}
        <button
          onClick={() => setIsRegister(!isRegister)}
          style={{ background: 'none', border: 'none', color: '#2ecc71', fontWeight: 'bold', cursor: 'pointer', marginLeft: '5px' }}
        >
          {isRegister ? 'Inicia sesión' : 'Regístrate aquí'}
        </button>
      </p>
    </div>
  )
}

export default Login;