import sys
import os
from datetime import datetime, timedelta, timezone
from supabase import create_client, Client
import DATABASECONNECTION

# Inicialización del cliente Supabase
supabase: Client = create_client(DATABASECONNECTION.SUPABASE_URL, DATABASECONNECTION.SUPABASE_KEY)

def obtener_partidos_liga_por_telefono(telefono_buscado):
    """
    Busca al jugador por su teléfono y luego consulta sus partidos de LIGA.
    """
    # Limpiar el teléfono por si viene con espacios o símbolos
    telefono_limpio = str(telefono_buscado).replace(" ", "")
    
    print(f"--- Buscando perfil para el teléfono: {telefono_limpio} ---")
    
    # 1. Obtener el ID y Nick del jugador mediante el teléfono
    # Buscamos en la columna 'phone'
    perfil_res = supabase.table("profiles")\
        .select("id, nick")\
        .eq("phone", telefono_limpio)\
        .execute()
    
    if not perfil_res.data:
        print(f"No se encontró ningún jugador registrado con el teléfono: {telefono_limpio}")
        return

    usuario = perfil_res.data[0]
    p_id = usuario['id']
    nick_jugador = usuario['nick']
    
    print(f"Jugador identificado: {nick_jugador}")
    print(f"--- Consultando partidos de Liga para: {nick_jugador} ---")

    ahora = datetime.now(timezone.utc)
    margen = timedelta(days=21)

    # 2. Obtener partidos de LIGA no jugados donde participe el jugador
    matches_res = supabase.table("matches")\
        .select("id, home_team, away_team, division, week, season, is_played")\
        .eq("is_played", False)\
        .or_(f"home_team.eq.{p_id},away_team.eq.{p_id}")\
        .execute()

    encontrados = []

    for m in matches_res.data:
        # 3. Comprobar si el partido está reprogramado
        resched_res = supabase.table("matches_rescheduled")\
            .select("fecha_inicio, fecha_fin")\
            .eq("match_id", m['id'])\
            .execute()
        
        reprogramado = False
        if resched_res.data:
            start_at = resched_res.data[0]['fecha_inicio']
            end_at = resched_res.data[0]['fecha_fin']
            reprogramado = True
        else:
            schedule_res = supabase.table("weeks_schedule")\
                .select("start_at, end_at")\
                .eq("season", m['season'])\
                .eq("week", m['week'])\
                .execute()
            
            if schedule_res.data:
                start_at = schedule_res.data[0]['start_at']
                end_at = schedule_res.data[0]['end_at']
            else:
                continue

        # 4. Validar rango de fechas (+/- 3 semanas)
        try:
            fecha_inicio = datetime.fromisoformat(start_at.replace('Z', '+00:00'))
            fecha_fin = datetime.fromisoformat(end_at.replace('Z', '+00:00'))
            
            if (ahora - margen) <= fecha_fin <= (ahora + margen):
                # Identificar rival
                rival_id = m['away_team'] if m['home_team'] == p_id else m['home_team']
                rival_res = supabase.table("profiles").select("nick").eq("id", rival_id).single().execute()
                rival_nick = rival_res.data['nick'] if rival_res.data else "Desconocido"

                encontrados.append({
                    "div": m['division'],
                    "week": m['week'],
                    "rival": rival_nick,
                    "inicio": fecha_inicio.strftime("%d/%m/%Y"),
                    "fin": fecha_fin.strftime("%d/%m/%Y"),
                    "resched": reprogramado
                })
        except Exception:
            continue

    # 5. Imprimir resultados para OpenClaw
    if not encontrados:
        print(f"No hay partidos de liga para {nick_jugador} en el rango de 3 semanas.")
    else:
        for p in encontrados:
            status = " (REPROGRAMADO)" if p['resched'] else ""
            print(f"⚽ Division {p['div']} - Jornada {p['week']}{status}")
            print(f"   Rival: {p['rival']}")
            print(f"   Fecha Inicio: {p['inicio']}")
            print(f"   Fecha Límite: {p['fin']}")
            print("-" * 30)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Tomamos el primer argumento como el teléfono
        obtener_partidos_liga_por_telefono(sys.argv[1])
    else:
        print("Error: Teléfono no proporcionado.")