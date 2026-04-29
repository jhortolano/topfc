import React, { useState } from 'react';
import { supabase } from '../supabaseClient';

// ─────────────────────────────────────────────────────────────
// Mapa de configuración por tipo de partido
// Centraliza las diferencias entre tablas para no repetir lógica
// ─────────────────────────────────────────────────────────────
const getTipoConfig = (partido) => {
  if (partido.is_extra_liguilla) {
    return {
      tabla: 'extra_matches',
      campoHome: 'player1_id',
      campoAway: 'player2_id',
      campoScoreHome: 'score1',
      campoScoreAway: 'score2',
      campoJugado: 'is_played',
      esExtra: true,
    };
  }
  if (partido.is_extra_playoff) {
    return {
      tabla: 'extra_playoffs_matches',
      campoHome: 'player1_id',
      campoAway: 'player2_id',
      campoScoreHome: 'score1',
      campoScoreAway: 'score2',
      campoJugado: 'is_played',
      esExtra: true,
    };
  }
  // Liga regular (por defecto)
  return {
    tabla: 'matches',
    campoHome: 'home_team',
    campoAway: 'away_team',
    campoScoreHome: 'home_score',
    campoScoreAway: 'away_score',
    campoJugado: 'is_played',
    esExtra: false,
  };
};

