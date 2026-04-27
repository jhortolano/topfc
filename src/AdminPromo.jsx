import React, { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';

const AdminPromo = ({ config, profile }) => {
  const [seasons, setSeasons] = useState([]);
  const [selectedSeason, setSelectedSeason] = useState(config?.current_season);
  const [loading, setLoading] = useState(false);

  // Configuración de generación
  const [directos, setDirectos] = useState(2);
  const [promocionan, setPromocionan] = useState(1);
  const [isIdaVuelta, setIsIdaVuelta] = useState(false);
  const [startDate, setStartDate] = useState('');

  // Datos de UI
  const [existingMatches, setExistingMatches] = useState([]);
  const [promoWeeks, setPromoWeeks] = useState([]); // Nuevo estado para fechas de semanas
  const [allPlayers, setAllPlayers] = useState([]);

  useEffect(() => {
    fetchSeasons();
    fetchPlayers();
    if (selectedSeason) fetchExistingData();
  }, [selectedSeason]);

  const fetchSeasons = async () => {
    const { data } = await supabase.from('season_rules').select('season').order('season', { ascending: false });
    if (data) setSeasons(data);
  };

  const fetchPlayers = async () => {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, nick')
      .not('nick', 'ilike', 'Retirado%')
      .order('nick', { ascending: true });

    if (error) {
      console.error("Error cargando jugadores:", error);
    } else {
      setAllPlayers(data || []);
    }
  };

  const fetchExistingData = async () => {
    // 1. Cargar Partidos
    const { data: matches } = await supabase.from('promo_matches')
      .select('*')
      .eq('season', selectedSeason)
      .order('division', { ascending: true })
      .order('idavuelta', { ascending: true });
    setExistingMatches(matches || []);

    // 2. Cargar Semanas (weeks_promo)
    const { data: weeks } = await supabase.from('weeks_promo')
      .select('*')
      .eq('season', selectedSeason)
      .order('idavuelta', { ascending: true });
    setPromoWeeks(weeks || []);
  };

  // Función para actualizar fechas de la semana directamente
  const handleUpdateWeek = async (id, field, value) => {
    const { error } = await supabase
      .from('weeks_promo')
      .update({ [field]: value })
      .eq('id', id);

    if (error) {
      alert("Error al actualizar la fecha");
    } else {
      // Actualizamos estado local para no recargar todo si no quieres
      setPromoWeeks(prev => prev.map(w => w.id === id ? { ...w, [field]: value } : w));
    }
  };

  const handleUpdateMatchPlayer = async (matchId, field, userId, index) => {
    const { error } = await supabase
      .from('promo_matches')
      .update({ [field]: userId })
      .eq('id', matchId);

    if (error) {
      alert("Error al actualizar el jugador en la base de datos");
    } else {
      // Actualizamos el estado local para que la UI refleje el cambio
      const updated = [...existingMatches];
      updated[index][field] = userId;
      setExistingMatches(updated);
    }
  };

  const generarPromociones = async () => {
    if (!startDate) return alert("Selecciona la fecha de inicio de los partidos.");
    setLoading(true);

    try {
      const { data: standings, error: errStand } = await supabase
        .from('clasificacion')
        .select('user_id, division, pts, dg, gf, pj') // Traemos todas las columnas necesarias
        .eq('season', selectedSeason)
        .order('division', { ascending: true })   // 1º Por división
        .order('pts', { ascending: false })        // 2º Más Puntos
        .order('dg', { ascending: false })         // 3º Mejor Diferencia Goles
        .order('gf', { ascending: false })         // 4º Más Goles Favor
        .order('pj', { ascending: true });         // 5º Menos Partidos Jugados

      if (errStand) throw errStand;
      if (!standings || standings.length === 0) {
        alert("No hay datos en la clasificación para esta temporada.");
        setLoading(false);
        return;
      }

      const divData = standings.reduce((acc, curr) => {
        if (!acc[curr.division]) acc[curr.division] = [];
        acc[curr.division].push(curr);
        return acc;
      }, {});

      const divisions = Object.keys(divData).map(Number).sort((a, b) => a - b);
      const matchesToInsert = [];
      const weeksToInsert = [];

      const fechaInicio = new Date(startDate);
      const fechaFinIda = new Date(fechaInicio);
      fechaFinIda.setDate(fechaFinIda.getDate() + 7);

      weeksToInsert.push({
        season: selectedSeason,
        start_at: fechaInicio.toISOString(),
        end_at: fechaFinIda.toISOString(),
        idavuelta: 'ida'
      });

      if (isIdaVuelta) {
        const fechaFinVuelta = new Date(fechaFinIda);
        fechaFinVuelta.setDate(fechaFinVuelta.getDate() + 7);
        weeksToInsert.push({
          season: selectedSeason,
          start_at: fechaFinIda.toISOString(),
          end_at: fechaFinVuelta.toISOString(),
          idavuelta: 'vuelta'
        });
      }

      for (let i = 0; i < divisions.length - 1; i++) {
        const dSuperior = divisions[i];
        const dInferior = divisions[i + 1];
        const playersSup = divData[dSuperior] || [];
        const playersInf = divData[dInferior] || [];

        const startSup = playersSup.length - directos - promocionan;
        const candidatesSup = playersSup.slice(startSup, startSup + promocionan);
        const candidatesInf = playersInf.slice(directos, directos + promocionan);

        candidatesSup.reverse().forEach((pSup, idx) => {
          const pInf = candidatesInf[idx];
          if (!pSup || !pInf) return;

          // Etiqueta solicitada: "Promoción a Div X"
          const info = `Promoción a Div ${dSuperior}`;

          matchesToInsert.push({
            player1_id: pSup.user_id,
            player2_id: pInf.user_id,
            divplayer1: dSuperior,
            divplayer2: dInferior,
            season: selectedSeason,
            division: dSuperior,
            idavuelta: 'ida',
            label_info: info
          });

          if (isIdaVuelta) {
            matchesToInsert.push({
              player1_id: pInf.user_id,
              player2_id: pSup.user_id,
              divplayer1: dInferior,
              divplayer2: dSuperior,
              season: selectedSeason,
              division: dSuperior,
              idavuelta: 'vuelta',
              label_info: info
            });
          }
        });
      }

      if (weeksToInsert.length > 0) await supabase.from('weeks_promo').insert(weeksToInsert);
      if (matchesToInsert.length > 0) await supabase.from('promo_matches').insert(matchesToInsert);

      alert("Partidos de promoción generados correctamente.");
      fetchExistingData();
    } catch (err) {
      console.error("Error:", err);
      alert("Error crítico: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async (m) => {
    const { error } = await supabase.from('promo_matches')
      .update({
        player1_id: m.player1_id,
        player2_id: m.player2_id,
        score1: m.score1,
        score2: m.score2,
        stream_url: m.stream_url,
        is_played: true,
        updated_at: new Date()
      })
      .eq('id', m.id);

    if (error) alert("Error al guardar.");
    else alert("Partido actualizado.");
  };

  const handleReset = async (m, index) => {
    const confirmar = window.confirm("¿Estás seguro de que quieres resetear este partido? Se borrará el resultado y el stream.");
    if (!confirmar) return;

    const { error } = await supabase.from('promo_matches')
      .update({
        score1: null,
        score2: null,
        stream_url: null,
        is_played: false,
        updated_at: new Date()
      })
      .eq('id', m.id);

    if (error) {
      alert("Error al resetear.");
    } else {
      // Actualizamos el estado local para que los inputs se vacíen visualmente
      const updated = [...existingMatches];
      updated[index].score1 = null;
      updated[index].score2 = null;
      updated[index].stream_url = null;
      updated[index].is_played = false;
      setExistingMatches(updated);
      alert("Partido reseteado.");
    }
  };

  const borrarPromociones = async () => {
    const confirmar = window.confirm(`¿Estás seguro de que quieres borrar TODOS los partidos y semanas de promoción de la Temporada ${selectedSeason}?`);
    if (!confirmar) return;

    setLoading(true);
    try {
      await supabase.from('promo_matches').delete().eq('season', selectedSeason);
      await supabase.from('weeks_promo').delete().eq('season', selectedSeason);
      alert("Datos de promoción eliminados.");
      setExistingMatches([]);
      setPromoWeeks([]);
    } catch (err) {
      console.error(err);
      alert("Hubo un error al intentar borrar.");
    } finally {
      setLoading(false);
    }
  };

  const formatToInput = (dateStr) => {
    if (!dateStr) return '';
    return dateStr.substring(0, 16);
  };

  if (!profile?.is_admin) return null;

  return (
    <div style={{ padding: '5px' }}>
      <h2 style={{ color: '#2c3e50', borderBottom: '2px solid #2ecc71', marginBottom: '15px' }}>Partidos de Promociones</h2>

      {/* CONFIGURADOR */}
      <div style={{ background: '#f9f9f9', padding: '15px', borderRadius: '8px', border: '1px solid #eee', marginBottom: '20px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(140px, 1fr))', gap: '10px' }}>
          <div>
            <label style={{ display: 'block', fontSize: '0.75rem' }}>Temporada</label>
            <select style={{ width: '100%' }} value={selectedSeason} onChange={e => setSelectedSeason(e.target.value)}>
              {seasons.map(s => <option key={s.season} value={s.season}>T {s.season}</option>)}
            </select>
          </div>
          <div>
            <label style={{ display: 'block', fontSize: '0.75rem' }}>Desc. Directo</label>
            <input type="number" style={{ width: '100%' }} value={directos} onChange={e => setDirectos(parseInt(e.target.value))} />
          </div>
          <div>
            <label style={{ display: 'block', fontSize: '0.75rem' }}>A Promocionar</label>
            <input type="number" style={{ width: '100%' }} value={promocionan} onChange={e => setPromocionan(parseInt(e.target.value))} />
          </div>
          <div>
            <label style={{ display: 'block', fontSize: '0.75rem' }}>Fecha Inicio</label>
            <input type="datetime-local" style={{ width: '100%' }} value={startDate} onChange={e => setStartDate(e.target.value)} />
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '5px', paddingTop: '15px' }}>
            <input type="checkbox" checked={isIdaVuelta} onChange={e => setIsIdaVuelta(e.target.checked)} />
            <label style={{ fontSize: '0.75rem' }}>Ida y Vuelta</label>
          </div>
        </div>
        <div style={{ display: 'flex', gap: '10px', marginTop: '15px' }}>
          <button
            onClick={generarPromociones}
            disabled={loading || existingMatches.length > 0}
            style={{ flex: 3, background: existingMatches.length > 0 ? '#bdc3c7' : '#2ecc71', color: 'white', border: 'none', padding: '10px', borderRadius: '6px', fontWeight: 'bold' }}
          >
            {existingMatches.length > 0 ? 'PROMOCIONES GENERADAS' : 'GENERAR PARTIDOS'}
          </button>
          {existingMatches.length > 0 && (
            <button
              onClick={borrarPromociones}
              disabled={loading}
              style={{ flex: 1, background: '#e74c3c', color: 'white', border: 'none', padding: '10px', borderRadius: '6px', fontWeight: 'bold' }}
            >
              BORRAR T{selectedSeason}
            </button>
          )}
        </div>
      </div>

      {/* GESTIÓN DE FECHAS (WEEKS_PROMO) */}
      {promoWeeks.length > 0 && (
        <div style={{ background: '#fdfefe', padding: '15px', borderRadius: '8px', border: '1px solid #dcdde1', marginBottom: '20px' }}>
          <h4 style={{ margin: '0 0 10px 0', fontSize: '0.9rem', color: '#2f3640' }}>Fechas de Semanas de Promoción</h4>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '15px' }}>
            {promoWeeks.map(week => (
              <div key={week.id} style={{ padding: '10px', border: '1px solid #f1f2f6', borderRadius: '6px', background: '#f8f9fa' }}>
                <div style={{ fontWeight: 'bold', fontSize: '0.75rem', marginBottom: '8px' }}>Partidos de {week.idavuelta.toUpperCase()}</div>
                <div style={{ display: 'flex', gap: '10px' }}>
                  <div style={{ flex: 1 }}>
                    <label style={{ display: 'block', fontSize: '0.65rem' }}>Inicio</label>
                    <input
                      type="datetime-local"
                      style={{ width: '100%', fontSize: '0.8rem' }}
                      value={formatToInput(week.start_at)}
                      onChange={e => handleUpdateWeek(week.id, 'start_at', e.target.value)}
                    />
                  </div>
                  <div style={{ flex: 1 }}>
                    <label style={{ display: 'block', fontSize: '0.65rem' }}>Fin</label>
                    <input
                      type="datetime-local"
                      style={{ width: '100%', fontSize: '0.8rem' }}
                      value={formatToInput(week.end_at)}
                      onChange={e => handleUpdateWeek(week.id, 'end_at', e.target.value)}
                    />
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* LISTA DE PARTIDOS */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {existingMatches.map((m, i) => (
          <div key={m.id} style={{ border: '1px solid #eee', padding: '12px', borderRadius: '10px', background: 'white' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.75rem', color: '#7f8c8d', marginBottom: '8px' }}>
              <strong>{m.label_info}</strong>
              <span style={{ color: '#2ecc71' }}>{m.idavuelta.toUpperCase()}</span>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <select style={{ flex: 1, fontSize: '0.85rem' }} value={m.player1_id} onChange={e => handleUpdateMatchPlayer(m.id, 'player1_id', e.target.value, i)}>
                {allPlayers.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
              </select>
              <input type="number" style={{ width: '45px', textAlign: 'center' }} value={m.score1 || ''} onChange={e => {
                const updated = [...existingMatches]; updated[i].score1 = e.target.value; setExistingMatches(updated);
              }} />
              <span>-</span>
              <input type="number" style={{ width: '45px', textAlign: 'center' }} value={m.score2 || ''} onChange={e => {
                const updated = [...existingMatches]; updated[i].score2 = e.target.value; setExistingMatches(updated);
              }} />
              <select style={{ flex: 1, fontSize: '0.85rem' }} value={m.player2_id} onChange={e => handleUpdateMatchPlayer(m.id, 'player2_id', e.target.value, i)}>
                {allPlayers.map(p => <option key={p.id} value={p.id}>{p.nick}</option>)}
              </select>
            </div>

            <div style={{ marginTop: '10px' }}>
              <input
                type="text"
                placeholder="URL del Stream (Twitch/YouTube...)"
                style={{ width: '100%', padding: '6px', fontSize: '0.8rem' }}
                value={m.stream_url || ''}
                onChange={e => {
                  const updated = [...existingMatches]; updated[i].stream_url = e.target.value; setExistingMatches(updated);
                }}
              />
            </div>

            <div style={{ display: 'flex', gap: '8px', marginTop: '8px' }}>
              <button
                onClick={() => handleSave(m)}
                style={{ flex: 3, padding: '6px', background: '#3498db', color: 'white', border: 'none', borderRadius: '4px', fontSize: '0.85rem', cursor: 'pointer' }}
              >
                Guardar Resultado y Stream
              </button>

              {/* Botón de Reset (solo se muestra si el partido tiene datos o está marcado como jugado) */}
              {(m.is_played || m.score1 !== null || m.stream_url) && (
                <button
                  onClick={() => handleReset(m, i)}
                  style={{ flex: 1, padding: '6px', background: '#95a5a6', color: 'white', border: 'none', borderRadius: '4px', fontSize: '0.85rem', cursor: 'pointer' }}
                >
                  Resetear
                </button>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AdminPromo;