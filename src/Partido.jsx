import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

const Avatar = ({ url }) => (
  <div style={{
    width: '35px', height: '35px', borderRadius: '50%', overflow: 'hidden',
    background: '#34495e', border: '2px solid #2ecc71', flexShrink: 0
  }}>
    {url ? (
      <img src={url} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
    ) : (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', fontSize: '0.8rem', color: '#7f8c8d' }}>👤</div>
    )}
  </div>
);

function TarjetaResultado({ partido, onUpdated }) {
  const [gL, setGL] = useState(partido.home_score ?? '');
  const [gV, setGV] = useState(partido.away_score ?? '');
  const [enviando, setEnviando] = useState(false);

  // Identificamos si es un partido de playoff
  const isPlayoff = !!partido.playoff_id;
  const tabla = isPlayoff ? 'playoff_matches' : 'matches';
  // Normalizamos el estado para que el botón desaparezca correctamente en ambos casos
  const yaJugado = isPlayoff ? partido.played : partido.is_played;

  const guardar = async () => {
    if (gL === '' || gV === '') return alert("Introduce los goles");
    setEnviando(true);

    try {
      const scoreL = parseInt(gL);
      const scoreV = parseInt(gV);

      // En playoff_matches_detallados (vista), los IDs reales son local_id y visitante_id
      const idLocal = partido.local_id;
      const idVisitante = partido.visitante_id;

      if (!idLocal || !idVisitante) throw new Error("Faltan IDs de los equipos.");

      // Datos según tabla (played vs is_played)
      const datosAEnviar = isPlayoff
        ? { home_score: scoreL, away_score: scoreV, played: true }
        : { home_score: scoreL, away_score: scoreV, is_played: true };

      const { error: errorUpdate } = await supabase
        .from(tabla)
        .update(datosAEnviar)
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      if (isPlayoff) {
        const pId = String(partido.playoff_id);
        const mOrder = parseInt(partido.match_order);
        const faseActualNombre = partido.round;
        const faseBase = faseActualNombre.split(' (')[0].trim();
        const esDoble = faseActualNombre.includes('(Ida)') || faseActualNombre.includes('(Vuelta)');

        // Traemos los enfrentamientos para calcular el global
        const { data: enfrentamientos } = await supabase
          .from('playoff_matches')
          .select('*')
          .eq('playoff_id', pId)
          .eq('match_order', String(mOrder))
          .ilike('round', `${faseBase}%`);

        let ganadorId = null;

        if (!esDoble) {
          if (scoreL > scoreV) ganadorId = idLocal;
          else if (scoreV > scoreL) ganadorId = idVisitante;
        } else {
          const ida = enfrentamientos.find(m => m.round.includes('(Ida)'));
          const vuelta = enfrentamientos.find(m => m.round.includes('(Vuelta)'));

          // Consideramos el estado actual
          const idaFinal = ida?.id === partido.id ? { ...ida, home_score: scoreL, away_score: scoreV, played: true } : ida;
          const vueltaFinal = vuelta?.id === partido.id ? { ...vuelta, home_score: scoreL, away_score: scoreV, played: true } : vuelta;

          if (idaFinal?.played && vueltaFinal?.played) {
            // El ID del equipo no cambia aunque cambie de casa
            // Local de Ida (ida.home_team) es Visitante de Vuelta (vuelta.away_team)
            const globalLocal = (idaFinal.home_score || 0) + (vueltaFinal.away_score || 0);
            const globalVisitante = (idaFinal.away_score || 0) + (vueltaFinal.home_score || 0);

            if (globalLocal > globalVisitante) ganadorId = idaFinal.home_team;
            else if (globalVisitante > globalLocal) ganadorId = idaFinal.away_team;
          }
        }

        // PROMOCIÓN
        if (ganadorId) {
          const ordenRondas = ["Dieciseisavos", "Octavos", "Cuartos", "Semifinales", "Final"];
          const idx = ordenRondas.findIndex(r => r.toLowerCase() === faseBase.toLowerCase());
          const sigRonda = ordenRondas[idx + 1];

          if (sigRonda) {
            const sigMatchOrder = Math.floor(mOrder / 2);
            const esLocalNext = mOrder % 2 === 0;
            // Columnas reales de tu dump: home_team / away_team
            const columnaDestino = esLocalNext ? 'home_team' : 'away_team';

            const { error: errorNext } = await supabase
              .from('playoff_matches')
              .update({ [columnaDestino]: ganadorId })
              .eq('playoff_id', pId)
              .eq('match_order', String(sigMatchOrder))
              .ilike('round', `${sigRonda}%`);

            if (errorNext) throw errorNext;
          }
        }
      }

      if (onUpdated) onUpdated();
      alert("Guardado y actualizado.");
    } catch (err) {
      console.error(err);
      alert(err.message);
    } finally {
      setEnviando(false);
    }
  };

  return (
    <div style={{
      background: isPlayoff ? '#3a2c50' : '#2c3e50', // Color lila oscuro si es playoff
      color: 'white', padding: '15px', borderRadius: '12px', textAlign: 'center', position: 'relative',
      border: isPlayoff ? '1px solid #9b59b6' : 'none'
    }}>
      {/* ETIQUETA SUPERIOR DINÁMICA */}
      <div style={{ position: 'absolute', top: '5px', left: '10px', fontSize: '0.6rem', color: isPlayoff ? '#d6a2e8' : '#2ecc71', fontWeight: 'bold', textTransform: 'uppercase' }}>
        {isPlayoff ? `${partido.playoff_name} - ${partido.round}` : `JORNADA ${partido.week}`}
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '15px', marginBottom: '10px', marginTop: '15px' }}>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.local_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.local_nick}
          </div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center' }}>
          {partido.is_played ? (
            <div style={{
              background: '#34495e', padding: '8px 15px', borderRadius: '8px',
              border: `2px solid ${isPlayoff ? '#9b59b6' : '#2ecc71'}`,
              fontWeight: 'bold', fontSize: '1.2rem', minWidth: '60px'
            }}>
              {partido.home_score} - {partido.away_score}
            </div>
          ) : (
            <div style={{ display: 'flex', gap: '5px', alignItems: 'center' }}>
              <input type="number" min="0" value={gL} onChange={e => setGL(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
              <span style={{ fontWeight: 'bold', fontSize: '1.2rem' }}>-</span>
              <input type="number" min="0" value={gV} onChange={e => setGV(e.target.value)} style={{ width: '45px', textAlign: 'center', padding: '8px', borderRadius: '6px', border: 'none', fontSize: '18px', fontWeight: 'bold' }} />
            </div>
          )}
        </div>

        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '5px' }}>
          <Avatar url={partido.visitante_avatar} />
          <div style={{ fontSize: '0.8rem', fontWeight: 'bold', width: '100%', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {partido.visitante_nick}
          </div>
        </div>
      </div>

      {!partido.is_played && (
        <button onClick={guardar} disabled={enviando} style={{
          background: isPlayoff ? '#9b59b6' : '#2ecc71',
          color: 'white', border: 'none', padding: '12px', borderRadius: '8px',
          cursor: 'pointer', fontWeight: 'bold', width: '100%', marginTop: '10px', fontSize: '0.85rem'
        }}>
          {enviando ? 'GUARDANDO...' : 'POSTEAR RESULTADO'}
        </button>
      )}
    </div>
  )
}

