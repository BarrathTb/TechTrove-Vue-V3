import { supabase } from '@/utils/Supabase'

class Profile {
  constructor(data) {
    this.id = data.id
    this.username = data.username
    this.full_name = data.full_name
    this.email = data.email
    this.avatar_url = data.avatar_url
    this.website = data.website
  }

  static async updateUser(userId, updates) {
    console.log('Updating user:', userId, 'with:', updates)
    const { error } = await supabase.from('profiles').update(updates).eq('id', userId)

    if (error) throw error
  }

  async updateUsername(newUsername) {
    const { error } = await supabase
      .from('profiles')
      .update({ username: newUsername })
      .eq('id', this.id)

    if (error) throw error

    return newUsername
  }

  async updateFullName(newFullName) {
    const { error } = await supabase
      .from('profiles')
      .update({ full_name: newFullName })
      .eq('id', this.id)

    if (error) throw error

    return newFullName
  }

  async updateEmail(newEmail) {
    const { user, error } = await supabase.auth.update({ email: newEmail })
    if (error) throw error
    if (user) this.email = user.email
  }

  async updatePassword(newPassword) {
    const { error } = await supabase.auth.update({ password: newPassword })
    if (error) throw error
  }

  async updateAvatar(userId, newAvatarUrl) {
    const { error } = await supabase
      .from('profiles')
      .update({ avatar_url: newAvatarUrl })
      .eq('id', userId)

    if (error) throw error

    // Update local instance property
    return newAvatarUrl
  }

  static async fetchUser(userId) {
    const { data, error } = await supabase.from('profiles').select('*').eq('id', userId).single()

    if (error) throw error
    console.log(data)

    return new Profile(data)
  }

  async updateField(fieldName, value) {
    const updates = {}
    updates[fieldName] = value

    const response = await supabase.from('profiles').update(updates).eq('id', this.id)
    if (response.error) throw response.error

    this[fieldName] = value
  }
}

export default Profile
