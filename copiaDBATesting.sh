#!/bin/bash

# ==========================================
# CONFIGURACIÓN DE ENTORNOS
# ==========================================

# PROYECTO A (Producción)
DB_A_HOST="aws-1-eu-west-1.pooler.supabase.com"
DB_A_USER="postgres.nkecyqwcrsicsyladdhw"
DB_A_PASS="topfcjulian1234!"

# PROYECTO B (Testing)
DB_B_HOST="aws-1-eu-west-1.pooler.supabase.com"
DB_B_USER="postgres.vudsxtdmqweefydivflf"
DB_B_PASS="topfcjulian1234!"

# ==========================================
# DIRECCIÓN DEL FLUJO (DESCOMENTA LA QUE NECESITES)
# ==========================================

# Opción 1: De Producción a Testing (Lo normal)
ORIGEN_HOST=$DB_A_HOST; ORIGEN_USER=$DB_A_USER; ORIGEN_PASS=$DB_A_PASS
DESTINO_HOST=$DB_B_HOST; DESTINO_USER=$DB_B_USER; DESTINO_PASS=$DB_B_PASS
echo "🔄 MODO: Producción -> Testing"

# Opción 2: De Testing a Producción (¡CUIDADO!)
# ORIGEN_HOST=$DB_B_HOST; ORIGEN_USER=$DB_B_USER; ORIGEN_PASS=$DB_B_PASS
# DESTINO_HOST=$DB_A_HOST; DESTINO_USER=$DB_A_USER; DESTINO_PASS=$DB_A_PASS
# echo "⚠️ MODO: Testing -> Producción"

# ==========================================
# PROCESO DE SINCRONIZACIÓN
# ==========================================

echo "📥 1. Extrayendo datos del ORIGEN..."
PGPASSWORD="$ORIGEN_PASS" pg_dump \
    -h "$ORIGEN_HOST" \
    -p 6543 \
    -U "$ORIGEN_USER" \
    -d "postgres" \
    -n public \
    --no-owner \
    --no-privileges \
    --no-comments \
    -Fc > sync_data.dump

if [ $? -ne 0 ]; then echo "❌ Error en la descarga"; exit 1; fi

echo "🧹 2. Limpiando destino (Borrando esquema public con CASCADE)..."
# El CASCADE es vital para eliminar triggers que dependen de la tabla auth.users
PGPASSWORD="$DESTINO_PASS" psql -h "$DESTINO_HOST" -p 6543 -U "$DESTINO_USER" -d "postgres" \
    -c "DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO anon; GRANT ALL ON SCHEMA public TO authenticated; GRANT ALL ON SCHEMA public TO service_role;"

echo "📤 3. Restaurando datos en el DESTINO..."
# Añadimos --no-data-for-failed-tables y forzamos la desactivación de validaciones
PGPASSWORD="$DESTINO_PASS" pg_restore \
    -h "$DESTINO_HOST" \
    -p 6543 \
    -U "$DESTINO_USER" \
    -d "postgres" \
    --no-owner \
    --no-privileges \
    --disable-triggers \
    sync_data.dump

# RE-VINCULACIÓN (Opcional)
# Si quieres que el script intente poner las FKs aunque den error:
echo "🔗 Intentando reactivar restricciones (si faltan usuarios en Auth, verás avisos aquí)..."
PGPASSWORD="$DESTINO_PASS" psql -h "$DESTINO_HOST" -p 6543 -U "$DESTINO_USER" -d "postgres" \
    -c "ALTER TABLE public.profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE NOT VALID;"

    

if [ $? -eq 0 ]; then
    echo "✅ Sincronización completada con éxito."
else
    echo "⚠️ Sincronización terminada. Es normal ver errores de Foreign Keys si los usuarios de Auth no coinciden."
fi

# Limpieza
rm -f sync_data.dump