function ProximoPartido({ profile, config, onUpdated }) {
  const [partidosLiga, setPartidosLiga] = useState([])
  const [partidosPlayoff, setPartidosPlayoff] = useState([])
  const [loading, setLoading] = useState(true)

  const cargar = async () => {
    if (!config || !profile) return;
    setLoading(true)

    try {
      // --- 1. CARGAR PARTIDOS DE LIGA ---
      const { data: currentWeekData } = await supabase
        .from('weeks_schedule')
        .select('start_at, end_at')
        .eq('season', config.current_season)
        .eq('week', config.current_week)
        .single();

      let ligaTemp = [];
      if (currentWeekData) {
        const { data: activeWeeks } = await supabase
          .from('weeks_schedule')
          .select('week')
          .eq('season', config.current_season)
          .eq('start_at', currentWeekData.start_at)
          .eq('end_at', currentWeekData.end_at);

        const weekNumbers = activeWeeks.map(w => w.week);
        const { data } = await supabase
          .from('partidos_detallados')
          .select('*')
          .eq('season', config.current_season)
          .in('week', weekNumbers)
          .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

        ligaTemp = data || [];
      }

      // --- 2. CARGAR PARTIDOS DE PLAYOFF ---
      const { data: playoffsActivos } = await supabase
        .from('playoffs')
        .select('id, name, current_round')
        .eq('season', config.current_season)
        .not('current_round', 'is', null)
        .neq('current_round', 'Finalizado');

      let playoffTemp = [];
      if (playoffsActivos && playoffsActivos.length > 0) {
        const idsActivos = playoffsActivos.map(p => p.id);

        // 1. Traemos todos los partidos detallados del usuario para estos playoffs
        const { data: todosMisPartidos } = await supabase
          .from('playoff_matches_detallados')
          .select('*')
          .in('playoff_id', idsActivos)
          .or(`local_nick.eq."${profile.nick}",visitante_nick.eq."${profile.nick}"`);

        if (todosMisPartidos) {
          playoffsActivos.forEach(po => {
            // 2. Buscamos el partido "referencia" que define las fechas actuales
            // Este es el partido que coincide con la current_round seleccionada en el admin
            const partidoReferencia = todosMisPartidos.find(
              m => m.playoff_id === po.id && m.round === po.current_round
            );

            if (partidoReferencia) {
              // 3. Filtramos todos los partidos que tengan las MISMAS fechas que el de referencia
              const partidosEnFecha = todosMisPartidos.filter(m =>
                m.playoff_id === po.id &&
                m.start_date === partidoReferencia.start_date &&
                m.end_date === partidoReferencia.end_date &&
                m.local_id !== null && // <--- El local debe existir
                m.visitante_id !== null // <--- El visitante debe existir
              );

              // 4. Los añadimos al listado temporal con el nombre del torneo
              const conNombre = partidosEnFecha.map(m => ({
                ...m,
                playoff_name: po.name
              }));

              playoffTemp = [...playoffTemp, ...conNombre];
            }
          });

          // Ordenamos por round para que si hay Ida y Vuelta, aparezcan en orden
          playoffTemp.sort((a, b) => a.round.localeCompare(b.round));
        }
      }

      setPartidosLiga(ligaTemp);
      setPartidosPlayoff(playoffTemp);

    } catch (error) {
      console.error("Error en carga:", error);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    cargar();
  }, [profile, config])

  if (loading) return <div style={{ fontSize: '0.8rem', color: '#95a5a6' }}>Cargando partidos...</div>

  const todosLosPartidos = [...partidosPlayoff, ...partidosLiga];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
      {todosLosPartidos.length === 0 ? (
        <div style={{ color: '#95a5a6', fontSize: '0.8rem', textAlign: 'center', padding: '20px' }}>
          No tienes partidos de Liga ni Playoff para esta semana.
        </div>
      ) : (
        todosLosPartidos.map(p => (
          <TarjetaResultado key={p.playoff_id ? `po-${p.id}` : `li-${p.id}`} partido={p} onUpdated={cargar} />
        ))
      )}
    </div>
  )
}

export default ProximoPartido;