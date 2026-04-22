import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import ClasificacionExtraPlayoff from './extraplayoff/ClasificacionExtraPlayoff'
import ClasificacionPromo from './utils/ClasificacionPromo';

// --- HELPER DE CACHÉ ---
// Busca en sessionStorage; si no existe, ejecuta fetchFn, guarda y devuelve el resultado.
// sessionStorage se borra al cerrar/recargar la pestaña, por lo que los datos
// siempre se refrescan en la siguiente visita. Perfecto para datos que cambian raramente.
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

const fetchDatosExtraParaStats = async (temporadaId) => {
  return getOrFetch(`extra_${temporadaId}`, async () => {
    // Cargamos todo en paralelo para máxima velocidad
    const [extras, liguilla, elims] = await Promise.all([
      supabase.from('playoffs_extra').select('id, stream_puntos').eq('season_id', temporadaId),
      supabase.from('extra_matches').select('extra_id, player1_id, player2_id, stream_url'),
      supabase.from('extra_playoffs_matches').select('playoff_extra_id, player1_id, player2_id, stream_url')
    ]);

    return {
      extras: extras.data || [],
      liguilla: liguilla.data || [],
      elims: elims.data || []
    };
  });
};

// --- COMPONENTE AVATAR REUTILIZADO CON ZOOM ---
const Avatar = ({ url, size = '30px' }) => {
  // Creamos un ID único para el efecto de escala en dispositivos móviles
  const [isTouched, setIsTouched] = useState(false);

  return (
    <div
      // Eventos para móvil (opcional, para forzar el estado si el CSS no basta)
      onTouchStart={() => setIsTouched(true)}
      onTouchEnd={() => setIsTouched(false)}
      style={{
        width: size,
        height: size,
        borderRadius: '50%',
        background: '#34495e',
        border: '2px solid #2ecc71',
        flexShrink: 0,
        cursor: 'pointer',
        transition: 'transform 0.2s ease-in-out, z-index 0.1s', // Animación suave
        position: 'relative',
        zIndex: isTouched ? 100 : 1, // Se pone al frente al tocarlo
        transform: isTouched ? 'scale(2.5)' : 'scale(1)', // Escala en móvil
        overflow: 'hidden' // Mantiene la imagen circular
      }}
      // Efecto para PC (Hover)
      onMouseEnter={e => {
        e.currentTarget.style.transform = 'scale(2.5)';
        e.currentTarget.style.zIndex = '100';
      }}
      onMouseLeave={e => {
        e.currentTarget.style.transform = 'scale(1)';
        e.currentTarget.style.zIndex = '1';
      }}
    >
      {url ? (
        <img
          src={url}
          style={{ width: '100%', height: '100%', objectFit: 'cover' }}
          alt="avatar"
        />
      ) : (
        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          height: '100%', fontSize: '0.7rem', color: '#7f8c8d'
        }}>👤</div>
      )}
    </div>
  );
};

const StreamIcon = ({ url }) => {
  if (!url || !url.startsWith('http')) return null;

  return (
    <a
      href={url}
      target="_blank"
      rel="noopener noreferrer"
      style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        background: '#9b59b6', color: 'white', borderRadius: '4px',
        padding: '2px 4px', fontSize: '0.6rem', textDecoration: 'none',
        transition: 'transform 0.2s', marginLeft: '6px', cursor: 'pointer',
        lineHeight: '1'
      }}
      onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.2)'}
      onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
      title="Ver retransmisión"
    >
      📺
    </a>
  );
};

