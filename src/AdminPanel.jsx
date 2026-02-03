import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

export default function AdminPanel({ config, onConfigChange }) {
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
  }, [editSeason, editWeek, editDiv]);

  const fetchSeasons = async () => {
    const { data } = await supabase.from('matches').select('season');
    if (data) {
      const unique = [...new Set(data.map(item => item.season))].sort((a, b) => b - a);
      setAvailableSeasons(unique);
      if (unique.length > 0) setSeasonToDelete(unique[0].toString());
    }
  };

  const fetchUsers = async () => {
    const { data } = await supabase.from('profiles').select('id, nick');
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

  const fetchPartidosParaEditar = async () => {
    const { data } = await supabase
      .from('partidos_detallados')
      .select('*')
      .eq('season', editSeason)
      .eq('week', editWeek)
      .eq('division', editDiv);
    setPartidosEdit(data || []);
  };

  // --- LÓGICA DE BORRADO ---
  const eliminarTemporada = async () => {
    if (!seasonToDelete) return;
    const conf = window.confirm(`¿ESTÁS SEGURO? Se borrarán todos los partidos y fechas de la Temporada ${seasonToDelete}. Esta acción no se puede deshacer.`);
    if (!conf) return;

    setLoading(true);
    const s = parseInt(seasonToDelete);
    await supabase.from('matches').delete().eq('season', s);
    await supabase.from('weeks_schedule').delete().eq('season', s);
    
    alert(`Temporada ${s} eliminada.`);
    await fetchSeasons();
    onConfigChange();
    setLoading(false);
  };

  // --- LÓGICA DE FECHAS ---
  const handleDateChange = async (index, field, newValue) => {
    let newSchedule = [...schedule];
    newSchedule[index][field] = newValue;

    for (let i = index; i < newSchedule.length; i++) {
      if (i < newSchedule.length - 1 && !newSchedule[i+1].is_linked) {
        newSchedule[i+1].start_at = newSchedule[i].end_at;
      }
      if (i > 0 && newSchedule[i].is_linked) {
        newSchedule[i].start_at = newSchedule[i-1].start_at;
        newSchedule[i].end_at = newSchedule[i-1].end_at;
      }
    }
    setSchedule(newSchedule);
    await supabase.from('weeks_schedule').upsert(newSchedule);
  };

  const toggleLink = async (index) => {
    const newSchedule = [...schedule];
    newSchedule[index].is_linked = !newSchedule[index].is_linked;
    if (newSchedule[index].is_linked) {
      newSchedule[index].start_at = newSchedule[index-1].start_at;
      newSchedule[index].end_at = newSchedule[index-1].end_at;
    } else {
      newSchedule[index].start_at = newSchedule[index-1].end_at;
      let nextWeek = new Date(newSchedule[index].start_at);
      nextWeek.setDate(nextWeek.getDate() + 7);
      newSchedule[index].end_at = nextWeek.toISOString();
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
          newSchedule[i].start_at = newSchedule[i-1].start_at;
          newSchedule[i].end_at = newSchedule[i-1].end_at;
        } else {
          newSchedule[i].start_at = newSchedule[i-1].end_at;
          let d = new Date(newSchedule[i].start_at);
          d.setDate(d.getDate() + 7);
          newSchedule[i].end_at = d.toISOString();
        }
      }
    }
    setSchedule(newSchedule);
    await supabase.from('weeks_schedule').upsert(newSchedule);
  };

  const handleUpdateMatch = async (id, hScore, aScore, played) => {
    await supabase.from('matches').update({
      home_score: hScore === '' ? null : parseInt(hScore),
      away_score: aScore === '' ? null : parseInt(aScore),
      is_played: played
    }).eq('id', id);
    fetchPartidosParaEditar();
  };

  const toLocalISO = (dateStr) => {
    if (!dateStr) return "";
    const d = new Date(dateStr);
    const tzoffset = d.getTimezoneOffset() * 60000;
    return new Date(d.getTime() - tzoffset).toISOString().slice(0, 16);
  };

  // --- GENERACIÓN TEMPORADA ---
  const handleAssign = (userId, div) => {
    const newAssignments = { ...assignments };
    Object.keys(newAssignments).forEach(d => {
      newAssignments[d] = newAssignments[d].filter(id => id !== userId);
    });
    if (div > 0) newAssignments[div].push(userId);
    setAssignments(newAssignments);
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
      const matches = generarCalendario(players);
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

    setShowUserSelector(false);
    fetchSeasons();
    onConfigChange();
    setLoading(false);
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '25px' }}>
      
      {/* 1. NAVEGACIÓN */}
      <div style={{ background: '#f8f9fa', padding: '15px', borderRadius: '8px', border: '1px solid #ddd', display: 'flex', justifyContent: 'space-between' }}>
        <div>
           Jornada Activa: 
           <button onClick={async () => { await supabase.from('config').update({ current_week: config.current_week - 1 }).eq('id', 1); onConfigChange(); }}>-</button>
           <strong style={{ margin: '0 10px' }}>{config?.current_week}</strong>
           <button onClick={async () => { await supabase.from('config').update({ current_week: config.current_week + 1 }).eq('id', 1); onConfigChange(); }}>+</button>
        </div>
        <div>
          T. Activa: 
          <select value={config?.current_season} onChange={async (e) => {
            await supabase.from('config').update({ current_season: parseInt(e.target.value), current_week: 1 }).eq('id', 1);
            onConfigChange();
          }}>
            {availableSeasons.map(s => <option key={s} value={s}>T{s}</option>)}
          </select>
        </div>
      </div>

      {/* 2. GESTIÓN TEMPORADAS (NUEVA Y BORRADO) */}
      <div style={{ background: '#fff5f5', padding: '15px', borderRadius: '8px', border: '1px solid #feb2b2' }}>
        <h4 style={{ marginTop: 0 }}>Gestión de Temporadas</h4>
        <div style={{ display: 'flex', gap: '10px', marginBottom: '15px', borderBottom: '1px solid #fed7d7', paddingBottom: '15px' }}>
           <button onClick={() => setShowUserSelector(true)} style={{ background: '#2ecc71', color: 'white', border: 'none', padding: '8px 12px', borderRadius: '5px', fontWeight: 'bold' }}>
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
             <div style={{ display: 'grid', gridTemplateColumns: `repeat(${numDivisions + 1}, 1fr)`, gap: '10px', marginTop: '10px' }}>
                <div><small>REGISTRADOS</small>
                  {availableUsers.filter(u => !Object.values(assignments).flat().includes(u.id)).map(u => (
                    <div key={u.id} style={{ fontSize: '0.7rem' }}>{u.nick} {[...Array(numDivisions)].map((_, i) => <button key={i} onClick={() => handleAssign(u.id, i+1)}>D{i+1}</button>)}</div>
                  ))}
                </div>
                {[...Array(numDivisions)].map((_, i) => (
                  <div key={i} style={{ background: '#f0fff4', padding: '5px' }}>
                    <small>DIV {i+1}</small>
                    {assignments[i+1].map(id => (
                      <div key={id} style={{ fontSize: '0.7rem' }}>{availableUsers.find(u => u.id === id)?.nick} <button onClick={() => handleAssign(id, 0)} style={{ color: 'red', border: 'none' }}>x</button></div>
                    ))}
                  </div>
                ))}
             </div>
             <div style={{ marginTop: '15px' }}>
                <button onClick={confirmarCreacionTemporada} style={{ background: '#2ecc71', color: 'white', padding: '8px' }}>GENERAR</button>
                <button onClick={() => setShowUserSelector(false)} style={{ marginLeft: '5px' }}>Cerrar</button>
             </div>
          </div>
        )}
      </div>

      {/* 3. EDITOR RESULTADOS */}
      <div style={{ background: 'white', padding: '15px', borderRadius: '8px', border: '1px solid #eee' }}>
        <h4 style={{ marginTop: 0 }}>Marcadores Rápidos</h4>
        <div style={{ display: 'flex', gap: '5px', marginBottom: '10px' }}>
          <select value={editSeason} onChange={e => setEditSeason(parseInt(e.target.value))}>{availableSeasons.map(s => <option key={s} value={s}>T{s}</option>)}</select>
          <select value={editDiv} onChange={e => setEditDiv(parseInt(e.target.value))}><option value={1}>D1</option><option value={2}>D2</option><option value={3}>D3</option></select>
          <input type="number" value={editWeek} onChange={e => setEditWeek(parseInt(e.target.value))} style={{ width: '45px' }} />
        </div>
        {partidosEdit.map(p => (
          <div key={p.id} style={{ display: 'flex', gap: '8px', fontSize: '0.8rem', marginBottom: '4px' }}>
            <span style={{ flex: 1, textAlign: 'right' }}>{p.local_nick}</span>
            <input type="number" defaultValue={p.home_score} onBlur={(e) => handleUpdateMatch(p.id, e.target.value, p.away_score, true)} style={{ width: '30px' }} />
            <input type="number" defaultValue={p.away_score} onBlur={(e) => handleUpdateMatch(p.id, p.home_score, e.target.value, true)} style={{ width: '30px' }} />
            <span style={{ flex: 1 }}>{p.visitante_nick}</span>
          </div>
        ))}
      </div>

      {/* 4. CALENDARIO DE FECHAS */}
      <div style={{ background: '#eef2f7', padding: '15px', borderRadius: '8px', border: '1px solid #d1d9e6' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
          <h4 style={{ margin: 0 }}>📅 Calendario T{config?.current_season}</h4>
          <button onClick={resetCalendarioSemanas} style={{ fontSize: '0.7rem', background: '#3498db', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px' }}>Resetear a 1 Semana</button>
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

    </div>
  );
}

function generarCalendario(jugadores) {
  const players = [...jugadores];
  if (players.length % 2 !== 0) players.push({ id: null, nick: 'BYE' });
  const n = players.length;
  const jornadasIda = [];
  const temp = [...players];
  for (let j = 0; j < n - 1; j++) {
    for (let i = 0; i < n / 2; i++) {
      if (temp[i].id && temp[n - 1 - i].id) {
        jornadasIda.push({ home_team: temp[i].id, away_team: temp[n - 1 - i].id, week: j + 1 });
      }
    }
    temp.splice(1, 0, temp.pop());
  }
  const jornadasVuelta = jornadasIda.map(p => ({ home_team: p.away_team, away_team: p.home_team, week: p.week + (n - 1) }));
  return [...jornadasIda, ...jornadasVuelta];
}