import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

// --- SUB-COMPONENTE PARA FILA DE PARTIDO ---
function PartidoEditable({ partido, onUpdate }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');

  // Sincronizar si el partido cambia desde fuera (ej: cambiar de jornada)
  useEffect(() => {
    setGL(partido.home_score ?? '');
    setGV(partido.away_score ?? '');
  }, [partido]);

  const modificado = gL != (partido.home_score ?? '') || gV != (partido.away_score ?? '');

  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: '10px', padding: '10px',
      background: modificado ? '#ebf8ff' : '#f8f9fa',
      borderRadius: '10px', marginBottom: '8px', border: modificado ? '1px solid #4299e1' : '1px solid #edf2f7',
      transition: 'all 0.2s'
    }}>
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
          onClick={() => onUpdate(partido.id, gL, gV, true)}
          disabled={!modificado}
          title="Guardar"
          style={{
            background: modificado ? '#2ecc71' : '#cbd5e0', color: 'white', border: 'none',
            padding: '5px 10px', borderRadius: '4px', cursor: modificado ? 'pointer' : 'default'
          }}
        >✓</button>
        <button
          onClick={() => {
            if (window.confirm("¿Resetear marcador?")) {
              setGL(''); setGV('');
              onUpdate(partido.id, '', '', false);
            }
          }}
          title="Resetear"
          style={{ background: '#e74c3c', color: 'white', border: 'none', padding: '5px 10px', borderRadius: '4px', cursor: 'pointer' }}
        >↺</button>
      </div>
    </div>
  );
}

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

  const [searchTerm, setSearchTerm] = useState(""); // Nuevo estado para filtrar usuarios

  const [isIdaVuelta, setIsIdaVuelta] = useState(true);

  // --- LÓGICA DE DETECCIÓN DE ENTORNO ---
  const supabaseUrl = supabase.supabaseUrl || '';
  const isProd = supabaseUrl.includes('nkecyqwcrsicsyladdhw');
  const dbName = isProd ? "PRODUCCIÓN (Real)" : "TESTING (Pruebas)";
  const dbColor = isProd ? "#e74c3c" : "#3498db";

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

  const fetchPartidosParaEditar = async () => {
    const { data } = await supabase
      .from('partidos_detallados')
      .select('*')
      .eq('season', editSeason)
      .eq('week', editWeek)
      .eq('division', editDiv);
    setPartidosEdit(data || []);
  };

  const handleUpdateMatch = async (id, hScore, aScore, played) => {
    const { error } = await supabase.from('matches').update({
      home_score: hScore === '' ? null : parseInt(hScore),
      away_score: aScore === '' ? null : parseInt(aScore),
      is_played: played
    }).eq('id', id);

    if (!error) fetchPartidosParaEditar();
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
    if (!seasonToDelete) return;
    if (!window.confirm(`¿ESTÁS SEGURO?`)) return;
    setLoading(true);
    const s = parseInt(seasonToDelete);
    await supabase.from('matches').delete().eq('season', s);
    await supabase.from('weeks_schedule').delete().eq('season', s);
    await fetchSeasons();
    onConfigChange();
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
    setShowUserSelector(false);
    fetchSeasons();
    onConfigChange();
    setLoading(false);
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '25px' }}>

      {/* 1. NAVEGACIÓN  */}
      <div style={{ background: '#f8f9fa', padding: '15px', borderRadius: '8px', border: '1px solid #ddd', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          Jornada Activa:
          <button style={{ padding: '2px 8px' }} onClick={async () => {
            await supabase.from('config').update({ current_week: config.current_week - 1 }).eq('id', 1);
            onConfigChange();
          }}>-</button>
          <strong style={{ margin: '0 10px' }}>{config?.current_week}</strong>
          <button style={{ padding: '2px 8px' }} onClick={async () => {
            await supabase.from('config').update({ current_week: config.current_week + 1 }).eq('id', 1);
            onConfigChange();
          }}>+</button>
        </div>
        <div>
          T. Activa:
          <select
            value={config?.current_season || ''}
            onChange={async (e) => {
              const nuevaSeason = parseInt(e.target.value);
              // Usamos update con eq('id', 1) explícito
              const { error } = await supabase
                .from('config')
                .update({ current_season: nuevaSeason, current_week: 1 })
                .eq('id', 1);

              if (error) {
                console.error("Error al cambiar temporada:", error);
                // Si el update falla, intentamos upsert como plan B
                await supabase.from('config').upsert({ id: 1, current_season: nuevaSeason, current_week: 1 });
              }
              onConfigChange();
            }}
          >
            {availableSeasons.map(s => <option key={s} value={s}>T{s}</option>)}
          </select>
        </div>
      </div>

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

            <div style={{ display: 'grid', gridTemplateColumns: `repeat(${numDivisions + 1}, 1fr)`, gap: '10px', marginTop: '10px' }}>
              <div><small>REGISTRADOS</small>
                {availableUsers.filter(u => !Object.values(assignments).flat().includes(u.id)).map(u => (
                  <div key={u.id} style={{ fontSize: '0.7rem', marginBottom: '4px' }}>
                    {u.nick || "Sin Nick"} {[...Array(numDivisions)].map((_, i) => <button key={i} onClick={() => handleAssign(u.id, i + 1)}>D{i + 1}</button>)}
                  </div>
                ))}
              </div>
              {[...Array(numDivisions)].map((_, i) => (
                <div key={i} style={{ background: '#f0fff4', padding: '5px' }}>
                  <small>DIV {i + 1}</small>
                  {assignments[i + 1].map(id => (
                    <div key={id} style={{ fontSize: '0.7rem' }}>
                      {availableUsers.find(u => u.id === id)?.nick || "Sin Nick"}
                      <button onClick={() => handleAssign(id, 0)} style={{ color: 'red', border: 'none', background: 'none', cursor: 'pointer' }}>x</button>
                    </div>
                  ))}
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

      {/* SECCIÓN GESTIÓN DE USUARIOS */}
      <div style={{ background: 'white', padding: '15px', borderRadius: '12px', border: '1px solid #ddd', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
        <h4 style={{ marginTop: 0, color: '#2c3e50', borderBottom: '2px solid #3498db', paddingBottom: '10px' }}>👥 Gestión de Usuarios</h4>

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
          {availableUsers
            .filter(u =>
              (u.nick?.toLowerCase().includes(searchTerm.toLowerCase())) ||
              (u.email?.toLowerCase().includes(searchTerm.toLowerCase()))
            )
            .map(u => (
              <UserRow key={u.id} user={u} onRefresh={fetchUsers} />
            ))
          }
        </div>
      </div>


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

      {/* 5. INDICADOR DE BASE DE DATOS (AÑADIDO AL FINAL) */}
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
  const [editPhone, setEditPhone] = useState(user.phone || ''); // Nuevo
  const [saving, setSaving] = useState(false);

  // Comprobar si hay cambios incluyendo el teléfono
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
      phone: editPhone // Guardar teléfono
    }).eq('id', user.id);

    if (error) alert(error.message);
    else onRefresh();
    setSaving(false);
  };

  const handleDelete = async () => {
    if (!window.confirm(`¿Borrar permanentemente a ${user.nick}?`)) return;
    const { error } = await supabase.from('profiles').delete().eq('id', user.id);
    if (error) alert(error.message);
    else onRefresh();
  };

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: '1fr 1.2fr 1fr 1fr auto',
      gap: '8px', padding: '8px',
      borderBottom: '1px solid #eee', alignItems: 'center'
    }}>
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%' }} value={editNick} onChange={e => setEditNick(e.target.value)} />
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%' }} value={editEmail} onChange={e => setEditEmail(e.target.value)} />
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%' }} value={editTelegram} onChange={e => setEditTelegram(e.target.value)} placeholder="@Telegram" />
      <input style={{ fontSize: '0.7rem', padding: '4px', width: '100%' }} value={editPhone} onChange={e => setEditPhone(e.target.value)} placeholder="+34..." />

      <div style={{ display: 'flex', gap: '4px' }}>
        <button
          onClick={handleUpdate}
          disabled={!hasChanges || saving}
          style={{ background: hasChanges ? '#2ecc71' : '#ccc', color: 'white', border: 'none', borderRadius: '4px', padding: '5px 8px', cursor: hasChanges ? 'pointer' : 'default' }}
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