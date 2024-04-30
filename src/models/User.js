import { supabase } from '@/utils/Supabase'

class User {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.email = data.email
    this.avatar = data.avatar
  }

  async updateName(newName) {
    const { error } = await supabase.from('users').update({ name: newName }).eq('id', this.id)

    if (error) throw error

    this.name = newName
  }

  async updateEmail(newEmail) {
    const { user, error } = await supabase.auth.update({ email: newEmail })
    if (error) throw error
    this.email = user.email
  }

  async updatePassword(newPassword) {
    const { error } = await supabase.auth.update({ password: newPassword })
    if (error) throw error
  }

  async updateAvatar(newAvatar) {
    const { error } = await supabase.from('users').update({ avatar: newAvatar }).eq('id', this.id)

    if (error) throw error
    this.avatar = newAvatar
  }

  static async fetchUser(userId) {
    const { data, error } = await supabase.from('users').select('*').eq('id', userId).single()

    if (error) throw error

    return new User(data)
  }
}

export default User
