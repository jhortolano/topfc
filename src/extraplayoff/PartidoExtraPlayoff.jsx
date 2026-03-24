import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';
import { verificarYObtenerRankingLiguilla, promocionarGanadorPlayoff, verificarYActualizarEstadoFinal, procesarYPublicarPlayoffs } from '../utils/playoffLogic';

export default function PartidoExtraPlayoff({ profile, config, renderTarjeta }) {
  const [partidosExtra, setPartidosExtra] = useState([]);

  useEffect(() => {
    fetchPartidosExtra();
  }, [profile, config]);

  const fetchPartidosExtra = async () => {
    // IMPORTANTE: Aseguramos que profile.id exista para evitar el Error 400
    if (!profile?.id || !config) return;

    try {
      const { data: torneos } = await supabase
        .from('playoffs_extra')
        .select('id, nombre, current_round, config_fechas, use_auto_round, limit_ga_enabled, max_ga_playoff')
        .eq('estado', 'activo');

      if (!torneos || torneos.length === 0) return setPartidosExtra([]);

      let acumulados = [];

      for (const torneo of torneos) {
        const { current_round, config_fechas, id: torneoId, nombre: torneoNombre, use_auto_round } = torneo;

        if (!config_fechas || !current_round) continue;

        const configActual = config_fechas[current_round];
        if (!configActual) continue;

        if (use_auto_round === true) {
          const ahora = new Date();
          const fechaInicio = new Date(configActual.start_at);

          if (ahora < fechaInicio) {
            //console.log(`Torneo ${torneoNombre}: La ronda ${current_round} aún no ha comenzado.`);
            continue;
          }
        }

        const desdeActual = configActual.start_at;
        const hastaActual = configActual.end_at;

        const rondasActivas = Object.entries(config_fechas)
          .filter(([_, rango]) => rango.start_at === desdeActual && rango.end_at === hastaActual)
          .map(([nombreRonda]) => nombreRonda);

        //console.log(configActual);
        //console.log(rondasActivas);

        const jornadasLiguilla = rondasActivas
          .filter(r => r.startsWith('j'))
          .map(r => parseInt(r.replace('j', '')))
          .filter(n => !isNaN(n)); // Evitamos NaNs

        const fasesEliminatoria = rondasActivas.filter(r => !r.startsWith('j')).map(f => f.toUpperCase().replace(/_/g, ' '));;

        // PASO 3: Liguilla
        if (jornadasLiguilla.length > 0) {
          const { data: matchesLiguilla, error: errL } = await supabase
            .from('extra_matches')
            .select(`
              *,
              local_nick:profiles!player1_id(nick),
              local_avatar:profiles!player1_id(avatar_url),
              visitante_nick:profiles!player2_id(nick),
              visitante_avatar:profiles!player2_id(avatar_url)
            `)
            .eq('extra_id', torneoId)
            .in('numero_jornada', jornadasLiguilla)
            // Eliminamos posibles paréntesis manuales para que Supabase gestione el OR limpio
            .or(`player1_id.eq.${profile.id},player2_id.eq.${profile.id}`);

          if (errL) console.error("Error Liguilla en torneo " + torneoNombre, errL);

          if (matchesLiguilla) {
            acumulados.push(...matchesLiguilla.map(m => ({
              ...m,
              home_team: m.player1_id,
              away_team: m.player2_id,
              home_score: m.score1,
              away_score: m.score2,
              local_nick: m.local_nick?.nick,
              local_avatar: m.local_avatar?.avatar_url,
              visitante_nick: m.visitante_nick?.nick,
              visitante_avatar: m.visitante_avatar?.avatar_url,
              playoff_name: torneoNombre,
              round: `Jornada ${m.numero_jornada}`,
              is_extra_liguilla: true,
              limit_ga_enabled: torneo.limit_ga_enabled,
              max_ga_playoff: torneo.max_ga_playoff
            })));
          }
        }

        // PASO 4: Eliminatoria
        if (fasesEliminatoria.length > 0) {
          const { data: matchesPlayoff, error: errP } = await supabase
            .from('extra_playoffs_matches')
            .select(`
              *,
              local_nick:profiles!player1_id(nick),
              local_avatar:profiles!player1_id(avatar_url),
              visitante_nick:profiles!player2_id(nick),
              visitante_avatar:profiles!player2_id(avatar_url)
            `)
            .eq('playoff_extra_id', torneoId)
            .in('numero_jornada', fasesEliminatoria)
            .not('player1_id', 'is', null)
            .not('player2_id', 'is', null)
            .or(`player1_id.eq.${profile.id},player2_id.eq.${profile.id}`);

          if (errP) console.error("Error Playoff en torneo " + torneoNombre, errP);

          if (matchesPlayoff) {
            acumulados.push(...matchesPlayoff.map(m => ({
              ...m,
              home_team: m.player1_id,
              away_team: m.player2_id,
              home_score: m.score1,
              away_score: m.score2,
              local_nick: m.local_nick?.nick,
              local_avatar: m.local_avatar?.avatar_url,
              visitante_nick: m.visitante_nick?.nick,
              visitante_avatar: m.visitante_avatar?.avatar_url,
              playoff_name: torneoNombre,
              round: (m.numero_jornada || m.fase || "Playoff").toString().toUpperCase().replace(/_/g, " "),
              is_extra_playoff: true,
              limit_ga_enabled: torneo.limit_ga_enabled,
              max_ga_playoff: torneo.max_ga_playoff
            })));
          }
        }
      }
      setPartidosExtra(acumulados);
    } catch (err) {
      console.error("Error cargando partidos extra:", err);
    }
  };

  const manejarProgresionAutomática = async (partidoOriginal) => {
    const torneoId = partidoOriginal.playoff_extra_id || partidoOriginal.extra_id;
    if (!torneoId) return;

    try {
      // 1. Traer el partido fresco de la base de datos
      const tabla = Number.isInteger(Number(partidoOriginal.numero_jornada))
        ? 'extra_matches'
        : 'extra_playoffs_matches';

      const { data: partidoFresco } = await supabase
        .from(tabla)
        .select('*')
        .eq('id', partidoOriginal.id)
        .single();

      if (!partidoFresco || !partidoFresco.is_played) {
        console.log("El partido aún no figura como jugado en la DB.");
        return;
      }

      const esNumero = Number.isInteger(Number(partidoFresco.numero_jornada));

      if (esNumero) {
        await procesarYPublicarPlayoffs(torneoId);
      } else {
        // Ahora pasamos el partidoFresco que ya tiene los goles y el is_played: true
        await promocionarGanadorPlayoff(torneoId, partidoFresco);
        await verificarYActualizarEstadoFinal(torneoId);
      }
    } catch (error) {
      console.error("Error en la progresión automática:", error);
    }
  };

  if (partidosExtra.length === 0) return null;

  return (
    <>
      {partidosExtra.map((p) =>
        renderTarjeta(p, async () => {
          // 1. Ejecutamos la lógica de progresión específica de Extra Playoff
          await manejarProgresionAutomática(p);

          // 2. Refrescamos los datos locales del componente para ver los cambios
          fetchPartidosExtra();
        })
      )}
    </>
  );
}