// --- SELECTORES ---
function CategorySelector({ current, onChange, season }) {
  const [categories, setCategories] = useState([]);
  const [activeTab, setActiveTab] = useState('div');

  // --- NUEVO: Memoria por pestaña ---
  const [lastSelected, setLastSelected] = useState({
    div: null,
    po: null
  });

  useEffect(() => {
    async function load() {
      if (!season) return;

      const all = await getOrFetch(`cats_${season}`, async () => {
        const [divRes, poRes, extraRes, promoRes] = await Promise.all([
          supabase.from('matches').select('division').eq('season', season),
          supabase.from('playoffs').select('id, name').eq('season', season),
          supabase.from('playoffs_extra').select('id, nombre').eq('season_id', season),
          supabase.from('promo_matches').select('id').eq('season', season).limit(1)
        ]);

        const uniqueDivs = divRes.data
          ? [...new Set(divRes.data.map(d => d.division))].sort((a, b) => a - b)
          : [];
        const formattedPlayoffs = poRes.data
          ? poRes.data.map(p => ({ id: p.id, label: p.name.toUpperCase(), type: 'po' }))
          : [];
        const formattedExtras = extraRes.data
          ? extraRes.data.map(e => ({ id: `extra-${e.id}`, label: e.nombre.toUpperCase(), type: 'extra' }))
          : [];
        const hasPromo = promoRes.data && promoRes.data.length > 0;

        return [
          ...uniqueDivs.map(d => ({ id: d, label: `DIV ${d}`, type: 'div' })),
          ...formattedPlayoffs,
          ...formattedExtras,
          ...(hasPromo ? [{ id: 'promo', label: 'PROMOCION', type: 'promo' }] : [])
        ];
      });

      setCategories(all);

      const currentCat = all.find(c => c.id === current);
      if (currentCat) {
        const type = currentCat.type === 'div' ? 'div' : 'po';
        setActiveTab(type);
        // Guardamos la seleccion inicial en la memoria
        setLastSelected(prev => ({ ...prev, [type]: currentCat.id }));
      } else if (all.length > 0) {
        const initialCat = all[0];
        const type = initialCat.type === 'div' ? 'div' : 'po';
        onChange(initialCat.id);
        setActiveTab(type);
        setLastSelected(prev => ({ ...prev, [type]: initialCat.id }));
      }
    }
    load();
  }, [season]);

  const filteredCategories = categories.filter(cat => {
    if (activeTab === 'div') return cat.type === 'div';
    return cat.type === 'po' || cat.type === 'extra';
  });

  const hasLigas = categories.some(c => c.type === 'div');
  const hasPlayoffs = categories.some(c => c.type === 'po' || c.type === 'extra');

  // --- MODIFICADO: Lógica de cambio de pestaña con memoria ---
  const handleTabChange = (tab) => {
    setActiveTab(tab);

    // Si tenemos algo guardado en la memoria para esa pestaña, volvemos a ello
    if (tab === 'promo') {
      onChange('promo'); 
    } else if (lastSelected[tab]) {
      onChange(lastSelected[tab]);
    } else {
      // Si no hay memoria (primera vez), buscamos el primero de ese grupo
      const firstOfTab = categories.find(c => tab === 'div' ? c.type === 'div' : (c.type === 'po' || c.type === 'extra'));
      if (firstOfTab) {
        onChange(firstOfTab.id);
      }
    }
  };

  // --- MODIFICADO: Al hacer click en un botón, actualizamos la memoria ---
  const handleCategoryClick = (cat) => {
    const type = cat.type === 'div' ? 'div' : 'po';
    setLastSelected(prev => ({ ...prev, [type]: cat.id }));
    onChange(cat.id);
  };

  return (
    <div style={{ marginBottom: '20px' }}>
      <div style={{ display: 'flex', gap: '10px', marginBottom: '12px', borderBottom: '1px solid #eee', paddingBottom: '10px' }}>
        {hasLigas && (
          <button
            onClick={() => handleTabChange('div')}
            style={{
              padding: '8px 16px', borderRadius: '8px', border: 'none',
              background: activeTab === 'div' ? '#2ecc71' : 'transparent',
              color: activeTab === 'div' ? 'white' : '#64748b',
              fontWeight: 'bold', cursor: 'pointer', fontSize: '0.75rem'
            }}
          > ⚽ LIGA </button>
        )}
        {hasPlayoffs && (
          <button
            onClick={() => handleTabChange('po')}
            style={{
              padding: '8px 16px', borderRadius: '8px', border: 'none',
              background: activeTab === 'po' ? '#34495e' : 'transparent',
              color: activeTab === 'po' ? 'white' : '#64748b',
              fontWeight: 'bold', cursor: 'pointer', fontSize: '0.75rem'
            }}
          > 🏆 PLAYOFFS </button>
        )}
        {categories.some(c => c.type === 'promo') && (
          <button
            onClick={() => handleTabChange('promo')}
            style={{
              padding: '8px 16px', borderRadius: '8px', border: 'none',
              background: activeTab === 'promo' ? '#e67e22' : 'transparent', // Color naranja para distinguir
              color: activeTab === 'promo' ? 'white' : '#64748b',
              fontWeight: 'bold', cursor: 'pointer', fontSize: '0.75rem'
            }}
          > ⚔️ PROMOCIÓN </button>
        )}
      </div>

      <div style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}>
        {filteredCategories.map(cat => (
          <button key={cat.id} onClick={() => handleCategoryClick(cat)} style={{
            padding: '6px 12px', borderRadius: '15px', border: 'none',
            background: current === cat.id ? (cat.type === 'div' ? '#2ecc71' : '#34495e') : '#ecf0f1',
            color: current === cat.id ? 'white' : '#7f8c8d',
            fontSize: '0.7rem', fontWeight: 'bold', cursor: 'pointer',
            transition: 'all 0.2s'
          }}> {cat.label} </button>
        ))}
      </div>
    </div>
  );
}

function SeasonSelector({ current, onChange }) {
  const [seasons, setSeasons] = useState([])
  useEffect(() => {
    async function load() {
      // Cacheamos la lista de temporadas en sessionStorage.
      // Usamos .order() y solo la columna season para no descargar toda la tabla.
      const data = await getOrFetch('seasons_list', async () => {
        const { data: rows } = await supabase
          .from('matches')
          .select('season')
          .order('season', { ascending: false });
        return rows ? [...new Set(rows.map(d => d.season))] : [];
      });
      setSeasons(data);
    }
    load()
  }, [])
  return (
    <select value={current || ''} onChange={(e) => onChange(parseInt(e.target.value))}
      style={{ padding: '4px', borderRadius: '4px', fontSize: '0.8rem', border: '1px solid #ddd' }}>
      {seasons.map(s => <option key={s} value={s}>Temporada {s}</option>)}
    </select>
  )
}

