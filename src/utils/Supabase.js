import { createClient } from '@supabase/supabase-js'
// import authService from '@/utils/AuthService'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'Your fallback URL'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'Your fallback anon key'

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Supabase URL and Anon Key must be provided!')
}
const supabase = createClient(supabaseUrl, supabaseAnonKey)

export { supabase }
// export { supabase, authService }
