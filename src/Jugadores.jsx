import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

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

// --- COMPONENTE PARA EL ZOOM DEL AVATAR ---
const AvatarConZoom = ({ url, nick }) => {
  const [isTouched, setIsTouched] = useState(false);

  return (
    <div
      onTouchStart={() => setIsTouched(true)}
      onTouchEnd={() => setIsTouched(false)}
      onMouseEnter={e => {
        e.currentTarget.style.transform = 'scale(3)';
        e.currentTarget.style.zIndex = '100';
        e.currentTarget.style.boxShadow = '0 10px 20px rgba(0,0,0,0.2)';
      }}
      onMouseLeave={e => {
        e.currentTarget.style.transform = 'scale(1)';
        e.currentTarget.style.zIndex = '1';
        e.currentTarget.style.boxShadow = '0 2px 4px rgba(0,0,0,0.05)';
      }}
      style={{
        width: '40px', height: '40px', borderRadius: '50%', overflow: 'hidden',
        background: '#eee', border: '2px solid #fff',
        boxShadow: '0 2px 4px rgba(0,0,0,0.05)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0, cursor: 'pointer', transition: 'all 0.25s ease-out',
        position: 'relative', zIndex: isTouched ? 100 : 1,
        transform: isTouched ? 'scale(3)' : 'scale(1)'
      }}
    >
      {url ? (
        <img src={url} alt={nick} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      ) : (
        <span style={{ fontSize: '1.2rem', color: '#bdc3c7' }}>👤</span>
      )}
    </div>
  );
};

// --- SELECTOR UNIFICADO: DIVISIONES + PLAYOFFS ---
function CategorySelector({ current, onChange, season }) {
  const [categories, setCategories] = useState([])

  useEffect(() => {
    async function load() {
      if (!season) return;

      const allCategories = await getOrFetch(`jugadores_cats_${season}`, async () => {
        const [divRes, poRes, poExtraRes] = await Promise.all([
          supabase.from('matches').select('division').eq('season', season),
          supabase.from('playoffs').select('id, name').eq('season', season),
          supabase.from('playoffs_extra').select('id, nombre').eq('season_id', season)
        ]);

        const uniqueDivs = divRes.data
          ? [...new Set(divRes.data.map(d => d.division))].sort((a, b) => a - b)
          : [];
        const formattedPlayoffs = poRes.data
          ? poRes.data.map(p => ({ id: p.id, label: p.name.toUpperCase(), type: 'po' }))
          : [];
        const formattedExtra = poExtraRes.data
          ? poExtraRes.data.map(p => ({ id: p.id, label: (p.nombre || 'PLAYOFF').toUpperCase(), type: 'extra' }))
          : [];

        return [
          ...uniqueDivs.map(d => ({ id: d, label: `DIV ${d}`, type: 'div' })),
          ...formattedPlayoffs,
          ...formattedExtra
        ];
      });

      setCategories(allCategories);

      // Si el actual no existe en la lista, poner el primero por defecto
      if (allCategories.length > 0 && !allCategories.find(c => c.id === current)) {
        onChange(allCategories[0].id);
      }
    }
    load()
  }, [season])

  if (categories.length <= 1 && categories[0]?.type === 'div') return null;

  return (
    <div style={{ display: 'flex', gap: '5px', marginBottom: '15px', flexWrap: 'wrap' }}>
      {categories.map(cat => (
        <button key={cat.id} onClick={() => onChange(cat.id)} style={{
          padding: '6px 12px', borderRadius: '15px', border: 'none',
          background: current === cat.id ? (cat.type === 'div' ? '#3498db' : '#34495e') : '#ecf0f1',
          color: current === cat.id ? 'white' : '#7f8c8d', fontSize: '0.75rem', fontWeight: 'bold', cursor: 'pointer'
        }}> {cat.label} </button>
      ))}
    </div>
  )
}