const calcularBonusPorStream = (porcentaje, rules) => {
  // Según el dump: bonus_min_percentage y bonus_points
  const enabled = rules?.bonus_enabled ?? false;
  const umbral = rules?.bonus_min_percentage ?? 80;
  const umbralb = rules?.bonus_min_porcentageb ?? umbral;
  const umbralc = rules?.bonus_min_porcentagec ?? umbral;
  const puntosExtra = rules?.bonus_points ?? 1;
  const puntosExtrab = rules?.bonus_pointsb ?? 0;
  const puntosExtrac = rules?.bonus_pointsc ?? 0;

  if (enabled && porcentaje >= umbral) {
    return { puntos: puntosExtra, aplica: true };
  } else if (enabled && porcentaje >= umbralb) {
    return { puntos: puntosExtrab, aplica: true };
  } else if (enabled && porcentaje >= umbralc) {
    return { puntos: puntosExtrac, aplica: true };
  }
  return { puntos: 0, aplica: false };
};

const calcularStatsStreams = (
  jugadorId,
  allMatches,
  allPlayoffMatches,
  allStreams,
  allPlayoffStreams,
  // Nuevos parámetros para Extra Playoffs
  allExtraPlayoffs = [],
  allExtraLiguilla = [],
  allExtraElims = []
) => {
  // 1. Identificar qué IDs de Extra Playoffs cuentan para puntos (stream_puntos === true)
  // Lo hacemos primero para filtrar rápidamente los partidos después
  const validExtraIds = new Set(
    allExtraPlayoffs
      .filter(ep => ep.stream_puntos === true)
      .map(ep => ep.id)
  );

  // 2. Filtrar partidos donde participa el jugador
  const ligaMatches = allMatches.filter(m => m.home_team === jugadorId || m.away_team === jugadorId);
  const poMatches = allPlayoffMatches.filter(m => m.local_id === jugadorId || m.visitante_id === jugadorId);

  // Extra: Liguilla (solo de torneos con stream_puntos activo)
  const extraLiguillaMatches = allExtraLiguilla.filter(m =>
    validExtraIds.has(m.extra_id) &&
    (m.player1_id === jugadorId || m.player2_id === jugadorId) &&
    m.player1_id !== null &&
    m.player2_id !== null // <--- Filtro de rival real
  );

  // Extra: Eliminatorias (solo de torneos con stream_puntos activo)
  const extraElimsMatches = allExtraElims.filter(m =>
    validExtraIds.has(m.playoff_extra_id) &&
    (m.player1_id === jugadorId || m.player2_id === jugadorId) &&
    m.player1_id !== null &&
    m.player2_id !== null // <--- Filtro de rival real
  );

  const totalPartidos = ligaMatches.length + poMatches.length + extraLiguillaMatches.length + extraElimsMatches.length;

  // 3. Contar streams con URL válida
  // Para Liga y Playoff normal usamos las tablas auxiliares (allStreams / allPlayoffStreams)
  const ligaStreamsCount = ligaMatches.filter(m =>
    allStreams.some(s => s.match_id === m.id && s.stream_url?.startsWith('http'))
  ).length;

  const poStreamsCount = poMatches.filter(m =>
    allPlayoffStreams.some(s => s.playoff_match_id === m.id && s.stream_url?.startsWith('http'))
  ).length;

  // Para Extra Playoffs, según tu lógica, la URL está en la propia fila del partido
  const extraLiguillaStreamsCount = extraLiguillaMatches.filter(m =>
    m.stream_url?.startsWith('http')
  ).length;

  const extraElimsStreamsCount = extraElimsMatches.filter(m =>
    m.stream_url?.startsWith('http')
  ).length;

  const totalStreams = ligaStreamsCount + poStreamsCount + extraLiguillaStreamsCount + extraElimsStreamsCount;

  const porcentaje = totalPartidos > 0 ? Math.round((totalStreams / totalPartidos) * 100) : 0;

  return { totalStreams, totalPartidos, porcentaje };
};

