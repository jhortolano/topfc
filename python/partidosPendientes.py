import os
import sys
from datetime import datetime, timedelta, timezone
# Asegúrate de importar el cliente supabase desde tu archivo de gestión
from gestorPartidos import partidosPendientes, supabase
import DATABASECONNECTION 
import subprocess
import time

# Constante para la limpieza de logs en DB
DIAS_LIMPIEZA_LOGS = 7
DIAS_PARA_EXPIRAR = 3


# --- CONFIGURACIÓN DE LOGS DINÁMICOS ---
def obtener_ruta_log():
    nombre_log = os.path.splitext(os.path.basename(__file__))[0] + ".log"
    directorio_preferido = "/app/python_logic"
    
    # Si el directorio existe, usamos esa ruta; si no, el directorio actual
    if os.path.exists(directorio_preferido):
        return os.path.join(directorio_preferido, nombre_log)
    else:
        return os.path.join(os.getcwd(), nombre_log)

RUTA_ARCHIVO_LOG = obtener_ruta_log()

def log_print(mensaje):
    """Imprime en consola y escribe en el archivo log con timestamp."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    texto_final = f"[{timestamp}] {mensaje}"
    
    # Imprimir en consola
    print(mensaje)
    
    # Escribir en el archivo (modo append 'a')
    try:
        with open(RUTA_ARCHIVO_LOG, "a", encoding="utf-8") as f:
            f.write(texto_final + "\n")
    except Exception as e:
        print(f"Error al escribir en el log: {e}")

# Inicialización: Borrar log previo si existe en la ruta calculada
if os.path.exists(RUTA_ARCHIVO_LOG):
    os.remove(RUTA_ARCHIVO_LOG)

# --- RESTO DEL CÓDIGO ---

def limpiar_notificaciones_antiguas():
    log_print(f"Iniciando limpieza de notificaciones antiguas (más de {DIAS_LIMPIEZA_LOGS} días)...")

    fecha_corte = (datetime.now(timezone.utc) -
                   timedelta(days=DIAS_LIMPIEZA_LOGS)).isoformat()

    try:
        res = supabase.table("notificaciones_enviadas")\
            .delete()\
            .lte("created_at", fecha_corte)\
            .execute()

        log_print(f"Limpieza completada. Registros eliminados: {len(res.data)}")
    except Exception as e:
        log_print(f"Error durante la limpieza de la tabla: {e}")


def enviarNotificacion(fila):
    nick = fila[0]
    telefono = str(fila[1]).replace(" ", "").replace("+", "")
    rival = fila[3]
    fase = fila[6]
    fecha_limite_raw = fila[5]

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

    mensaje = (
        f"Hola {nick}, tienes un partido pendiente en *{fase}* contra {rival}. "
        f"La fecha límite es el *{fecha_formateada}*. ¡No olvides jugarlo!"
        f"\n\n"
        f"_*Esto es un recordatorio automático, por favor no respondas a este mensaje.*_"
    )

    log_print(f"--- EJECUTANDO MUDSLIDE ---")
    log_print(f"Destinatario: {nick} ({telefono})")

    try:
        log_print(f"DEBUG: Ejecutando comando npx mudslide send {telefono} {mensaje}")
        resultado = subprocess.run(
            ["npx", "mudslide", "send", telefono, mensaje],
            capture_output=True,
            text=True,
            check=True
        )
        
        log_print(f"Respuesta de Mudslide: {resultado.stdout.strip()}")
        log_print(f"WhatsApp enviado correctamente a {nick}")
        
        time.sleep(1)

    except subprocess.CalledProcessError as e:
        log_print(f"Error al ejecutar Mudslide para {nick}: {e.stderr}")
    except Exception as e:
        log_print(f"Error inesperado: {e}")


def guardarDBNotificacionEnviada(id_base):
    try:
        data = {"id": id_base}
        supabase.table("notificaciones_enviadas").insert(data).execute()
        log_print(f"ID {id_base} guardado en la base de datos.")
    except Exception as e:
        log_print(f"Error al guardar en DB: {e}")


def verificar_notificacion_existente(id_base):
    res = supabase.table("notificaciones_enviadas").select(
        "id").eq("id", id_base).execute()
    return len(res.data) > 0


def filtrar_partidos_por_expiracion(lista_partidos, dias_limite=3):
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
    limpiar_notificaciones_antiguas()

    log_print(f"Log activo en: {RUTA_ARCHIVO_LOG}")
    log_print("Consultando partidos pendientes...")
    lista_total = partidosPendientes()

    lista_proximos = filtrar_partidos_por_expiracion(
        lista_total, DIAS_PARA_EXPIRAR)

    if not lista_proximos:
        log_print("No hay partidos próximos a expirar.")
    else:
        for fila in lista_proximos:
            id_base = fila[7]

            if not verificar_notificacion_existente(id_base):
                log_print(f"Enviando notificación para {fila[0]} vs {fila[3]}...")
                enviarNotificacion(fila)
                guardarDBNotificacionEnviada(id_base)
            else:
                log_print(f"Notificación ya enviada anteriormente para el ID: {id_base}. Saltando...")

            log_print("-" * 30)


if __name__ == "__main__":
    ejecutar_reporte()