import { useState } from 'react'
import { supabase } from './supabaseClient'

export default function UserInfo({ profile, onUpdate }) {
  const [loading, setLoading] = useState(false)
  const [telegram, setTelegram] = useState(profile?.telegram_user || '')
  const [phone, setPhone] = useState(profile?.phone || '')
  const [mensaje, setMensaje] = useState('')

  const labelStyle = { display: 'block', fontSize: '0.85rem', fontWeight: 'bold', color: '#34495e', marginBottom: '5px' }
  const inputStyle = { width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #ddd', marginBottom: '15px', background: '#f9f9f9' }
  const editableInputStyle = { ...inputStyle, background: 'white' }

  const handleSave = async (e) => {
    e.preventDefault()
    setLoading(true)
    const { error } = await supabase
      .from('profiles')
      .update({ telegram_user: telegram, phone: phone })
      .eq('id', profile.id)

    if (error) setMensaje('❌ Error: ' + error.message)
    else {
      setMensaje('✅ Actualizado')
      if (onUpdate) onUpdate()
    }
    setLoading(false)
  }

  return (
    <div style={{ maxWidth: '400px', margin: '0 auto', padding: '10px' }}>
      <h3 style={{ borderBottom: '2px solid #2ecc71', paddingBottom: '10px', color: '#2c3e50', marginTop: 0 }}>
        Configuración de Cuenta
      </h3>
      
      <form onSubmit={handleSave}>
        <label style={labelStyle}>Nick</label>
        <input style={inputStyle} type="text" value={profile?.nick || ''} readOnly />

        <label style={labelStyle}>Email</label>
        <input style={inputStyle} type="text" value={profile?.email || ''} readOnly />

        <label style={labelStyle}>Usuario de Telegram</label>
        <input style={editableInputStyle} type="text" value={telegram} onChange={e => setTelegram(e.target.value)} placeholder="@usuario" />

        <label style={labelStyle}>Teléfono</label>
        <input style={editableInputStyle} type="text" value={phone} onChange={e => setPhone(e.target.value)} placeholder="+34..." />

        {mensaje && <p style={{ fontSize: '0.85rem', textAlign: 'center', color: mensaje.startsWith('✅') ? '#27ae60' : '#e74c3c' }}>{mensaje}</p>}

        <button 
          type="submit" 
          disabled={loading}
          style={{ width: '100%', background: '#2ecc71', color: 'white', border: 'none', padding: '12px', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer', marginBottom: '10px' }}
        >
          {loading ? 'GUARDANDO...' : 'GUARDAR CAMBIOS'}
        </button>
      </form>

      <div style={{ borderTop: '1px solid #eee', marginTop: '20px', paddingTop: '20px' }}>
        <button 
          onClick={() => supabase.auth.signOut()}
          style={{ 
            width: '100%', background: 'white', color: '#e74c3c', border: '1px solid #e74c3c', 
            padding: '10px', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer' 
          }}
        >
          CERRAR SESIÓN
        </button>
      </div>
    </div>
  )
}