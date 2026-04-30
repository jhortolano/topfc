import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import ReactMarkdown from 'react-markdown'
import PartidoExtraPlayoff from './extraplayoff/PartidoExtraPlayoff';
import PartidoPromo from './utils/PartidoPromo';
import GestionNoPresentados from './utils/GestionNoPresentados';

// Variable global para persistir datos entre montajes de componentes
let cacheProximoPartido = {
  data: null,
  timestamp: 0,
  userId: null
};
const DURACION_CACHE = 1000 * 60 * 5; // 5 minutos de caché

const Avatar = ({ url }) => (
  <div style={{
    width: '35px', height: '35px', borderRadius: '50%', overflow: 'hidden',
    background: '#34495e', border: '2px solid #2ecc71', flexShrink: 0
  }}>
    {url ? (
      <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
    ) : (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.8rem', color: '#7f8c8d' }}>👤</div>
    )}
  </div>
);

function TarjetaResultado({ partido, onUpdated, limitGaEnabled, maxGaLeague, userId }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');
  const [enviando, setEnviando] = useState(false);
  const [urlStream, setUrlStream] = useState('');
  const [ajustado, setAjustado] = useState(false);

  const idLocal = partido.player1_id || partido.home_team;
  const idVisitante = partido.player2_id || partido.away_team;
  const esLocal = idLocal === userId;

  const rival = esLocal ? partido.p2 : partido.p1;
  const partidoYaJugado = partido.is_played === true || partido.played === true || partido.home_score !== null;
  const [showRivalContact, setShowRivalContact] = useState(false);

  useEffect(() => {
    const yaJugado = partido.played === true || partido.is_played === true;

    setJugadoLocal(yaJugado);
    setGL(partido.home_score ?? '');
    setGV(partido.away_score ?? '');

    // Ahora el stream_url viene incluido en el objeto del partido
    setUrlStream(partido.stream_url || '');
  }, [partido]);

  // Identificamos si es un partido de playoff
  const isPlayoff = !!partido.playoff_id;
  const isExtraLiguilla = !!partido.is_extra_liguilla;
  const isExtraPlayoff = !!partido.is_extra_playoff;
  const isPromo = !!partido.is_promo;
  let tabla = 'matches';
  if (isPlayoff) tabla = 'playoff_matches';
  if (isExtraLiguilla) tabla = 'extra_matches';
  if (isExtraPlayoff) tabla = 'extra_playoffs_matches';
  if (isPromo) tabla = 'promo_matches';
  const yaJugado = partido.played === true || partido.is_played === true;
  const [jugadoLocal, setJugadoLocal] = useState(yaJugado);

  // Esto asegura que si cambias de jornada, el estado se resetee
  useEffect(() => {
    // Detección universal para el reseteo
    const yaJugado = partido.played === true || partido.is_played === true || (partido.home_score !== null && partido.away_score !== null);;

    setJugadoLocal(yaJugado);
    setGL(partido.home_score ?? '');
    setGV(partido.away_score ?? '');
  }, [partido]);

  const guardar = async () => {
    if (gL === '' || gV === '') return alert("Introduce los goles");
    setEnviando(true);

    try {
      let urlLimpia = urlStream.trim();

      // 1. Buscamos el patrón: o empieza por http/https o empieza por www
      // El regex busca: (https?:// o www\.) seguido de caracteres que no sean espacios
      const match = urlLimpia.match(/(https?:\/\/[^\s]+|www\.[^\s]+)/i);

      if (match) {
        urlLimpia = match[0];
        // 2. Normalización: Si capturó algo que empieza por www, le añadimos el https://
        // Esto es vital para que al hacer clic en el enlace después, no intente abrir
        // una ruta relativa de tu propia web.
        if (urlLimpia.toLowerCase().startsWith('www.')) {
          urlLimpia = `https://${urlLimpia}`;
        }
      }

      let scoreL = parseInt(gL);
      let scoreV = parseInt(gV);
      let huboAjuste = false;

      // --- NUEVA LÓGICA DE RECORTE (LIGA + PLAYOFF) ---
      let activo = false;
      let maximo = 0;

      if (isPlayoff) {
        // Usamos los datos que inyectaste en el mapeo: po.limit_ga_enabled y po.max_ga_playoff
        activo = String(partido.playoff_limit_ga) === 'true' || partido.playoff_limit_ga === true;
        maximo = parseInt(partido.playoff_max_ga);
      } else if (isExtraLiguilla || isExtraPlayoff) {
        activo = String(partido.limit_ga_enabled) === 'true' || partido.limit_ga_enabled === true;
        maximo = parseInt(partido.max_ga_playoff);
      } else {
        // Usamos las reglas de la liga que vienen por props
        activo = String(limitGaEnabled) === 'true' || limitGaEnabled === true;
        maximo = parseInt(maxGaLeague);
      }

      if (activo && maximo > 0) {
        const diferenciaActual = Math.abs(scoreL - scoreV);
        if (diferenciaActual > maximo) {
          huboAjuste = true;
          if (scoreL > scoreV) scoreL = scoreV + maximo;
          else scoreV = scoreL + maximo;
        }
      }
      // --- FIN LÓGICA DE RECORTE ---

      // En playoff_matches_detallados (vista), los IDs reales son local_id y visitante_id
      // Intentamos capturar el ID de cualquier fuente posible (Vista o Tabla base)
      const idLocal = partido.local_id || partido.home_team;
      const idVisitante = partido.visitante_id || partido.away_team;

      if (!idLocal || !idVisitante) {
        console.error("Contenido de partido:", partido); // Para debug
        throw new Error("Faltan IDs de los equipos.");
      }


      // 1. Preparamos los datos del resultado
      const datosAEnviar = (isExtraLiguilla || isExtraPlayoff || isPromo)
        ? {
          score1: scoreL,
          score2: scoreV,
          is_played: true,
          stream_url: urlLimpia  // <--- Solo aquí existe la columna
        }
        : (isPlayoff
          ? { home_score: scoreL, away_score: scoreV, played: true } // Quitamos stream_url de aquí
          : { home_score: scoreL, away_score: scoreV, is_played: true } // Y de aquí
        );

      // 2. Actualizamos la tabla del partido
      const { error: errorUpdate } = await supabase
        .from(tabla)
        .update(datosAEnviar)
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      // 3. Si NO es extra, guardamos el stream en su tabla correspondiente
      if (!isExtraLiguilla && !isExtraPlayoff && urlLimpia) {
        const tablaStream = isPlayoff ? 'match_playoff_streams' : 'match_streams';
        const columnaId = isPlayoff ? 'playoff_match_id' : 'match_id';

        await supabase.from(tablaStream).upsert({
          [columnaId]: partido.id,
          stream_url: urlLimpia,
          updated_at: new Date().toISOString()
        });
      }



      // Guardar URL del stream (tanto para Liga como para Playoff)
      setJugadoLocal(true);
      if (isPlayoff) {
        // 1. Intentar actualizar el ganador_id en el partido actual si la columna existe
        await supabase.from('playoff_matches').update({ winner_id: null }).eq('id', partido.id);

        const pId = String(partido.playoff_id);
        const mOrder = parseInt(partido.match_order);
        const faseActualNombre = partido.round;
        const faseBase = faseActualNombre.split(' (')[0].trim();
        const esDoble = faseActualNombre.includes('(Ida)') || faseActualNombre.includes('(Vuelta)');

        const { data: enfrentamientos } = await supabase
          .from('playoff_matches')
          .select('*')
          .eq('playoff_id', pId)
          .eq('match_order', String(mOrder))
          .ilike('round', `${faseBase}%`);

        let ganadorId = null;

        if (!esDoble) {
          if (scoreL > scoreV) ganadorId = idLocal;
          else if (scoreV > scoreL) ganadorId = idVisitante;
        } else {
          const ida = enfrentamientos.find(m => m.round.includes('(Ida)'));
          const vuelta = enfrentamientos.find(m => m.round.includes('(Vuelta)'));

          const idaFinal = ida?.id === partido.id ? { ...ida, home_score: scoreL, away_score: scoreV, played: true } : ida;
          const vueltaFinal = vuelta?.id === partido.id ? { ...vuelta, home_score: scoreL, away_score: scoreV, played: true } : vuelta;

          if (idaFinal?.played && vueltaFinal?.played) {
            const globalLocal = (idaFinal.home_score || 0) + (vueltaFinal.away_score || 0);
            const globalVisitante = (idaFinal.away_score || 0) + (vueltaFinal.home_score || 0);

            if (globalLocal > globalVisitante) ganadorId = idaFinal.home_team;
            else if (globalVisitante > globalLocal) ganadorId = idaFinal.away_team;
          }
        }

        // 3. EJECUTAR PROMOCIÓN
        if (ganadorId) {
          const ordenRondas = ["Dieciseisavos", "Octavos", "Cuartos", "Semifinales", "Final"];
          const idx = ordenRondas.findIndex(r => r.toLowerCase() === faseBase.toLowerCase());
          const sigRonda = ordenRondas[idx + 1];

          if (sigRonda) {
            const sigMatchOrder = Math.floor(mOrder / 2);
            const esLocalNext = mOrder % 2 === 0;
            const columnaDestino = esLocalNext ? 'home_team' : 'away_team';

            // IMPORTANTE: Usamos un try/catch específico para la promoción
            // para que si falla el RLS del siguiente partido, al menos el resultado actual se guarde
            try {
              const { error: errorNext } = await supabase
                .from('playoff_matches')
                .update({ [columnaDestino]: ganadorId })
                .eq('playoff_id', pId)
                .eq('match_order', String(sigMatchOrder))
                .ilike('round', `${sigRonda}%`);

              if (errorNext) console.warn("RLS bloqueó la promoción automática. El admin deberá asignar al ganador.");
            } catch (e) {
              console.error("Error promocionando:", e);
            }
          }
        }
      }

      if (onUpdated) onUpdated();
      if (huboAjuste) alert(`Resultado ajustado por normativa (Máx: ${maximo} goles)`);
      else alert("Guardado correctamente.");
    } catch (err) {
      console.error(err);
      alert(err.message);
    } finally {
      setEnviando(false);
    }
  };

  return (
    <div style={{
      background: isPlayoff ? '#3a2c50' : '#2c3e50', // Color lila oscuro si es playoff
      color: 'white', padding: '15px', borderRadius: '12px', textAlign: 'center', position: 'relative',
      border: isPlayoff ? '1px solid #9b59b6' : 'none'
    }}>
      {/* ETIQUETA SUPERIOR DINÁMICA */}
      <div style={{
        position: 'absolute',
        top: '5px',
        left: '10px',
        fontSize: '0.6rem',
        color: isPromo ? '#FFD700' : (isPlayoff ? '#d6a2e8' : '#2ecc71'), // Dorado para promo o el color que prefieras
        fontWeight: 'bold',
        textTransform: 'uppercase'
      }}>
        {isPromo ?
          /* Caso específico: Partidos de Promoción */
          partido.label_info :
          (partido.is_extra_liguilla ?
            /* Caso específico: Jornada de Liguilla Extra */
            `JORNADA ${partido.numero_jornada} - ${partido.playoff_name}` :
            (partido.is_extra_playoff ?
              /* Caso específico: Semis/Final de Torneo Extra */
              `${partido.round} - ${partido.playoff_name}` :
              (isPlayoff ?
                /* Caso: Playoff Liga Regular */
                `${partido.playoff_name || 'Playoff'} - ${partido.round}` :
                /* Caso: Jornada Liga Regular */
                partido.is_rescheduled ? `REPROGRAMADO - JORNADA ${partido.week}` :
                  `JORNADA ${partido.week || partido.numero_jornada}`)
            )
          )
        }
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'flex-start', gap: '15px', marginBottom: '10px', marginTop: '15px' }}>
        {/* COLUMNA LOCAL */}
        <div
          onClick={() => !esLocal && setShowRivalContact(!showRivalContact)}
          style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px', cursor: !esLocal ? 'pointer' : 'default' }}
        >
          <Avatar url={partido.local_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.local_nick}
          </div>
          {/* CONTACTO SI EL RIVAL ES EL LOCAL */}
          {!esLocal && rival && showRivalContact && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '5px', marginTop: '3px' }}>
              {rival.eafc_user && <span style={{ fontSize: '0.6rem', color: '#2ecc71' }}>{rival.eafc_user}</span>}
              <div style={{ display: 'flex', gap: '8px', justifyContent: 'center' }}>
                {rival.phone && (
                  <a href={`https://wa.me/${rival.phone.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
                    {/* Icono de WhatsApp SVG */}
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="#25D366">
                      <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.72.937 3.659 1.432 5.631 1.433h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z" />
                    </svg>
                  </a>
                )}
                {rival.telegram_user && (
                  <a href={`https://t.me/${rival.telegram_user.replace('@', '')}`} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
                    {/* Icono de Telegram SVG */}
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                      <path d="M21.435 2.509a1.507 1.507 0 0 0-1.503-.13L2.736 9.493c-.933.376-.84 1.706.13 1.954l4.593 1.168 1.954 6.273a1.5 1.5 0 0 0 2.585.439l2.716-3.23 4.673 3.447a1.5 1.5 0 0 0 2.378-1.01l3.037-14.331a1.5 1.5 0 0 0-1.367-1.693zM10.15 14.542l-.52 3.293-1.464-4.7 9.873-6.666-7.889 8.073z" fill="#0088cc" />
                    </svg>
                  </a>
                )}
              </div>
            </div>
          )}
        </div>

        <div style={{ display: 'flex', alignItems: 'center', marginTop: '10px' }}>
          {jugadoLocal ? (
            <div style={{
              background: '#34495e', padding: '8px 15px', borderRadius: '8px',
              border: `2px solid ${isPlayoff ? '#9b59b6' : '#2ecc71'}`,
              fontWeight: 'bold', fontSize: '1.2rem', minWidth: '60px'
            }}>
              {gL} - {gV}
            </div>
          ) : (
            <div style={{ display: 'flex', gap: '5px', alignItems: 'center' }}>
              <input type="number" min="0" value={gL} onChange={e => setGL(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
              <span style={{ fontWeight: 'bold', fontSize: '1.2rem' }}>-</span>
              <input type="number" min="0" value={gV} onChange={e => setGV(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
            </div>
          )}
        </div>

        {/* COLUMNA VISITANTE */}
        <div
          onClick={() => esLocal && setShowRivalContact(!showRivalContact)}
          style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px', cursor: esLocal ? 'pointer' : 'default' }}
        >
          <Avatar url={partido.visitante_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.visitante_nick}
          </div>
          {/* CONTACTO SI EL RIVAL ES EL VISITANTE */}
          {esLocal && rival && showRivalContact && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '5px', marginTop: '3px' }}>
              {rival.eafc_user && <span style={{ fontSize: '0.6rem', color: '#2ecc71' }}>{rival.eafc_user}</span>}
              <div style={{ display: 'flex', gap: '8px', justifyContent: 'center' }}>
                {rival.phone && (
                  <a href={`https://wa.me/${rival.phone.replace(/\D/g, '')}`} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
                    {/* Icono de WhatsApp SVG */}
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="#25D366">
                      <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.72.937 3.659 1.432 5.631 1.433h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z" />
                    </svg>
                  </a>
                )}
                {rival.telegram_user && (
                  <a href={`https://t.me/${rival.telegram_user.replace('@', '')}`} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>
                    {/* Icono de Telegram SVG */}
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                      <path d="M21.435 2.509a1.507 1.507 0 0 0-1.503-.13L2.736 9.493c-.933.376-.84 1.706.13 1.954l4.593 1.168 1.954 6.273a1.5 1.5 0 0 0 2.585.439l2.716-3.23 4.673 3.447a1.5 1.5 0 0 0 2.378-1.01l3.037-14.331a1.5 1.5 0 0 0-1.367-1.693zM10.15 14.542l-.52 3.293-1.464-4.7 9.873-6.666-7.889 8.073z" fill="#0088cc" />
                    </svg>
                  </a>
                )}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* SECCIÓN DE STREAM */}
      {(jugadoLocal ? !!urlStream : true) && (
        <div style={{
          marginTop: '15px', marginBottom: '10px', paddingTop: '10px',
          borderTop: '1px solid rgba(255,255,255,0.1)', display: 'flex',
          flexDirection: 'column', gap: '4px'
        }}>
          <label style={{ fontSize: '0.65rem', color: '#bdc3c7', textAlign: 'left', marginLeft: '2px' }}>
            Retransmisión:
          </label>

          {jugadoLocal ? (
            urlStream && (
              urlStream.includes('http') ? (
                <a
                  href={urlStream.trim()}
                  target="_blank"
                  rel="noopener noreferrer"
                  style={{
                    background: isPlayoff ? '#9b59b6' : '#2ecc71',
                    color: 'white', padding: '8px',
                    borderRadius: '6px', fontSize: '0.7rem', textDecoration: 'none',
                    fontWeight: 'bold', display: 'block', overflow: 'hidden',
                    textOverflow: 'ellipsis', whiteSpace: 'nowrap'
                  }}
                >
                  📺 {urlStream.replace('https://', '').replace('http://', '')}
                </a>
              ) : (
                <div style={{
                  background: 'rgba(255,255,255,0.05)',
                  padding: '8px',
                  borderRadius: '6px',
                  fontSize: '0.7rem',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  border: '1px solid rgba(231, 76, 60, 0.3)'
                }}>
                  <span style={{ color: '#bdc3c7', fontStyle: 'italic', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {urlStream}
                  </span>
                  <span style={{
                    color: '#e74c3c',
                    fontWeight: 'bold',
                    fontSize: '0.6rem',
                    marginLeft: '10px',
                    whiteSpace: 'nowrap',
                    textTransform: 'uppercase'
                  }}>
                    ⚠️ Link no válido
                  </span>
                </div>
              )
            )
          ) : (
            <input
              type="text"
              value={urlStream}
              onChange={e => setUrlStream(e.target.value)}
              placeholder="Link de Twitch/YouTube (Opcional)"
              style={{
                width: '100%', background: 'rgba(255,255,255,0.05)',
                border: '1px solid rgba(255,255,255,0.2)', borderRadius: '6px',
                padding: '8px 10px', fontSize: '0.75rem', color: 'white'
              }}
            />
          )}
        </div>
      )}

      {!jugadoLocal && (
        <button onClick={guardar} disabled={enviando} style={{
          background: isPlayoff ? '#9b59b6' : '#2ecc71',
          color: 'white', border: 'none', padding: '18px', borderRadius: '8px',
          cursor: 'pointer', fontWeight: 'bold', width: '100%', marginTop: '10px', fontSize: '1rem', letterSpacing: '1px', boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
        }}>
          {enviando ? 'GUARDANDO...' : 'POSTEAR RESULTADO'}
        </button>
      )}

      <div style={{ marginTop: '20px' }}>
        <GestionNoPresentados
          partido={partido}
          userId={userId}
          onUpdated={onUpdated}
        />
      </div>
    </div>
  )
}

function ProximoPartido({ profile, config, onUpdated }) {
  const [partidosLiga, setPartidosLiga] = useState([])
  const [partidosPlayoff, setPartidosPlayoff] = useState([])
  const [aviso, setAviso] = useState(null)
  const [loading, setLoading] = useState(true)
  const [encuestas, setEncuestas] = useState([]);
  const [votosPropios, setVotosPropios] = useState({});
  const [reglas, setReglas] = useState({ limit_ga_enabled: false, max_ga_league: 0 });

  const cargar = async (forceRefresh = false) => {
    if (!config || !profile) return;

    // --- LÓGICA DE CACHÉ PARA EVITAR LENTITUD ---
    const ahoraMs = Date.now();
    if (!forceRefresh &&
      cacheProximoPartido.data &&
      cacheProximoPartido.userId === profile.id &&
      (ahoraMs - cacheProximoPartido.timestamp) < DURACION_CACHE) {

      const c = cacheProximoPartido.data;
      setAviso(c.aviso);
      setEncuestas(c.encuestas);
      setVotosPropios(c.votosPropios);
      setReglas(c.reglas);
      setPartidosLiga(c.liga);
      setPartidosPlayoff(c.playoff);
      setLoading(false);
      return;
    }

    setLoading(true)

    try {
      // --- INICIO DE TU CÓDIGO ORIGINAL (ÍNTEGRO) ---
      // --- 0. CARGAR AVISO ---
      const { data: avisoData } = await supabase
        .from('avisos')
        .select('*')
        .eq('id', 1)
        .eq('mostrar', true) // Solo lo traemos si el checkbox está activo
        .maybeSingle();

      setAviso(avisoData);

      // --- 0.5 CARGAR ENCUESTAS ---
      const { data: encData } = await supabase
        .from('encuestas')
        .select('*')
        .eq('activa', true)
        .order('created_at', { ascending: false });

      let mapaVotos = {};
      if (encData && encData.length > 0) {
        setEncuestas(encData);

        // Cargar qué ha votado este usuario específicamente
        const { data: misVotos } = await supabase
          .from('votos_encuesta')
          .select('encuesta_id, opcion_index')
          .eq('usuario_id', profile.id)
          .in('encuesta_id', encData.map(e => e.id));

        misVotos?.forEach(v => mapaVotos[v.encuesta_id] = v.opcion_index);
        setVotosPropios(mapaVotos);
      }

      // 0.7 Obtener las reglas de la temporada actual
      const { data: rulesData, error: rulesError } = await supabase
        .from('season_rules')
        .select('limit_ga_enabled, max_ga_league')
        .eq('season', config.current_season) // Usamos el ID de temporada de la config global
        .single();

      if (rulesData) {
        setReglas(rulesData);
      }

      // --- 1. CARGAR PARTIDOS DE LIGA ---
      let ligaTemp = [];
      if (config.current_week > 0) {
        const { data: currentWeekData, error: weekError } = await supabase
          .from('weeks_schedule')
          .select('start_at, end_at')
          .eq('season', config.current_season)
          .eq('week', config.current_week)
          .maybeSingle();

        // Solo intentamos cargar partidos si encontramos la semana
        if (currentWeekData) {
          const { data: activeWeeks } = await supabase
            .from('weeks_schedule')
            .select('week')
            .eq('season', config.current_season)
            .eq('start_at', currentWeekData.start_at)
            .eq('end_at', currentWeekData.end_at);

          const weekNumbers = activeWeeks.map(w => w.week);

          const { data } = await supabase
            .from('partidos_detallados')
            .select(`
                     *,
                    p1:profiles!home_team(id, nick, eafc_user, phone, telegram_user),
                    p2:profiles!away_team(id, nick, eafc_user, phone, telegram_user)
                  `)
            .eq('season', config.current_season)
            .in('week', weekNumbers)
            .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

          ligaTemp = data || [];
        } else {
          console.warn("No se encontró configuración de fechas para la semana actual.");
        }
      } else {
        console.log("Temporada en preparación (Jornada 0).");
      }

      // --- 1.1 CARGAR PARTIDOS REPROGRAMADOS (LIGA) ---
      const ahora = new Date().toISOString();

      // Traemos las reprogramaciones activas en fecha
      const { data: reschedData } = await supabase
        .from('matches_rescheduled')
        .select('match_id')
        .eq('tipo_partido', 'liga')
        .lte('fecha_inicio', ahora)
        .gte('fecha_fin', ahora);

      if (reschedData && reschedData.length > 0) {
        const idsReprogramados = reschedData.map(r => r.match_id);

        // Filtramos para no traer los que ya están en ligaTemp (evitar duplicados)
        const idsNuevos = idsReprogramados.filter(id => !ligaTemp.some(lp => lp.id === id));

        if (idsNuevos.length > 0) {
          const { data: partidosExtra } = await supabase
            .from('partidos_detallados')
            .select('*')
            .in('id', idsNuevos)
            .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

          if (partidosExtra) {
            // Marcamos estos partidos para que la etiqueta superior sea coherente
            const partidosMarcados = partidosExtra.map(p => ({ ...p, is_rescheduled: true }));
            ligaTemp = [...ligaTemp, ...partidosMarcados];
          }
        }
      }

      // --- 2. CARGAR PARTIDOS DE PLAYOFF ---
      const { data: playoffsActivos } = await supabase
        .from('playoffs')
        .select('id, name, current_round, limit_ga_enabled, max_ga_playoff')
        .eq('season', config.current_season)
        .not('current_round', 'is', null)
        .neq('current_round', 'Finalizado');

      let playoffTemp = [];
      if (playoffsActivos && playoffsActivos.length > 0) {
        const idsActivos = playoffsActivos.map(p => p.id);

        // 1. Traemos todos los partidos detallados del usuario para estos playoffs
        const { data: todosMisPartidos } = await supabase
          .from('playoff_matches_detallados')
          .select('*')
          .in('playoff_id', idsActivos)
          .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

        if (todosMisPartidos) {
          playoffsActivos.forEach(po => {
            // 2. Buscamos el partido "referencia" que define las fechas actuales
            const partidoReferencia = todosMisPartidos.find(
              m => m.playoff_id === po.id && m.round === po.current_round
            );

            if (partidoReferencia) {
              // 3. Filtramos todos los partidos que tengan las MISMAS fechas que el de referencia
              const partidosEnFecha = todosMisPartidos.filter(m =>
                m.playoff_id === po.id &&
                m.start_date === partidoReferencia.start_date &&
                m.end_date === partidoReferencia.end_date &&
                m.local_id !== null &&
                m.visitante_id !== null
              );

              // 4. Los añadimos al listado temporal con el nombre del torneo
              const conNombre = partidosEnFecha.map(m => ({
                ...m,
                playoff_name: po.name,
                playoff_limit_ga: po.limit_ga_enabled,
                playoff_max_ga: po.max_ga_playoff
              }));

              playoffTemp = [...playoffTemp, ...conNombre];
            }
          });

          // Ordenamos por round para que si hay Ida y Vuelta, aparezcan en orden
          playoffTemp.sort((a, b) => a.round.localeCompare(b.round));
        }
      }

      setPartidosLiga(ligaTemp);
      setPartidosPlayoff(playoffTemp);
      // --- FIN DE TU CÓDIGO ORIGINAL ---

      // --- ACTUALIZAR LA CACHÉ CON LOS RESULTADOS ---
      cacheProximoPartido = {
        userId: profile.id,
        timestamp: Date.now(),
        data: {
          aviso: avisoData,
          encuestas: encData || [],
          votosPropios: mapaVotos || {},
          reglas: rulesData || reglas,
          liga: ligaTemp,
          playoff: playoffTemp
        }
      };

    } catch (error) {
      console.error("Error en carga:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    cargar();
  }, [profile, config])

  if (loading) return <div style={{ fontSize: '0.8rem', color: '#95a5a6' }}>Cargando partidos...</div>

  const todosLosPartidos = [...partidosPlayoff, ...partidosLiga];

  const votar = async (encuestaId, opcionIndex) => {
    try {
      const { error } = await supabase
        .from('votos_encuesta')
        .upsert(
          {
            encuesta_id: encuestaId,
            usuario_id: profile.id,
            opcion_index: opcionIndex
          },
          { onConflict: 'encuesta_id, usuario_id' }
        );

      if (error) throw error;

      setVotosPropios(prev => ({ ...prev, [encuestaId]: opcionIndex }));
    } catch (error) {
      console.error("Error completo:", error);
      alert("Error al guardar el voto: " + error.message);
    }
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>

      {/* SECCIÓN DE AVISO */}
      {aviso && (
        <div style={{
          background: '#fff3cd',
          border: '1px solid #ffeeba',
          padding: '20px',
          borderRadius: '12px',
          color: '#856404',
          boxShadow: '0 2px 5px rgba(0,0,0,0.05)'
        }}>
          <h2 style={{ margin: '0 0 10px 0', fontSize: '1.4rem', color: '#664d03' }}>
            {aviso.titulo}
          </h2>
          <div style={{ margin: 0, fontSize: '1rem', lineHeight: '1.4' }}>
            <ReactMarkdown>{aviso.contenido}</ReactMarkdown>
          </div>
        </div>
      )}

      {/* SECCIÓN DE ENCUESTAS */}
      {encuestas.map(enc => (
        <div key={enc.id} style={{
          background: '#ffffff',
          border: '1px solid #e1e8ed',
          padding: '15px',
          borderRadius: '12px',
          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
        }}>
          <h3 style={{ margin: '0 0 12px 0', fontSize: '1.1rem', color: '#2c3e50', display: 'flex', alignItems: 'center', gap: '8px' }}>
            📊 {enc.pregunta}
          </h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {enc.opciones.map((opcion, idx) => {
              const estaSeleccionado = votosPropios[enc.id] === idx;
              return (
                <button
                  key={idx}
                  onClick={() => votar(enc.id, idx)}
                  style={{
                    padding: '12px',
                    borderRadius: '8px',
                    border: estaSeleccionado ? '2px solid #3498db' : '1px solid #ced4da',
                    background: estaSeleccionado ? '#ebf5ff' : 'white',
                    color: estaSeleccionado ? '#2980b9' : '#495057',
                    fontWeight: estaSeleccionado ? 'bold' : 'normal',
                    cursor: 'pointer',
                    textAlign: 'left',
                    transition: 'all 0.2s ease',
                    fontSize: '0.9rem'
                  }}
                >
                  <span style={{ marginRight: '8px' }}>{estaSeleccionado ? '✅' : '⚪'}</span>
                  {opcion}
                </button>
              );
            })}
          </div>
          {votosPropios[enc.id] !== undefined && (
            <p style={{ fontSize: '0.7rem', color: '#95a5a6', marginTop: '10px', textAlign: 'center', fontStyle: 'italic' }}>
              Voto registrado. Puedes cambiarlo pulsando otra opción.
            </p>
          )}
        </div>
      ))}

      {/* PARTIDOS DE TORNEOS EXTRA (Liguillas/Playoffs Extra) */}
      <PartidoExtraPlayoff
        profile={profile}
        config={config}
        renderTarjeta={(p, refresh) => (
          <TarjetaResultado
            key={`extra-${p.id}`}
            userId={profile.id}
            partido={p}
            onUpdated={() => { cargar(true); refresh(); }}
            limitGaEnabled={false} // Ajustar si los extra tienen límites
          />
        )}
      />

      {/* PARTIDOS DE PROMOCIÓN */}
      <PartidoPromo
        profile={profile}
        config={config}
        renderTarjeta={(p) => (
          <TarjetaResultado
            key={`promo-${p.id}`}
            userId={profile.id}
            partido={p}
            onUpdated={() => cargar(true)}
            limitGaEnabled={false} // Normalmente las promos no tienen límite, o puedes pasar reglas.limit_ga_enabled
          />
        )}
      />


      {todosLosPartidos.length === 0 ? (
        <div style={{ color: '#95a5a6', fontSize: '0.8rem', textAlign: 'center', padding: '20px' }}>
          No tienes partidos de Liga ni Playoff para esta semana.
        </div>
      ) : (
        todosLosPartidos.map(p => (
          <TarjetaResultado
            key={p.playoff_id ? `po-${p.id}` : `li-${p.id}`}
            partido={p}
            userId={profile.id}
            onUpdated={() => cargar(true)}
            // Pasamos los datos del nuevo estado 'reglas'
            limitGaEnabled={reglas.limit_ga_enabled}
            maxGaLeague={reglas.max_ga_league}
          />
        ))
      )}
    </div>
  )
}

export default ProximoPartido;