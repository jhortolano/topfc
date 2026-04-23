import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

// --- HELPER DE CACHÉ ---
// Busca en sessionStorage; si no existe, ejecuta fetchFn, guarda y devuelve el resultado.
// sessionStorage se borra al cerrar/recargar la pestaña, por lo que los datos
// siempre se refrescan en la siguiente visita.
/*
const getOrFetch = async (key, fetchFn) => {
  try {
    const cached = sessionStorage.getItem(key);
    if (cached) return JSON.parse(cached);
  } catch (_) {
    // Si sessionStorage falla (modo privado, cuota llena) simplemente ignoramos el caché
  }
  const data = await fetchFn();
  try {
    sessionStorage.setItem(key, JSON.stringify(data));
  } catch (_) {}
  return data;
};
*/

// --- HELPER DE CACHÉ EN MEMORIA ---
// Al usar window.apiCache, los datos persisten mientras te mueves por la app,
// pero desaparecen completamente al pulsar F5 o recargar.
const getOrFetch = async (key, fetchFn) => {
  if (!window.apiCache) {
    window.apiCache = {};
  }

  if (window.apiCache[key]) {
    return window.apiCache[key];
  }

  const data = await fetchFn();
  window.apiCache[key] = data;
  return data;
};

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
  const [userNick, setUserNick] = useState(null);

  useEffect(() => {
    async function fetchAllExtraData() {
      if (!season) return;
      setLoading(true);
      try {
        // Cacheamos liguilla y eliminatorias juntas por extraId
        const { liguilla, eliminatorias } = await getOrFetch(`cal_extra_${extraId}`, async () => {
          const [ligRes, elimRes] = await Promise.all([
            supabase
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
              .eq('extra_groups.extra_id', extraId),
            supabase
              .from('extra_playoffs_matches')
              .select(`
                id, score1, score2, is_played, stream_url, numero_jornada, numero_jornada,
                local:player1_id(nick, avatar_url),
                visitante:player2_id(nick, avatar_url),
                torneo:playoffs_extra!inner(season_id, config_fechas)
              `)
              .eq('torneo.season_id', season)
              .eq('torneo.id', extraId)
          ]);
          return {
            liguilla: ligRes.data || [],
            eliminatorias: elimRes.data || []
          };
        });

        const config = liguilla?.[0]?.extra_groups?.playoffs_extra?.config_fechas ||
          eliminatorias?.[0]?.torneo?.config_fechas || {};
        setFechasConfig(config);

        const hoy = new Date();
        const rondasQueDeberianEstarActivas = Object.entries(config)
          .filter(([_, rango]) => {
            if (!rango.start_at || !rango.end_at) return false;
            const inicio = new Date(rango.start_at);
            const fin = new Date(rango.end_at);
            return hoy >= inicio && hoy <= fin;
          })
          .map(([nombreRonda]) => nombreRonda);

        setRondasActivas(rondasQueDeberianEstarActivas);

        // Normalización
        const normalizadosLiguilla = liguilla.map(m => ({
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
          fase_id: `j${m.numero_jornada}`
        }));

        const normalizadosEliminatorias = eliminatorias.map(m => ({
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
          const ordenFases = ['dieciseisavos', 'octavos', 'cuartos', 'semis', 'final'];
          const faseA = a.fase_id.toString().toLowerCase();
          const faseB = b.fase_id.toString().toLowerCase();
          const pesoA = ordenFases.findIndex(f => faseA.includes(f));
          const pesoB = ordenFases.findIndex(f => faseB.includes(f));
          if (pesoA !== pesoB) return pesoA - pesoB;
          const esIdaA = faseA.includes('ida');
          const esIdaB = faseB.includes('ida');
          if (esIdaA && !esIdaB) return -1;
          if (!esIdaA && esIdaB) return 1;
          if (a.jornada === b.jornada) return a.grupo_nombre.localeCompare(b.grupo_nombre);
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

  useEffect(() => {
    async function getMyNick() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data } = await supabase
          .from('profiles')
          .select('nick')
          .eq('id', user.id)
          .single();
        if (data) setUserNick(data.nick);
      }
    }
    getMyNick();
  }, [supabase.auth]);

  // Obtenemos los IDs de fase únicos presentes en los partidos
  const fasesUnicas = [...new Set(partidos.map(p => p.fase_id))];

  // Función 100% dinámica: busca la llave en el JSON y usa su label
  const getInfoJornada = (faseId) => {
    const llaveNormalizada = faseId.toString().toLowerCase().replace(/\s+/g, '_');
    const info = fechasConfig[llaveNormalizada] || {};
    const labelLabel = info.label || faseId.toString().toUpperCase();
    return { label: labelLabel, ...info };
  };

  const formatearFecha = (f) => f ? new Date(f).toLocaleDateString('es-ES') : '';

  if (loading || partidos.length === 0) return null;

  return (
    <div style={{ marginTop: '25px', padding: '15px', background: '#fffcf9', borderRadius: '12px', border: '1px solid #ffe8cc' }}>

      {/* Mapeamos directamente las llaves del JSON para respetar su orden */}
      {Object.keys(fechasConfig)
        .sort((a, b) => {
          const ordenLógico = ['j1', 'j2', 'j3', 'j4', 'j5', 'j6', 'j7', 'j8', 'j9', 'j10', 'dieciseis', 'dieciseis_ida', 'dieciseis_vuelta', 'octavos', 'octavos_ida', 'octavos_vuelta', 'cuartos', 'cuartos_ida', 'cuartos_vuelta', 'semis', 'semis_ida', 'semis_vuelta', 'final', 'final_ida', 'final_vuelta'];
          const indexA = ordenLógico.findIndex(item => a.startsWith(item) || a === item);
          const indexB = ordenLógico.findIndex(item => b.startsWith(item) || b === item);
          return (indexA === -1 ? 99 : indexA) - (indexB === -1 ? 99 : indexB);
        })
        .map(keyDelJson => {
          const partidosDeFase = partidos.filter(p =>
            p.fase_id.toString().toLowerCase().replace(/\s+/g, '_') === keyDelJson
          );

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
                const esMiPartido = userNick && (p.local_nick === userNick || p.visitante_nick === userNick);
                const localEsTBD = !p.local_nick || p.local_nick === 'TBD';
                const visitanteEsTBD = !p.visitante_nick || p.visitante_nick === 'TBD';
                const localEsBye = localEsTBD && !visitanteEsTBD && p.is_played;
                const visitanteEsBye = visitanteEsTBD && !localEsTBD && p.is_played;
                const esBye = localEsBye || visitanteEsBye;

                return (
                  <div key={p.id} style={{
                    display: 'flex',
                    alignItems: 'center',
                    padding: '10px',
                    fontSize: '0.75rem',
                    gap: '8px',
                    borderBottom: '1px solid #fffaf5',
                    background: esBye ? '#f9f9f9' : (esMiPartido ? 'rgba(204, 128, 46, 0.03)' : 'transparent'),
                    borderLeft: esMiPartido ? '4px solid #d35400' : '4px solid transparent',
                    transition: 'all 0.3s ease'
                  }}>
                    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: '8px', textAlign: 'right', fontWeight: esMiPartido ? 'bold' : 'normal' }}>
                      <span style={{ fontSize: '0.55rem', color: '#999' }}>({p.grupo_nombre})</span>
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

                    <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'flex-start', gap: '8px', textAlign: 'left', fontWeight: esMiPartido ? 'bold' : 'normal' }}>
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
