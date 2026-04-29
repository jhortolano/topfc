import React from 'react';

function NormasNoPresentados() {
  return (
    <div>
      <h2 style={{ color: '#2ecc71', marginBottom: '15px' }}>GESTIÓN DE JUGADORES NO PRESENTADOS</h2>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #e67e22' }}>
          <p style={{ margin: 0, color: '#2c3e50', fontSize: '0.95rem' }}>
            La responsabilidad de gestionar los partidos no presentados recae sobre los propios jugadores.
            Se recomienda contactar al oponente al inicio de la jornada y, en caso de no obtener respuesta, reintentarlo pasados unos días.
          </p>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>📋 Protocolo de Ausencia de Contacto:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '8px' }}>
              <strong>1. Notificación:</strong> Si se acerca el fin de la jornada y tu oponente no responde, pulsa el botón <strong>"No contacto con mi oponente"</strong> (ubicado bajo "Postear partido").
              <img src="/nopresentados1.jpg" alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }} />
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>2. Bloqueo de seguridad:</strong> El botón se volverá gris. Si el oponente no responde antes del cierre de jornada, se te otorgará la victoria automática al inicio de la siguiente semana sin posibilidad de jugar el encuentro.
              <img src="/nopresentados2.jpg" alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }} />
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>3. Respuesta del oponente:</strong> Si el usuario notificado entra en la app, verá un aviso: <em>"Tu oponente no logra contactar contigo..."</em>. Deberá escribirte por WhatsApp y luego pulsar el botón <strong>"Ya he contactado con mi oponente"</strong>.
              <img src="/nopresentados3.jpg" alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }} />
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>4. Confirmación:</strong> Tras pulsar el botón, el sistema le confirmará: <em>"Has indicado a tu oponente que ya has contactado con él"</em>.
              <img src="/nopresentados4.jpg" alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }} />
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>5. Resolución:</strong> Al jugador que inició la queja le aparecerá el mensaje: <em>"Tu oponente ha indicado que ya ha contactado contigo"</em>. El partido deberá jugarse en la jornada actual. Si no se juega, el resultado final será <strong>0-0</strong>.
              <em> (Nota: Si el oponente vuelve a desaparecer, se puede repetir el proceso tras dejar pasar un día de margen).</em>
              <img src="/nopresentados5.jpg" alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }} />
            </li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #3498db' }}>
          <strong>🗓️ Reprogramación de Partidos (Solo Liga):</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '8px' }}>
              Si existe contacto pero es imposible coincidir en el horario, podéis usar el botón <strong>"Reprogramar a la siguiente semana"</strong>.
            <img src="/nopresentados6.jpg"  alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }}/>
            </li>
            <li style={{ marginBottom: '8px' }}>
              Esto habilita 7 días extra. Si al finalizar la prórroga no se ha jugado, se registrará un <strong>0-0</strong> definitivo.
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>Dar partido por perdido:</strong> Si un jugador sabe que no podrá jugar el partido reprogramado, puede pulsar el botón homónimo para ceder los puntos voluntariamente.
            <img src="/nopresentados7.jpg"  alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }}/>
            <img src="/nopresentados8.jpg"  alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }}/>
            </li>
            <li style={{ marginBottom: '8px' }}>
              <strong>Importante:</strong> La administración no realizará reprogramaciones manuales. Es vital estar seguros de poder jugar el partido antes de solicitar la prórroga.
            </li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #e74c3c' }}>
          <strong>🏆 Reglas en Playoff:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '8px' }}>Los partidos de Playoff <strong>NO</strong> se pueden reprogramar.</li>
            <li style={{ marginBottom: '8px' }}>Solo se permite la opción de indicar falta de contacto.</li>
            <img src="/nopresentados9.jpg"  alt="NoPresentados" style={{ marginTop: '15px', borderRadius: '6px', width: '100%', maxWidth: '400px', display: 'block', border: '1px solid #ddd' }}/>
            <li style={{ marginBottom: '8px' }}>
              En caso de incompatibilidad horaria insalvable, los jugadores deben acordar quién avanza a la siguiente ronda e introducir el resultado manualmente.
              <em> (Tip: Si soléis retransmitir, usad vuestro enlace habitual de Twitch para no perder los puntos de retransmisión).</em>
            </li>
          </ul>
        </div>

      </div>
    </div>
  );
}

export default NormasNoPresentados;