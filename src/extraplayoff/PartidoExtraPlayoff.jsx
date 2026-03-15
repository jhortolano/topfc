import { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

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
        .select('id, nombre, current_round, config_fechas')
        .eq('estado', 'activo');

      if (!torneos || torneos.length === 0) return setPartidosExtra([]);

      let acumulados = [];

      for (const torneo of torneos) {
        const { current_round, config_fechas, id: torneoId, nombre: torneoNombre } = torneo;

        if (!config_fechas || !current_round) continue;

        const configActual = config_fechas[current_round];
        if (!configActual) continue;

        const desdeActual = configActual.start_at;
        const hastaActual = configActual.end_at;
        
        const rondasActivas = Object.entries(config_fechas)
          .filter(([_, rango]) => rango.start_at === desdeActual && rango.end_at === hastaActual)
          .map(([nombreRonda]) => nombreRonda);

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
              is_extra_liguilla: true
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
              is_extra_playoff: true
            })));
          }
        }
      }

      setPartidosExtra(acumulados);
    } catch (err) {
      console.error("Error cargando partidos extra:", err);
    }
  };

  if (partidosExtra.length === 0) return null;

  return (
    <>
      {partidosExtra.map(p => (
        // Usamos una key única para evitar problemas de renderizado
        <div key={p.id || `${p.extra_id}-${p.home_team}`}>
          {renderTarjeta(p, fetchPartidosExtra)}
        </div>
      ))}
    </>
  );
}