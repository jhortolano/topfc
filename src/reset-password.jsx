import { useState } from 'react'
import { supabase } from './supabaseClient' // Ajusta la ruta si es necesario

export default function ResetPassword({ onFinish }) {
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [mensaje, setMensaje] = useState('')

  const handleUpdatePassword = async (e) => {
    e.preventDefault()
    setLoading(true)
    setMensaje('')

    // Esta es la línea mágica que actualiza la clave del usuario que viene del email
    const { error } = await supabase.auth.updateUser({ password: password })

    if (error) {
      setMensaje('❌ Error: ' + error.message)
    } else {
      setMensaje('✅ ¡Contraseña actualizada con éxito!')
      // Opcional: Redirigir al perfil tras 2 segundos
      setTimeout(() => onFinish(), 2000)
    }
    setLoading(false)
  }

  return (
    <div style={{ maxWidth: '400px', margin: '50px auto', padding: '20px', textAlign: 'center', fontFamily: 'sans-serif' }}>
      <h2 style={{ color: '#2c3e50', borderBottom: '2px solid #2ecc71', paddingBottom: '10px' }}>
        Nueva Contraseña
      </h2>
      <p style={{ fontSize: '0.9rem', color: '#7f8c8d' }}>Introduce tu nueva clave para TopFC</p>

      <form onSubmit={handleUpdatePassword}>
        <input
          type="password"
          placeholder="Escribe tu nueva contraseña"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          style={{ 
            width: '100%', padding: '12px', borderRadius: '8px', border: '1px solid #ddd', 
            marginBottom: '15px', boxSizing: 'border-box' 
          }}
        />

        {mensaje && (
          <p style={{ 
            fontSize: '0.85rem', 
            color: mensaje.startsWith('✅') ? '#27ae60' : '#e74c3c',
            marginBottom: '15px'
          }}>
            {mensaje}
          </p>
        )}

        <button
          type="submit"
          disabled={loading || password.length < 6}
          style={{ 
            width: '100%', background: '#2ecc71', color: 'white', border: 'none', 
            padding: '12px', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer' 
          }}
        >
          {loading ? 'ACTUALIZANDO...' : 'CONFIRMAR NUEVA CLAVE'}
        </button>
      </form>
    </div>
  )
}