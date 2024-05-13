import { createClient } from '@supabase/supabase-js'
// import authService from '@/utils/AuthService'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'Your fallback URL'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'Your fallback anon key'

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Supabase URL and Anon Key must be provided!')
}
const supabase = createClient(supabaseUrl, supabaseAnonKey)

// supabase.auth.onAuthStateChange((event, session) => {
//   // the "event" is a string indicating what trigger the state change (ie. SIGN_IN, SIGN_OUT, etc)
//   // the session contains info about the current session most importanly the user dat
//   const { user } = authService()

//   user.value = session?.user || null
// })
export { supabase }

// Immediately-Invoked Function Expression (IIFE) for handling async operations
// ;(async () => {
//   try {
//     let { data, error } = await supabase.from('products').insert(products)

//     if (error) {
//       throw error
//     }

//     console.log('Successfully imported products:', data)
//   } catch (error) {
//     console.error('Error importing products:', error)
//   }
// })()
