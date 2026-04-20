import sys
import os
from datetime import datetime, timedelta, timezone
from supabase import create_client, Client
import DATABASECONNECTION

# Inicialización del cliente Supabase
supabase: Client = create_client(DATABASECONNECTION.SUPABASE_URL, DATABASECONNECTION.SUPABASE_KEY)

def reprogramar_partido_por_telefono(numero_jornada, telefono_usuario):
    ahora = datetime.now(timezone.utc)
    
    # Limpiar el teléfono para la búsqueda (quitar espacios)
    telefono_limpio = str(telefono_usuario).replace(" ", "")
    
    print(f"--- Iniciando reprogramación para el teléfono {telefono_limpio} (Jornada {numero_jornada}) ---")

    try:
        # 1. Obtener el ID y Nick del jugador por su teléfono
        perfil_res = supabase.table("profiles").select("id, nick").eq("phone", telefono_limpio).execute()
        if not perfil_res.data:
            print(f"Error: No se encontró al jugador con el teléfono '{telefono_limpio}'.")
            return
        
        usuario = perfil_res.data[0]
        p_id = usuario['id']
        nick_usuario = usuario['nick']
        
        print(f"Jugador identificado: {nick_usuario} (ID: {p_id})")

        # 2. Obtener la temporada actual desde 'config'
        config_res = supabase.table("config").select("current_season").single().execute()
        current_season = config_res.data['current_season']

        # 3. Determinar MAX_RESCHEDULED_DATE de 'weeks_schedule'
        schedule_res = supabase.table("weeks_schedule")\
            .select("end_at")\
            .eq("season", current_season)\
            .execute()
        
        if not schedule_res.data:
            print("Error: No se encontraron jornadas para la temporada actual.")
            return

        # Buscamos la fecha 'end_at' más lejana en el futuro
        fechas_final = [datetime.fromisoformat(w['end_at'].replace('Z', '+00:00')) for w in schedule_res.data]
        max_rescheduled_date = max(fechas_final)

        # Validar si hoy ya pasó el límite de la temporada
        if ahora > max_rescheduled_date:
            print(f"Error: No se puede reprogramar. La temporada terminó el {max_rescheduled_date.strftime('%d/%m/%Y')}.")
            return

        # 4. Buscar el partido en 'matches'
        match_res = supabase.table("matches")\
            .select("id, home_team, away_team")\
            .eq("week", numero_jornada)\
            .eq("season", current_season)\
            .or_(f"home_team.eq.{p_id},away_team.eq.{p_id}")\
            .execute()

        if not match_res.data:
            print(f"No se encontró ningún partido para {nick_usuario} en la Jornada {numero_jornada}.")
            return

        partido = match_res.data[0]
        m_id = partido['id']
        h_team = partido['home_team']
        a_team = partido['away_team']

        # 5. Calcular fechas para la reprogramación
        # Fecha inicio: lunes de la semana actual a las 00:00
        lunes_actual = ahora - timedelta(days=ahora.weekday())
        fecha_inicio = lunes_actual.replace(hour=0, minute=0, second=0, microsecond=0)
        
        # Fecha fin: una semana después
        fecha_fin = fecha_inicio + timedelta(days=7)

        # Ajustar fecha_fin si excede el límite de la temporada
        if fecha_fin > max_rescheduled_date:
            fecha_fin = max_rescheduled_date

        # 6. Insertar/Actualizar en 'matches_rescheduled'
        data_reschedule = {
            "match_id": m_id,
            "player1_id": h_team,
            "player2_id": a_team,
            "fecha_inicio": fecha_inicio.isoformat(),
            "fecha_fin": fecha_fin.isoformat(),
            "tipo_partido": "liga"
        }

        # Comprobar si ya existe una reprogramación
        existente = supabase.table("matches_rescheduled").select("id").eq("match_id", m_id).execute()
        
        if existente.data:
            supabase.table("matches_rescheduled").update(data_reschedule).eq("match_id", m_id).execute()
            print(f"✅ Reprogramación actualizada para el partido de {nick_usuario} (ID {m_id}).")
        else:
            supabase.table("matches_rescheduled").insert(data_reschedule).execute()
            print(f"✅ Partido de la Jornada {numero_jornada} para {nick_usuario} reprogramado correctamente.")

        print(f"   Nueva fecha inicio: {fecha_inicio.strftime('%d/%m/%Y %H:%M')}")
        print(f"   Nueva fecha límite: {fecha_fin.strftime('%d/%m/%Y %H:%M')}")

    except Exception as e:
        print(f"Error inesperado: {e}")

if __name__ == "__main__":
    # El script espera: python script.py <jornada> <telefono>
    if len(sys.argv) >= 3:
        jornada_input = sys.argv[1]
        # El segundo argumento es el teléfono
        telefono_input = sys.argv[2]
        reprogramar_partido_por_telefono(jornada_input, telefono_input)
    else:
        print("Uso: python reprogramar.py <numero_jornada> <telefono_whatsapp>")