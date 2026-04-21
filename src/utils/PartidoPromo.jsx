import React, { useState, useEffect } from 'react';
import { supabase } from '../supabaseClient';

const PartidoPromo = ({ profile, config, renderTarjeta }) => {
  const [partidos, setPartidos] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPromoMatches = async () => {
      if (!profile || !config) return;
      setLoading(true);

      try {
        const ahora = new Date().toISOString();

        // 1. Buscamos si hay una semana de promoción activa para la temporada actual
        const { data: weeks, error: weekError } = await supabase
          .from('weeks_promo')
          .select('idavuelta, season')
          .eq('season', config.current_season)
          .lte('start_at', ahora)
          .gte('end_at', ahora);

        if (weekError) throw weekError;

        if (weeks && weeks.length > 0) {
          // Sacamos los tipos de ronda activos (pueden ser 'ida', 'vuelta' o ambos si solapan)
          const tiposActivos = weeks.map(w => w.idavuelta);

          // 2. Buscamos los partidos del usuario en esas rondas activas
          // Importante: Usamos una query que busque al usuario en ambos slots
          const { data: matches, error: matchError } = await supabase
            .from('promo_matches')
            .select(`
              *,
              p1:profiles!player1_id(id, nick, eafc_user, phone, telegram_user, avatar_url),
              p2:profiles!player2_id(id, nick, eafc_user, phone, telegram_user, avatar_url)
            `)
            .eq('season', config.current_season)
            .in('idavuelta', tiposActivos)
            .or(`player1_id.eq.${profile.id},player2_id.eq.${profile.id}`);

          if (matchError) throw matchError;

          // 3. Formateamos los datos para que sean compatibles con TarjetaResultado
          const matchesFormateados = (matches || []).map(m => ({
            ...m,
            is_promo: true,
            // Adaptamos nombres de columnas para que TarjetaResultado las entienda
            local_id: m.player1_id,
            visitante_id: m.player2_id,
            home_team: m.player1_id,
            away_team: m.player2_id,
            local_nick: m.p1?.nick,
            visitante_nick: m.p2?.nick,
            local_avatar: m.p1?.avatar_url,
            visitante_avatar: m.p2?.avatar_url,
            home_score: m.is_played ? m.score1 : '',
            away_score: m.is_played ? m.score2 : '',
            played: m.is_played,
            // La etiqueta que saldrá arriba a la izquierda
            label_info: m.label_info || `PROMOCIÓN - ${m.idavuelta.toUpperCase()}`
          }));

          setPartidos(matchesFormateados);
        }
      } catch (err) {
        console.error("Error cargando promociones:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchPromoMatches();
  }, [profile, config]);

  if (loading || partidos.length === 0) return null;

  return (
    <>
      {partidos.map(p => renderTarjeta(p, () => {}))}
    </>
  );
};

export default PartidoPromo;