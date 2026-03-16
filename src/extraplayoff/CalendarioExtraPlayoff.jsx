import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

// --- COMPONENTE AVATAR ---
const AvatarConZoom = ({ url }) => {
  const [isTouched, setIsTouched] = useState(false);
  return (
    <div
      onTouchStart={() => setIsTouched(true)}
      onTouchEnd={() => setIsTouched(false)}
      onMouseEnter={e => {
        e.currentTarget.style.transform = 'scale(2.8)';
        e.currentTarget.style.zIndex = '100';
      }}
      onMouseLeave={e => {
        e.currentTarget.style.transform = 'scale(1)';
        e.currentTarget.style.zIndex = '1';
      }}
      style={{
        width: '24px', height: '24px', borderRadius: '50%',
        overflow: 'hidden', background: '#eee', border: '1px solid #ddd',
        flexShrink: 0, cursor: 'pointer', transition: 'transform 0.2s ease-in-out',
        position: 'relative', zIndex: isTouched ? 100 : 1,
        transform: isTouched ? 'scale(2.8)' : 'scale(1)'
      }}
    >
      {url ? (
        <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} alt="avatar" />
      ) : (
        <div style={{ fontSize: '0.6rem', color: '#bdc3c7', textAlign: 'center', lineHeight: '24px' }}>👤</div>
      )}
    </div>
  );
};

