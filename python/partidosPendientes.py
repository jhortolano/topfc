from datetime import datetime, timedelta, timezone
# Asegúrate de importar el cliente supabase desde tu archivo de gestión
from gestorPartidos import partidosPendientes, supabase
import DATABASECONNECTION 
import subprocess
import time


# Constante para la limpieza de logs
DIAS_LIMPIEZA_LOGS = 7
DIAS_PARA_EXPIRAR = 3


def limpiar_notificaciones_antiguas():
    """
    Borra los registros de la tabla notificaciones_enviadas que tengan 
    una antigüedad superior a DIAS_LIMPIEZA_LOGS.
    """
    print(
        f"Iniciando limpieza de notificaciones antiguas (más de {DIAS_LIMPIEZA_LOGS} días)...")

    # Calculamos la fecha límite (UTC)
    fecha_corte = (datetime.now(timezone.utc) -
                   timedelta(days=DIAS_LIMPIEZA_LOGS)).isoformat()

    try:
        # Borramos registros donde created_at sea menor o igual a la fecha de corte
        res = supabase.table("notificaciones_enviadas")\
            .delete()\
            .lte("created_at", fecha_corte)\
            .execute()

        # res.data suele contener los registros borrados
        print(f"Limpieza completada. Registros eliminados: {len(res.data)}")
    except Exception as e:
        print(f"Error durante la limpieza de la tabla: {e}")


def enviarNotificacion(fila):
    nick = fila[0]
    # Aseguramos que el teléfono sea un string y quitamos espacios o símbolos raros
    telefono = str(fila[1]).replace(" ", "").replace("+", "")
    rival = fila[3]
    fase = fila[6]
    fecha_limite_raw = fila[5]

    # --- LÓGICA DE FORMATEO DE FECHA ---
    meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
             "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    dias_semana = ["Lunes", "Martes", "Miércoles",
                   "Jueves", "Viernes", "Sábado", "Domingo"]

    try:
        fecha_obj = datetime.fromisoformat(fecha_limite_raw.replace('Z', '+00:00'))
        dia = fecha_obj.day
        nombre_mes = meses[fecha_obj.month - 1]
        nombre_dia = dias_semana[fecha_obj.weekday()]
        fecha_formateada = f"{dia} de {nombre_mes} ({nombre_dia})"
    except:
        fecha_formateada = fecha_limite_raw

    # --- CONSTRUCCIÓN DEL MENSAJE ---
    mensaje = (
        f"Hola {nick}, tienes un partido pendiente en *{fase}* contra {rival}. "
        f"La fecha límite es el *{fecha_formateada}*. ¡No olvides jugarlo!"
    )

    print(f"--- EJECUTANDO MUDSLIDE ---")
    print(f"Destinatario: {nick} ({telefono})")

    try:
        # Ejecutamos el comando de mudslide: npx mudslide send <numero> <mensaje>
        # Nota: Mudslide gestiona internamente la conexión si ya hiciste 'npx mudslide login'
        resultado = subprocess.run(
            ["npx", "mudslide", "send", telefono, mensaje],
            capture_output=True,
            text=True,
            check=True
        )
        
        print(f"Respuesta de Mudslide: {resultado.stdout.strip()}")
        print(f"WhatsApp enviado correctamente a {nick}")
        
        # Un pequeño delay para no saturar el proceso de la Raspberry si hay varios envíos
        time.sleep(1)

    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar Mudslide para {nick}: {e.stderr}")
    except Exception as e:
        print(f"Error inesperado: {e}")


def guardarDBNotificacionEnviada(id_base):
    # ... (tu código se mantiene igual)
    try:
        data = {"id": id_base}
        supabase.table("notificaciones_enviadas").insert(data).execute()
        print(f"ID {id_base} guardado en la base de datos.")
    except Exception as e:
        print(f"Error al guardar en DB: {e}")


def verificar_notificacion_existente(id_base):
    # ... (tu código se mantiene igual)
    res = supabase.table("notificaciones_enviadas").select(
        "id").eq("id", id_base).execute()
    return len(res.data) > 0


def filtrar_partidos_por_expiracion(lista_partidos, dias_limite=3):
    # ... (tu código se mantiene igual)
    lista_partidos_expiran_pronto = []
    ahora = datetime.now(timezone.utc)

    for fila in lista_partidos:
        fecha_final_str = fila[5]
        if fecha_final_str == "N/A" or not fecha_final_str:
            continue

        try:
            fecha_final = datetime.fromisoformat(
                fecha_final_str.replace('Z', '+00:00'))
            diferencia = fecha_final - ahora

            if timedelta(0) <= diferencia <= timedelta(days=dias_limite):
                nick_usuario = str(fila[0])
                nick_rival = str(fila[3])
                fase = str(fila[6])
                fecha_limite = str(fila[5])

                cadena_base = f"{nick_usuario}{nick_rival}{fase}{fecha_limite}"
                fila.append(cadena_base)
                lista_partidos_expiran_pronto.append(fila)
        except ValueError:
            continue
    return lista_partidos_expiran_pronto


def ejecutar_reporte():
    # 0. LO PRIMERO: Limpiar registros viejos
    limpiar_notificaciones_antiguas()

    print("\nConsultando partidos pendientes...")
    lista_total = partidosPendientes()

    lista_proximos = filtrar_partidos_por_expiracion(
        lista_total, DIAS_PARA_EXPIRAR)

    if not lista_proximos:
        print("No hay partidos próximos a expirar.")
    else:
        for fila in lista_proximos:
            id_base = fila[7]

            if verificar_notificacion_existente(id_base):
                print(
                    f"Saltando: La notificación para {fila[0]} vs {fila[3]} ya fue enviada.")
            else:
                enviarNotificacion(fila)
                guardarDBNotificacionEnviada(id_base)

            print("-" * 30)


if __name__ == "__main__":
    ejecutar_reporte()