const getPosicionStyle = (pos, div, total, totalDivisiones) => {
  const baseStyle = {
    // CAMBIOS AQUÍ:
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '24px',
    height: '24px',
    borderRadius: '6px',
    fontWeight: '900',
    fontSize: '0.75rem',
    textAlign: 'center',
    lineHeight: '1'
  };

  // Lógica de colores por División
  if (div === 1) {
    if (pos === 1) return { ...baseStyle, background: '#2ecc71', color: 'white' }; // Campeón
    if (pos >= total - 1) return { ...baseStyle, background: '#e74c3c', color: 'white' }; // 9 y 10 (Rojo)
    if (pos === total - 2) return { ...baseStyle, background: '#f37312', color: 'white' }; // 8 (Naranja-Rojo)
    if (total > 7) {
      if (pos === total - 3) return { ...baseStyle, background: '#f39c12', color: 'white' }; // 7 (Naranja)
    }
  }

  if (div > 1 && div < totalDivisiones) {
    if (pos === 1 || pos === 2) return { ...baseStyle, background: '#2ecc71', color: 'white' }; // Ascenso
    if (total > 5) {
      if (pos === 3) return { ...baseStyle, background: '#bee31b', color: 'white' }; // Playoff
      if (pos === total - 2) return { ...baseStyle, background: '#f39c12', color: 'white' }; // Penúltimo Naranja-Rojo
    }
    if (total > 7) {
      if (pos === 4) return { ...baseStyle, background: '#e3e31b', color: 'white' }; // Playoff
      if (pos === total - 3) return { ...baseStyle, background: '#f39c12', color: 'white' }; // 7 (Naranja)
    }
    if (pos >= total - 1) return { ...baseStyle, background: '#e74c3c', color: 'white' }; // Últimos dos
  }

  if (div == totalDivisiones) {
    if (pos === 1 || pos === 2) return { ...baseStyle, background: '#2ecc71', color: 'white' };
    if (total > 5) {
      if (pos === 3) return { ...baseStyle, background: '#bee31b', color: 'white' }; // Playoff
    }
    if (total > 7) {
      if (pos === 4) return { ...baseStyle, background: '#e3e31b', color: 'white' }; // Playoff
    }
  }

  return { ...baseStyle, color: '#94a3b8', background: '#f1f5f9' }; // Resto
};

