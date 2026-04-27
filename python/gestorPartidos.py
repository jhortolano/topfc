import os
from supabase import create_client, Client
import DATABASECONNECTION

supabase: Client = create_client(DATABASECONNECTION.SUPABASE_URL, DATABASECONNECTION.SUPABASE_KEY)

def obtener_partidos_extra_playoff():
    # 1. Obtener temporada actual de config
    config_res = supabase.table("config").select("current_season").limit(1).execute()
    if not config_res.data:
        return []
    curr_season = config_res.data[0]['current_season']

    # 2. Obtener Playoffs Extra activos para esta temporada
    playoffs_extra_res = supabase.table("playoffs_extra")\
        .select("id, nombre, current_round, config_fechas")\
        .eq("estado", "activo")\
        .eq("season_id", curr_season)\
        .execute()

    partidos_extra = []

    for pe in playoffs_extra_res.data:
        pe_id = pe['id']
        pe_nombre = pe['nombre']
        round_actual = pe['current_round']
        fechas_json = pe['config_fechas'] or {}

        if not round_actual or round_actual not in fechas_json:
            continue

        # Identificar todas las fases que comparten las mismas fechas que la ronda actual
        fecha_target = fechas_json[round_actual]
        fases_activas = []
        for fase, fechas in fechas_json.items():
            if fechas.get('start_at') == fecha_target.get('start_at') and \
               fechas.get('end_at') == fecha_target.get('end_at'):
                if fase.lower().startswith('j'):
                    fases_activas.append(fase)
                else:
                    fases_activas.append(fase.upper())

        start_date = fecha_target.get('start_at', 'N/A')
        end_date = fecha_target.get('end_at', 'N/A')

        # Helper para procesar y añadir jugadores
        def procesar_y_añadir(m, p1_key, p2_key, fase_label):
            p1_id = m.get(p1_key)
            p2_id = m.get(p2_key)
            
            if p1_id and p2_id and not m.get('is_played', False):
                p1_data = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", p1_id).single().execute().data
                p2_data = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", p2_id).single().execute().data

                if p1_data and p2_data:
                    # FILTRO: No añadir si alguno empieza por "Retirado"
                    if p1_data['nick'].startswith("Retirado") or p2_data['nick'].startswith("Retirado"):
                        return

                    tipo_jornada = f"{fase_label} {pe_nombre}"
                    # Línea Jugador 1
                    partidos_extra.append([
                        p1_data['nick'], p1_data['phone'], p1_data['telegram_user'],
                        p2_data['nick'], start_date, end_date, tipo_jornada
                    ])
                    # Línea Jugador 2
                    partidos_extra.append([
                        p2_data['nick'], p2_data['phone'], p2_data['telegram_user'],
                        p1_data['nick'], start_date, end_date, tipo_jornada
                    ])

        # 3. Buscar en extra_matches (Liguilla)
        liguilla_res = supabase.table("extra_matches")\
            .select("player1_id, player2_id, is_played, fase")\
            .eq("extra_id", pe_id)\
            .in_("fase", fases_activas)\
            .execute()

        for m in liguilla_res.data:
            procesar_y_añadir(m, 'player1_id', 'player2_id', m['fase'])

        # 4. Buscar en extra_playoffs_matches (Eliminatorias)
        eliminatorias_res = supabase.table("extra_playoffs_matches")\
            .select("player1_id, player2_id, is_played, numero_jornada")\
            .eq("playoff_extra_id", pe_id)\
            .in_("numero_jornada", fases_activas)\
            .execute()

        for m in eliminatorias_res.data:
            procesar_y_añadir(m, 'player1_id', 'player2_id', m['numero_jornada'])

    return partidos_extra