export default function CalendarioExtraPlayoff({ season, extraId }) {
  const [partidos, setPartidos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [jornadaActual, setJornadaActual] = useState(null);
  const [fechasConfig, setFechasConfig] = useState({});
  const [rondasActivas, setRondasActivas] = useState([]);

  useEffect(() => {
    async function fetchAllExtraData() {
      if (!season) return;
      setLoading(true);
      try {
        // 1. LIGUILLA
        const { data: liguilla, error: errL } = await supabase
          .from('extra_matches')
          .select(`
            id, score1, score2, is_played, stream_url, numero_jornada,
            local:player1_id(nick, avatar_url),
            visitante:player2_id(nick, avatar_url),
            extra_groups!inner(
              nombre_grupo,
              playoffs_extra!inner(season_id, config_fechas)
            )
          `)
          .eq('extra_groups.extra_id', extraId);

        if (errL) console.error("Error Liguilla:", errL);

        // 2. ELIMINATORIAS 
        const { data: eliminatorias, error: errE } = await supabase
          .from('extra_playoffs_matches')
          .select(`
            id, score1, score2, is_played, stream_url, numero_jornada, numero_jornada,
            local:player1_id(nick, avatar_url),
            visitante:player2_id(nick, avatar_url),
            torneo:playoffs_extra!inner(season_id, config_fechas)
          `)
          .eq('torneo.season_id', season)
          .eq('torneo.id', extraId);

        if (errE) console.error("Error Eliminatorias:", errE);

        const config = liguilla?.[0]?.extra_groups?.playoffs_extra?.config_fechas ||
          eliminatorias?.[0]?.torneo?.config_fechas || {};
        setFechasConfig(config);

        // 1. Buscamos qué fechas están configuradas como "Actuales" en tu JSON
        // Suponiendo que tienes una entrada en el JSON o una lógica para obtener el rango de esta semana:
        const hoy = new Date();

        const rondasQueDeberianEstarActivas = Object.entries(config)
          .filter(([_, rango]) => {
            if (!rango.start_at || !rango.end_at) return false;
            const inicio = new Date(rango.start_at);
            const fin = new Date(rango.end_at);
            // Comprueba si "hoy" está entre el inicio y el fin
            return hoy >= inicio && hoy <= fin;
          })
          .map(([nombreRonda]) => nombreRonda);

        setRondasActivas(rondasQueDeberianEstarActivas); // Necesitarás un useState para esto

        // 3. Normalización sin lógica de números fijos
        const normalizadosLiguilla = (liguilla || []).map(m => ({
          id: m.id,
          local_nick: m.local?.nick,
          local_avatar: m.local?.avatar_url,
          visitante_nick: m.visitante?.nick,
          visitante_avatar: m.visitante?.avatar_url,
          home_score: m.score1,
          away_score: m.score2,
          is_played: m.is_played,
          stream_url: m.stream_url,
          grupo_nombre: m.extra_groups?.nombre_grupo || 'Liguilla',
          jornada: m.numero_jornada,
          fase_id: `j${m.numero_jornada}` // Identificador de fase basado en el JSON
        }));

        const normalizadosEliminatorias = (eliminatorias || []).map(m => ({
          id: m.id,
          local_nick: m.local?.nick,
          local_avatar: m.local?.avatar_url,
          visitante_nick: m.visitante?.nick,
          visitante_avatar: m.visitante?.avatar_url,
          home_score: m.score1,
          away_score: m.score2,
          is_played: m.is_played,
          stream_url: m.stream_url,
          grupo_nombre: 'PLAYOFF',
          jornada: m.numero_jornada,
          fase_id: m.numero_jornada
        }));

        const todos = [...normalizadosLiguilla, ...normalizadosEliminatorias].sort((a, b) => {
          // 1. Definimos el orden de importancia (de primero a último)
          const ordenFases = [
            'dieciseisavos',
            'octavos',
            'cuartos',
            'semis',
            'final'
          ];

          const faseA = a.fase_id.toString().toLowerCase();
          const faseB = b.fase_id.toString().toLowerCase();

          // 2. Buscamos en qué posición está cada palabra (ej: octavos = 1, cuartos = 2)
          const pesoA = ordenFases.findIndex(f => faseA.includes(f));
          const pesoB = ordenFases.findIndex(f => faseB.includes(f));

          // 3. Si las fases son distintas (ej: Octavos vs Cuartos), ordenamos por el peso
          if (pesoA !== pesoB) {
            return pesoA - pesoB;
          }

          // 4. Si es la misma fase (ej: Octavos Ida vs Octavos Vuelta), buscamos "ida"
          const esIdaA = faseA.includes('ida');
          const esIdaB = faseB.includes('ida');

          if (esIdaA && !esIdaB) return -1; // Ida va antes
          if (!esIdaA && esIdaB) return 1;  // Vuelta va después

          // 5. Si es Liguilla (misma jornada), ordenamos por NOMBRE DE GRUPO
          if (a.jornada === b.jornada) {
            // localeCompare hace que "Grupo A" vaya antes que "Grupo B"
            return a.grupo_nombre.localeCompare(b.grupo_nombre);
          }

          // 6. Si no es nada de lo anterior (Liguilla), usamos la jornada
          return a.jornada - b.jornada;
        });
        const actual = todos.find(p => !p.is_played)?.jornada || todos[todos.length - 1]?.jornada;

        setPartidos(todos);
        setJornadaActual(actual);
      } catch (err) {
        console.error("Error general:", err);
      } finally {
        setLoading(false);
      }
    }

    fetchAllExtraData();
  }, [season, extraId]);

  // Obtenemos los IDs de fase únicos presentes en los partidos
  const fasesUnicas = [...new Set(partidos.map(p => p.fase_id))];

  // Función 100% dinámica: busca la llave en el JSON y usa su label
  const getInfoJornada = (faseId) => {
    // 1. Normalizamos el ID: "CUARTOS IDA" -> "cuartos_ida"
    // Esto hace que coincida exactamente con las llaves de tu fechasConfig
    const llaveNormalizada = faseId.toString().toLowerCase().replace(/\s+/g, '_');

    // 2. Buscamos en el JSON usando la llave normalizada
    const info = fechasConfig[llaveNormalizada] || {};

    // 3. Generamos el label (Prioridad: label del JSON > Texto original de la DB)
    const labelLabel = info.label || faseId.toString().toUpperCase();

    return {
      label: labelLabel,
      ...info
    };
  };

  const formatearFecha = (f) => f ? new Date(f).toLocaleDateString('es-ES') : '';

  if (loading || partidos.length === 0) return null;

  return (
    <div style={{ marginTop: '25px', padding: '15px', background: '#fffcf9', borderRadius: '12px', border: '1px solid #ffe8cc' }}>
      <h3 style={{ fontSize: '0.85rem', color: '#d35400', marginBottom: '12px', fontWeight: '800', textAlign: 'center' }}>
        🏆 EXTRA PLAY-OFF T{season}
      </h3>

      {/* Mapeamos directamente las llaves del JSON para respetar su orden */}
      {Object.keys(fechasConfig)
        .sort((a, b) => {
          const ordenLógico = ['j1', 'j2', 'j3', 'j4', 'j5', 'j6', 'j7', 'j8', 'j9', 'j10', 'dieciseis', 'octavos', 'cuartos_ida', 'cuartos_vuelta', 'semis', 'final'];

          // Obtenemos el índice del orden lógico (si no existe, lo manda al final)
          const indexA = ordenLógico.findIndex(item => a.startsWith(item) || a === item);
          const indexB = ordenLógico.findIndex(item => b.startsWith(item) || b === item);

          return (indexA === -1 ? 99 : indexA) - (indexB === -1 ? 99 : indexB);
        })
        .map(keyDelJson => {
          // Buscamos si hay partidos que coincidan con esta llave del JSON
          // Normalizamos el fase_id del partido para comparar (ej: "CUARTOS IDA" -> "cuartos_ida")
          const partidosDeFase = partidos.filter(p =>
            p.fase_id.toString().toLowerCase().replace(/\s+/g, '_') === keyDelJson
          );

          // Si no hay partidos cargados para esta fase del calendario, no pintamos nada
          if (partidosDeFase.length === 0) return null;

          const info = getInfoJornada(keyDelJson);
          const esActual = rondasActivas.includes(keyDelJson);
          const rangoFechas = info.start_at ? `del ${formatearFecha(info.start_at)} al ${formatearFecha(info.end_at)}` : '';

          return (
            <div key={keyDelJson} style={{ marginBottom: '15px', background: 'white', borderRadius: '8px', border: esActual ? '2px solid #d35400' : '1px solid #fce5cd', overflow: 'hidden' }}>
              <div style={{
                background: esActual ? '#d35400' : '#fff7ed',
                color: esActual ? 'white' : '#d35400',
                padding: '8px 12px',
                fontSize: '0.7rem',
                fontWeight: 'bold',
                display: 'flex',
                flexDirection: 'column',
                gap: '2px'
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <span>{info.label}</span>
                  {esActual && <span style={{ fontSize: '0.6rem', background: 'rgba(255,255,255,0.2)', padding: '2px 6px', borderRadius: '4px' }}>ACTUAL</span>}
                </div>
                {rangoFechas && <span style={{ fontSize: '0.6rem', opacity: 0.9, fontWeight: 'normal' }}>{rangoFechas}</span>}
              </div>

              {partidosDeFase.map(p => {
                // 1. Identificamos si son TBD o nulos
                const localEsTBD = !p.local_nick || p.local_nick === 'TBD';
                const visitanteEsTBD = !p.visitante_nick || p.visitante_nick === 'TBD';

                // 2. Un "BYE" (Pase Directo) SOLO ocurre si uno es TBD y el otro NO
                // Si ambos son TBD, es un partido pendiente de definir (TBD vs TBD)
                const localEsBye = localEsTBD && !visitanteEsTBD;
                const visitanteEsBye = visitanteEsTBD && !localEsTBD;
                const esBye = localEsBye || visitanteEsBye;

                // 2. Ahora sí, retornamos el diseño usando esas variables
                return (
                  <div key={p.id} style={{
                    display: 'flex',
                    alignItems: 'center',
                    padding: '10px',
                    fontSize: '0.75rem',
                    gap: '8px',
                    borderBottom: '1px solid #fffaf5',
                    background: esBye ? '#f9f9f9' : 'transparent' // Fondo gris si es BYE
                  }}>
                    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '8px', textAlign: 'right' }}>
                      <span style={{ fontSize: '0.55rem', color: '#999' }}>({p.grupo_nombre})</span>

                      {/* Usamos las variables para el texto y color */}
                      <span style={{ color: localEsBye ? '#94a3b8' : 'inherit', fontStyle: localEsBye ? 'italic' : 'normal' }}>
                        {localEsBye ? 'Pase Directo' : p.local_nick}
                      </span>

                      <AvatarConZoom url={p.local_avatar} />
                    </div>

                    <div style={{
                      width: '40px',
                      textAlign: 'center',
                      fontWeight: 'bold',
                      color: esBye ? '#cbd5e1' : '#e67e22',
                      background: esBye ? '#f1f5f9' : '#fff4e6',
                      borderRadius: '4px'
                    }}>
                      {p.is_played && !esBye ? `${p.home_score}-${p.away_score}` : (esBye ? '-' : 'vs')}
                    </div>

                    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-start', gap: '8px', textAlign: 'left' }}>
                      <AvatarConZoom url={p.visitante_avatar} />

                      <span style={{ color: visitanteEsBye ? '#94a3b8' : 'inherit', fontStyle: visitanteEsBye ? 'italic' : 'normal' }}>
                        {visitanteEsBye ? 'Pase Directo' : p.visitante_nick}
                      </span>
                    </div>

                    <div style={{ width: '20px', textAlign: 'center' }}>
                      {p.stream_url && !esBye && (
                        <a href={p.stream_url} target="_blank" rel="noreferrer" style={{ textDecoration: 'none' }}>📺</a>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          );
        })}
    </div>
  );
}