// ─────────────────────────────────────────────────────────────
// Componente principal
// ─────────────────────────────────────────────────────────────
const GestionNoPresentados = ({ partido, userId, onUpdated }) => {
  const [cargando, setCargando] = useState(false);

  // Resolvemos la config según el tipo de partido
  const cfg = getTipoConfig(partido);

  // Si el partido ya está jugado, no mostramos nada
  const scoreHome = partido[cfg.campoScoreHome];
  const partidoJugado =
    partido[cfg.campoJugado] === true ||
    partido.played === true ||
    scoreHome !== null && scoreHome !== undefined;
  if (partidoJugado) return null;

  // Extraemos el último valor de la columna "issues" (separada por guiones)
  const issuesArray = partido.issues ? partido.issues.split('-').filter(Boolean) : [];
  const ultimoIssue = issuesArray.length > 0 ? issuesArray[issuesArray.length - 1] : null;

  // Identificamos si somos home o away usando los campos correctos para cada tabla
  const esHome = userId === partido[cfg.campoHome];
  const esAway = userId === partido[cfg.campoAway];

  // Solo mostramos el componente si el usuario es parte del partido
  if (!esHome && !esAway) return null;

  // ─── Actualiza la columna issues en la tabla correspondiente ───
  const actualizarIssue = async (nuevoTag, callbackEspecial = null) => {
    setCargando(true);
    const nuevoValor = partido.issues ? `${partido.issues}-${nuevoTag}` : nuevoTag;

    const { error } = await supabase
      .from(cfg.tabla)
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

  // ─── Función: Reprogramar ───────────────────────────────────
  // Solo disponible para liga regular; los partidos extra NO se pueden reprogramar.
  const fnReprogramar = async () => {
    console.log('Iniciando proceso de reprogramación...');
    setCargando(true);

    try {
      const { data: weekData, error: errorWeekData } = await supabase
        .from('weeks_schedule')
        .select('end_at')
        .eq('season', partido.season)
        .eq('week', partido.week)
        .single();

      if (errorWeekData || !weekData) {
        throw new Error('No se pudo determinar la fecha de fin del periodo actual del partido.');
      }

      const fechaFinActual = weekData.end_at;

      const { data: config, error: errorConfig } = await supabase
        .from('config')
        .select('current_season')
        .single();

      if (errorConfig || !config) throw new Error('Error al obtener la configuración de temporada.');

      const { data: lastWeeks, error: errorLastWeeks } = await supabase
        .from('weeks_schedule')
        .select('end_at')
        .eq('season', config.current_season)
        .order('end_at', { ascending: false })
        .limit(1);

      if (errorLastWeeks || !lastWeeks || lastWeeks.length === 0) {
        throw new Error('No se pudo determinar el fin de la temporada.');
      }

      const finTemporadaAbsoluto = lastWeeks[0].end_at;

      if (new Date(fechaFinActual).getTime() >= new Date(finTemporadaAbsoluto).getTime()) {
        await supabase
          .from('matches')
          .update({ issues: partido.issues })
          .eq('id', partido.id);

        alert('El partido no se puede reprogramar: ya se encuentra en la última semana de la temporada.');
        return;
      }

      const { data: existente, error: errorCheck } = await supabase
        .from('matches_rescheduled')
        .select('id')
        .eq('match_id', partido.id)
        .maybeSingle();

      if (errorCheck) throw errorCheck;
      if (existente) {
        alert('El partido ya está reprogramado y no podemos hacer nada.');
        return;
      }

      const fechaInicioNueva = new Date(fechaFinActual);
      const fechaFinNueva = new Date(fechaFinActual);
      fechaFinNueva.setDate(fechaFinNueva.getDate() + 7);

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

      alert('Partido reprogramado con éxito para la siguiente semana.');
      if (onUpdated) onUpdated();

    } catch (error) {
      console.error('Error en fnReprogramar:', error.message);
      alert(error.message || 'Ocurrió un error al intentar reprogramar el partido.');
    } finally {
      setCargando(false);
    }
  };

  // ─── Función: Dar por perdido ───────────────────────────────
  // Determina el marcador según el tipo de partido y quién pierde.
  // En partidos extra (liguilla y playoff) también se pone is_played = true.
  const fnDarPorPerdido = async (issuesConPorPerdido) => {
    console.log('Iniciando proceso: Dar partido por perdido');
    setCargando(true);

    try {
      // Obtenemos las reglas de goles de victoria según el tipo de partido
      let golesVictoria = 3;

      if (!cfg.esExtra) {
        // Liga: consultamos season_rules
        const { data: config } = await supabase.from('config').select('current_season').single();
        const { data: rules } = await supabase
          .from('season_rules')
          .select('max_ga_league')
          .eq('season', config?.current_season ?? partido.season)
          .single();
        golesVictoria = rules?.max_ga_league ?? 3;
      } else {
        // Extra: usamos max_ga_playoff si viene en el objeto partido
        golesVictoria = partido.max_ga_playoff ?? 3;
      }

      // El que pulsa el botón pierde (0), el oponente gana (golesVictoria)
      const scoreHome = esHome ? 0 : golesVictoria;
      const scoreAway = esAway ? 0 : golesVictoria;

      const valorFinalIssues = `${issuesConPorPerdido}-finalizado`;

      const updateData = {
        [cfg.campoScoreHome]: scoreHome,
        [cfg.campoScoreAway]: scoreAway,
        issues: valorFinalIssues,
      };

      // En partidos extra (liguilla y playoff) marcamos is_played = true.
      // En liga regular NO se toca is_played.
      if (cfg.esExtra) {
        updateData[cfg.campoJugado] = true;
      }

      const { error: errorUpdate } = await supabase
        .from(cfg.tabla)
        .update(updateData)
        .eq('id', partido.id);

      if (errorUpdate) throw errorUpdate;

      alert(`Partido finalizado. Resultado: ${scoreHome} - ${scoreAway}`);
      if (onUpdated) onUpdated();

    } catch (error) {
      console.error('Error en fnDarPorPerdido:', error.message);
      alert('Hubo un error al procesar la derrota del partido.');
    } finally {
      setCargando(false);
    }
  };

  // ─────────────────────────────────────────────────────────────
  // CASOS DE VISUALIZACIÓN
  // ─────────────────────────────────────────────────────────────

  // CASO 5: issues ya resueltos, no mostrar nada
  if (['p1_por_perdido', 'p2_por_perdido', 'finalizado'].includes(ultimoIssue)) {
    return null;
  }

  // CASO 4: partido reprogramado, solo botón "Dar por perdido"
  // (Los partidos extra nunca llegan aquí con 'reprogramado', pero por seguridad lo dejamos)
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

  // CASO 3: el oponente te ha reportado (eres el "acusado")
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
          {/* Botón de reprogramar: solo visible en liga regular */}
          {!cfg.esExtra && (
            <button
              disabled={cargando}
              style={estiloBoton('#3498db')}
              onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
            >
              Reprogramar a siguiente semana
            </button>
          )}
        </div>
        <style>{estiloAnimacion}</style>
      </div>
    );
  }

  // CASO 2: tú has reportado al oponente (botón izquierdo deshabilitado)
  const yoHeReportado = (p1Reporta && esHome) || (p2Reporta && esAway);

  if (yoHeReportado) {
    return (
      <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
        <button disabled={true} style={estiloBoton('#7f8c8d')}>
          No contacto con mi oponente
        </button>
        {/* Botón de reprogramar: solo visible en liga regular */}
        {!cfg.esExtra && (
          <button
            disabled={cargando}
            style={estiloBoton('#3498db')}
            onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
          >
            Reprogramar a siguiente semana
          </button>
        )}
      </div>
    );
  }

  // CASO "contestado": alguien confirmó contacto, mostramos mensaje informativo
  if (ultimoIssue === 'p1_contestado' || ultimoIssue === 'p2_contestado') {
    const yoConteste =
      (ultimoIssue === 'p1_contestado' && esHome) ||
      (ultimoIssue === 'p2_contestado' && esAway);

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
          {/* Botón de reprogramar: solo visible en liga regular */}
          {!cfg.esExtra && (
            <button
              disabled={cargando}
              style={estiloBoton('#3498db')}
              onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
            >
              Reprogramar a siguiente semana
            </button>
          )}
        </div>
      </div>
    );
  }

  // CASO 1: sin issues (estado normal inicial)
  return (
    <div style={{ marginTop: '10px', display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
      <button
        disabled={cargando}
        style={estiloBoton('#f39c12')}
        onClick={() => actualizarIssue(esHome ? 'p1_no_contacta_p2' : 'p2_no_contacta_p1')}
      >
        No contacto con mi oponente
      </button>
      {/* Botón de reprogramar: solo visible en liga regular */}
      {!cfg.esExtra && (
        <button
          disabled={cargando}
          style={estiloBoton('#3498db')}
          onClick={() => actualizarIssue('reprogramado', fnReprogramar)}
        >
          Reprogramar a siguiente semana
        </button>
      )}
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// ESTILOS
// ─────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────
// UTILIDAD: Cierre de jornada (exportada para uso externo)
// ─────────────────────────────────────────────────────────────
export const procesarCierreJornada = async (weekParaCerrar) => {
  console.log(`Iniciando procesamiento de cierre para la jornada: ${weekParaCerrar}`);

  try {
    const { data: config } = await supabase.from('config').select('current_season').single();
    if (!config) return;

    const { data: rules } = await supabase
      .from('season_rules')
      .select('max_ga_league')
      .eq('season', config.current_season)
      .single();

    const golesVictoria = rules?.max_ga_league ?? 3;

    const getUltimoIssue = (str) => {
      if (!str) return null;
      const parts = str.split('-').filter(Boolean);
      return parts[parts.length - 1] ?? null;
    };

    // PROCESO A: Jornada que se cierra
    const { data: matchesActual } = await supabase
      .from('matches')
      .select('id, issues')
      .eq('season', config.current_season)
      .eq('week', weekParaCerrar)
      .eq('is_played', false);

    if (matchesActual) {
      for (const m of matchesActual) {
        const ultimo = getUltimoIssue(m.issues);
        let updateData = null;

        if (ultimo === 'p1_no_contacta_p2') {
          updateData = { home_score: golesVictoria, away_score: 0 };
        } else if (ultimo === 'p2_no_contacta_p1') {
          updateData = { home_score: 0, away_score: golesVictoria };
        } else if (!ultimo || ultimo === 'p1_contestado' || ultimo === 'p2_contestado') {
          updateData = { home_score: 0, away_score: 0 };
        }

        if (updateData) {
          await supabase.from('matches').update(updateData).eq('id', m.id);
        }
      }
    }

    // PROCESO B: Jornada anterior — solo si está en estado 'reprogramado'
    const { data: matchesAnterior } = await supabase
      .from('matches')
      .select('id, issues')
      .eq('season', config.current_season)
      .eq('week', weekParaCerrar - 1)
      .eq('is_played', false);

    if (matchesAnterior) {
      for (const m of matchesAnterior) {
        const ultimo = getUltimoIssue(m.issues);
        if (ultimo === 'reprogramado') {
          await supabase.from('matches').update({ home_score: 0, away_score: 0 }).eq('id', m.id);
        }
      }
    }

    console.log('Cierre de jornada completado con éxito.');
  } catch (error) {
    console.error('Error procesando cierre de jornada:', error);
  }
};

export const procesarCierreExtraPlayoff = async (po) => {
  // po = { id, current_round, config_fechas, ... }
  // config_fechas tiene la forma: { "Semifinales": { start_at, end_at }, "Final": { ... } }

  const getUltimoIssue = (str) => {
    if (!str) return null;
    const parts = str.split('-').filter(Boolean);
    return parts[parts.length - 1] ?? null;
  };

  const ahora = new Date();

  // Iteramos todas las rondas del config_fechas para ver cuáles han terminado
  // y cuyos partidos aún no están cerrados
  const rondasTerminadas = Object.entries(po.config_fechas || {}).filter(([nombre, rango]) => {
    return rango.end_at && new Date(rango.end_at) <= ahora;
  });

  for (const [nombreRonda, rango] of rondasTerminadas) {
    // ── extra_matches (liguilla por grupos) ──────────────────
    // Filtramos por fecha de fin de la ronda (numero_jornada si aplica,
    // o directamente por fecha_fin dentro del rango)
    const { data: matchesLiguilla } = await supabase
      .from('extra_matches')
      .select('id, issues, player1_id, player2_id')
      .eq('extra_id', po.id)
      .eq('is_played', false)
      .eq('fase',nombreRonda)

    if (matchesLiguilla) {
      for (const m of matchesLiguilla) {
        const ultimo = getUltimoIssue(m.issues);
        let score1 = null, score2 = null;
        console.log(ultimo);
        const golesVictoria = po.max_ga_playoff ?? 5;

        if (ultimo === 'p1_no_contacta_p2') {
          // p1 gana
          score2 = 0; score1 = golesVictoria;
        } else if (ultimo === 'p2_no_contacta_p1') {
          // p2 gana
          score2 = golesVictoria; score1 = 0;
        } else {
          // ninguno contactó o issues ambiguos → empate
          score1 = 0; score2 = 0;
        }

        await supabase
          .from('extra_matches')
          .update({ score1, score2, is_played: true, issues: m.issues ? `${m.issues}-finalizado` : 'finalizado' })
          .eq('id', m.id);
      }
    }

    // ── extra_playoffs_matches (eliminatorias) ───────────────
    const { data: matchesElim } = await supabase
      .from('extra_playoffs_matches')
      .select('id, issues, player1_id, player2_id')
      .eq('playoff_extra_id', po.id)
      .eq('is_played', false)
      .eq('numero_jornada', nombreRonda.toUpperCase()); // numero_jornada guarda el nombre de la ronda

      console.log(po);
    if (matchesElim) {
      for (const m of matchesElim) {
        const ultimo = getUltimoIssue(m.issues);
        let score1 = null, score2 = null;

        const golesVictoria = po.max_ga_playoff ?? 5;

        if (ultimo === 'p1_no_contacta_p2') {
          score2 = 0; score1 = golesVictoria;
        } else if (ultimo === 'p2_no_contacta_p1') {
          score2 = golesVictoria; score1 = 0;
        } else {
          score1 = 0; score2 = 0;
        }

        await supabase
          .from('extra_playoffs_matches')
          .update({ score1, score2, is_played: true, issues: m.issues ? `${m.issues}-finalizado` : 'finalizado' })
          .eq('id', m.id);
      }
    }
  }
};