def obtener_partidos_playoffs_simples():
    # 1. Obtener temporada actual de config
    config_res = supabase.table("config").select("current_season").limit(1).execute()
    if not config_res.data:
        return []
    curr_season = config_res.data[0]['current_season']

    # 2. Obtener Playoffs activos para esta temporada
    playoffs_res = supabase.table("playoffs")\
        .select("id, name, current_round")\
        .eq("season", curr_season)\
        .eq("is_active", True)\
        .execute()

    partidos_playoff = []

    for po in playoffs_res.data:
        po_id = po['id']
        po_name = po['name']
        round_actual = po['current_round']

        # 3. Obtener el partido de referencia para saber las fechas de la ronda actual
        ref_match = supabase.table("playoff_matches")\
            .select("start_date, end_date")\
            .eq("playoff_id", po_id)\
            .eq("round", round_actual)\
            .limit(1).execute()

        if not ref_match.data:
            continue

        target_start = ref_match.data[0]['start_date']
        target_end = ref_match.data[0]['end_date']

        # 4. Obtener todos los partidos de ese playoff que tengan las mismas fechas
        # y que no se hayan jugado todavía
        matches_res = supabase.table("playoff_matches")\
            .select("home_team, away_team, round, start_date, end_date")\
            .eq("playoff_id", po_id)\
            .eq("played", False)\
            .eq("start_date", target_start)\
            .eq("end_date", target_end)\
            .execute()

        for m in matches_res.data:
            h_id = m['home_team']
            a_id = m['away_team']
            fase_label = m['round']
            
            # Formatear la fase (Upper si no empieza por j)
            fase_display = fase_label if fase_label.lower().startswith('j') else fase_label.upper()
            tipo_jornada = f"{fase_display} {po_name}"

            if h_id and a_id:
                # Obtener perfiles
                p_h = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", h_id).single().execute().data
                p_a = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", a_id).single().execute().data

                if p_h and p_a:
                    # FILTRO: No añadir si alguno empieza por "Retirado"
                    if p_h['nick'].startswith("Retirado") or p_a['nick'].startswith("Retirado"):
                        continue

                    # Registro Local
                    partidos_playoff.append([
                        p_h['nick'], p_h['phone'], p_h['telegram_user'],
                        p_a['nick'], m['start_date'], m['end_date'], tipo_jornada
                    ])
                    # Registro Visitante
                    partidos_playoff.append([
                        p_a['nick'], p_a['phone'], p_a['telegram_user'],
                        p_h['nick'], m['start_date'], m['end_date'], tipo_jornada
                    ])

    return partidos_playoff

def obtener_partidos_pendientes():
    # 1. Configuración actual
    config_res = supabase.table("config").select("current_week, current_season").limit(1).execute()
    if not config_res.data:
        return []
    
    curr_week = config_res.data[0]['current_week']
    curr_season = config_res.data[0]['current_season']

    # 2. Fechas de la jornada
    schedule_res = supabase.table("weeks_schedule").select("start_at, end_at")\
        .eq("season", curr_season).eq("week", curr_week).execute()
    
    start_date = schedule_res.data[0]['start_at'] if schedule_res.data else "N/A"
    end_date = schedule_res.data[0]['end_at'] if schedule_res.data else "N/A"

    partidos_finales = []

    # Función auxiliar para evitar repetir código de perfiles
    def agregar_partidos_a_lista(matches_data, tipo_jornada_prefix="Div"):
        for m in matches_data:
            # Solo si el partido no se ha jugado
            if not m.get('is_played', False):
                h_id, a_id = m['home_team'], m['away_team']
                div = f"{tipo_jornada_prefix} {m['division']}"
                
                p_h = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", h_id).single().execute().data
                p_a = supabase.table("profiles").select("nick, phone, telegram_user").eq("id", a_id).single().execute().data

                if p_h and p_a:
                    # FILTRO: No añadir si alguno empieza por "Retirado"
                    if p_h['nick'].startswith("Retirado") or p_a['nick'].startswith("Retirado"):
                        continue

                    partidos_finales.append([p_h['nick'], p_h['phone'], p_h['telegram_user'], p_a['nick'], start_date, end_date, div])
                    partidos_finales.append([p_a['nick'], p_a['phone'], p_a['telegram_user'], p_h['nick'], start_date, end_date, div])

    # 3. Obtener partidos de LIGA normales
    matches_res = supabase.table("matches").select("home_team, away_team, division, is_played")\
        .eq("season", curr_season).eq("week", curr_week).execute()
    
    agregar_partidos_a_lista(matches_res.data)

    # 4. Obtener partidos REPROGRAMADOS
    rescheduled_res = supabase.table("matches_rescheduled").select("match_id").execute()
    
    if rescheduled_res.data:
        match_ids = [r['match_id'] for r in rescheduled_res.data]
        matches_resched_data = supabase.table("matches")\
            .select("home_team, away_team, division, is_played")\
            .in_("id", match_ids).execute()
        
        agregar_partidos_a_lista(matches_resched_data.data)

    return partidos_finales

def partidosPendientes():
    """Consolida todos los partidos de Liga, Extra Playoff y Playoff Simple."""
    liga = obtener_partidos_pendientes()
    extra = obtener_partidos_extra_playoff()
    simples = obtener_partidos_playoffs_simples()
    
    return liga + extra + simples
