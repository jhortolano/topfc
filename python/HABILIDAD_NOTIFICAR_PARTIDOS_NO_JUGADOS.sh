#!/bin/bash

# --- CONFIGURACIÓN ---
DIR_ACTUAL=$(cd "$(dirname "$0")" && pwd)
SCRIPT_PYTHON="$DIR_ACTUAL/partidosPendientes.py"
TIMEOUT_SEGUNDOS=120

# 1. Detectar qué comando usar para el timeout
if command -v timeout &> /dev/null; then
    CMD_TIMEOUT="timeout"      # Linux / Docker
elif command -v gtimeout &> /dev/null; then
    CMD_TIMEOUT="gtimeout"     # macOS con coreutils
else
    CMD_TIMEOUT=""             # No instalado
fi

# 2. Ejecutar según disponibilidad de timeout
# IMPORTANTE: Redirigimos la salida a /dev/null porque Python ya escribe su propio log.
# Si no lo hacemos, OpenClaw podría recibir basura visual en lugar de solo el PID.
if [ -n "$CMD_TIMEOUT" ]; then
    $CMD_TIMEOUT "${TIMEOUT_SEGUNDOS}s" python3 "$SCRIPT_PYTHON" > /dev/null 2>&1 &
else
    python3 "$SCRIPT_PYTHON" > /dev/null 2>&1 &
fi

# 3. Devolver el PID para OpenClaw
echo $!