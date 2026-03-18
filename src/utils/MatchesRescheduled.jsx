import { useState, useEffect } from 'react'
import { supabase } from '../supabaseClient'

export default function MatchesRescheduled({ currentSeason }) {
  const [loading, setLoading] = useState(false);
  const [seasons, setSeasons] = useState([]);
  const [weeks, setWeeks] = useState([]);

  // Filtros superiores
  const [selSeason, setSelSeason] = useState(currentSeason || 1);
  const [selDiv, setSelDiv] = useState(1);
  const [selWeek, setSelWeek] = useState(1);

  // Datos
  const [partidos, setPartidos] = useState([]);
  const [allRescheduled, setAllRescheduled] = useState([]);
  const [editingId, setEditingId] = useState(null);
  const [tempDates, setTempDates] = useState({ inicio: '', fin: '' });

  useEffect(() => {
    fetchSeasons();
  }, []);

  useEffect(() => {
    if (selSeason) {
      fetchWeeks();
      fetchPartidos();
      fetchAllRescheduled();
    }
  }, [selSeason, selDiv, selWeek]);

  const fetchSeasons = async () => {
    const { data } = await supabase.from('matches').select('season');
    if (data) {
      const unique = [...new Set(data.map(item => item.season))].sort((a, b) => b - a);
      setSeasons(unique);
    }
  };

  const fetchWeeks = async () => {
    const { data } = await supabase.from('matches').select('week').eq('season', selSeason);
    if (data) {
      const unique = [...new Set(data.map(item => item.week))].sort((a, b) => a - b);
      setWeeks(unique);
    }
  };

  const fetchPartidos = async () => {
    const { data } = await supabase
      .from('partidos_detallados')
      .select('*')
      .eq('season', selSeason)
      .eq('division', selDiv)
      .eq('week', selWeek);
    setPartidos(data || []);
  };

  // CARGA CORREGIDA: Traemos las dos tablas por separado y las unimos en JS
  const fetchAllRescheduled = async () => {
    try {
      // 1. Traer todas las reprogramaciones
      const { data: reschedData } = await supabase
        .from('matches_rescheduled')
        .select('*')
        .eq('tipo_partido', 'liga');

      if (!reschedData) return;

      // 2. Traer todos los partidos detallados de la temporada para cruzar datos
      const { data: partidosData } = await supabase
        .from('partidos_detallados')
        .select('*')
        .eq('season', selSeason);

      if (partidosData) {
        // Unimos los datos en el cliente (evita errores de Foreign Key en Supabase)
        const joined = reschedData.map(r => ({
          ...r,
          partido: partidosData.find(p => p.id === r.match_id)
        })).filter(item => item.partido !== undefined); // Solo los de esta temporada

        setAllRescheduled(joined.sort((a, b) => (a.partido?.week || 0) - (b.partido?.week || 0)));
      }
    } catch (err) {
      console.error("Error en fetchAllRescheduled:", err);
    }
  };

  const openEditor = (p) => {
    const hoy = new Date();
    const defecto = `${hoy.toISOString().split('T')[0]}T00:00`;
    setTempDates({ inicio: defecto, fin: defecto });
    setEditingId(p.id);
  };

  const saveReschedule = async (p) => {
    try {
      setLoading(true);
      const { error } = await supabase.from('matches_rescheduled').insert({
        match_id: p.id,
        match_id_uid: p.match_id,
        tipo_partido: 'liga',
        player1_id: p.local_id,
        player2_id: p.visitante_id,
        fecha_inicio: new Date(tempDates.inicio).toISOString(),
        fecha_fin: new Date(tempDates.fin).toISOString()
      });
      if (error) throw error;
      setEditingId(null);
      fetchAllRescheduled();
    } catch (err) {
      alert("Error: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  const removeReschedule = async (match_id) => {
    if (!window.confirm("¿Eliminar esta reprogramación?")) return;
    const { error } = await supabase.from('matches_rescheduled').delete().eq('match_id', match_id);
    if (error) alert(error.message);
    else fetchAllRescheduled();
  };

  const groupedRescheduled = allRescheduled.reduce((acc, item) => {
    const week = item.partido?.week || 'S/N';
    if (!acc[week]) acc[week] = [];
    acc[week].push(item);
    return acc;
  }, {});

  const formatDate = (dateStr) => {
    if (!dateStr) return 'Sin fecha';
    const d = new Date(dateStr);
    if (isNaN(d.getTime())) return 'Fecha inválida';
    return d.toLocaleString('es-ES', {
      day: '2-digit',
      month: '2-digit',
      year: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div style={{ background: '#f0f4f8', padding: '15px', borderRadius: '8px', marginTop: '10px', border: '1px solid #d1d9e6' }}>
      <h3 style={{ margin: '0 0 15px 0', fontSize: '1rem', color: '#2c3e50' }}>⚙️ Panel de Reprogramación</h3>

      <div style={{ display: 'flex', gap: '10px', marginBottom: '20px', flexWrap: 'wrap', background: 'rgba(255,255,255,0.5)', padding: '10px', borderRadius: '6px' }}>
        <div style={{ display: 'flex', flexDirection: 'column' }}>
          <label style={{ fontSize: '0.65rem', fontWeight: 'bold', color: '#666' }}>TEMPORADA</label>
          <select value={selSeason} onChange={e => setSelSeason(parseInt(e.target.value))}>
            {seasons.map(s => <option key={s} value={s}>Temporada {s}</option>)}
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column' }}>
          <label style={{ fontSize: '0.65rem', fontWeight: 'bold', color: '#666' }}>DIVISIÓN</label>
          <select value={selDiv} onChange={e => setSelDiv(parseInt(e.target.value))}>
            <option value={1}>Primera División</option>
            <option value={2}>Segunda División</option>
            <option value={3}>Tercera División</option>
          </select>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column' }}>
          <label style={{ fontSize: '0.65rem', fontWeight: 'bold', color: '#666' }}>JORNADA FILTRO</label>
          <select value={selWeek} onChange={e => setSelWeek(parseInt(e.target.value))}>
            {weeks.map(w => <option key={w} value={w}>Jornada {w}</option>)}
          </select>
        </div>
      </div>

      <h4 style={{ fontSize: '0.8rem', color: '#7f8c8d', marginBottom: '10px', textTransform: 'uppercase' }}>Seleccionar partido para reprogramar:</h4>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '30px' }}>
        {partidos.map(p => {
          const isEditing = editingId === p.id;
          const yaReprogramado = allRescheduled.some(r => r.match_id === p.id);

          return (
            <div key={p.id} style={{ background: 'white', padding: '10px', borderRadius: '6px', border: '1px solid #eee' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span style={{ fontSize: '0.85rem' }}>
                  {p.local_nick} <small>vs</small> {p.visitante_nick}
                  {yaReprogramado && <span style={{ marginLeft: '10px', color: '#3498db', fontSize: '0.7rem', fontWeight: 'bold' }}>[Reprogramado]</span>}
                </span>
                {!isEditing && !yaReprogramado && (
                  <button onClick={() => openEditor(p)} style={{ background: '#3498db', color: 'white', border: 'none', padding: '4px 8px', borderRadius: '4px', cursor: 'pointer', fontSize: '0.7rem' }}>Reprogramar</button>
                )}
              </div>
              {isEditing && (
                <div style={{ marginTop: '10px', padding: '10px', background: '#fdfdfd', border: '1px dashed #ccc', borderRadius: '4px' }}>
                  <div style={{ display: 'flex', gap: '5px', marginBottom: '10px' }}>
                    <input type="datetime-local" value={tempDates.inicio} onChange={e => setTempDates({ ...tempDates, inicio: e.target.value })} style={{ flex: 1, fontSize: '0.75rem' }} />
                    <input type="datetime-local" value={tempDates.fin} onChange={e => setTempDates({ ...tempDates, fin: e.target.value })} style={{ flex: 1, fontSize: '0.75rem' }} />
                  </div>
                  <div style={{ display: 'flex', gap: '5px' }}>
                    <button onClick={() => saveReschedule(p)} style={{ flex: 1, background: '#2ecc71', color: 'white', border: 'none', padding: '5px', borderRadius: '4px' }}>Confirmar</button>
                    <button onClick={() => setEditingId(null)} style={{ flex: 1, background: '#95a5a6', color: 'white', border: 'none', padding: '5px', borderRadius: '4px' }}>Cancelar</button>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>

      <h4 style={{ fontSize: '0.8rem', color: '#7f8c8d', marginBottom: '10px', textTransform: 'uppercase', borderTop: '2px solid #ddd', paddingTop: '15px' }}>
        Listado de Reprogramaciones T{selSeason}:
      </h4>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
        {Object.keys(groupedRescheduled).length === 0 ? (
          <div style={{ textAlign: 'center', padding: '20px', color: '#95a5a6', fontSize: '0.8rem' }}>No hay partidos reprogramados esta temporada.</div>
        ) : (
          Object.keys(groupedRescheduled).sort((a, b) => a - b).map(week => (
            <div key={week}>
              <div style={{ background: '#34495e', color: 'white', padding: '4px 10px', borderRadius: '4px', fontSize: '0.75rem', fontWeight: 'bold', marginBottom: '5px' }}>
                JORNADA {week}
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '5px', paddingLeft: '5px' }}>
                {groupedRescheduled[week].map(res => (
                  <div key={res.id} style={{ background: 'white', padding: '10px', borderRadius: '6px', borderLeft: '4px solid #3498db', boxShadow: '0 2px 4px rgba(0,0,0,0.05)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: '0.85rem', fontWeight: 'bold', marginBottom: '3px' }}>
                        {res.partido?.local_nick} vs {res.partido?.visitante_nick}
                      </div>
                      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.5fr', fontSize: '0.7rem', color: '#666', gap: '10px' }}>
                        <div>
                          <span style={{ color: '#e67e22', fontWeight: 'bold' }}>ORIGINAL:</span><br />
                          {formatDate(res.partido?.date || res.partido?.fecha || res.partido?.scheduled_at)}
                        </div>
                        <div>
                          <span style={{ color: '#27ae60', fontWeight: 'bold' }}>REPROGRAMACIÓN:</span><br />
                          <div style={{ display: 'flex', flexDirection: 'column' }}>
                            <span><strong style={{ fontSize: '0.6rem', color: '#999' }}>INICIO:</strong> {formatDate(res.fecha_inicio)}</span>
                            <span><strong style={{ fontSize: '0.6rem', color: '#999' }}>FIN:</strong> {formatDate(res.fecha_fin)}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <button onClick={() => removeReschedule(res.match_id)} style={{ background: '#fceaea', color: '#e74c3c', border: '1px solid #f5c6cb', padding: '6px 10px', borderRadius: '4px', cursor: 'pointer', fontSize: '0.7rem', marginLeft: '10px' }}>
                      Borrar
                    </button>
                  </div>
                ))}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}