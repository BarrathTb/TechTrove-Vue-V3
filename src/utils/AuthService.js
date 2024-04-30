import { supabase } from '@/utils/Supabase.js'

class AuthService {
  constructor() {
    // Access the current session directly as a property
    this._session = supabase.auth.session

    // Listen for changes in authentication state
    supabase.auth.onAuthStateChange((event, session) => {
      this._session = session
    })
  }

  isLoggedIn() {
    return !!this._session
  }

  async login(email) {
    try {
      this.loading = true
      const { error } = await supabase.auth.signInWithOtp({ email })
      if (error) throw error

      if (error instanceof Error) {
        alert(error.message)
      }
    } finally {
      this.loading = false
    }
  }

  async logout() {
    try {
      const { error } = await supabase.auth.signOut()
      if (error) throw error
      return true
    } catch (error) {
      console.error('Logout error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }

  async signUp(email, password) {
    try {
      const { data, session, error } = await supabase.auth.signUp({
        email,
        password
        // ...other relevant fields
      })
      if (error) throw error
      console.log('data', data)
      return { data, session }
    } catch (error) {
      console.error('Sign up failed:', error.message)
      // Handle the error appropriately in your application
    }
  }

  async resetPassword(email) {
    try {
      const { error } = await supabase.auth.api.resetPasswordForEmail(email)
      if (error) throw error
      return true
    } catch (error) {
      console.error('Reset password error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }

  async updatePassword(newPassword) {
    try {
      const { error } = await supabase.auth.update({ password: newPassword })
      if (error) throw error
      return true
    } catch (error) {
      console.error('Update password error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }

  async updateEmail(newEmail) {
    try {
      const { user, error } = await supabase.auth.update({ email: newEmail })
      if (error) throw error
      return user
    } catch (error) {
      console.error('Update email error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }

  async loginWithProvider(provider) {
    try {
      const { user, error } = await supabase.auth.signIn({ provider })
      if (error) throw error
      return user
    } catch (error) {
      console.error('Login with provider error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }
  async getUser(user) {
    try {
      const { data, error } = await supabase.from('users').select('*').eq('id', user.id).single()
      if (error) throw error
      return data
    } catch (error) {
      console.error('Get user error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }
  //isLoggedIn()
  // utils/AuthService.js

  async storeUserOrders(user) {
    try {
      const { error } = await supabase.from('orders').insert(user.orders)
      if (error) throw error
      return true
    } catch (error) {
      console.error('Store user orders error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }

  // admin
  async adminLogin(email, password) {
    try {
      const { user, error } = await supabase.auth.signIn({ email, password })
      if (error) throw error
      return user
    } catch (error) {
      console.error('Login error:', error.message)
      // Handle error by rethrowing or returning an error response
      throw error
    }
  }
}
export default new AuthService()
