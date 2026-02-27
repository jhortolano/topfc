import { useState } from 'react'
import { supabase } from './supabaseClient'

export default function ResetPassword({ onFinish }) {
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [mensaje, setMensaje] = useState('')

  // Validaciones
  const contraseñasCoinciden = password === confirmPassword && password !== ''
  const longitudOk = password.length >= 6

  const handleUpdatePassword = async (e) => {
    e.preventDefault()
    
    if (!contraseñasCoinciden) {
      setMensaje('❌ Las contraseñas no coinciden')
      return
    }

    setLoading(true)
    setMensaje('')

    const { error } = await supabase.auth.updateUser({ password: password })

    if (error) {
      setMensaje('❌ Error: ' + error.message)
    } else {
      setMensaje('✅ ¡Contraseña actualizada con éxito!')
      setTimeout(() => onFinish(), 2000)
    }
    setLoading(false)
  }

  return (
    <div style={{
      height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: '20px', backgroundColor: '#f0f2f5'
    }}>
      <div style={{
        background: 'white', padding: '40px 30px', borderRadius: '20px',
        boxShadow: '0 10px 25px rgba(0,0,0,0.1)', textAlign: 'center', 
        maxWidth: '400px', width: '100%'
      }}>
        {/* Icono decorativo */}
        <div style={{ fontSize: '3rem', marginBottom: '10px' }}>🔐</div>
        
        <h2 style={{ color: '#2c3e50', margin: '0 0 10px 0', fontSize: '1.5rem' }}>
          Seguridad de la Cuenta
        </h2>
        <p style={{ fontSize: '0.9rem', color: '#7f8c8d', marginBottom: '25px', lineHeight: '1.4' }}>
          Crea una nueva contraseña robusta para acceder a <b>TOPFC</b>.
        </p>

        <form onSubmit={handleUpdatePassword} style={{ textAlign: 'left' }}>
          <label style={{ fontSize: '0.8rem', fontWeight: 'bold', color: '#95a5a6', marginLeft: '5px' }}>
            NUEVA CONTRASEÑA
          </label>
          <input
            type="password"
            placeholder="Mínimo 6 caracteres"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            style={{ 
              width: '100%', padding: '12px', borderRadius: '10px', border: '1px solid #ddd', 
              marginTop: '5px', marginBottom: '15px', boxSizing: 'border-box', fontSize: '16px'
            }}
          />

          <label style={{ fontSize: '0.8rem', fontWeight: 'bold', color: '#95a5a6', marginLeft: '5px' }}>
            REPETIR CONTRASEÑA
          </label>
          <input
            type="password"
            placeholder="Confirma tu contraseña"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            required
            style={{ 
              width: '100%', padding: '12px', borderRadius: '10px', 
              border: `1px solid ${confirmPassword === '' ? '#ddd' : (contraseñasCoinciden ? '#2ecc71' : '#e74c3c')}`, 
              marginTop: '5px', marginBottom: '5px', boxSizing: 'border-box', fontSize: '16px'
            }}
          />

          {/* Mensajes de validación dinámica */}
          <div style={{ minHeight: '20px', marginBottom: '20px' }}>
            {!contraseñasCoinciden && confirmPassword !== '' && (
              <span style={{ fontSize: '0.75rem', color: '#e74c3c' }}>⚠️ Las contraseñas no coinciden</span>
            )}
            {contraseñasCoinciden && (
              <span style={{ fontSize: '0.75rem', color: '#2ecc71' }}>✓ Las contraseñas coinciden</span>
            )}
          </div>

          {mensaje && (
            <div style={{ 
              padding: '10px', borderRadius: '8px', 
              backgroundColor: mensaje.startsWith('✅') ? '#ebfaf0' : '#fdedec',
              color: mensaje.startsWith('✅') ? '#27ae60' : '#e74c3c',
              fontSize: '0.85rem', marginBottom: '15px', textAlign: 'center'
            }}>
              {mensaje}
            </div>
          )}

          <button
            type="submit"
            disabled={loading || !contraseñasCoinciden || !longitudOk}
            style={{ 
              width: '100%', 
              background: (loading || !contraseñasCoinciden || !longitudOk) ? '#bdc3c7' : '#2ecc71', 
              color: 'white', border: 'none', padding: '14px', borderRadius: '10px', 
              fontWeight: 'bold', fontSize: '1rem', cursor: 'pointer',
              transition: 'all 0.3s ease'
            }}
          >
            {loading ? 'ACTUALIZANDO...' : 'GUARDAR NUEVA CLAVE'}
          </button>
        </form>
      </div>
    </div>
  )
}