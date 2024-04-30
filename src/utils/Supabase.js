import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'Your fallback URL'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'Your fallback anon key'

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Supabase URL and Anon Key must be provided!')
}
const supabase = createClient(supabaseUrl, supabaseAnonKey)
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
