function Normas() {
  return (
    <div>
      <h2 style={{ color: '#2ecc71', marginBottom: '15px' }}>REGLAMENTO</h2>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>👕 Equipos Oficiales:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li>Puedes jugar con cualquier equipo con sus jugadores oficiales.</li>
            <li>Se permite cambiar de equipo entre partidos.</li>
          </ul>
        </div>

        {/* Respeto y Fair Play */}
        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>🤝 Respeto y Fair Play:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '8px' }}>Jugamos por diversión. Respeta a tu adversario e intenta saltar las celebraciones.</li>
            <li style={{ marginBottom: '8px' }}>
              <strong>Ajuste deportivo de marcadores:</strong> Con el fin de mantener la competitividad y un ambiente amistoso, el programa reseteará automáticamente los resultados con diferencias muy altas:
              <ul style={{ marginTop: '5px', listStyleType: 'circle' }}>
                <li>En <strong>Liga</strong>: Diferencia máxima de 3 goles (Ej: un 5-1 se registrará como 4-1).</li>
                <li>En <strong>Playoffs</strong>: Diferencia máxima de 5 goles (Ej: un 2-9 se registrará como 2-7).</li>
              </ul>
            </li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>⚙️ Configuración del partido:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>Dur. de tiempos: 6 minutos</li>
            <li>Controles: Cualquiera</li>
            <li>Vel de juego: Normal</li>
            <li>Tipo de plantilla: Online  --  <strong>No se pueden usar plantillas personalizadas</strong></li>
          </ul>
        </div>

        {/* Partidos Semanales con subpuntos */}
        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>⚽ Partidos semanales:</strong>
          <div style={{ marginTop: '8px' }}>Un partido a la semana.</div>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>Si no puedes jugar una semana, intenta adelantar el partido en lugar de retrasarlo.</li>
            <li>No se pueden retrasar partidos más allá del final de la temporada.</li>
            <li>Partidos no jugados al final de la temporada serán marcados como 3-0 en contra de la persona que no podía jugar en la semana que tocaba</li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>📝 Posteos:</strong>
          <div style={{ marginTop: '8px' }}>Se debe postear al final del partido</div>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>Puede postear el resultado cualquier jugador, aunque la responsabilidad de postear es del ganador del partido</li>
            <li>Si un resultado se introduce de forma incorrecta, contactar con la administración.</li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>📺 Retransmisión:</strong>
          <div style={{ marginTop: '8px' }}>
            Retransmitir los partidos da <strong>puntos extra</strong>. Si al menos el <strong>80%</strong> de tus partidos durante la temporada es retransmitido (Twitch/YouTube/etc) consigues <strong>2 puntos extra</strong> en la clasificación.
          </div>
          <div style={{ marginTop: '8px', fontWeight: 'bold', fontSize: '0.9rem' }}>Pasos para conseguir los puntos:</div>
          <ul style={{ margin: '5px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>
              <strong>1)</strong> Antes del partido, pega el link de la retransmisión en el grupo de Whatsapp "Retransmisiones".
            </li>
            <li style={{ marginBottom: '5px' }}>
              <strong>2)</strong> Después del partido, al guardar el resultado en la web, añade el link debajo del resultado.
            </li>
            <li>
              <strong>3)</strong> No importa quién retransmita, una sola retransmisión contará para <strong>ambos jugadores</strong>.
            </li>
          </ul>
        </div>

      </div>
    </div>
  );
}

export default Normas;