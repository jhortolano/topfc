import os
from supabase import create_client, Client
from datetime import datetime

# Configuración de Supabase
SUPABASE_URL = "https://nkecyqwcrsicsyladdhw.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5rZWN5cXdjcnNpY3N5bGFkZGh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxMjY0NDMsImV4cCI6MjA4NTcwMjQ0M30.0VNiNVNrW-qXXKHs6oSc6BousAjBwSUUTg69CgycNww"

def obtener_partidos_pendientes():
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

    try:
        # Usamos week_id:weeks_scheduled para indicar explícitamente la columna de unión
        query = supabase.table("matches").select(
            "id, played, "
            "weeks_scheduled:week_id(end_date, type), "
            "player1:player1_id(nick), "
            "player2:player2_id(nick)"
        ).eq("played", False).execute()

        partidos = query.data

        if not partidos:
            print("No hay partidos pendientes para jugar actualmente.")
            return

        print(f"{'TIPO':<15} | {'PARTIDO':<40} | {'FECHA LÍMITE'}")
        print("-" * 75)

        for p in partidos:
            # Extraer info de la semana
            week_info = p.get('weeks_scheduled', {})
            tipo = "Liga"
            fecha_limite = "Sin fecha"
            
            if week_info:
                tipo = week_info.get('type', 'Liga').replace('_', ' ').capitalize()
                fecha_limite = week_info.get('end_date', 'Sin fecha')

            # Extraer nicks
            nick1 = p.get('player1', {}).get('nick', 'Desconocido')
            nick2 = p.get('player2', {}).get('nick', 'Desconocido')
            
            # Formatear la fecha
            if fecha_limite and fecha_limite != "Sin fecha":
                try:
                    fecha_dt = datetime.fromisoformat(fecha_limite.replace('Z', '+00:00'))
                    fecha_formateada = fecha_dt.strftime('%d/%m/%Y %H:%M')
                except:
                    fecha_formateada = fecha_limite
            else:
                fecha_formateada = "Sin fecha"

            print(f"{tipo:<15} | {nick1} vs {nick2:<36} | {fecha_formateada}")

    except Exception as e:
        print(f"Error al consultar la base de datos: {e}")

if __name__ == "__main__":
    obtener_partidos_pendientes()