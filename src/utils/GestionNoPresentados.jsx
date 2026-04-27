import React, { useState } from 'react';
import { supabase } from '../supabaseClient';

const GestionNoPresentados = ({ partido, userId, onUpdated }) => {
  const [cargando, setCargando] = useState(false);

  // Si el partido ya está jugado, no mostramos nada
  const partidoJugado = partido.is_played === true || partido.played === true || partido.home_score !== null;
  if (partidoJugado) return null;

  // Extraemos el último valor de la columna "issues" (separada por guiones)
  const issuesArray = partido.issues ? partido.issues.split('-').filter(Boolean) : [];
  const ultimoIssue = issuesArray.length > 0 ? issuesArray[issuesArray.length - 1] : null;

  const esHome = userId === partido.home_team;
  const esAway = userId === partido.away_team;

  // Solo mostramos el componente si el usuario es parte del partido
  if (!esHome && !esAway) return null;

  // Añade un tag al final de la columna issues
  const actualizarIssue = async (nuevoTag, callbackEspecial = null) => {
    setCargando(true);
    const nuevoValor = partido.issues ? `${partido.issues}-${nuevoTag}` : nuevoTag;

    const { error } = await supabase
      .from('matches')
      .update({ issues: nuevoValor })
      .eq('id', partido.id);

    if (!error) {
      if (callbackEspecial) await callbackEspecial(nuevoValor);
      if (onUpdated) onUpdated();
    } else {
      console.error('Error actualizando issues:', error);
    }
    setCargando(false);
  };

  const fnReprogramar = async () => {
    console.log('Iniciando proceso de reprogramación...');
    setCargando(true);

    try {
      // 1. Obtener la fecha de fin del partido actual desde 'weeks_schedule'
      // Usamos partido.season y partido.week (o los nombres exactos de tus columnas)
      const { data: weekData, error: errorWeekData } = await supabase
        .from('weeks_schedule')
        .select('end_at')
        .eq('season', partido.season)
        .eq('week', partido.week)
        .single();

      if (errorWeekData || !weekData) {
        throw new Error("No se pudo determinar la fecha de fin del periodo actual del partido.");
      }

      const fechaFinActual = weekData.end_at;

      // 2. Consultar la temporada actual en la tabla 'config'
      const { data: config, error: errorConfig } = await supabase
        .from('config')
        .select('current_season')
        .single();

      if (errorConfig || !config) throw new Error("Error al obtener la configuración de temporada.");

      // 3. Obtener la fecha más tardía de la temporada completa en 'weeks_schedule'
      const { data: lastWeeks, error: errorLastWeeks } = await supabase
        .from('weeks_schedule')
        .select('end_at')
        .eq('season', config.current_season)
        .order('end_at', { ascending: false })
        .limit(1);

      if (errorLastWeeks || !lastWeeks || lastWeeks.length === 0) {
        throw new Error("No se pudo determinar el fin de la temporada.");
      }

      const finTemporadaAbsoluto = lastWeeks[0].end_at;

      // 4. Validar si ya estamos en el límite de la temporada
      if (new Date(fechaFinActual).getTime() >= new Date(finTemporadaAbsoluto).getTime()) {
        // Revertimos el issue "reprogramado" en la base de datos
        await supabase
          .from('matches')
          .update({ issues: partido.issues }) // Devolvemos al valor original sin el nuevo tag
          .eq('id', partido.id);

        alert("El partido no se puede reprogramar: ya se encuentra en la última semana de la temporada.");
        return;
      }

      // 5. Verificar si ya existe una reprogramación para este match_id
      const { data: existente, error: errorCheck } = await supabase
        .from('matches_rescheduled')
        .select('id')
        .eq('match_id', partido.id)
        .maybeSingle();

      if (errorCheck) throw errorCheck;
      if (existente) {
        alert("El partido ya está reprogramado y no podemos hacer nada.");
        return;
      }

      // 6. Calcular nuevas fechas (fecha_inicio = fin actual, fecha_fin = 1 semana después)
      const fechaInicioNueva = new Date(fechaFinActual);
      const fechaFinNueva = new Date(fechaFinActual);
      fechaFinNueva.setDate(fechaFinNueva.getDate() + 7);

      // 7. Insertar nueva línea en matches_rescheduled
      const { error: errorInsert } = await supabase
        .from('matches_rescheduled')
        .insert([{
          match_id: partido.id,
          tipo_partido: 'liga',
          player1_id: partido.home_team,
          player2_id: partido.away_team,
          fecha_inicio: fechaInicioNueva.toISOString(),
          fecha_fin: fechaFinNueva.toISOString()
        }]);

      if (errorInsert) throw errorInsert;

      alert("Partido reprogramado con éxito para la siguiente semana.");
      if (onUpdated) onUpdated();

    } catch (error) {
      console.error("Error en fnReprogramar:", error.message);
      alert(error.message || "Ocurrió un error al intentar reprogramar el partido.");
    } finally {
      setCargando(false);
    }
  };

  const fnDarPorPerdido = async (issuesConPorPerdido) => {
    console.log('Iniciando proceso: Dar partido por perdido');
    setCargando(true);

    try {
      // 1. Obtener reglas de la temporada (max_ga_league)
      const { data: rules, error: errorRules } = await supabase
        .from('season_rules')
        .select('max_ga_league')
        .eq('season', partido.season)
        .single();

      if (errorRules) {
        console.warn("No se pudieron cargar las reglas, usando valor por defecto 3.");
      }

      // Si es null o hay error, el valor es 3
      const golesVictoria = rules?.max_ga_league ?? 3;

      // 2. Determinar el marcador según quién pulsó el botón (el que pulsa pierde 0-X o X-0)
      // Usamos las variables esHome/esAway que ya tienes definidas en el componente
      const nuevoHomeScore = esHome ? 0 : golesVictoria;
      const nuevoAwayScore = esAway ? 0 : golesVictoria;

      // 3. Añadir el tag "finalizado" al string de issues que recibimos por parámetro
      const valorFinalIssues = `${issuesConPorPerdido}-finalizado`;

      // 4. Actualizar el partido
      const { error: errorUpdate } = await supabase
        .from('matches')
        .update({
          home_score: nuevoHomeScore,
          away_score: nuevoAwayScore,
          is_played: false, // Tal como solicitaste, queda como FALSE
          issues: valorFinalIssues
        })
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      alert(`Partido finalizado. Resultado: ${nuevoHomeScore} - ${nuevoAwayScore}`);

      if (onUpdated) onUpdated();

    } catch (error) {
      console.error("Error en fnDarPorPerdido:", error.message);
      alert("Hubo un error al procesar la derrota del partido.");
    } finally {
      setCargando(false);
    }
  };

  // --- CASO 5: issues ya resueltos, no mostrar nada ---
  if (['p1_por_perdido', 'p2_por_perdido', 'finalizado'].includes(ultimoIssue)) {
    return null;
  }

  // --- CASO 4: partido reprogramado, solo botón "Dar por perdido" ---
  if (ultimoIssue === 'reprogramado') {
    return (
      <div style={{ marginTop: '10px' }}>
        <button
          disabled={cargando}
          onClick={() => actualizarIssue(
            esHome ? 'p1_por_perdido' : 'p2_por_perdido',
            fnDarPorPerdido
          )}
          style={estiloBoton('#e74c3c')}
        >
          Dar partido por perdido
        </button>
      </div>
    );
  }

  const p1Reporta = ultimoIssue === 'p1_no_contacta_p2';
  const p2Reporta = ultimoIssue === 'p2_no_contacta_p1';

  // --- CASO 3: el oponente te ha reportado (eres el "acusado") ---
  const mostrarAvisoCulpable = (p1Reporta && esAway) || (p2Reporta && esHome);

  if (mostrarAvisoCulpable) {
    return (
      <div style={{ marginTop: '10px' }}>
        <div className="flash-warning">
          Tu oponente no logra contactar contigo, contacta con él y pulsa el botón de abajo
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
          <button
            disabled={cargando}
            style={estiloBoton('#f39c12')}
            onClick={() => actualizarIssue(esHome ? 'p1_contestado' : 'p2_contestado')}
          >
            Ya he contactado con mi oponente
          </button>
          <button
            disabled={cargando}
            style={estiloBoton('#3498db')}
            onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
          >
            Reprogramar a siguiente semana
          </button>
        </div>
        <style>{estiloAnimacion}</style>
      </div>
    );
  }

  // --- CASO 2: tú has reportado al oponente (botón izquierdo deshabilitado) ---
  const yoHeReportado = (p1Reporta && esHome) || (p2Reporta && esAway);

  if (yoHeReportado) {
    return (
      <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
        <button disabled={true} style={estiloBoton('#7f8c8d')}>
          No contacto con mi oponente
        </button>
        <button
          disabled={cargando}
          style={estiloBoton('#3498db')}
          onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
        >
          Reprogramar a siguiente semana
        </button>
      </div>
    );
  }

  // --- CASO "contestado": alguien confirmó contacto ---
  // p1_contestado: fue P1 (home) quien confirmó que ya contactó
  // p2_contestado: fue P2 (away) quien confirmó que ya contactó
  if (ultimoIssue === 'p1_contestado' || ultimoIssue === 'p2_contestado') {
    const yoConteste = (ultimoIssue === 'p1_contestado' && esHome) || (ultimoIssue === 'p2_contestado' && esAway);

    return (
      <div style={{ marginTop: '10px' }}>
        <div style={estiloMensajeInfo}>
          {yoConteste
            ? 'Has indicado a tu oponente que ya has contactado con él'
            : 'Tu oponente ha indicado que ya ha contactado contigo'}
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: '10px', marginTop: '8px' }}>
          <button
            disabled={cargando}
            style={estiloBoton('#f39c12')}
            onClick={() => actualizarIssue(esHome ? 'p1_no_contacta_p2' : 'p2_no_contacta_p1')}
          >
            No contacto con mi oponente
          </button>
          <button
            disabled={cargando}
            style={estiloBoton('#3498db')}
            onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
          >
            Reprogramar a siguiente semana
          </button>
        </div>
      </div>
    );
  }

  // --- CASO 1: sin issues (estado normal inicial) ---
  return (
    <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
      <button
        disabled={cargando}
        style={estiloBoton('#f39c12')}
        onClick={() => actualizarIssue(esHome ? 'p1_no_contacta_p2' : 'p2_no_contacta_p1')}
      >
        No contacto con mi oponente
      </button>
      <button
        disabled={cargando}
        style={estiloBoton('#3498db')}
        onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
      >
        Reprogramar a siguiente semana
      </button>
    </div>
  );
};

// --- ESTILOS ---

const estiloBoton = (color) => ({
  flex: 1,
  backgroundColor: color,
  color: 'white',
  border: 'none',
  padding: '10px 5px',
  borderRadius: '4px',
  fontSize: '0.75rem',
  cursor: 'pointer',
  fontWeight: 'bold',
});

const estiloMensajeInfo = {
  backgroundColor: 'rgba(46, 204, 113, 0.15)',
  border: '1px solid #2ecc71',
  color: '#2ecc71',
  padding: '8px',
  borderRadius: '4px',
  textAlign: 'center',
  fontSize: '0.8rem',
  fontWeight: 'bold',
};

const estiloAnimacion = `
  @keyframes flash {
    0%   { background-color: #f1c40f; color: black; }
    50%  { background-color: #e74c3c; color: white; }
    100% { background-color: #f1c40f; color: black; }
  }
  .flash-warning {
    animation: flash 1s infinite;
    padding: 8px;
    border-radius: 4px;
    text-align: center;
    font-size: 0.8rem;
    font-weight: bold;
    margin-bottom: 10px;
    border: 1px solid #c0392b;
  }
`;

export default GestionNoPresentados;