// --- COMPONENTE PRINCIPAL ---
export default function Clasificacion({ config }) {
  const [vS, setVS] = useState(config?.current_season);
  const [vD, setVD] = useState(() => {
    const cached = localStorage.getItem(`pref_div_${config?.current_season}`);
    return cached ? (isNaN(cached) ? cached : parseInt(cached)) : 1;
  });
  const [lista, setLista] = useState([]);
  const [playoffMatches, setPlayoffMatches] = useState([]);
  const [datosExtra, setDatosExtra] = useState({ extras: [], liguilla: [], elims: [] });
  const [currentUserId, setCurrentUserId] = useState(null);

  const esPlayoff = typeof vD === 'string';

  const [totalDivisiones, setTotalDivisiones] = useState(() => {
    const cached = localStorage.getItem('total_divisiones');
    return cached ? parseInt(cached, 10) : 0;
  });


  // Lógica de detección de división con CACHÉ
  useEffect(() => {
    async function getInitialData() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      setCurrentUserId(user.id);

      // Clave única por temporada para el caché
      const cacheKey = `pref_div_${vS}`;
      const cachedDiv = localStorage.getItem(cacheKey);

      if (cachedDiv) {
        // Si ya lo tenemos en caché, actualizamos el estado y no pedimos a DB
        const parsedDiv = isNaN(cachedDiv) ? cachedDiv : parseInt(cachedDiv);
        setVD(parsedDiv);
      } else {
        // Si NO hay caché, pedimos a Supabase una sola vez
        const { data: userDiv } = await supabase
          .from('clasificacion')
          .select('division')
          .eq('season', vS)
          .eq('user_id', user.id)
          .maybeSingle();

        if (userDiv?.division) {
          setVD(userDiv.division);
          localStorage.setItem(cacheKey, userDiv.division); // Guardamos para la próxima
        }
      }
    }

    if (vS) getInitialData();
  }, [vS]);

  // Nuevo: Si el usuario cambia manualmente la pestaña, actualizamos su preferencia en caché
  const handleDivisionChange = (newDiv) => {
    setVD(newDiv);
    localStorage.setItem(`pref_div_${vS}`, newDiv);
  };

  useEffect(() => {
    async function fetch() {
      if (!vS) return;

      if (!esPlayoff) {
        // --- totalDivisiones: cacheado en localStorage (ya existia, lo mantenemos) ---
        const allDivsData = await getOrFetch(`divs_${vS}`, async () => {
          const { data } = await supabase
            .from('clasificacion')
            .select('division')
            .eq('season', vS);
          return data || [];
        });
        if (allDivsData.length > 0) {
          const maxFound = Math.max(...allDivsData.map(d => d.division || 0));
          if (maxFound !== totalDivisiones) {
            setTotalDivisiones(maxFound);
            localStorage.setItem('total_divisiones', maxFound.toString());
          }
        }

        // --- Datos compartidos por temporada (independientes de la division) ---
        // Se cachean con clave de temporada para reutilizarlos al cambiar de division
        const [playoffIds, matchesData, poMatchesData, streamsData, poStreamsData, rules, extrasData] =
          await Promise.all([
            getOrFetch(`playoff_ids_${vS}`, async () => {
              const { data } = await supabase.from('playoffs').select('id').eq('season', vS);
              return data?.map(p => p.id) || [];
            }),
            getOrFetch(`matches_${vS}`, async () => {
              const { data } = await supabase.from('matches').select('id, home_team, away_team').eq('season', vS);
              return data || [];
            }),
            getOrFetch(`po_matches_${vS}`, async () => {
              // Necesitamos los playoff_ids antes; los obtenemos de sessionStorage si existen
              let ids = [];
              try { ids = JSON.parse(sessionStorage.getItem(`playoff_ids_${vS}`) || '[]'); } catch (_) {}
              if (!ids.length) return [];
              const { data } = await supabase
                .from('playoff_matches_detallados')
                .select('id, local_id, visitante_id, playoff_id')
                .in('playoff_id', ids);
              return data || [];
            }),
            getOrFetch(`streams_${vS}`, async () => {
              const { data } = await supabase.from('match_streams').select('match_id, stream_url');
              return data || [];
            }),
            getOrFetch(`po_streams_${vS}`, async () => {
              const { data } = await supabase.from('match_playoff_streams').select('playoff_match_id, stream_url');
              return data || [];
            }),
            getOrFetch(`rules_${vS}`, async () => {
              const { data } = await supabase.from('season_rules').select('*').eq('season', vS).maybeSingle();
              return data || null;
            }),
            fetchDatosExtraParaStats(vS)
          ]);

        // --- Clasificacion de la division: cacheada por temporada+division ---
        const clasiData = await getOrFetch(`clasi_${vS}_${vD}`, async () => {
          const { data } = await supabase
            .from('clasificacion')
            .select('*')
            .eq('season', vS)
            .eq('division', vD)
            .order('pts', { ascending: false });
          return data || [];
        });

        // Si po_matches se cargo antes de que playoff_ids estuviera en cache,
        // lo recargamos ahora que si tenemos los ids
        let finalPoMatches = poMatchesData;
        if (!finalPoMatches.length && playoffIds.length) {
          finalPoMatches = await getOrFetch(`po_matches_${vS}`, async () => {
            const { data } = await supabase
              .from('playoff_matches_detallados')
              .select('id, local_id, visitante_id, playoff_id')
              .in('playoff_id', playoffIds);
            return data || [];
          });
        }

        setDatosExtra(extrasData);

        const listaEnriquecida = clasiData.map(jugador => {
          const stats = calcularStatsStreams(
            jugador.user_id,
            matchesData,
            finalPoMatches,
            streamsData,
            poStreamsData,
            extrasData.extras,
            extrasData.liguilla,
            extrasData.elims
          );

          // Aplicamos la logica del bonus
          const bonus = calcularBonusPorStream(stats.porcentaje, rules);

          return {
            ...jugador,
            streamStats: stats,
            bonusStream: bonus,
            total_pts: (jugador.pts ?? 0) + bonus.puntos
          };
        });

        // Re-ordenamos por los nuevos puntos totales
        const listaOrdenada = listaEnriquecida.sort((a, b) => b.total_pts - a.total_pts);
        setLista(listaOrdenada);
      } else {
        // Si el ID es un extra, no ejecutamos esta logica porque ya la hace el hijo
        if (vD.toString().startsWith('extra-')) return;
        // Playoffs normales: cacheamos por playoff_id
        const matchesWithStreams = await getOrFetch(`po_bracket_${vD}`, async () => {
          const { data: matches } = await supabase
            .from('playoff_matches_detallados')
            .select('*')
            .eq('playoff_id', vD)
            .order('match_order', { ascending: true });

          if (!matches || matches.length === 0) return [];

          const matchIds = matches.map(m => m.id);
          const { data: streams } = await supabase
            .from('match_playoff_streams')
            .select('playoff_match_id, stream_url')
            .in('playoff_match_id', matchIds);

          return matches.map(m => ({
            ...m,
            stream_url: streams?.find(s => s.playoff_match_id === m.id)?.stream_url || null
          }));
        });

        setPlayoffMatches(matchesWithStreams);
      }
    }
    if (vS) fetch();
  }, [vS, vD, esPlayoff]);

  useEffect(() => {
    async function getSession() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) setCurrentUserId(user.id);
    }
    getSession();
  }, []);

  const renderPlayoffBrackets = () => {
    const getBaseRound = (r) => r ? r.replace(/\(.*\)/g, '').replace(/Ida|Vuelta|IDA|VUELTA/gi, '').trim() : "OTRA";
    const ordenRondas = ["OCTAVOS", "CUARTOS", "SEMIFINALES", "FINAL", "TERCER Y CUARTO PUESTO"];
    const rondasDetectadas = [...new Set(playoffMatches.map(m => getBaseRound(m.round)))];
    const rondasUnicas = rondasDetectadas.sort((a, b) => ordenRondas.indexOf(a.toUpperCase()) - ordenRondas.indexOf(b.toUpperCase()));

    const bracketData = {};

    rondasUnicas.forEach((baseRound, roundIdx) => {
      const matchesInRound = playoffMatches.filter(m => getBaseRound(m.round) === baseRound);
      const enfrentamientos = [];
      const idsProcesados = new Set();

      matchesInRound.forEach(m => {
        if (idsProcesados.has(m.id)) return;
        const n1 = m.local_nick?.trim().toLowerCase() || 'tbd';
        const n2 = m.visitante_nick?.trim().toLowerCase() || 'tbd';
        const pairKey = [n1, n2].sort().join(' vs ');

        const pareja = matchesInRound.filter(pm => {
          if (idsProcesados.has(pm.id)) return false;
          const pn1 = pm.local_nick?.trim().toLowerCase() || 'tbd';
          const pn2 = pm.visitante_nick?.trim().toLowerCase() || 'tbd';
          const pmKey = [pn1, pn2].sort().join(' vs ');
          const compartenNombres = (n1 !== 'tbd' && (n1 === pn1 || n1 === pn2)) || (n2 !== 'tbd' && (n2 === pn1 || n2 === pn2));
          return pmKey === pairKey || (pairKey.includes('tbd') && compartenNombres);
        });

        pareja.sort((a, b) => (a.round.toLowerCase().includes('ida') || a.round.toLowerCase().includes('1')) ? -1 : 1);
        enfrentamientos.push(pareja);
        pareja.forEach(p => idsProcesados.add(p.id));
      });

      if (roundIdx > 0) {
        const prevRoundKey = rondasUnicas[roundIdx - 1];
        const prevEnfrentamientos = bracketData[prevRoundKey];
        enfrentamientos.sort((a, b) => {
          const getMatchPos = (match) => {
            const players = [match[0].local_nick?.toLowerCase(), match[0].visitante_nick?.toLowerCase()].filter(p => p && p !== 'tbd');
            return prevEnfrentamientos.findIndex(prev =>
              players.some(p => prev[0].local_nick?.toLowerCase() === p || prev[0].visitante_nick?.toLowerCase() === p)
            );
          };
          return getMatchPos(a) - getMatchPos(b);
        });
      }
      bracketData[baseRound] = enfrentamientos;
    });

    return (
      <div style={{ display: 'flex', gap: '40px', overflowX: 'auto', padding: '40px 20px', minHeight: '600px', alignItems: 'stretch' }}>
        {rondasUnicas.map((baseRound, roundIdx) => (
          <div key={baseRound} style={{ display: 'flex', flexDirection: 'column', width: '250px', flexShrink: 0 }}>
            <h4 style={{ fontSize: '0.65rem', color: '#64748b', textAlign: 'center', marginBottom: '25px', textTransform: 'uppercase', letterSpacing: '1.5px', fontWeight: '900' }}>
              {baseRound}
            </h4>

            <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-around', flexGrow: 1 }}>
              {bracketData[baseRound].map((pair, idx) => {
                const m1 = pair[0];
                const m2 = pair[1];

                const checkPlayed = (m) => m && (m.played === true || m.played === 'true' || m.is_played === true || m.home_score !== null);

                // Lógica de TBD solo para la PRIMERA ronda mostrada
                const isLocalTBD = !m1.local_nick || m1.local_nick.toLowerCase() === 'tbd';
                const isVisitanteTBD = !m1.visitante_nick || m1.visitante_nick.toLowerCase() === 'tbd';
                const isFirstRound = roundIdx === 0;

                // Si es primera fase y hay un TBD, se da por terminado como BYE
                const isBye = isFirstRound && (isLocalTBD || isVisitanteTBD);

                const isFinished = isBye || (m2 ? (checkPlayed(m1) && checkPlayed(m2)) : checkPlayed(m1));

                let gL = m1.home_score || 0;
                let gV = m1.away_score || 0;
                if (m2) {
                  if (m2.local_nick === m1.local_nick) {
                    gL += (m2.home_score || 0); gV += (m2.away_score || 0);
                  } else {
                    gL += (m2.away_score || 0); gV += (m2.home_score || 0);
                  }
                }

                // Determinar ganador (si es BYE, gana el que no es TBD)
                const winL = isFinished && ((isBye && !isLocalTBD) || (!isBye && gL > gV));
                const winV = isFinished && ((isBye && !isVisitanteTBD) || (!isBye && gV > gL));

                return (
                  <div key={idx} style={{ position: 'relative', margin: '15px 0' }}>
                    {isFinished && (
                      <div style={{
                        position: 'absolute', top: '-8px', right: '-8px',
                        background: '#2ecc71', color: 'white', borderRadius: '50%',
                        width: '20px', height: '20px', display: 'flex',
                        alignItems: 'center', justifyContent: 'center',
                        fontSize: '10px', zIndex: 10, boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
                        border: '2px solid #fff'
                      }}>
                        ✓
                      </div>
                    )}

                    <div style={{
                      background: isFinished ? '#f0f9ff' : '#fff',
                      border: isFinished ? '1.5px solid #7dd3fc' : '1px solid #e2e8f0',
                      borderRadius: '12px',
                      padding: '12px',
                      boxShadow: isFinished ? '0 4px 12px -2px rgba(14, 165, 233, 0.15)' : '0 4px 6px -1px rgba(0,0,0,0.05)',
                      borderLeft: isFinished ? '5px solid #0ea5e9' : '4px solid #34495e',
                      transition: 'all 0.3s ease'
                    }}>

                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '8px', marginBottom: '12px' }}>
                        {/* LOCAL */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1, minWidth: 0 }}>
                          <Avatar url={m1.local_avatar} size="28px" />
                          <span style={{
                            fontSize: winL ? '0.8rem' : '0.75rem',
                            fontWeight: winL ? '900' : '800',
                            color: winL ? '#10b981' : (isFinished ? '#0369a1' : '#1e293b'),
                            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                            textDecoration: winL ? 'underline' : 'none'
                          }}>
                            {m1.local_nick || 'TBD'}
                          </span>
                        </div>

                        {/* VISITANTE */}
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1, minWidth: 0, flexDirection: 'row-reverse' }}>
                          <Avatar url={m1.visitante_avatar} size="28px" />
                          <span style={{
                            fontSize: winV ? '0.8rem' : '0.75rem',
                            fontWeight: winV ? '900' : '800',
                            color: winV ? '#10b981' : (isFinished ? '#0369a1' : '#1e293b'),
                            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', textAlign: 'right',
                            textDecoration: winV ? 'underline' : 'none'
                          }}>
                            {m1.visitante_nick || 'TBD'}
                          </span>
                        </div>
                      </div>

                      <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '12px' }}>
                        <div style={{ height: '1px', background: isFinished ? '#bae6fd' : '#f1f5f9', flex: 1 }}></div>
                        <span style={{
                          fontSize: '0.65rem',
                          fontWeight: '900',
                          color: '#fff',
                          background: isFinished ? '#0ea5e9' : '#334155',
                          padding: '3px 10px',
                          borderRadius: '6px'
                        }}>
                          {isBye ? 'PASO DIRECTO' : `GLB: ${gL} - ${gV}`}
                        </span>
                        <div style={{ height: '1px', background: isFinished ? '#bae6fd' : '#f1f5f9', flex: 1 }}></div>
                      </div>
                      <div style={{ display: 'flex', gap: '8px' }}>
                        {/* CAJA PARTIDO 1 (IDA O FINAL) */}
                        <div style={{
                          flex: 1, textAlign: 'center',
                          background: isFinished ? '#e0f2fe' : '#f8fafc',
                          borderRadius: '8px', padding: '6px 0',
                          border: isFinished ? '1px solid #bae6fd' : '1px solid #f1f5f9'
                        }}>
                          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                            <span style={{ display: 'block', fontSize: '0.5rem', color: isFinished ? '#0369a1' : '#94a3b8', fontWeight: '800' }}>
                              {m2 ? 'IDA' : 'FINAL'}
                            </span>
                            {/* AQUÍ VA EL ICONO DEL PRIMER PARTIDO */}
                            <StreamIcon url={m1.stream_url} />
                          </div>
                          <span style={{ fontSize: '1rem', fontWeight: '900', color: isFinished ? '#0c4a6e' : '#1e293b' }}>
                            {isBye ? '-' : (m1.home_score ?? '-')} : {isBye ? '-' : (m1.away_score ?? '-')}
                          </span>
                        </div>

                        {/* CAJA PARTIDO 2 (VUELTA) */}
                        {m2 && (
                          <div style={{
                            flex: 1, textAlign: 'center',
                            background: isFinished ? '#e0f2fe' : '#f8fafc',
                            borderRadius: '8px', padding: '6px 0',
                            border: isFinished ? '1px solid #bae6fd' : '1px solid #f1f5f9'
                          }}>
                            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                              <span style={{ display: 'block', fontSize: '0.5rem', color: isFinished ? '#0369a1' : '#94a3b8', fontWeight: '800' }}>VTA</span>
                              {/* AQUÍ VA EL ICONO DEL SEGUNDO PARTIDO */}
                              <StreamIcon url={m2.stream_url} />
                            </div>
                            <span style={{ fontSize: '1rem', fontWeight: '900', color: isFinished ? '#0c4a6e' : '#1e293b' }}>
                              {isBye ? '-' : (m2.local_nick === m1.local_nick ? (m2.home_score ?? '-') : (m2.away_score ?? '-'))}
                              :
                              {isBye ? '-' : (m2.visitante_nick === m1.visitante_nick ? (m2.away_score ?? '-') : (m2.home_score ?? '-'))}
                            </span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    );
  };

  const handleRefresh = () => {
    sessionStorage.clear();
    window.location.reload();
  };

  return (
    <div style={{ fontFamily: 'Inter, system-ui, sans-serif' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
        <CategorySelector season={vS} current={vD} onChange={handleDivisionChange} />
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <SeasonSelector current={vS} onChange={setVS} />
          {/*
          <button
            onClick={handleRefresh}
            title="Forzar actualizacion de datos"
            style={{
              background: 'transparent', border: '1px solid #ddd', borderRadius: '4px',
              padding: '4px 8px', cursor: 'pointer', fontSize: '0.75rem', color: '#64748b'
            }}
          >
            Actualizar
          </button>
          */}
        </div>
      </div>


      {(() => {
        // CASO 1: Es Promocion
        if (vD === 'promo') {
          return <ClasificacionPromo season={vS} />;
        }

        // CASO 2: Es un Extra Playoff (ID con prefijo "extra-")
        if (typeof vD === 'string' && vD.startsWith('extra-')) {
          // Quitamos el prefijo para pasarle solo el ID numérico al componente
          const extraId = vD.replace('extra-', '');
          return <ClasificacionExtraPlayoff season={vS} id={extraId} />;
        }

        // CASO 3: Es un Playoff normal (Brackets)
        if (esPlayoff) {
          return (
            <div style={{ background: '#f8fafc', borderRadius: '16px', border: '1px solid #e2e8f0', backgroundImage: 'radial-gradient(#e2e8f0 1px, transparent 1px)', backgroundSize: '20px 20px' }}>
              {renderPlayoffBrackets()}
            </div>
          );
        }

        // CASO 4: Es Liga normal (Tabla de clasificación)
        return (
          <div style={{ background: '#fff', borderRadius: '12px', border: '1px solid #eee', overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '0.75rem' }}>
              <thead>
                <tr style={{ background: '#f8f9fa', borderBottom: '2px solid #2ecc71' }}>
                  <th style={{ padding: '12px 5px', width: '20px' }}></th>
                  <th style={{ padding: '12px', textAlign: 'left' }}>JUGADOR</th>
                  <th style={{ padding: '10px' }}>PTS</th>
                  <th style={{ padding: '10px' }}>PJ</th>
                  <th style={{ padding: '10px' }}>PG</th>
                  <th style={{ padding: '10px' }}>PE</th>
                  <th style={{ padding: '10px' }}>GF</th>
                  <th style={{ padding: '10px' }}>GC</th>
                  <th style={{ padding: '10px' }}>DG</th>
                  <th style={{ padding: '10px' }}>📺</th>
                </tr>
              </thead>

              <tbody>
                {lista.map((j, i) => {
                  const pos = i + 1;
                  const total = lista.length;
                  const esMiFila = currentUserId && j.user_id === currentUserId;

                  return (
                    <tr key={j.user_id || i} style={{ borderBottom: '1px solid #f1f1f1', textAlign: 'center', background: esMiFila ? 'rgba(46, 204, 113, 0.08)' : 'transparent', borderLeft: esMiFila ? '4px solid #2ecc71' : '4px solid transparent', transition: 'background 0.3s ease' }}>
                      {/* ESTA ES LA CELDA QUE CAMBIA */}
                      <td style={{ padding: '10px 5px', width: '35px' }}>
                        <span style={getPosicionStyle(pos, vD, total, totalDivisiones)}>
                          {pos}
                        </span>
                      </td>

                      {/* El resto de la fila se queda igual que antes... */}
                      <td style={{ padding: '10px', textAlign: 'left', fontWeight: esMiFila ? '900' : 'bold', display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <Avatar url={j.avatar_url} size="24px" />
                        {j.nick} {esMiFila && <span style={{ fontSize: '0.6rem', color: '#2ecc71', marginLeft: '4px' }}></span>}
                      </td>
                      <td style={{ fontWeight: 'bold', color: '#2ecc71', fontSize: esMiFila ? '0.85rem' : '0.75rem' }}>{j.total_pts ?? 0}</td>
                      <td>{j.pj ?? 0}</td>
                      <td>{j.pg ?? 0}</td>
                      <td>{j.pe ?? 0}</td>
                      <td>{j.gf ?? 0}</td>
                      <td>{j.gc ?? 0}</td>
                      <td style={{ color: (j.dg ?? 0) > 0 ? '#2ecc71' : (j.dg ?? 0) < 0 ? '#e74c3c' : '#7f8c8d', fontWeight: '600' }}>{j.dg ?? 0}</td>
                      <td style={{ padding: '10px', color: '#64748b', fontWeight: 'bold' }}>
                        <div style={{ display: 'flex', flexDirection: 'column', fontSize: '0.65rem' }}>
                          <span>{j.streamStats?.totalStreams || 0}/{j.streamStats?.totalPartidos || 0}</span>
                          <span style={{ color: j.bonusStream?.aplica ? '#9b59b6' : '#94a3b8' }}>
                            ({j.streamStats?.porcentaje || 0}%)
                            {j.bonusStream?.aplica && (
                              <span style={{ color: '#2ecc71', fontWeight: 'bold', marginLeft: '4px' }}>
                                (+{j.bonusStream.puntos})
                              </span>
                            )}
                          </span>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>




            </table>
          </div>
        );
      })()}
    </div>
  )
}