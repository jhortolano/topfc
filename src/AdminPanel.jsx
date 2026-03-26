import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import SwitchPlayer from './utils/SwitchPlayer'
import MatchesRescheduled from './utils/MatchesRescheduled'


const getOnlineStatus = (lastSeen) => {
  if (!lastSeen) return { dot: '#cbd5e0', text: 'Nunca', active: false };
  const last = new Date(lastSeen);
  const ahora = new Date();
  const diffMs = ahora - last;
  const diffMin = Math.floor(diffMs / 60000);

  if (diffMin < 5) return { dot: '#2ecc71', text: 'En línea', active: true };
  if (diffMin < 60) return { dot: '#f1c40f', text: `Hace ${diffMin}m`, active: false };
  if (diffMin < 1440) return { dot: '#95a5a6', text: `Hace ${Math.floor(diffMin / 60)}h`, active: false };
  return { dot: '#d1d5db', text: last.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit' }), active: false };
};

// --- SUB-COMPONENTE PARA FILA DE PARTIDO ---
function PartidoEditable({ partido, onUpdate }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');
  const [streamUrl, setStreamUrl] = useState(partido.stream_url || '');

  // Sincronizar si el partido cambia desde fuera (ej: cambiar de jornada)
  useEffect(() => {
    setGL(partido.home_score ?? '');
    setGV(partido.away_score ?? '');
    setStreamUrl(partido.stream_url || '');
  }, [partido]);

  const modificado = gL != (partido.home_score ?? '') ||
    gV != (partido.away_score ?? '') ||
    streamUrl !== (partido.stream_url || '');

  // Condición: is_played es false/null Y los scores en la DB NO son null
  const esNoJugadoConGoles =
    !partido.is_played &&
    partido.home_score !== null &&
    partido.away_score !== null;

  return (
    <div style={{
      display: 'flex', flexDirection: 'column', gap: '8px', padding: '10px', // Cambiado a column para el input debajo
      // Prioridad de colores: 1. Modificado (Azul), 2. No jugado con goles (Naranja), 3. Normal (Gris)
      background: modificado
        ? '#ebf8ff'
        : (esNoJugadoConGoles ? '#fff3e0' : '#f8f9fa'),
      borderRadius: '10px', marginBottom: '8px', border: modificado ? '1px solid #4299e1' : '1px solid #edf2f7',
      border: modificado
        ? '1px solid #4299e1'
        : (esNoJugadoConGoles ? '1px solid #ffb74d' : '1px solid #edf2f7'),
      transition: 'all 0.2s'
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
        <span style={{ flex: 1, textAlign: 'right', fontWeight: 'bold', fontSize: '0.85rem' }}>{partido.local_nick}</span>

        <div style={{ display: 'flex', gap: '5px' }}>
          <input
            type="number"
            value={gL}
            onChange={e => setGL(e.target.value)}
            style={{ width: '35px', textAlign: 'center', padding: '5px', borderRadius: '4px', border: '1px solid #cbd5e0' }}
          />
          <span style={{ fontWeight: 'bold', color: '#a0aec0' }}>-</span>
          <input
            type="number"
            value={gV}
            onChange={e => setGV(e.target.value)}
            style={{ width: '35px', textAlign: 'center', padding: '5px', borderRadius: '4px', border: '1px solid #cbd5e0' }}
          />
        </div>

        <span style={{ flex: 1, fontWeight: 'bold', fontSize: '0.85rem' }}>{partido.visitante_nick}</span>

        <div style={{ display: 'flex', gap: '5px' }}>
          <button
            onClick={() => onUpdate(partido.id, gL, gV, true, streamUrl)} // Pasamos streamUrl
            disabled={!modificado}
            title="Guardar"
            style={{
              background: modificado ? '#2ecc71' : '#cbd5e0', color: 'white', border: 'none',
              padding: '5px 10px', borderRadius: '4px', cursor: modificado ? 'pointer' : 'default'
            }}
          >✓</button>
          <button
            onClick={() => {
              if (window.confirm("¿Resetear marcador y retransmisión?")) {
                setGL(''); setGV(''); setStreamUrl('');
                onUpdate(partido.id, '', '', false, '');
              }
            }}
            title="Resetear"
            style={{ background: '#e74c3c', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}
          >↺</button>
          <button
            onClick={() => {
              // Lógica: Si no hay goles en el estado local, ponemos 0-0
              const finalGL = gL === '' ? 0 : gL;
              const finalGV = gV === '' ? 0 : gV;
              setGL(finalGL);
              setGV(finalGV);
              // Llamamos a onUpdate con is_played = false
              onUpdate(partido.id, finalGL, finalGV, false, streamUrl);
            }}
            title="Marcar como No Jugado"
            style={{ background: '#f39c12', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer', fontWeight: 'bold' }}
          >NJ</button>
        </div>
      </div>

      {/* Nuevo input para la URL de retransmisión */}
      <input
        type="text"
        placeholder="URL de retransmisión (Twitch, YouTube...)"
        value={streamUrl}
        onChange={e => {
          setStreamUrl(e.target.value);
        }}
        style={{
          fontSize: '0.75rem', padding: '4px 8px', borderRadius: '4px',
          border: '1px solid #cbd5e0', width: '100%', boxSizing: 'border-box'
        }}
      />
    </div>
  );
}

export default function AdminPanel({ config, onConfigChange, profile }) {
  const isAdminReal = profile?.is_admin === true;
  const [loading, setLoading] = useState(false);
  const [availableSeasons, setAvailableSeasons] = useState([]);
  const [availableUsers, setAvailableUsers] = useState([]);
  const [showUserSelector, setShowUserSelector] = useState(false);
  const [numDivisions, setNumDivisions] = useState(1);
  const [assignments, setAssignments] = useState({ 1: [], 2: [], 3: [] });
  const [seasonToDelete, setSeasonToDelete] = useState("");

  const [editSeason, setEditSeason] = useState(config?.current_season || 1);
  const [editWeek, setEditWeek] = useState(config?.current_week || 1);
  const [editDiv, setEditDiv] = useState(1);
  const [partidosEdit, setPartidosEdit] = useState([]);
  const [schedule, setSchedule] = useState([]);

  const [searchTerm, setSearchTerm] = useState(""); // Nuevo estado para filtrar usuarios

  const [isIdaVuelta, setIsIdaVuelta] = useState(true);

  const [bonusEnabled, setBonusEnabled] = useState(false);
  const [minPercentage, setMinPercentage] = useState(80);
  const [extraPoints, setExtraPoints] = useState(1);
  const [limitGaEnabled, setLimitGaEnabled] = useState(true); // Checkbox de activo
  const [maxGaLeague, setMaxGaLeague] = useState(3);          // Diferencia máxima
  const [showSwitch, setShowSwitch] = useState(false);

  const [showReschedule, setShowReschedule] = useState(false);

  const [seasonRules, setSeasonRules] = useState(null);

  // --- ESTADOS PARA COLABORADORES ---
  const [colaboradorSearch, setColaboradorSearch] = useState('');
  const [showColaboradorResults, setShowColaboradorResults] = useState(false);

  // Lista de usuarios que ya son colaboradores
  const colaboradores = availableUsers.filter(u => u.is_colaborador);

  // --- LÓGICA DE DETECCIÓN DE ENTORNO ---
  const supabaseUrl = supabase.supabaseUrl || '';

  // 1. Identificamos las bases de datos por su ID único
  const isProd = supabaseUrl.includes('nkecyqwcrsicsyladdhw');
  const isSilver = supabaseUrl.includes('yzudeybjzjmzsnjlgsui'); // El ID de tu nueva DB

  // 2. Definimos el nombre que se mostrará
  let dbName = "DESCONOCIDO";
  if (isProd) dbName = "PRODUCCIÓN (Real)";
  else if (isSilver) dbName = "SILVER (Pre-Producción)";
  else dbName = "LOCAL / TESTING";

  // 3. Definimos el color (Silver suele ser un gris azulado o plateado)
  let dbColor = "#95a5a6"; // Gris por defecto
  if (isProd) dbColor = "#e74c3c"; // Rojo para Prod
  if (isSilver) dbColor = "#7f8c8d"; // Plateado/Gris oscuro para Silver





  const [autoWeek, setAutoWeek] = useState(false);
  const [allowReg, setAllowReg] = useState(config?.allow_registration ?? true);

  const [hideRetired, setHideRetired] = useState(true); // Por defecto seleccionado

  const [onlyNoGame, setOnlyNoGame] = useState(false);
  const [activePlayerIds, setActivePlayerIds] = useState([]);

  // Sincronizar si la config cambia desde fuera
  useEffect(() => {
    setAllowReg(config?.allow_registration ?? true);
  }, [config?.allow_registration]);

  // Sincroniza si la prop cambia desde fuera
  useEffect(() => {
    setAutoWeek(autoWeek || false);
  }, [autoWeek]);

  useEffect(() => {
    fetchSeasons();
    fetchUsers();
  }, []);

  useEffect(() => {
    if (config) {
      setEditSeason(config.current_season);
      setEditWeek(config.current_week);
      fetchSchedule();
    }
  }, [config]);

  useEffect(() => {
    fetchPartidosParaEditar();
    if (editSeason) loadSeasonRules(editSeason);
  }, [editSeason, editWeek, editDiv]);

  useEffect(() => {
    const fetchSeasonRules = async () => {
      if (config?.current_season) {
        const { data, error } = await supabase
          .from('season_rules')
          .select('*')
          .eq('season', config.current_season)
          .maybeSingle(); // Usa maybeSingle para que no de error si no encuentra nada

        if (error) {
          console.error("Error cargando reglas:", error);
          return;
        }

        if (data) {
          setSeasonRules(data);
          setAutoWeek(data.auto_week_by_date);
        } else {
          // Si no existe la fila, ponemos valores por defecto para evitar el crash
          setSeasonRules({ auto_week_by_date: false });
          setAutoWeek(false);

          // OPCIONAL: Podrías crear la fila aquí si falta
          console.warn("No se encontraron reglas para la temporada actual.");
        }
      }
    };
    fetchSeasonRules();
  }, [config?.current_season]);

  useEffect(() => {
    const fetchActivePlayers = async () => {
      if (!onlyNoGame) return;

      const s = config?.current_season;
      if (!s) return;

      let ids = new Set();

      // 1. Liga (matches)
      const { data: m } = await supabase.from('matches').select('home_team, away_team').eq('season', s);
      m?.forEach(p => { if (p.home_team) ids.add(p.home_team); if (p.away_team) ids.add(p.away_team); });

      // 2. Playoff Matches
      const { data: pl } = await supabase.from('playoffs').select('id').eq('season', s);
      if (pl?.length > 0) {
        const plIds = pl.map(p => p.id);
        const { data: pm } = await supabase.from('playoff_matches').select('home_team, away_team').in('playoff_id', plIds);
        pm?.forEach(p => { if (p.home_team) ids.add(p.home_team); if (p.away_team) ids.add(p.away_team); });
      }

      // 3. Extra Playoff Matches & Extra Matches
      const { data: ex } = await supabase.from('playoffs_extra').select('id').eq('season_id', s);
      if (ex?.length > 0) {
        const exIds = ex.map(e => e.id);

        // Tabla extra_playoff_matches
        const { data: epm } = await supabase.from('extra_playoffs_matches').select('player1_id, player2_id').in('playoff_extra_id', exIds);
        epm?.forEach(p => { if (p.player1_id) ids.add(p.player1_id); if (p.player2_id) ids.add(p.player2_id); });

        // Tabla extra_matches
        const { data: em } = await supabase.from('extra_matches').select('player1_id, player2_id').in('extra_id', exIds);
        em?.forEach(p => { if (p.player1_id) ids.add(p.player1_id); if (p.player2_id) ids.add(p.player2_id); });
      }
      setActivePlayerIds(Array.from(ids));
    };

    fetchActivePlayers();
  }, [onlyNoGame, config?.current_season]);


  const fetchSeasons = async () => {
    const { data } = await supabase.from('matches').select('season');
    if (data) {
      const unique = [...new Set(data.map(item => item.season))].sort((a, b) => b - a);
      setAvailableSeasons(unique);
      if (unique.length > 0) setSeasonToDelete(unique[0].toString());
    }
  };

  const fetchUsers = async () => {
    const { data, error } = await supabase
      .from('profiles')
      .select('*') // Traemos todo: email, telegram_user, etc.
      .order('nick', { ascending: true });
    if (error) console.error("Error:", error);
    if (data) setAvailableUsers(data);
  };

  const fetchSchedule = async () => {
    const { data } = await supabase
      .from('weeks_schedule')
      .select('*')
      .eq('season', config.current_season)
      .order('week', { ascending: true });
    setSchedule(data || []);
  };


  const loadSeasonRules = async (seasonId) => {
    const { data } = await supabase.from('season_rules').select('*').eq('season', seasonId).maybeSingle();
    if (data) {
      setBonusEnabled(data.bonus_enabled);
      setMinPercentage(data.bonus_min_percentage);
      setExtraPoints(data.bonus_points);
      setLimitGaEnabled(data.limit_ga_enabled ?? true);
      setMaxGaLeague(data.max_ga_league ?? 3);
    } else {
      setBonusEnabled(false);
      setMinPercentage(80);
      setExtraPoints(1);
      setLimitGaEnabled(true);
      setMaxGaLeague(3);
    }
  };

  // Función para cambiar el estado de colaborador
  const toggleColaborador = async (userId, status) => {
    const { error } = await supabase
      .from('profiles')
      .update({ is_colaborador: status })
      .eq('id', userId);

    if (error) {
      alert("Error al actualizar colaborador");
    } else {
      // Refrescamos la lista de usuarios para que se actualice la UI
      fetchUsers();
      setColaboradorSearch('');
      setShowColaboradorResults(false);
    }
  };

  const handleSaveRules = async () => {
    const { error } = await supabase.from('season_rules').upsert({
      season: editSeason,
      bonus_enabled: bonusEnabled,
      bonus_min_percentage: minPercentage,
      bonus_points: extraPoints,
      limit_ga_enabled: limitGaEnabled,
      max_ga_league: maxGaLeague
    });
    if (error) alert("Error: " + error.message);
    else alert(`¡Reglas guardadas para la Temporada ${editSeason}!`);
  };


  const fetchPartidosParaEditar = async () => {
    const { data, error } = await supabase
      .from('partidos_detallados')
      .select(`
        *,
        match_streams ( stream_url )
      `)
      .eq('season', editSeason)
      .eq('week', editWeek)
      .eq('division', editDiv);

    if (error) {
      console.error("ERROR SUPABASE FETCH:", error);
      return;
    }

    if (data) {
      const formateados = data.map(p => {
        // Acceso directo al objeto match_streams
        const urlDeTabla = p.match_streams?.stream_url || '';

        return {
          ...p,               // 1º Metemos todo lo de la vista
          stream_url: urlDeTabla // 2º SOBRESCRIBIMOS con la de la tabla (así ésta manda)
        };
      });
      setPartidosEdit(formateados);
    }
  };

  const handleUpdateMatch = async (id, hScore, aScore, played, streamUrl) => {

    try {
      // 1. Update Matches
      const { error: errorMatch } = await supabase.from('matches').update({
        home_score: hScore === '' ? null : parseInt(hScore),
        away_score: aScore === '' ? null : parseInt(aScore),
        is_played: played
      }).eq('id', id);

      if (errorMatch) {
        console.error("ERROR ACTUALIZANDO MARCADOR:", errorMatch);
        throw errorMatch;
      }

      // 2. Update Stream
      if (streamUrl && streamUrl.trim() !== '') {
        const { error: errorStream } = await supabase
          .from('match_streams')
          .upsert({
            match_id: id,
            stream_url: streamUrl.trim(),
          }, { onConflict: 'match_id' });

        if (errorStream) {
          console.error("ERROR UPSERT STREAM:", errorStream);
          throw errorStream;
        }
      } else {
        await supabase.from('match_streams').delete().eq('match_id', id);
      }

      await fetchPartidosParaEditar();

    } catch (err) {
      console.error("FALLO GLOBAL EN UPDATE:", err);
      alert("Error: " + err.message);
    }
  };

  // --- LÓGICA DE FECHAS EN CASCADA ---
  const handleDateChange = async (index, field, newValue) => {
    let newSchedule = [...schedule];
    newSchedule[index][field] = newValue;
    for (let i = index; i < newSchedule.length; i++) {
      const current = newSchedule[i];
      const next = newSchedule[i + 1];
      if (next) {
        if (next.is_linked) {
          next.start_at = current.start_at;
          next.end_at = current.end_at;
        } else {
          const oldStartNext = new Date(next.start_at).getTime();
          const oldEndNext = new Date(next.end_at).getTime();
          const durationNext = oldEndNext - oldStartNext;
          next.start_at = current.end_at;
          next.end_at = new Date(new Date(next.start_at).getTime() + durationNext).toISOString();
        }
      }
    }
    setSchedule(newSchedule);
    await supabase.from('weeks_schedule').upsert(newSchedule);
  };

  const toggleLink = async (index) => {
    const newSchedule = [...schedule];
    newSchedule[index].is_linked = !newSchedule[index].is_linked;
    if (newSchedule[index].is_linked) {
      newSchedule[index].start_at = newSchedule[index - 1].start_at;
      newSchedule[index].end_at = newSchedule[index - 1].end_at;
    } else {
      newSchedule[index].start_at = newSchedule[index - 1].end_at;
      let defaultEnd = new Date(newSchedule[index].start_at);
      defaultEnd.setDate(defaultEnd.getDate() + 7);
      newSchedule[index].end_at = defaultEnd.toISOString();
    }
    for (let i = index; i < newSchedule.length - 1; i++) {
      const current = newSchedule[i];
      const next = newSchedule[i + 1];
      if (next.is_linked) {
        next.start_at = current.start_at;
        next.end_at = current.end_at;
      } else {
        const dur = new Date(next.end_at).getTime() - new Date(next.start_at).getTime();
        next.start_at = current.end_at;
        next.end_at = new Date(new Date(next.start_at).getTime() + dur).toISOString();
      }
    }
    setSchedule(newSchedule);
    await supabase.from('weeks_schedule').upsert(newSchedule);
  };

  const resetCalendarioSemanas = async () => {
    if (!window.confirm("¿Resetear a intervalos de 1 semana?")) return;
    let newSchedule = [...schedule];
    for (let i = 0; i < newSchedule.length; i++) {
      if (i > 0) {
        if (newSchedule[i].is_linked) {
          newSchedule[i].start_at = newSchedule[i - 1].start_at;
          newSchedule[i].end_at = newSchedule[i - 1].end_at;
        } else {
          newSchedule[i].start_at = newSchedule[i - 1].end_at;
          let d = new Date(newSchedule[i].start_at);
          d.setDate(d.getDate() + 7);
          newSchedule[i].end_at = d.toISOString();
        }
      }
    }
    setSchedule(newSchedule);
    await supabase.from('weeks_schedule').upsert(newSchedule);
  };

  const eliminarTemporada = async () => {
    if (!seasonToDelete) return alert("Selecciona una temporada");
    if (!window.confirm(`¿Seguro que quieres borrar la T${seasonToDelete}?`)) return;

    setLoading(true);
    const s = parseInt(seasonToDelete);

    // 1. Borrar partidos de liga
    const { error: errorMatches } = await supabase
      .from('matches')
      .delete()
      .eq('season', s);

    // 2. Borrar calendario de fechas
    const { error: errorWeeks } = await supabase
      .from('weeks_schedule')
      .delete()
      .eq('season', s);

    if (errorMatches || errorWeeks) {
      console.error("Error al borrar:", errorMatches || errorWeeks);
      alert("Error de base de datos al borrar");
    } else {
      alert(`Temporada ${s} eliminada de la base de datos.`);
      // IMPORTANTE: Limpiar el estado de los partidos editables
      setPartidosEdit([]);
      await fetchSeasons();
      onConfigChange();
    }
    setLoading(false);
  };

  const toLocalISO = (dateStr) => {
    if (!dateStr) return "";
    const d = new Date(dateStr);
    const tzoffset = d.getTimezoneOffset() * 60000;
    return new Date(d.getTime() - tzoffset).toISOString().slice(0, 16);
  };

  const handleAssign = (userId, div) => {
    const newAssignments = { ...assignments };
    Object.keys(newAssignments).forEach(d => {
      newAssignments[d] = newAssignments[d].filter(id => id !== userId);
    });
    if (div > 0) newAssignments[div].push(userId);
    setAssignments(newAssignments);
  };

  const abrirSelectorUsuarios = () => {
    fetchUsers();
    setShowUserSelector(true);
  };

  const confirmarCreacionTemporada = async () => {
    const seasonNum = prompt("Nº Temporada?", (availableSeasons.length > 0 ? Math.max(...availableSeasons) + 1 : 1).toString());
    const startStr = prompt("Inicio J1 (AAAA-MM-DD HH:MM)", "2026-02-10 17:00");
    if (!seasonNum || !startStr) return;
    setLoading(true);
    let allMatches = [];
    let maxJ = 0;
    for (let d = 1; d <= numDivisions; d++) {
      const ids = assignments[d];
      if (ids.length < 2) continue;
      const players = availableUsers.filter(u => ids.includes(u.id));
      const matches = generarCalendario(players, isIdaVuelta);
      maxJ = Math.max(maxJ, Math.max(...matches.map(m => m.week)));
      allMatches = [...allMatches, ...matches.map(m => ({ ...m, season: parseInt(seasonNum), division: d, is_played: false }))];
    }
    await supabase.from('matches').insert(allMatches);
    let currentStart = new Date(startStr.replace(' ', 'T'));
    const scheduleEntries = [];
    for (let i = 1; i <= maxJ; i++) {
      let currentEnd = new Date(currentStart.getTime());
      currentEnd.setDate(currentEnd.getDate() + 7);
      scheduleEntries.push({
        season: parseInt(seasonNum), week: i,
        start_at: currentStart.toISOString(), end_at: currentEnd.toISOString(), is_linked: false
      });
      currentStart = new Date(currentEnd.getTime());
    }
    await supabase.from('weeks_schedule').insert(scheduleEntries);
    // 2. Crear automáticamente las reglas para la nueva temporada
    const { error: rulesError } = await supabase
      .from('season_rules')
      .insert([{
        season: seasonNum,
        bonus_enabled: false,
        bonus_min_percentage: 80,
        bonus_points: 1,
        limit_ga_enabled: true,
        max_ga_league: 3,
        auto_week_by_date: false,
        auto_playoff_by_date: false
      }]);
    if (rulesError) {
      console.error("Error al crear season_rules:", rulesError);
    }
    setShowUserSelector(false);
    fetchSeasons();
    onConfigChange();
    setLoading(false);
  };


  const filteredUsers = availableUsers.filter(u => {
    // 1. Filtro por el buscador (Nick o Email)
    const coincideBusqueda =
      (u.nick?.toLowerCase().includes(searchTerm.toLowerCase())) ||
      (u.email?.toLowerCase().includes(searchTerm.toLowerCase()));

    // 2. Filtro de usuarios retirados
    const esRetirado = u.nick?.toLowerCase().startsWith("retirado");
    const pasaFiltroRetirados = hideRetired ? !esRetirado : true;

    // 3: Filtro de "Sin Juego"
    const estaJugando = activePlayerIds.includes(u.id);
    const pasaFiltroSinJuego = onlyNoGame ? (!estaJugando && !esRetirado) : true;

    return coincideBusqueda && pasaFiltroRetirados && pasaFiltroSinJuego;
  });

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '25px' }}>

      {isAdminReal && (
        <>
          {/* 1. NAVEGACIÓN  */}
          <div style={{
            background: '#f8f9fa',
            padding: '15px',
            borderRadius: '8px',
            border: '1px solid #ddd',
            display: 'flex',
            flexDirection: 'column',
            gap: '10px'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                <span>Jornada Activa:</span>
                <button
                  style={{ padding: '2px 8px', cursor: autoWeek ? 'not-allowed' : 'pointer' }}
                  disabled={autoWeek}
                  onClick={async () => {
                    await supabase.from('config').update({ current_week: config.current_week - 1 }).eq('id', 1);
                    onConfigChange();
                  }}
                >-</button>

                <strong style={{
                  margin: '0 5px',
                  color: autoWeek ? '#95a5a6' : '#2c3e50'
                }}>
                  {config?.current_week}
                </strong>

                <button
                  style={{ padding: '2px 8px', cursor: autoWeek ? 'not-allowed' : 'pointer' }}
                  disabled={autoWeek}
                  onClick={async () => {
                    await supabase.from('config').update({ current_week: config.current_week + 1 }).eq('id', 1);
                    onConfigChange();
                  }}
                >+</button>

                {autoWeek && (
                  <span style={{ fontSize: '0.65rem', color: '#2ecc71', fontWeight: 'bold' }}>
                    (AUTO)
                  </span>
                )}
              </div>

              <div>
                T. Activa:
                <select
                  value={config?.current_season || ''}
                  style={{ marginLeft: '5px' }}
                  onChange={async (e) => {
                    const nuevaSeason = parseInt(e.target.value);
                    const { error } = await supabase
                      .from('config')
                      .update({ current_season: nuevaSeason, current_week: 1 })
                      .eq('id', 1);
                    onConfigChange();
                  }}
                >
                  {availableSeasons.map(s => <option key={s} value={s}>T{s}</option>)}
                </select>
              </div>
            </div>

            {/* NUEVO: Checkbox de control automático */}
            <div style={{ borderTop: '1px solid #eee', paddingTop: '10px' }}>
              <label style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                fontSize: '0.8rem',
                cursor: 'pointer',
                color: autoWeek ? '#2ecc71' : '#7f8c8d',
                fontWeight: autoWeek ? 'bold' : 'normal'
              }}>
                <input
                  type="checkbox"
                  checked={autoWeek} // Usamos el estado local
                  onChange={async (e) => {
                    const checked = e.target.checked;

                    // 1. Cambio visual INSTANTÁNEO
                    setAutoWeek(checked);

                    // 2. Guardar en Base de Datos
                    const { error } = await supabase
                      .from('season_rules')
                      .update({ autoWeek: checked })
                      .eq('season', config.current_season);

                    if (error) {
                      alert("Error al guardar en DB");
                      setAutoWeek(!checked); // Revertimos si falla
                    } else {
                      // 3. Informar al padre de forma silenciosa para actualizar el estado global
                      onConfigChange();
                    }
                  }}
                />
                Actualizar jornada por fecha automáticamente
              </label>
            </div>
          </div>
        </>
      )}



      {isAdminReal && (
        <>
          {/* 2. GESTIÓN TEMPORADAS */}
          <div style={{ background: '#fff5f5', padding: '15px', borderRadius: '8px', border: '1px solid #feb2b2' }}>
            <h4 style={{ marginTop: 0 }}>Gestión de Temporadas</h4>
            <div style={{ display: 'flex', gap: '10px', marginBottom: '15px', borderBottom: '1px solid #fed7d7', paddingBottom: '15px' }}>
              <button onClick={abrirSelectorUsuarios} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '8px 12px', borderRadius: '5px', fontWeight: 'bold', cursor: 'pointer' }}>
                + NUEVA TEMPORADA
              </button>
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: '5px' }}>
                <select value={seasonToDelete} onChange={e => setSeasonToDelete(e.target.value)} style={{ padding: '5px' }}>
                  {availableSeasons.map(s => <option key={s} value={s}>Temporada {s}</option>)}
                </select>
                <button onClick={eliminarTemporada} disabled={loading} style={{ background: '#e74c3c', color: 'white', border: 'none', padding: '8px', borderRadius: '5px', cursor: 'pointer' }}>
                  BORRAR
                </button>
              </div>
            </div>

            {showUserSelector && (
              <div style={{ background: 'white', padding: '15px', borderRadius: '8px', border: '1px solid #ddd' }}>
                <h3>Reparto de Divisiones</h3>
                <select value={numDivisions} onChange={e => setNumDivisions(parseInt(e.target.value))}>
                  <option value={1}>1 División</option><option value={2}>2 Divisiones</option><option value={3}>3 Divisiones</option>
                </select>

                {/* CHECKBOXES DE MODALIDAD */}
                <label style={{ fontSize: '0.85rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '5px' }}>
                  <input
                    type="checkbox"
                    checked={isIdaVuelta}
                    onChange={() => setIsIdaVuelta(true)}
                  /> Ida y Vuelta
                </label>
                <label style={{ fontSize: '0.85rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '5px' }}>
                  <input
                    type="checkbox"
                    checked={!isIdaVuelta}
                    onChange={() => setIsIdaVuelta(false)}
                  /> Solo Ida
                </label>

                {/* CONTENEDOR GRID DE REPARTO */}
                <div style={{
                  display: 'grid',
                  gridTemplateColumns: `repeat(${numDivisions + 1}, 1fr)`,
                  gap: '15px',
                  marginTop: '20px',
                  alignItems: 'start'
                }}>

                  {/* COLUMNA DE USUARIOS DISPONIBLES */}
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
                    <small style={{ fontWeight: 'bold', color: '#7f8c8d' }}>JUGADORES DISPONIBLES</small>

                    {/* FILTRO RÁPIDO DENTRO DEL SELECTOR */}
                    <input
                      type="text"
                      placeholder="Filtrar..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      style={{ padding: '5px', fontSize: '0.75rem', borderRadius: '4px', border: '1px solid #ddd' }}
                    />

                    <div style={{
                      maxHeight: '300px',
                      overflowY: 'auto',
                      border: '1px solid #eee',
                      padding: '5px',
                      background: '#fafafa',
                      borderRadius: '4px'
                    }}>
                      {availableUsers
                        .filter(u => {
                          const matchesSearch = (u.nick?.toLowerCase().includes(searchTerm.toLowerCase()));
                          const isRetired = u.nick?.toLowerCase().startsWith("retirado");
                          const matchesRetiredFilter = hideRetired ? !isRetired : true;
                          return matchesSearch && matchesRetiredFilter;
                        })
                        .map(u => (
                          <div key={u.id} style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            padding: '6px 4px',
                            borderBottom: '1px solid #eee',
                            fontSize: '0.75rem'
                          }}>
                            <span style={{ fontWeight: assignments[1].includes(u.id) || assignments[2].includes(u.id) || assignments[3].includes(u.id) ? 'bold' : 'normal' }}>
                              {u.nick || 'Sin Nick'}
                            </span>
                            <div style={{ display: 'flex', gap: '2px' }}>
                              <button onClick={() => handleAssign(u.id, 1)} style={{ fontSize: '0.6rem', padding: '2px 4px', cursor: 'pointer', background: assignments[1].includes(u.id) ? '#2ecc71' : '#eee', color: assignments[1].includes(u.id) ? 'white' : 'black', border: '1px solid #ddd' }}>D1</button>
                              {numDivisions >= 2 && <button onClick={() => handleAssign(u.id, 2)} style={{ fontSize: '0.6rem', padding: '2px 4px', cursor: 'pointer', background: assignments[2].includes(u.id) ? '#3498db' : '#eee', color: assignments[2].includes(u.id) ? 'white' : 'black', border: '1px solid #ddd' }}>D2</button>}
                              {numDivisions >= 3 && <button onClick={() => handleAssign(u.id, 3)} style={{ fontSize: '0.6rem', padding: '2px 4px', cursor: 'pointer', background: assignments[3].includes(u.id) ? '#9b59b6' : '#eee', color: assignments[3].includes(u.id) ? 'white' : 'black', border: '1px solid #ddd' }}>D3</button>}
                            </div>
                          </div>
                        ))
                      }
                    </div>
                  </div>

                  {/* COLUMNAS DE LAS DIVISIONES (DINÁMICAS) */}
                  {[...Array(numDivisions)].map((_, i) => (
                    <div key={i} style={{
                      background: '#f0fff4',
                      padding: '10px',
                      borderRadius: '6px',
                      border: '1px solid #c6f6d5',
                      minHeight: '100px'
                    }}>
                      <small style={{ fontWeight: 'bold', color: '#2f855a', display: 'block', marginBottom: '5px' }}>DIVISIÓN {i + 1}</small>
                      <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
                        {assignments[i + 1].map(id => (
                          <div key={id} style={{
                            fontSize: '0.75rem',
                            display: 'flex',
                            justifyContent: 'space-between',
                            background: 'white',
                            padding: '3px 6px',
                            borderRadius: '3px',
                            border: '1px solid #e2e8f0'
                          }}>
                            {availableUsers.find(u => u.id === id)?.nick || "Sin Nick"}
                            <button onClick={() => handleAssign(id, 0)} style={{ color: '#e74c3c', border: 'none', background: 'none', cursor: 'pointer', fontWeight: 'bold' }}>×</button>
                          </div>
                        ))}
                        {assignments[i + 1].length === 0 && <span style={{ fontSize: '0.65rem', color: '#94a3b8', fontStyle: 'italic' }}>Vacía...</span>}
                      </div>
                    </div>
                  ))}
                </div>
                <div style={{ marginTop: '15px' }}>
                  <button onClick={confirmarCreacionTemporada} style={{ background: '#2ecc71', color: 'white', padding: '8px', borderRadius: '4px', border: 'none', cursor: 'pointer' }}>GENERAR</button>
                  <button onClick={() => setShowUserSelector(false)} style={{ marginLeft: '5px', padding: '8px', cursor: 'pointer' }}>Cerrar</button>
                </div>
              </div>
            )}
          </div>
        </>
      )}



      {isAdminReal && (
        <>
          {/* SECCIÓN CONFIGURACIÓN DE COMPETICIÓN */}
          <div style={{ background: '#fffbeb', padding: '15px', borderRadius: '8px', border: '1px solid #fef3c7', marginBottom: '20px' }}>
            <h4 style={{ marginTop: 0, color: '#92400e' }}>⚙️ Configuración de Competición (T{editSeason})</h4>

            {/* FILA 1: BONUS POR DIRECTOS */}
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '15px', alignItems: 'flex-end', marginBottom: '15px', borderBottom: '1px solid #fde68a', paddingBottom: '15px' }}>
              <label style={{ display: 'flex', flexDirection: 'column', fontSize: '0.8rem', gap: '5px' }}>
                <span style={{ fontWeight: 'bold' }}>¿Activar Bonus Directos?</span>
                <input type="checkbox" checked={bonusEnabled} onChange={e => setBonusEnabled(e.target.checked)} style={{ width: '20px', height: '20px' }} />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', fontSize: '0.8rem', gap: '5px' }}>
                <span style={{ fontWeight: 'bold' }}>% Mínimo</span>
                <input type="number" value={minPercentage} onChange={e => setMinPercentage(e.target.value)} style={{ width: '80px', padding: '5px' }} />
              </label>
              <label style={{ display: 'flex', flexDirection: 'column', fontSize: '0.8rem', gap: '5px' }}>
                <span style={{ fontWeight: 'bold' }}>Puntos Extra</span>
                <input type="number" value={extraPoints} onChange={e => setExtraPoints(e.target.value)} style={{ width: '60px', padding: '5px' }} />
              </label>
            </div>

            {/* FILA 2: FAIR PLAY (DIFERENCIA DE GOLES) */}
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '15px', alignItems: 'flex-end' }}>
              <label style={{ display: 'flex', flexDirection: 'column', fontSize: '0.8rem', gap: '5px' }}>
                <span style={{ fontWeight: 'bold' }}>¿Limitar Goles (Fair Play)?</span>
                <input type="checkbox" checked={limitGaEnabled} onChange={e => setLimitGaEnabled(e.target.checked)} style={{ width: '20px', height: '20px' }} />
              </label>

              <label style={{ display: 'flex', flexDirection: 'column', fontSize: '0.8rem', gap: '5px' }}>
                <span style={{ fontWeight: 'bold' }}>Dif. Máxima Liga</span>
                <input
                  type="number"
                  min="1"
                  value={maxGaLeague}
                  onChange={e => setMaxGaLeague(Math.max(1, parseInt(e.target.value) || 1))}
                  style={{ width: '80px', padding: '5px', border: '1px solid #d1d5db', borderRadius: '4px' }}
                />
              </label>

              <button
                onClick={handleSaveRules}
                style={{
                  background: '#f59e0b', color: 'white', border: 'none',
                  padding: '8px 15px', borderRadius: '5px', fontWeight: 'bold', cursor: 'pointer', marginLeft: 'auto'
                }}
              >
                GUARDAR TODO
              </button>
            </div>
          </div>
        </>
      )}




      {/* 3. EDITOR RESULTADOS (MEJORADO) */}
      <div style={{ background: 'white', padding: '20px', borderRadius: '12px', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
        <h4 style={{ marginTop: 0, color: '#2c3e50', borderBottom: '2px solid #2ecc71', paddingBottom: '10px' }}>Marcadores Rápidos</h4>
        <div style={{ display: 'flex', gap: '10px', marginBottom: '15px', flexWrap: 'wrap' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
            <label style={{ fontSize: '0.75rem', fontWeight: 'bold' }}>TEMP:</label>
            <select style={{ padding: '5px' }} value={editSeason} onChange={e => setEditSeason(parseInt(e.target.value))}>
              {availableSeasons.map(s => <option key={s} value={s}>T{s}</option>)}
            </select>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
            <label style={{ fontSize: '0.75rem', fontWeight: 'bold' }}>DIV:</label>
            <select style={{ padding: '5px' }} value={editDiv} onChange={e => setEditDiv(parseInt(e.target.value))}>
              <option value={1}>D1</option><option value={2}>D2</option><option value={3}>D3</option>
            </select>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
            <label style={{ fontSize: '0.75rem', fontWeight: 'bold' }}>JORNADA:</label>
            <input type="number" value={editWeek} onChange={e => setEditWeek(parseInt(e.target.value))} style={{ width: '45px', padding: '5px' }} />
          </div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column' }}>
          {partidosEdit.length === 0 ? (
            <p style={{ fontSize: '0.8rem', color: '#95a5a6', textAlign: 'center' }}>No hay partidos para este filtro.</p>
          ) : (
            partidosEdit.map(p => (
              <PartidoEditable key={p.id} partido={p} onUpdate={handleUpdateMatch} />
            ))
          )}
        </div>
      </div>




      {isAdminReal && (
        <>
          {/* SECCIÓN GESTIÓN DE USUARIOS */}
          <div style={{ background: 'white', padding: '15px', borderRadius: '12px', border: '1px solid #ddd', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
            <h4 style={{ marginTop: 0, color: '#2c3e50', borderBottom: '2px solid #3498db', paddingBottom: '10px' }}>👥 Gestión de Usuarios ({filteredUsers.length})</h4>

            {/* CONTROL DE REGISTRO DE NUEVOS USUARIOS */}
            <div style={{
              marginBottom: '15px',
              padding: '10px',
              background: allowReg ? '#f0fff4' : '#fff5f5',
              borderRadius: '8px',
              border: allowReg ? '1px solid #c6f6d5' : '1px solid #fed7d7',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between'
            }}>
              <label style={{
                display: 'flex',
                alignItems: 'center',
                gap: '10px',
                fontSize: '0.9rem',
                cursor: 'pointer',
                fontWeight: 'bold',
                color: allowReg ? '#2f855a' : '#c53030'
              }}>
                <input
                  type="checkbox"
                  checked={!allowReg} // Marcamos si "impedimos" el registro
                  onChange={async (e) => {
                    const valueToBlock = e.target.checked; // Si está marcado, queremos bloquear (false)
                    const newValue = !valueToBlock;

                    setAllowReg(newValue); // Cambio visual rápido

                    const { error } = await supabase
                      .from('config')
                      .update({ allow_registration: newValue })
                      .eq('id', 1);

                    if (error) {
                      alert("Error al actualizar configuración");
                      setAllowReg(!newValue);
                    } else {
                      onConfigChange(); // Avisar al resto de la app
                    }
                  }}
                />
                BLOQUEAR NUEVOS REGISTROS
              </label>
              <span style={{ fontSize: '0.7rem', fontWeight: 'normal' }}>
                {allowReg ? "✅ Inscripciones abiertas" : "🚫 Inscripciones cerradas"}
              </span>
            </div>

            {/* BUSCADOR */}
            <div style={{ marginBottom: '15px' }}>
              <input
                type="text"
                placeholder="🔍 Filtrar por Nick o Email..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                style={{ width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #ddd', fontSize: '0.85rem' }}
              />
            </div>

            <div style={{ maxHeight: '400px', overflowY: 'auto' }}>
              {/* CABECERA (Añadido Teléfono) */}
              <div style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1.2fr 1fr 1fr auto',
                gap: '8px', padding: '8px',
                background: '#f8f9fa', fontWeight: 'bold', fontSize: '0.65rem'
              }}>
                <span>NICK</span><span>EMAIL</span><span>TELEGRAM</span><span>TELÉFONO</span><span>ACC.</span>
              </div>

              {/* LISTA FILTRADA */}
              {filteredUsers.length === 0 ? (
                <p style={{ textAlign: 'center', fontSize: '0.8rem', color: '#95a5a6', padding: '20px' }}>
                  No se han encontrado usuarios con estos filtros.
                </p>
              ) : (
                filteredUsers.map(u => (
                  <UserRow key={u.id} user={u} onRefresh={fetchUsers} />
                ))
              )}
            </div>
            {/* CHECKBOX PARA OCULTAR RETIRADOS */}
            <div style={{ marginTop: '15px', padding: '10px 5px', borderTop: '1px solid #eee' }}>
              <label style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                fontSize: '0.85rem',
                cursor: 'pointer',
                color: '#7f8c8d'
              }}>
                <input
                  type="checkbox"
                  checked={hideRetired}
                  onChange={(e) => setHideRetired(e.target.checked)}
                />
                Ocultar usuarios retirados
              </label>
              <label style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '0.85rem', cursor: 'pointer', color: onlyNoGame ? '#3498db' : '#7f8c8d', fontWeight: onlyNoGame ? 'bold' : 'normal' }}>
                <input
                  type="checkbox"
                  checked={onlyNoGame}
                  onChange={(e) => setOnlyNoGame(e.target.checked)}
                />
                Mostrar solo sin juego (T{config?.current_season})
              </label>
            </div>
          </div>

          {/* SECCIÓN COLABORADORES */}
          <div style={{
            background: 'white',
            padding: '20px',
            borderRadius: '12px',
            border: '1px solid #ddd',
            marginBottom: '20px',
            boxShadow: '0 2px 10px rgba(0,0,0,0.05)'
          }}>
            <h4 style={{
              marginTop: 0,
              color: '#2c3e50',
              borderBottom: '2px solid #3498db',
              paddingBottom: '10px'
            }}>
              🤝 Gestión de Colaboradores
            </h4>

            {/* Buscador de nuevos colaboradores */}
            <div style={{ position: 'relative', marginBottom: '15px', marginTop: '15px' }}>
              <input
                type="text"
                placeholder="🔍 Buscar usuario para hacer colaborador..."
                value={colaboradorSearch}
                onChange={(e) => {
                  setColaboradorSearch(e.target.value);
                  setShowColaboradorResults(e.target.value.length > 0);
                }}
                style={{
                  width: '100%',
                  padding: '10px',
                  borderRadius: '8px',
                  border: '1px solid #ddd',
                  fontSize: '0.9rem'
                }}
              />

              {showColaboradorResults && (
                <div style={{
                  position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 10,
                  background: 'white', border: '1px solid #ddd', borderRadius: '8px',
                  maxHeight: '200px', overflowY: 'auto', boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
                }}>
                  {availableUsers
                    .filter(u => u.nick?.toLowerCase().includes(colaboradorSearch.toLowerCase()) && !u.is_colaborador)
                    .map(u => (
                      <div key={u.id}
                        onClick={() => toggleColaborador(u.id, true)}
                        style={{
                          padding: '12px',
                          cursor: 'pointer',
                          borderBottom: '1px solid #eee',
                          fontSize: '0.85rem',
                          color: '#2c3e50'
                        }}
                        onMouseEnter={(e) => e.target.style.background = '#f8f9fa'}
                        onMouseLeave={(e) => e.target.style.background = 'transparent'}
                      >
                        ➕ Añadir <b>{u.nick}</b>
                      </div>
                    ))}
                  {availableUsers.filter(u => u.nick?.toLowerCase().includes(colaboradorSearch.toLowerCase()) && !u.is_colaborador).length === 0 && (
                    <div style={{ padding: '12px', fontSize: '0.8rem', color: '#95a5a6' }}>No se encontraron usuarios...</div>
                  )}
                </div>
              )}
            </div>

            {/* Lista de colaboradores actuales */}
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
              {colaboradores.length === 0 ? (
                <span style={{ fontSize: '0.8rem', color: '#95a5a6', fontStyle: 'italic' }}>
                  No hay colaboradores asignados actualmente.
                </span>
              ) : (
                colaboradores.map(c => (
                  <div key={c.id} style={{
                    background: '#f8f9fa',
                    padding: '6px 14px',
                    borderRadius: '20px',
                    border: '1px solid #3498db',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px',
                    fontSize: '0.85rem',
                    fontWeight: 'bold',
                    color: '#3498db'
                  }}>
                    {c.nick}
                    <button
                      onClick={() => toggleColaborador(c.id, false)}
                      title="Quitar colaborador"
                      style={{
                        background: 'none', border: 'none', color: '#e74c3c',
                        cursor: 'pointer', fontWeight: 'bold', fontSize: '1.2rem',
                        padding: '0', display: 'flex', alignItems: 'center'
                      }}
                    >
                      ×
                    </button>
                  </div>
                ))
              )}
            </div>
          </div>
        </>
      )}

      {isAdminReal && (
        <>
          {/* 4. CALENDARIO DE FECHAS */}
          <div style={{ background: '#eef2f7', padding: '15px', borderRadius: '8px', border: '1px solid #d1d9e6' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
              <h4 style={{ margin: 0 }}>📅 Calendario T{config?.current_season}</h4>
              <button onClick={resetCalendarioSemanas} style={{ fontSize: '0.7rem', background: '#3498db', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}>Resetear a 1 Semana</button>
            </div>
            <table style={{ width: '100%', fontSize: '0.75rem', borderCollapse: 'collapse' }}>
              <thead><tr style={{ textAlign: 'left', borderBottom: '1px solid #ccc' }}><th>J</th><th>Unir</th><th>Apertura</th><th>Cierre Plazo</th></tr></thead>
              <tbody>
                {schedule.map((s, i) => (
                  <tr key={s.id} style={{ borderBottom: '1px solid #eee' }}>
                    <td style={{ padding: '8px 0' }}>J{s.week}</td>
                    <td>{i > 0 && <input type="checkbox" checked={s.is_linked} onChange={() => toggleLink(i)} />}</td>
                    <td><input type="datetime-local" value={toLocalISO(s.start_at)} disabled={s.is_linked} onChange={(e) => handleDateChange(i, 'start_at', new Date(e.target.value).toISOString())} /></td>
                    <td><input type="datetime-local" value={toLocalISO(s.end_at)} onChange={(e) => handleDateChange(i, 'end_at', new Date(e.target.value).toISOString())} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}

      {/* 5. SWITCH PLAYER  */}
      {isAdminReal && (
        <>
          <div style={{ marginBottom: '20px' }}>
            <button
              onClick={() => setShowSwitch(!showSwitch)}
              style={{
                width: '100%',
                padding: '12px',
                background: '#34495e',
                color: 'white',
                border: 'none',
                borderRadius: '8px',
                fontWeight: 'bold',
                cursor: 'pointer',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}
            >
              <span>🔄 Sustituir jugador en liga (T{config?.current_season})</span>
              <span>{showSwitch ? '▲' : '▼'}</span>
            </button>

            {showSwitch && (
              <SwitchPlayer
                season={config?.current_season}
                availableUsers={availableUsers}
                onComplete={() => {
                  setShowSwitch(false);
                  onConfigChange(); // Refrescar para ver cambios
                }}
              />
            )}
          </div>
        </>
      )}

      {/* 5. RESCHEDULER  */}
      {isAdminReal && (
        <div style={{ marginBottom: '20px' }}>
          <button
            onClick={() => setShowReschedule(!showReschedule)}
            style={{
              width: '100%',
              padding: '12px',
              background: '#16a085', // Un color verde azulado diferente
              color: 'white',
              border: 'none',
              borderRadius: '8px',
              fontWeight: 'bold',
              cursor: 'pointer',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}
          >
            <span>📅 Gestionar adelantos y retrasos</span>
            <span>{showReschedule ? '▲' : '▼'}</span>
          </button>

          {showReschedule && (
            <MatchesRescheduled
              currentSeason={config?.current_season}
            />
          )}
        </div>
      )}

      {isAdminReal && (
        <>
          {/* 6. INDICADOR DE BASE DE DATOS (AÑADIDO AL FINAL) */}
          <div style={{
            marginTop: '10px',
            padding: '15px',
            borderRadius: '10px',
            textAlign: 'center',
            background: '#f8f9fa',
            border: `2px solid ${dbColor}`,
            boxShadow: '0 2px 5px rgba(0,0,0,0.05)'
          }}>
            <div style={{ color: dbColor, fontWeight: 'bold', fontSize: '1rem', marginBottom: '4px' }}>
              🔌 CONECTADO A: {dbName}
            </div>
            <div style={{ color: '#95a5a6', fontSize: '0.7rem', fontFamily: 'monospace' }}>
              {supabaseUrl}
            </div>
          </div>
        </>
      )}

    </div>
  );
}

function generarCalendario(jugadores, idaYVuelta) {
  const players = [...jugadores];
  // Mezclar jugadores aleatoriamente para que el orden de emparejamientos cambie cada vez
  players.sort(() => Math.random() - 0.5);

  if (players.length % 2 !== 0) players.push({ id: null, nick: 'BYE' });

  const n = players.length;
  const jornadasIda = [];
  const temp = [...players];

  // Algoritmo Round Robin (Sistema de liga)
  for (let j = 0; j < n - 1; j++) {
    for (let i = 0; i < n / 2; i++) {
      const local = temp[i];
      const visitante = temp[n - 1 - i];

      if (local.id && visitante.id) {
        // Alternar quién es local para que sea más justo
        if (j % 2 === 0) {
          jornadasIda.push({ home_team: local.id, away_team: visitante.id, week: j + 1 });
        } else {
          jornadasIda.push({ home_team: visitante.id, away_team: local.id, week: j + 1 });
        }
      }
    }
    // Rotación del algoritmo
    temp.splice(1, 0, temp.pop());
  }

  if (!idaYVuelta) {
    return jornadasIda;
  }

  // Generar la vuelta invirtiendo locales y sumando jornadas
  const numJornadasIda = n - 1;
  const jornadasVuelta = jornadasIda.map(p => ({
    home_team: p.away_team,
    away_team: p.home_team,
    week: p.week + numJornadasIda
  }));

  return [...jornadasIda, ...jornadasVuelta];
}

function UserRow({ user, onRefresh }) {
  const [editNick, setEditNick] = useState(user.nick || '');
  const [editEmail, setEditEmail] = useState(user.email || '');
  const [editTelegram, setEditTelegram] = useState(user.telegram_user || '');
  const [editPhone, setEditPhone] = useState(user.phone || '');
  const [saving, setSaving] = useState(false);

  const status = getOnlineStatus(user.last_seen);

  const hasChanges =
    editNick !== (user.nick || '') ||
    editEmail !== (user.email || '') ||
    editTelegram !== (user.telegram_user || '') ||
    editPhone !== (user.phone || '');

  const handleUpdate = async () => {
    setSaving(true);
    const { error } = await supabase.from('profiles').update({
      nick: editNick,
      email: editEmail,
      telegram_user: editTelegram,
      phone: editPhone
    }).eq('id', user.id);

    if (error) alert(error.message);
    else onRefresh();
    setSaving(false);
  };

  const handleDelete = async () => {
    const confirmacion = window.confirm(
      `¿Quieres eliminar visualmente a ${user.nick}? \n\nSe borrará su foto, email y teléfono, pero sus partidos se mantendrán como 'Usuario Retirado'.`
    );
    if (!confirmacion) return;
    setSaving(true);
    try {
      const { error } = await supabase
        .from('profiles')
        .update({
          nick: `Retirado (${user.nick || 'Sin nombre'})`,
          email: `retirado_${Date.now()}@liga.com`,
          telegram_user: null,
          phone: null,
          avatar_url: null
        })
        .eq('id', user.id);
      if (error) throw error;
      onRefresh();
    } catch (err) {
      alert("Error: " + err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: '1fr 1.2fr 1fr 1fr auto',
      gap: '8px', padding: '14px 8px', // Más padding vertical para el texto de abajo
      borderBottom: '1px solid #eee', alignItems: 'center',
      background: status.active ? '#f0fff4' : 'transparent',
      position: 'relative'
    }}>

      {/* COLUMNA NICK CORREGIDA */}
      <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
        {/* El punto ahora está DENTRO del área del input a la izquierda */}
        <div style={{
          position: 'absolute',
          left: '8px',
          zIndex: 2,
          width: '8px', height: '8px', borderRadius: '50%',
          backgroundColor: status.dot,
          boxShadow: status.active ? '0 0 5px #2ecc71' : 'none'
        }} />

        <input
          style={{
            fontSize: '0.7rem',
            padding: '4px 4px 4px 22px', // Padding izquierdo extra para no tapar el texto con el punto
            width: '100%',
            fontWeight: 'bold',
            border: '1px solid #ddd',
            borderRadius: '4px',
            boxSizing: 'border-box'
          }}
          value={editNick}
          onChange={e => setEditNick(e.target.value)}
        />

        {/* Texto de estado debajo del input */}
        <span style={{
          position: 'absolute',
          bottom: '-15px',
          left: '4px',
          fontSize: '0.55rem',
          color: '#95a5a6',
          whiteSpace: 'nowrap'
        }}>
          {status.text}
        </span>
      </div>

      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%', border: '1px solid #ddd', borderRadius: '4px' }} value={editEmail} onChange={e => setEditEmail(e.target.value)} />
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%', border: '1px solid #ddd', borderRadius: '4px' }} value={editTelegram} onChange={e => setEditTelegram(e.target.value)} placeholder="@Telegram" />
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%', border: '1px solid #ddd', borderRadius: '4px' }} value={editPhone} onChange={e => setEditPhone(e.target.value)} placeholder="+34..." />

      <div style={{ display: 'flex', gap: '4px' }}>
        <button
          onClick={handleUpdate}
          disabled={!hasChanges || saving}
          style={{ background: hasChanges ? '#2ecc71' : '#ccc', color: 'white', border: 'none', borderRadius: '4px', padding: '5px 8px', cursor: 'pointer' }}
        >
          {saving ? '...' : '✓'}
        </button>
        <button
          onClick={handleDelete}
          style={{ background: '#e74c3c', color: 'white', border: 'none', borderRadius: '4px', padding: '5px 8px', cursor: 'pointer' }}
        >
          ×
        </button>
      </div>
    </div>
  );
}