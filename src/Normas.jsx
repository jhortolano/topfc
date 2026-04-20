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
            <li style={{ marginBottom: '8px' }}><strong>Jugamos por diversión.</strong> Respeta a tu adversario e intenta saltar las celebraciones.</li>
            <li style={{ marginBottom: '8px' }}>
              <strong>Ajuste deportivo de marcadores:</strong> Con el fin de mantener la competitividad y un ambiente amistoso, el programa reseteará automáticamente los resultados con diferencias muy altas:
              <ul style={{ marginTop: '5px', listStyleType: 'circle' }}>
                <li>En <strong>Liga</strong>: Diferencia máxima de 3 goles (Ej: un 5-1 se registrará como 4-1).</li>
                <li>En <strong>Playoffs</strong>: Diferencia máxima de 5 goles (Ej: un 2-9 se registrará como 2-7).</li>
              </ul>
            </li>
            <li style={{ marginBottom: '8px' }}>Abandono de partido: Si por cualquier razón no estás cómodo en el partido, puedes abandonarlo, se lo indicas a tu oponente y se finaliza el partido. El resultado será 3-0 en liga o 5-0 en playoff a favor del oponente.</li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>⚙️ Configuración del partido:</strong>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>Dur. de tiempos: 6 minutos</li>
            <li>Controles: Cualquiera</li>
            <li>Vel de juego: Normal</li>
            <li>Tipo de plantilla: Online  --  <strong>No se pueden usar plantillas personalizadas</strong></li>
            <img
              src="/ajustesOnline.jpg"
              alt="Configuración recomendada"
              style={{
                marginTop: '15px',
                borderRadius: '6px',
                width: '100%',
                maxWidth: '400px',
                display: 'block',
                border: '1px solid #ddd'
              }}
            />
          </ul>
        </div>

        {/* Partidos Semanales con subpuntos */}
        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>⚽ Partidos semanales:</strong>
          <div style={{ marginTop: '8px' }}>Jugamos un partido a la semana.</div>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '8px' }}><strong>¿No puedes jugar?:</strong> Si te surge algo, intenta <strong>adelantar</strong> el partido. Siempre es mejor jugar antes que dejarlo para después.</li>
            <li style={{ marginBottom: '8px' }}><strong>Fecha límite:</strong> 
              <ul>
                <li>No se puede reprogramar partidos pendientes más allá del final de la temporada.</li>
                <li><strong>Partidos de Playoff</strong> NO se pueden reprogramar.</li>
                <li>Se pueden adelantar partidos hasta dos jornadas en adelante si hay una justificación válida. (ej: jugar la Jornada 3-4 en la Jornada 2).</li>
                <li>Como norma general, cualquier partido con 2 o más jornadas de antigüedad será marcado como no jugado o con el marcador que corresponda dependiendo de los casos descritos abajo.
                  <ul>
                    <li>Ejemplo: Comienza la Jornada 4, los partidos no jugados de la Jornada 3 se pueden reprogramar. Todos los partidos no jugados de la Jornada 2 ya no se pueden jugar.</li>
                  </ul>
                </li>
              </ul>
            </li>
            <li style={{ marginBottom: '8px' }}><strong>Avisa a los admins:</strong> Si necesitas reprogramarlo, <strong>una vez habiendolo organizado con tu oponente y no antes,</strong> dinos qué semana lo vas a jugar. Si llega la siguiente jornada, el partido no se juega y nadie ha avisado, se queda en <strong>0-0</strong> y se pierde la oportunidad de jugarlo.</li>
            <li style={{ marginBottom: '8px' }}><strong>Si uno no aparece:</strong> Si el partido se queda sin jugar porque solo uno de los dos no ha podido (o no ha querido), el que sí estaba disponible gana <strong>3-0</strong> en liga o <strong>5-0</strong> en playoff.</li>
            <li style={{ marginBottom: '8px' }}><strong>Empate técnico:</strong> Si ninguno de los dos puede jugar ni ponerse de acuerdo, se marca un <strong>0-0</strong>. Eso sí, si hay una diferencia clara en la disponibilidad de un jugador sobre el otro, se le dará la victoria al que más disponibilidad tenía ganando este con <strong>3-0</strong> en liga o <strong>5-0</strong> en playoff.</li>
            <li><strong>¡No desaparezcas!:</strong> Avisa siempre a tu rival. Si alguien pasa <strong>10 días sin contestar</strong> a los mensajes, la administración podrá buscarle un reemplazo. <em>(Ojo: esto es por no contestar; si avisas de que no puedes, no pasa nada)</em>.</li>
          </ul>
        </div>

        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>📝 Posteos:</strong>
          <div style={{ marginTop: '8px' }}>Se debe postear al final del partido</div>
          <ul style={{ margin: '8px 0 0 0', paddingLeft: '20px', fontSize: '0.95rem', color: '#555' }}>
            <li style={{ marginBottom: '5px' }}>Puede postear el resultado cualquier jugador, aunque la responsabilidad de postear es del ganador del partido</li>
            <li>Si un resultado se introduce de forma incorrecta, contactar con la administración.</li>
            <li><strong>Partidos de Playoff:</strong>
                <ul>
                  <li>En eliminatorias (no liguilla) no puede haber empates. Si hay ida y vuelta, en ida puede haber empate, pero en la vuelta, cuando se suman los goles, no puede haber empate.</li>
                  <li>Si hubiera empate:
                    <ul>
                      <li>Se juega un nuevo partido, quien gane el partido, gana esa fase de la eliminatoria</li>
                      <li>Si el nuevo partido vuelve a quedar empate, se vuelve a jugar otro nuevo partido, quien marque primero en ese nuevo partido gana esa fase de la eliminatoria.</li>
                    </ul>
                  </li>
                </ul>
            </li>
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

        {/* Escenarios Especiales */}
        <div style={{ padding: '15px', background: '#f8f9fa', borderRadius: '8px', borderLeft: '4px solid #2ecc71' }}>
          <strong>⚠️ Escenarios Especiales (Lag y Desconexiones):</strong>

          <div style={{ marginTop: '12px', color: '#333' }}>
            <strong>1. Incidencias por Lag persistente:</strong>
            <ul style={{ margin: '5px 0 10px 0', paddingLeft: '20px', fontSize: '0.9rem', color: '#555' }}>
              <li><strong>Minuto 0-30:</strong> El jugador afectado puede abandonar y posponer el encuentro.</li>
              <li><strong>Minuto 30+:</strong> El partido debe finalizarse obligatoriamente pese al lag.</li>
              <li><strong>Marcador:</strong> Si hay una diferencia de 2 o más goles al abandonar, se arrastrará esa ventaja al nuevo partido. Si la diferencia es de 1 gol o empate, se empieza de cero.</li>
            </ul>
          </div>

          <div style={{ marginTop: '10px', color: '#333' }}>
            <strong>2. Desconexión de red:</strong>
            <ul style={{ margin: '5px 0 0 0', paddingLeft: '20px', fontSize: '0.9rem', color: '#555' }}>
              <li><strong>Antes del min 30:</strong> Se juega un partido nuevo completo y se suma el resultado del primer partido al marcador final.</li>
              <li><strong>Después del min 30:</strong> Se juega un nuevo partido solo los minutos restantes (hasta el min 90 total). Se debe detener el juego inmediatamente al cumplir el tiempo acordado, sin esperar a terminar la jugada. El marcador del primer partido se suma al marcador del segundo partido.</li>
            </ul>
          </div>
          <div style={{ marginTop: '10px', color: '#333' }}>
            <strong>3. Otras incidencias:</strong>
            <ul style={{ margin: '5px 0 0 0', paddingLeft: '20px', fontSize: '0.9rem', color: '#555' }}>
              <li><strong>Tipos:</strong> Aquí se engloban el resto de incidencias como por ejemplo, el partido empezó pero... viene un repartidor, me tengo que ir, tengo que atender una llamada, etc., y las pausas del juego no son suficientes.</li>
              <li><strong>Antes del min 30:</strong> Si la persona que no tuvo la incidencia va ganando, se juega un nuevo partido solo los minutos restantes (hasta el min 90 total). Se debe detener el juego inmediatamente al cumplir el tiempo acordado, sin esperar a terminar la jugada. El marcador del primer partido se suma al marcador del segundo partido. En caso de que la persona que no tuvo la incidencia va perdiendo o en empate, se juega un nuevo partido entero, sin suma de goles.</li>
              <li><strong>Después del min 30:</strong> El partido lo pierde la persona que tuvo la incidencia por 3-0 en liga o 5-0 en playoffs.</li>
            </ul>
          </div>
        </div>

      </div>
    </div>
  );
}

export default Normas;