import { supabase } from '@/utils/Supabase.js'
import { useUserStore } from '@/stores/User'

class AuthService {
  constructor() {
    // Listen for changes in authentication state and update the Pinia store
    supabase.auth.onAuthStateChange((event, session) => {
      const userStore = useUserStore()
      if (session) {
        // Updating user info and session in the store
        userStore.setUser(session.user)
        userStore.setSession(session)
      } else {
        // Clearing user info and session in the store when logged out
        userStore.clearUser()
      }
    })
  }

  // Use Pinia store to check if the user is logged in
  async isLoggedIn() {
    const userStore = useUserStore()
    return userStore.isLoggedIn
  }

  async login(email) {
    try {
      const { user, error } = await supabase.auth.signInWithOtp({ email })
      if (error) throw error

      const userStore = useUserStore()
      if (user) {
        userStore.setUser(user)
      }

      return user
    } catch (error) {
      throw new Error(`Login failed: ${error.message}`)
    }
  }
  async signInWithEmail(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })

    if (error) {
      throw new Error(`Sign in failed: ${error.message}`)
    }

    return data
  }

  async logout() {
    const { error } = await supabase.auth.signOut()
    if (error) throw new Error(`Logout failed: ${error.message}`)
    return true
  }

  async signUp(email, password, options = {}) {
    const { user, error } = await supabase.auth.signUp({
      email,
      password,
      data: options.data || {}
    })

    if (error) {
      throw new Error(`Sign up failed: ${error.message}`)
    }

    if (!user) {
      throw new Error('Sign up failed. Please try again.')
    }

    const userStore = useUserStore()
    userStore.setUser(user)

    return user
  }

  async resetPassword(email) {
    const { error } = await supabase.auth.api.resetPasswordForEmail(email)
    if (error) throw new Error(`Reset password failed: ${error.message}`)
    return true
  }

  async updatePassword(newPassword) {
    const { error } = await supabase.auth.update({ password: newPassword })
    if (error) throw new Error(`Update password failed: ${error.message}`)
    return true
  }

  async updateEmail(newEmail) {
    const { user, error } = await supabase.auth.update({ email: newEmail })
    if (error) throw new Error(`Update email failed: ${error.message}`)
    return user
  }

  async loginWithProvider(providerName) {
    try {
      console.log(`Attempting to sign in with ${providerName}`)
      const { user, error } = await supabase.auth.signInWithOAuth({
        provider: providerName
      })
      if (error) {
        console.error('Error during signInWithOAuth:', error)
        throw new Error(`Login with provider failed: ${error.message}`)
      }
      console.log('User object returned from signInWithOAuth:', user)
      return user
    } catch (error) {
      console.error('Exception caught in loginWithProvider:', error)
      throw error // Re-throwing the error to be caught by the caller
    }
  }

  async getUser() {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', this._session.user.id)
      .single()

    if (error) throw new Error(`Get user failed: ${error.message}`)
    return data
  }

  async storeUserOrders(user) {
    const { error } = await supabase.from('orders').insert(user.orders)
    if (error) throw new Error(`Store user orders failed: ${error.message}`)
    return true
  }

  getSession() {
    return this._session
  }

  async adminLogin(email, password) {
    const { user, error } = await supabase.auth.signIn({ email, password })
    if (error) throw new Error(`Admin login failed: ${error.message}`)
    return user
  }
}

export default new AuthService()