export default function Jugadores({ config }) {
  const [usuarios, setUsuarios] = useState([])
  const [filtro, setFiltro] = useState('')
  const [catActiva, setCatActiva] = useState(1)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchJugadores() {
      setLoading(true)
      let ids = []

      if (typeof catActiva === 'number') {
        // Lógica para Divisiones
        const matches = await getOrFetch(`jugadores_matches_${config.current_season}_${catActiva}`, async () => {
          const { data } = await supabase
            .from('matches')
            .select('home_team, away_team')
            .eq('season', config.current_season)
            .eq('division', catActiva);
          return data || [];
        });
        ids = matches.flatMap(m => [m.home_team, m.away_team]);
      } else {
        // Lógica para Playoffs normales
        const poMatches = await getOrFetch(`jugadores_po_${catActiva}`, async () => {
          const { data } = await supabase
            .from('playoff_matches')
            .select('home_team, away_team')
            .eq('playoff_id', catActiva);
          return data || [];
        });

        if (poMatches.length > 0) {
          ids = poMatches.flatMap(m => [m.home_team, m.away_team]);
        } else {
          // CASO 3: PLAYOFFS EXTRA
          const extraMatches = await getOrFetch(`jugadores_extra_${catActiva}`, async () => {
            const { data } = await supabase
              .from('extra_matches')
              .select('player1_id, player2_id')
              .eq('extra_id', catActiva);
            return data || [];
          });
          ids = extraMatches.flatMap(m => [m.player1_id, m.player2_id]);
        }
      }

      // Limpiar IDs (quitar nulos/TBD/duplicados)
      const cleanIds = [...new Set(ids)].filter(id => id !== null);

      if (cleanIds.length > 0) {
        // Cacheamos los perfiles por la lista de IDs (usando la categoría como clave)
        const profiles = await getOrFetch(`jugadores_profiles_${catActiva}`, async () => {
          const { data } = await supabase
            .from('profiles')
            .select('nick, telegram_user, phone, avatar_url, eafc_user')
            .in('id', cleanIds)
            .order('nick', { ascending: true });
          return data || [];
        });
        setUsuarios(profiles);
      } else {
        setUsuarios([]);
      }
      setLoading(false)
    }
    if (config?.current_season) fetchJugadores()
  }, [config, catActiva])

  const usuariosFiltrados = usuarios.filter(u => {
    const coincideTexto = u.nick?.toLowerCase().includes(filtro.toLowerCase());
    const esRetirado = u.nick?.toLowerCase().startsWith("retirado");
    return coincideTexto && !esRetirado;
  });

  const abrirTelegram = (u) => {
    const cleanUser = u.telegram_user.replace('@', '');
    window.open(`https://t.me/${cleanUser}`, '_blank');
  };

  const abrirWhatsApp = (u) => {
    const cleanPhone = u.phone.replace(/\D/g, '');
    window.open(`https://wa.me/${cleanPhone}`, '_blank');
  };

  return (
    <div>
      <h3 style={{ marginTop: 0, color: '#2c3e50', fontSize: '1.1rem' }}>Directorio de Jugadores</h3>

      <CategorySelector
        season={config?.current_season}
        current={catActiva}
        onChange={setCatActiva}
      />

      <input
        type="text"
        placeholder="Buscar por nick..."
        value={filtro}
        onChange={(e) => setFiltro(e.target.value)}
        style={{
          width: '100%', padding: '10px', borderRadius: '8px',
          border: '1px solid #ddd', marginBottom: '15px', fontSize: '0.9rem'
        }}
      />

      {loading ? (
        <p style={{ color: '#95a5a6', fontSize: '0.8rem' }}>Cargando jugadores...</p>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          {usuariosFiltrados.map((u, i) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '8px 12px', background: '#f8f9fa', borderRadius: '10px', border: '1px solid #eee'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <AvatarConZoom url={u.avatar_url} nick={u.nick} />
                <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                  <span style={{
                    fontWeight: 'bold', color: '#2c3e50', fontSize: '0.9rem', lineHeight: '1.1'
                  }}>
                    {u.nick}
                  </span>
                  {u.eafc_user && (
                    <span style={{
                      fontSize: '0.65rem', color: '#7f8c8d', fontWeight: 'normal', marginTop: '2px'
                    }}>
                      ID: {u.eafc_user}
                    </span>
                  )}
                </div>
              </div>

              <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                {u.telegram_user && (
                  <button
                    onClick={() => abrirTelegram(u)}
                    style={{
                      background: '#0088cc', color: 'white', border: 'none',
                      borderRadius: '12px', padding: '0 10px', height: '32px',
                      cursor: 'pointer', fontSize: '0.7rem', fontWeight: 'bold'
                    }}
                  >
                    <span>✈</span> Telegram
                  </button>
                )}
                {u.phone && (
                  <button
                    onClick={() => abrirWhatsApp(u)}
                    style={{
                      background: '#25D366', color: 'white', border: 'none',
                      borderRadius: '12px', padding: '0 10px', height: '32px',
                      cursor: 'pointer', fontSize: '0.7rem', fontWeight: 'bold'
                    }}
                  >
                    <span>📞</span> Whatsapp
                  </button>
                )}
              </div>
            </div>
          ))}
          {usuariosFiltrados.length === 0 && (
            <p style={{ textAlign: 'center', color: '#95a5a6', fontSize: '0.8rem' }}>No se han encontrado jugadores.</p>
          )}
        </div>
      )}
    </div>
  )
}
