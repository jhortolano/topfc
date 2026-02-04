import { useState } from 'react'
import { supabase } from './supabaseClient'

export default function UserInfo({ profile, onUpdate }) {
  const [loading, setLoading] = useState(false)
  const [telegram, setTelegram] = useState(profile?.telegram_user || '')
  const [phone, setPhone] = useState(profile?.phone || '')
  const [mensaje, setMensaje] = useState('')
  const [avatarUrl, setAvatarUrl] = useState(profile?.avatar_url || '')
  const [uploading, setUploading] = useState(false)

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

  const uploadAvatar = async (event) => {
    try {
      setUploading(true)
      if (!event.target.files || event.target.files.length === 0) return

      const file = event.target.files[0]
      const img = new Image()
      const reader = new FileReader()

      reader.onload = (e) => {
        img.src = e.target.result
        img.onload = async () => {
          // --- LÓGICA DE REDIMENSIONADO (CANVAS) ---
          const canvas = document.createElement('canvas')
          const size = 128 // Tamaño final 128x128
          canvas.width = size
          canvas.height = size
          const ctx = canvas.getContext('2d')

          // Dibujar imagen centrada y recortada (square crop)
          const minSide = Math.min(img.width, img.height)
          const sx = (img.width - minSide) / 2
          const sy = (img.height - minSide) / 2
          ctx.drawImage(img, sx, sy, minSide, minSide, 0, 0, size, size)

          // Convertir a Blob (formato WebP para máxima compresión)
          canvas.toBlob(async (blob) => {
            // Usamos un nombre fijo basado en el ID para que siempre sea el mismo archivo
            // Añadimos el nombre de la carpeta antes del nombre del archivo
            const folderName = 'avatars'; 
            const filePath = `${folderName}/${profile.id}.webp`;

            const { error: uploadError } = await supabase.storage
              .from('avatars')
              .upload(filePath, blob, {
                upsert: true, // Esta opción permite sobrescribir si el archivo ya existe
                contentType: 'image/webp'
              })

            if (uploadError) throw uploadError

            // 2. Obtener URL pública
            const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(filePath)

            // Añadimos ?t=timestamp para que el navegador ignore el caché y muestre la nueva foto
            const urlConCacheBuster = `${publicUrl}?t=${new Date().getTime()}`

            const { error: updateError } = await supabase
              .from('profiles')
              .update({ avatar_url: urlConCacheBuster }) // Guardamos la URL con el truco del caché
              .eq('id', profile.id)

            setAvatarUrl(urlConCacheBuster)

            // 3. Actualizar perfil en la tabla 'profiles
            if (updateError) throw updateError

            setMensaje('✅ Foto actualizada')
            if (onUpdate) onUpdate()
          }, 'image/webp', 0.8)
        }
      }
      reader.readAsDataURL(file)
    } catch (error) {
      setMensaje('❌ Error subiendo: ' + error.message)
    } finally {
      setUploading(false)
    }
  }

  return (
    <div style={{ maxWidth: '400px', margin: '0 auto', padding: '10px' }}>
      <h3 style={{ borderBottom: '2px solid #2ecc71', paddingBottom: '10px', color: '#2c3e50', marginTop: 0 }}>
        Configuración de Cuenta
      </h3>
      
      <form onSubmit={handleSave}>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', marginBottom: '20px' }}>
        <div style={{ 
          width: '100px', height: '100px', borderRadius: '50%', overflow: 'hidden', 
          background: '#eee', border: '3px solid #2ecc71', marginBottom: '10px',
          display: 'flex', alignItems: 'center', justifyContent: 'center'
        }}>
          {avatarUrl ? (
            <img src={avatarUrl} alt="Avatar" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
          ) : (
            <span style={{ fontSize: '3rem', color: '#bdc3c7' }}>👤</span>
          )}
        </div>
        <label style={{ 
          background: '#34495e', color: 'white', padding: '6px 12px', borderRadius: '4px', 
          fontSize: '0.75rem', cursor: 'pointer', fontWeight: 'bold' 
        }}>
          {uploading ? 'PROCESANDO...' : 'CAMBIAR FOTO'}
          <input type="file" accept="image/*" onChange={uploadAvatar} disabled={uploading} style={{ display: 'none' }} />
        </label>
        </div>

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