import { createClient } from '@supabase/supabase-js'

// Intentamos leer de ambos sitios para que no falle en ningún entorno
const supabaseUrl = import.meta.env?.VITE_SUPABASE_URL || process.env?.EXPO_PUBLIC_SUPABASE_URL
const supabaseAnonKey = import.meta.env?.VITE_SUPABASE_ANON_KEY || process.env?.EXPO_PUBLIC_SUPABASE_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.error("⚠️ Configuración de Supabase no encontrada. Revisa tus archivos .env");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)