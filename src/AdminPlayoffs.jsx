import { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

export default function AdminPlayoffs({ config }) {
  const [nombre, setNombre] = useState('');
  const [temporadaSeleccionada, setTemporadaSeleccionada] = useState(config?.current_season);
  const [listaPlayoffs, setListaPlayoffs] = useState([]);
  const [seasons, setSeasons] = useState([]);
  const [selectedTorneo, setSelectedTorneo] = useState(null);
  const [viewBracket, setViewBracket] = useState(null);
  const [viewCalendar, setViewCalendar] = useState(null);
  const [matches, setMatches] = useState([]);
  const [calendarRounds, setCalendarRounds] = useState([]);
  const [allPlayers, setAllPlayers] = useState([]);
  const [search, setSearch] = useState('');
  const [selectedPlayers, setSelectedPlayers] = useState([]);
  const [playoffsConPartidos, setPlayoffsConPartidos] = useState(new Set());
  const [roundSettings, setRoundSettings] = useState({
    "Dieciseisavos": false, "Octavos": false, "Cuartos": false, "Semifinales": false, "Final": false
  });

  const rondasNombres = { 2: "Final", 4: "Semifinales", 8: "Cuartos", 16: "Octavos", 32: "Dieciseisavos" };
  const orderRondas = ["Dieciseisavos", "Octavos", "Cuartos", "Semifinales", "Final"];

  // Función para que el input datetime-local entienda la fecha de la base de datos
  const formatToInput = (isoString) => {
    if (!isoString) return '';
    const date = new Date(isoString);
    // Esto elimina los milisegundos y la "Z" para que el input HTML lo acepte
    return date.toISOString().slice(0, 16);
  };

  useEffect(() => { fetchSeasons(); fetchAllPlayers(); }, []);
  useEffect(() => { if (temporadaSeleccionada) fetchPlayoffs(); }, [temporadaSeleccionada]);

  const fetchSeasons = async () => {
    const { data } = await supabase.from('matches').select('season');
    if (data) {
      const unique = [...new Set(data.map(d => d.season))].sort((a, b) => b - a);
      setSeasons(unique);
    }
  };

  const fetchAllPlayers = async () => {
    const { data } = await supabase.from('profiles').select('id, nick');
    if (data) setAllPlayers(data.sort((a, b) => a.nick.localeCompare(b.nick)));
  };

  const fetchPlayoffs = async () => {
    const { data } = await supabase.from('playoffs').select('*').eq('season', temporadaSeleccionada).order('created_at', { ascending: false });
    if (data) {
      setListaPlayoffs(data);
      checkExistingMatches(data);
    }
  };

  const checkExistingMatches = async (playoffs) => {
    const ids = playoffs.map(p => p.id);
    const { data } = await supabase.from('playoff_matches').select('playoff_id').in('playoff_id', ids);
    const hasMatches = new Set(data?.map(m => m.playoff_id));
    setPlayoffsConPartidos(hasMatches);
  };

  const fetchMatches = async (playoffId) => {
    const { data } = await supabase
      .from('playoff_matches')
      .select('*')
      .eq('playoff_id', playoffId)
      .order('start_date', { ascending: true }) // Ordenamos por fecha primero
      .order('match_order', { ascending: true });

    setMatches(data || []);

    if (data) {
      const calendarData = [];
      // Obtenemos las rondas únicas pero respetando el orden lógico de competición
      const uniqueRounds = [...new Set(data.map(m => m.round))].sort(
        (a, b) => orderRondas.indexOf(a) - orderRondas.indexOf(b)
      );

      uniqueRounds.forEach(r => {
        const matchesInRound = data.filter(m => m.round === r);
        // Agrupamos por match_order para ver si hay ida y vuelta
        const firstMatchOrder = matchesInRound.filter(m => m.match_order === 0);
        const isIdaVuelta = firstMatchOrder.length > 1;

        if (isIdaVuelta) {
          // Buscamos el partido con la fecha más temprana (Ida) y el de la más tardía (Vuelta)
          const sortedByDate = [...firstMatchOrder].sort(
            (a, b) => new Date(a.start_date) - new Date(b.start_date)
          );

          calendarData.push({
            round: r,
            label: `${r} (Ida)`,
            isVuelta: false,
            start_date: sortedByDate[0]?.start_date,
            end_date: sortedByDate[0]?.end_date
          });
          calendarData.push({
            round: r,
            label: `${r} (Vuelta)`,
            isVuelta: true,
            start_date: sortedByDate[1]?.start_date,
            end_date: sortedByDate[1]?.end_date
          });
        } else {
          const singleMatch = matchesInRound[0];
          calendarData.push({
            round: r,
            label: r,
            isVuelta: false,
            start_date: singleMatch?.start_date,
            end_date: singleMatch?.end_date
          });
        }
      });

      // RE-ORDENAR EL CALENDARIO POR FECHA
      // Esto asegura que si una Vuelta quedó antes que una Ida por error, la tabla lo muestre bien
      calendarData.sort((a, b) => new Date(a.start_date) - new Date(b.start_date));

      setCalendarRounds(calendarData);
    }
  };

  const updateCurrentRound = async (playoffId, roundLabel) => {
    const { error } = await supabase
      .from('playoffs')
      .update({ current_round: roundLabel })
      .eq('id', playoffId);

    if (error) {
      alert("Error al actualizar la fase: " + error.message);
    } else {
      // Actualizamos el estado local para que se vea el cambio
      setListaPlayoffs(listaPlayoffs.map(p =>
        p.id === playoffId ? { ...p, current_round: roundLabel } : p
      ));
    }
  };

  const formatDateSimple = (isoString) => {
    if (!isoString) return '';
    const date = new Date(isoString);
    return date.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit' });
  };

  const crearTorneo = async () => {
    if (!nombre.trim()) return alert("Escribe un nombre");
    const { error } = await supabase.from('playoffs').insert([{ name: nombre, season: temporadaSeleccionada, settings: roundSettings }]);
    if (error) alert(error.message); else { setNombre(''); fetchPlayoffs(); }
  };

  const eliminarTorneo = async (id) => {
    if (!confirm("¿Eliminar torneo y sus partidos?")) return;
    await supabase.from('playoffs').delete().eq('id', id);
    fetchPlayoffs();
  };

const updateMatchPlayer = async (roundBase, matchOrder, field, userId) => {
    const val = userId === "" ? null : userId;
    const matchesToUpdate = matches.filter(m =>
      m.round.startsWith(roundBase) && m.match_order === matchOrder
    );

    if (matchesToUpdate.length >= 1) {
      // 1. Actualizar el partido o partidos (Ida/Vuelta)
      if (matchesToUpdate.length === 1) {
        await supabase.from('playoff_matches').update({ [field]: val }).eq('id', matchesToUpdate[0].id);
      } else {
        const sorted = [...matchesToUpdate].sort((a, b) => a.round.includes('(Vuelta)') ? 1 : -1);
        const oppositeField = field === 'home_team' ? 'away_team' : 'home_team';
        await supabase.from('playoff_matches').update({ [field]: val }).eq('id', sorted[0].id);
        await supabase.from('playoff_matches').update({ [oppositeField]: val }).eq('id', sorted[1].id);
      }

      // 2. IMPORTANTE: Tras actualizar, comprobamos si ahora es un BYE para promocionar
      // Pasamos los datos actualizados localmente para la comprobación
      const updatedGroup = matchesToUpdate.map(m => ({ ...m, [field]: val }));
      await checkAndPromoteBye(updatedGroup, viewBracket.id, roundBase, matchOrder);
    }
    fetchMatches(viewBracket.id);
  };

  const generarPlayoff = async () => {
    if (selectedPlayers.length < 2) return alert("Mínimo 2 jugadores");

    const fechaInicioStr = prompt("Fecha y hora inicio (YYYY-MM-DD HH:MM):", new Date().toISOString().slice(0, 16).replace('T', ' '));
    if (!fechaInicioStr) return;

    const numPlayers = selectedPlayers.length;
    // Calculamos el tamaño del bracket (potencia de 2)
    const bracketSize = Math.pow(2, Math.ceil(Math.log2(numPlayers)));
    const shuffled = [...selectedPlayers].sort(() => Math.random() - 0.5);
    const numPartidosReales = numPlayers - (bracketSize / 2);

    try {
      // Guardamos los settings de ida y vuelta en el torneo

      // Creamos un objeto que SOLO contenga las rondas que se van a generar
      const finalSettings = {};
      let tempSize = bracketSize;
      while (tempSize >= 2) {
        const nombreR = rondasNombres[tempSize];
        // Solo guardamos si la ronda existe en nuestro esquema actual
        finalSettings[nombreR] = roundSettings[nombreR] || false;
        tempSize /= 2;
      }
      await supabase.from('playoffs').update({ settings: finalSettings }).eq('id', selectedTorneo.id);

      const inserts = [];
      let playerIdx = 0;
      let currentDate = new Date(fechaInicioStr.replace(' ', 'T'));
      let currentRoundSize = bracketSize;

      // Recorremos las rondas desde la inicial hasta la Final
      while (currentRoundSize >= 2) {
        const rondaNombre = rondasNombres[currentRoundSize];
        const esIdaVuelta = roundSettings[rondaNombre];

        // --- ASIGNACIÓN DE FECHAS DE ESTA RONDA ---
        // 1. Fecha para la IDA
        const start_date_ida = currentDate.toISOString();
        currentDate.setDate(currentDate.getDate() + 7); // La ida dura 1 semana
        const end_date_ida = currentDate.toISOString();

        // 2. Fecha para la VUELTA (si está activa)
        let start_date_vuelta = null;
        let end_date_vuelta = null;
        if (esIdaVuelta) {
          // Añadimos un minuto de margen para que el orden ID sea coherente con el tiempo
          currentDate.setMinutes(currentDate.getMinutes() + 1);
          start_date_vuelta = currentDate.toISOString();
          currentDate.setDate(currentDate.getDate() + 7); // La vuelta dura otra semana
          end_date_vuelta = currentDate.toISOString();
        }

        // --- GENERACIÓN DE PARTIDOS ---
        const numEnfrentamientos = currentRoundSize / 2;

        for (let i = 0; i < numEnfrentamientos; i++) {
          let p1 = null, p2 = null;

          if (currentRoundSize === bracketSize) {
            if (i < numPartidosReales) {
              p1 = shuffled[playerIdx++];
              p2 = shuffled[playerIdx++];
            } else {
              p1 = shuffled[playerIdx++];
              p2 = null;
            }
          }

          // --- PARTIDO DE IDA ---
          inserts.push({
            playoff_id: selectedTorneo.id,
            // Si es ida y vuelta, guardamos "Semifinales (Ida)", si no, solo "Semifinales"
            round: esIdaVuelta ? `${rondaNombre} (Ida)` : rondaNombre,
            match_order: String(i),
            home_team: p1?.id || null,
            away_team: p2?.id || null,
            start_date: start_date_ida,
            end_date: end_date_ida
          });

          // --- PARTIDO DE VUELTA ---
          if (esIdaVuelta) {
            if (currentRoundSize !== bracketSize || (p1 && p2)) {
              inserts.push({
                playoff_id: selectedTorneo.id,
                // Guardamos "Semifinales (Vuelta)"
                round: `${rondaNombre} (Vuelta)`,
                match_order: String(i),
                home_team: p2?.id || null, // Invertimos localía
                away_team: p1?.id || null,
                start_date: start_date_vuelta,
                end_date: end_date_vuelta
              });
            }
          }
        }

        // Preparamos la siguiente ronda
        currentRoundSize /= 2;
        // Añadimos un pequeño espacio de tiempo (ej. 1 hora) antes de la siguiente fase
        currentDate.setHours(currentDate.getHours() + 1);
      }

      const { error } = await supabase.from('playoff_matches').insert(inserts);
      if (error) throw error;

      // Buscamos los partidos de la primera ronda que acabamos de insertar
      const { data: firstRoundMatches } = await supabase
        .from('playoff_matches')
        .select('*')
        .eq('playoff_id', selectedTorneo.id)
        .eq('round', inserts[0].round);

      if (firstRoundMatches) {
        const orders = [...new Set(firstRoundMatches.map(m => m.match_order))];
        for (const order of orders) {
           const group = firstRoundMatches.filter(m => m.match_order === order);
           const roundBase = group[0].round.split(' (')[0];
           // Esta función revisará si falta p1 o p2 y lo mandará a la siguiente fase
           await checkAndPromoteBye(group, selectedTorneo.id, roundBase, order);
        }
      }

      setSelectedTorneo(null);
      setSelectedPlayers([]);
      fetchPlayoffs();
    } catch (e) {
      console.error(e);
      alert("Error al generar: " + e.message);
    }
  };


  const updateCalendarDates = async (index, field, newValue) => {
    const updated = [...calendarRounds];
    const isoValue = new Date(newValue).toISOString();
    updated[index][field] = isoValue;

    setCalendarRounds(updated);

    const targetRow = updated[index];

    // Buscamos los partidos en Supabase
    const { data: roundMatches } = await supabase
      .from('playoff_matches')
      .select('id, match_order')
      .eq('playoff_id', viewCalendar.id)
      .eq('round', targetRow.round);

    if (!roundMatches) return;

    const orders = [...new Set(roundMatches.map(m => m.match_order))];
    const idsToUpdate = [];

    orders.forEach(order => {
      const matchesOfOrder = roundMatches.filter(m => m.match_order === order)
        .sort((a, b) => new Date(a.start_date) - new Date(b.start_date));

      // Identificamos si es Ida (0) o Vuelta (1) basado en el registro del calendario
      const match = targetRow.isVuelta ? matchesOfOrder[1] : matchesOfOrder[0];
      if (match) idsToUpdate.push(match.id);
    });

    if (idsToUpdate.length > 0) {
      await supabase
        .from('playoff_matches')
        .update({ [field]: isoValue })
        .in('id', idsToUpdate);
    }
  };

  const juntarFechas = async (index) => {
    if (index === 0) return;

    const anterior = calendarRounds[index - 1];

    // Seteamos inicio y fin iguales a la fila superior
    await updateCalendarDates(index, 'start_date', anterior.start_date);
    await updateCalendarDates(index, 'end_date', anterior.end_date);
  };

  const groupedForBracket = matches.reduce((acc, m) => {
    // Extraemos el nombre base: de "Semifinales (Ida)" sacamos "Semifinales"
    const roundBase = m.round.split(' (')[0];

    if (!acc[roundBase]) acc[roundBase] = {};
    if (!acc[roundBase][m.match_order]) acc[roundBase][m.match_order] = [];
    acc[roundBase][m.match_order].push(m);
    return acc;
  }, {});

  const sortedRoundKeys = Object.keys(groupedForBracket).sort((a, b) => orderRondas.indexOf(a) - orderRondas.indexOf(b));

  const checkAndPromoteBye = async (matchGroup, playoffId, roundBase, matchOrder) => {
    // Un matchGroup puede tener 1 partido (Ida) o 2 (Ida y Vuelta)
    const p1 = matchGroup[0].home_team;
    const p2 = matchGroup[0].away_team;

    // Si ambos son null o ambos están presentes, no es un Bye
    if ((!p1 && !p2) || (p1 && p2)) return;

    const ganadorId = p1 || p2; // El que no sea null
    const idx = orderRondas.findIndex(r => r.toLowerCase() === roundBase.toLowerCase());
    const sigRonda = orderRondas[idx + 1];

    if (sigRonda && ganadorId) {
      const sigMatchOrder = String(Math.floor(parseInt(matchOrder) / 2));
      const columna = parseInt(matchOrder) % 2 === 0 ? 'home_team' : 'away_team';

      await supabase.from('playoff_matches')
        .update({ [columna]: ganadorId })
        .eq('playoff_id', playoffId)
        .eq('match_order', sigMatchOrder)
        .ilike('round', `${sigRonda}%`);
    }
  };

  const getAvailablePlayers = (round, matchOrder, currentTeamId) => {
    const roundIndex = orderRondas.indexOf(round);

    // 1. Si es la PRIMERA ronda del torneo (la que esté más a la izquierda)
    // Usamos el índice 0 de sortedRoundKeys para saber cuál es la inicial real
    if (round === sortedRoundKeys[0]) {
      const playersInThisRound = matches
        .filter(m => m.round === round)
        .reduce((acc, m) => {
          if (m.home_team) acc.add(m.home_team);
          if (m.away_team) acc.add(m.away_team);
          return acc;
        }, new Set());
      return allPlayers.filter(p => !playersInThisRound.has(p.id) || p.id === currentTeamId);
    }

    // 2. Para rondas avanzadas:
    const prevRound = orderRondas[roundIndex - 1];
    const sourceMatchOrder1 = matchOrder * 2;
    const sourceMatchOrder2 = matchOrder * 2 + 1;

    // Buscamos quiénes jugaron en los dos partidos que alimentan este cruce
    const prevMatches = matches.filter(m =>
      m.round === prevRound && (m.match_order === sourceMatchOrder1 || m.match_order === sourceMatchOrder2)
    );

    const candidatesIds = new Set();
    prevMatches.forEach(m => {
      if (m.home_team) candidatesIds.add(m.home_team);
      if (m.away_team) candidatesIds.add(m.away_team);
    });

    // IMPORTANTE: Si los partidos previos están vacíos (torneo recién creado), 
    // permitimos elegir de TODA la lista para no bloquear el administrador.
    if (candidatesIds.size === 0) return allPlayers;

    return allPlayers.filter(p => candidatesIds.has(p.id));
  };

  const saveBracketScore = async (partido, scoreL, scoreV) => {
    if (scoreL === '' || scoreV === '') return;

    try {
      const sL = parseInt(scoreL);
      const sV = parseInt(scoreV);

      // 1. Actualizar partido actual
      const { error: errorUpdate } = await supabase
        .from('playoff_matches')
        .update({ home_score: sL, away_score: sV, played: true })
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      // 2. Lógica de Promoción
      const pId = partido.playoff_id;
      const mOrder = parseInt(partido.match_order);
      const faseBase = partido.round.split(' (')[0].trim();
      const esDoble = partido.round.includes('(Ida)') || partido.round.includes('(Vuelta)');
      
      let ganadorId = null;

      if (!esDoble) {
        const idLocal = partido.home_team || partido.local_id;
        const idVisitante = partido.away_team || partido.visitante_id;
        if (sL > sV) ganadorId = idLocal;
        else if (sV > sL) ganadorId = idVisitante;
      } else {
        // BUSCAR EL OTRO PARTIDO PARA EL GLOBAL
        const { data: enfrentamiento } = await supabase
          .from('playoff_matches')
          .select('*')
          .eq('playoff_id', pId)
          .eq('match_order', String(mOrder))
          .ilike('round', `${faseBase}%`);

        const partidoIda = enfrentamiento?.find(m => m.round.includes('(Ida)'));
        const partidoVuelta = enfrentamiento?.find(m => m.round.includes('(Vuelta)'));

        if (partidoIda?.played && partidoVuelta?.played) {
          const idJugadorA = partidoIda.home_team; // Local en la ida
          const idJugadorB = partidoIda.away_team; // Visitante en la ida

          // Goles A = Ida(Casa) + Vuelta(Fuera)
          const golesA = (partidoIda.home_score || 0) + (partidoVuelta.away_score || 0);
          // Goles B = Ida(Fuera) + Vuelta(Casa)
          const golesB = (partidoIda.away_score || 0) + (partidoVuelta.home_score || 0);

          if (golesA > golesB) ganadorId = idJugadorA;
          else if (golesB > golesA) ganadorId = idJugadorB;
        } 
      }

      // 3. ACTUALIZAR RONDA SIGUIENTE (Promover o Limpiar)
      const idx = orderRondas.findIndex(r => r.toLowerCase() === faseBase.toLowerCase());
      const sigRonda = orderRondas[idx + 1];

      if (sigRonda) {
        const sigMatchOrder = String(Math.floor(mOrder / 2));
        const columna = mOrder % 2 === 0 ? 'home_team' : 'away_team';
      
        
        // MUY IMPORTANTE: Actualizamos con el ganadorId (que puede ser null si hay empate)
        // Esto limpia la casilla si el resultado cambia a un empate global.
        await supabase.from('playoff_matches')
          .update({ [columna]: ganadorId })
          .eq('playoff_id', pId)
          .eq('match_order', sigMatchOrder)
          .ilike('round', `${sigRonda}%`);
      }

      fetchMatches(viewBracket.id); 
    } catch (err) {
      console.error("Error crítico en saveBracketScore:", err);
    }
  };

  return (
    <div style={{ padding: '10px', fontSize: '0.85rem', color: '#333' }}>
      <h3 style={{ marginTop: 0 }}>🏆 Gestión de Eliminatorias</h3>

      {!selectedTorneo && !viewBracket && !viewCalendar ? (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          <div style={{ background: '#f8f9fa', padding: '15px', borderRadius: '12px', border: '1px solid #ddd' }}>
            <select value={temporadaSeleccionada} onChange={(e) => setTemporadaSeleccionada(parseInt(e.target.value))} style={{ padding: '8px', width: '100%', marginBottom: '10px' }}>
              {seasons.map(s => <option key={s} value={s}>Temporada {s}</option>)}
            </select>
            <div style={{ display: 'flex', gap: '5px' }}>
              <input type="text" placeholder="Nombre torneo..." value={nombre} onChange={(e) => setNombre(e.target.value)} style={{ flex: 1, padding: '8px' }} />
              <button onClick={crearTorneo} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '8px 12px', borderRadius: '5px' }}>CREAR</button>
            </div>
          </div>

          {listaPlayoffs.map(tp => (
            <div key={tp.id} style={{
              display: 'flex',
              flexDirection: 'column', // Importante para que los radios vayan debajo
              gap: '0px',
              background: 'white',
              border: '1px solid #eee',
              borderRadius: '8px',
              marginBottom: '10px',
              overflow: 'hidden'
            }}>
              {/* PARTE SUPERIOR: Nombre y Botones */}
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                padding: '12px'
              }}>
                <span style={{ fontWeight: 'bold' }}>{tp.name}</span>
                <div style={{ display: 'flex', gap: '5px' }}>
                  <button onClick={() => { setViewBracket(tp); fetchMatches(tp.id); }} style={{ background: '#9b59b6', color: 'white', border: 'none', padding: '6px 10px', borderRadius: '4px' }}>ESQUEMA</button>
                  {playoffsConPartidos.has(tp.id) && (
                    <button onClick={() => { setViewCalendar(tp); fetchMatches(tp.id); }} style={{ background: '#f39c12', color: 'white', border: 'none', padding: '6px 10px', borderRadius: '4px' }}>FECHAS</button>
                  )}
                  {!playoffsConPartidos.has(tp.id) && (
                    <button onClick={() => { setSelectedTorneo(tp); setRoundSettings(tp.settings || roundSettings); fetchMatches(tp.id); }} style={{ background: '#3498db', color: 'white', border: 'none', padding: '6px 10px', borderRadius: '4px' }}>JUGADORES</button>
                  )}
                  <button onClick={() => eliminarTorneo(tp.id)} style={{ background: '#ff7675', color: 'white', border: 'none', padding: '6px 10px', borderRadius: '4px' }}>BORRAR</button>
                </div>
              </div>
              {/* PARTE INFERIOR: Radio Buttons de Fase */}
              {playoffsConPartidos.has(tp.id) && (
                <div style={{
                  display: 'flex',
                  flexWrap: 'wrap',
                  gap: '8px',
                  padding: '10px 12px',
                  background: '#fcfcfc',
                  borderTop: '1px dashed #ddd',
                  fontSize: '0.75rem'
                }}>
                  <span style={{ width: '100%', color: '#7f8c8d', fontWeight: 'bold', marginBottom: '2px' }}>FASE ACTUAL:</span>

                  {/* Usamos orderRondas pero solo mostramos las que REALMENTE tienen partidos en este playoff */}
                  {orderRondas
                    .filter(r => {
                      // Buscamos si existe al menos un partido generado para esta ronda en este playoff
                      // Nota: Esto asume que 'matches' contiene los partidos del playoff seleccionado.
                      // Como 'matches' cambia según el botón pulsado, usaremos una lógica basada en el tamaño del torneo
                      // o en los settings que tengan valor true/false.

                      // Mejor opción: Si el torneo se generó, calculamos qué rondas debieron crearse según el número de jugadores
                      // Pero para ser 100% precisos, comprobamos los settings que NO son undefined y pertenecen al rango.
                      return tp.settings && tp.settings[r] !== undefined;
                    })
                    .map(r => {
                      const isIdaVuelta = tp.settings[r];
                      const labels = isIdaVuelta ? [`${r} (Ida)`, `${r} (Vuelta)`] : [r];

                      return labels.map(label => (
                        <label key={label} style={{
                          display: 'flex',
                          alignItems: 'center',
                          gap: '4px',
                          cursor: 'pointer',
                          background: tp.current_round === label ? '#e8f8f5' : 'transparent',
                          padding: '4px 8px',
                          borderRadius: '4px',
                          border: tp.current_round === label ? '1px solid #2ecc71' : '1px solid transparent',
                          transition: 'all 0.2s'
                        }}>
                          <input
                            type="radio"
                            name={`round-${tp.id}`}
                            checked={tp.current_round === label}
                            onChange={() => updateCurrentRound(tp.id, label)}
                          />
                          {label}
                        </label>
                      ));
                    })}

                  <label style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '4px',
                    cursor: 'pointer',
                    padding: '4px 8px',
                    background: (!tp.current_round || tp.current_round === 'Finalizado') ? '#f1f2f6' : 'transparent',
                    borderRadius: '4px'
                  }}>
                    <input
                      type="radio"
                      name={`round-${tp.id}`}
                      checked={!tp.current_round || tp.current_round === 'Finalizado'}
                      onChange={() => updateCurrentRound(tp.id, 'Finalizado')}
                    />
                    Finalizado
                  </label>
                </div>
              )}
            </div>
          ))}
        </div>
      ) : viewCalendar ? (
        <div style={{ background: 'white', padding: '15px', borderRadius: '12px', border: '1px solid #ddd' }}>
          <button onClick={() => setViewCalendar(null)} style={{ marginBottom: '15px', background: '#95a5a6', color: 'white', border: 'none', padding: '8px 15px', borderRadius: '8px' }}>← Volver</button>
          <h4>Calendario: {viewCalendar.name}</h4>
          <table style={{ width: '100%', borderCollapse: 'collapse', marginTop: '10px' }}>
            <thead>
              <tr style={{ background: '#f8f9fa' }}>
                <th style={{ padding: '10px', textAlign: 'left', borderBottom: '2px solid #ddd' }}>Ronda</th>
                <th style={{ padding: '10px', textAlign: 'left', borderBottom: '2px solid #ddd' }}>Apertura</th>
                <th style={{ padding: '10px', textAlign: 'left', borderBottom: '2px solid #ddd' }}>Cierre</th>
                <th style={{ padding: '10px', textAlign: 'center', borderBottom: '2px solid #ddd' }}>Acción</th>
              </tr>
            </thead>
            <tbody>
              {calendarRounds.map((row, idx) => (
                <tr key={`${row.label}-${idx}`} style={{ borderBottom: '1px solid #eee' }}>
                  <td style={{ padding: '10px', fontWeight: 'bold' }}>
                    {row.label}
                  </td>
                  <td style={{ padding: '10px' }}>
                    <input
                      type="datetime-local"
                      value={formatToInput(row.start_date)}
                      onChange={(e) => updateCalendarDates(idx, 'start_date', e.target.value)}
                      style={{ padding: '5px', borderRadius: '4px', border: '1px solid #ccc' }}
                    />
                  </td>
                  <td style={{ padding: '10px' }}>
                    <input
                      type="datetime-local"
                      value={formatToInput(row.end_date)}
                      onChange={(e) => updateCalendarDates(idx, 'end_date', e.target.value)}
                      style={{ padding: '5px', borderRadius: '4px', border: '1px solid #ccc' }}
                    />
                  </td>
                  <td style={{ padding: '10px', textAlign: 'center' }}>
                    {idx > 0 && (
                      <button
                        onClick={() => juntarFechas(idx)}
                        style={{
                          background: calendarRounds[idx].start_date === calendarRounds[idx - 1].start_date ? '#95a5a6' : '#3498db',
                          color: 'white',
                          border: 'none',
                          padding: '5px 10px',
                          borderRadius: '4px',
                          fontSize: '0.7rem',
                          cursor: 'pointer'
                        }}
                      >
                        {calendarRounds[idx].start_date === calendarRounds[idx - 1].start_date ? 'SOLAPADAS' : 'JUNTAR'}
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : viewBracket ? (
        <div>
          <button onClick={() => setViewBracket(null)} style={{ marginBottom: '15px', background: '#95a5a6', color: 'white', border: 'none', padding: '8px 15px', borderRadius: '8px' }}>← Volver</button>
          <div style={{ display: 'flex', overflowX: 'auto', gap: '40px', padding: '20px', background: '#f0f2f5', borderRadius: '12px' }}>
            {sortedRoundKeys.map((round) => {
              // --- LÓGICA PARA CALCULAR FECHAS DE LA COLUMNA ---
              const roundMatches = matches.filter(m => m.round === round);
              const startDates = roundMatches.map(m => new Date(m.start_date)).filter(d => !isNaN(d));
              const endDates = roundMatches.map(m => new Date(m.end_date)).filter(d => !isNaN(d));

              const minStart = startDates.length > 0 ? new Date(Math.min(...startDates)) : null;
              const maxEnd = endDates.length > 0 ? new Date(Math.max(...endDates)) : null;

              return (
                <div key={round} style={{ display: 'flex', flexDirection: 'column', gap: '20px', minWidth: '200px' }}>
                  {/* CABECERA DE RONDA CON FECHAS */}
                  <div style={{
                    textAlign: 'center',
                    background: '#34495e',
                    color: 'white',
                    padding: '6px',
                    borderRadius: '4px',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '2px'
                  }}>
                    <span style={{ fontSize: '0.75rem', fontWeight: 'bold' }}>{round}</span>
                    {minStart && maxEnd && (
                      <span style={{ fontSize: '0.65rem', opacity: 0.9 }}>
                        {formatDateSimple(minStart.toISOString())} - {formatDateSimple(maxEnd.toISOString())}
                      </span>
                    )}
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-around', flexGrow: 1, gap: '30px' }}>
                    {Object.values(groupedForBracket[round]).map((matchGroup, gIdx) => (
                      <div key={`${round}-${gIdx}`} style={{
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '8px',
                        background: '#fff',
                        padding: '10px',
                        borderRadius: '10px',
                        boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
                        border: '1px solid #dcdde1'
                      }}>
                        {/* Iteramos sobre los partidos del grupo (Ida y Vuelta si los hay) */}
                        {matchGroup.map((m, mIdx) => (
                          <div key={m.id} style={{ borderBottom: mIdx === 0 && matchGroup.length > 1 ? '1px dashed #eee' : 'none', paddingBottom: '5px' }}>
                            <div style={{ fontSize: '0.65rem', color: '#7f8c8d', marginBottom: '3px', fontWeight: 'bold' }}>
                              {matchGroup.length > 1 ? (m.round.includes('Ida') ? 'IDA' : 'VUELTA') : 'ÚNICO'}
                            </div>

                            {/* Fila Local */}
                            <div style={{ display: 'flex', alignItems: 'center', gap: '5px', marginBottom: '3px' }}>
                              <select
                                value={m.home_team || ''}
                                onChange={(e) => updateMatchPlayer(round, m.match_order, 'home_team', e.target.value)}
                                style={{ flex: 1, padding: '4px', fontSize: '0.75rem', border: '1px solid #eee' }}
                              >
                                <option value="">-- Bye --</option>
                                {getAvailablePlayers(round, m.match_order, m.home_team).map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
                              </select>
                              <input
                                type="number"
                                placeholder="-"
                                defaultValue={m.home_score}
                                onBlur={(e) => saveBracketScore(m, e.target.value, m.away_score)}
                                style={{ width: '35px', textAlign: 'center', padding: '4px', border: '1px solid #3498db', borderRadius: '4px' }}
                              />
                            </div>

                            {/* Fila Visitante */}
                            <div style={{ display: 'flex', alignItems: 'center', gap: '5px' }}>
                              <select
                                value={m.away_team || ''}
                                onChange={(e) => updateMatchPlayer(round, m.match_order, 'away_team', e.target.value)}
                                style={{ flex: 1, padding: '4px', fontSize: '0.75rem', border: '1px solid #eee' }}
                              >
                                <option value="">-- Bye --</option>
                                {getAvailablePlayers(round, m.match_order, m.away_team).map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
                              </select>
                              <input
                                type="number"
                                placeholder="-"
                                defaultValue={m.away_score}
                                onBlur={(e) => saveBracketScore(m, m.home_score, e.target.value)}
                                style={{ width: '35px', textAlign: 'center', padding: '4px', border: '1px solid #3498db', borderRadius: '4px' }}
                              />
                            </div>
                          </div>
                        ))}
                      </div>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      ) : (
        <div style={{ background: '#fff', padding: '15px', border: '1px solid #3498db', borderRadius: '12px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '15px' }}>
            <button onClick={() => { setSelectedTorneo(null); setSelectedPlayers([]); }} style={{ background: '#95a5a6', color: 'white', border: 'none', padding: '8px 15px', borderRadius: '8px' }}>← Volver</button>
            <span style={{ background: '#2ecc71', color: 'white', padding: '8px 15px', borderRadius: '50px', fontWeight: 'bold', fontSize: '0.9rem', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' }}>
              👤 {selectedPlayers.length} Jugadores
            </span>
          </div>
          <h4>Configurar: {selectedTorneo.name}</h4>
          <input type="text" placeholder="Buscar jugador..." value={search} onChange={(e) => setSearch(e.target.value)} style={{ width: '100%', padding: '10px', marginBottom: '10px', borderRadius: '8px', border: '1px solid #ddd' }} />
          <div style={{ maxHeight: '400px', overflowY: 'auto', border: '1px solid #eee', padding: '5px', borderRadius: '8px', background: '#fafafa' }}>
            {allPlayers.filter(p => p.nick.toLowerCase().includes(search.toLowerCase())).map(p => {
              const isSelected = selectedPlayers.find(sp => sp.id === p.id);
              return (
                <div key={p.id} onClick={() => {
                  if (isSelected) setSelectedPlayers(selectedPlayers.filter(sp => sp.id !== p.id));
                  else setSelectedPlayers([...selectedPlayers, p]);
                }} style={{
                  padding: '12px', cursor: 'pointer', background: isSelected ? '#e8f8f5' : 'white',
                  borderRadius: '8px', marginBottom: '6px', display: 'flex', justifyContent: 'space-between',
                  border: isSelected ? '2px solid #2ecc71' : '1px solid #eee'
                }}>
                  <span>{p.nick}</span>
                  {isSelected ? <span style={{ color: '#2ecc71' }}>● Seleccionado</span> : <span style={{ color: '#ccc' }}>○</span>}
                </div>
              );
            })}
          </div>
          <div style={{ margin: '15px 0', padding: '12px', background: '#f4f7f6', borderRadius: '10px', border: '1px solid #e0e0e0' }}>
            <p style={{ margin: '0 0 8px 0', fontWeight: 'bold', fontSize: '0.75rem', color: '#7f8c8d' }}>AJUSTES DE IDA Y VUELTA:</p>
            {Object.keys(rondasNombres).filter(k => k <= Math.pow(2, Math.ceil(Math.log2(selectedPlayers.length || 2)))).map(k => (
              <label key={k} style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '0.85rem', marginBottom: '6px', cursor: 'pointer' }}>
                <input type="checkbox" checked={roundSettings[rondasNombres[k]]} onChange={(e) => setRoundSettings({ ...roundSettings, [rondasNombres[k]]: e.target.checked })} />
                Ronda de {rondasNombres[k]}
              </label>
            ))}
          </div>
          <button onClick={generarPlayoff} disabled={selectedPlayers.length < 2} style={{ width: '100%', padding: '15px', background: selectedPlayers.length < 2 ? '#bdc3c7' : '#2ecc71', color: 'white', border: 'none', borderRadius: '10px', fontWeight: 'bold', fontSize: '1rem' }}>
            GENERAR CUADRO AHORA
          </button>
        </div>
      )}
    </div>
  );
}