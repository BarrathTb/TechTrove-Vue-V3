import { supabase } from '@/utils/Supabase'
import Level from '@/models/Level'
export default class User {
  constructor(data = {}) {
    this.id = data.id
    this.username = data.username
    this.email = data.email
    this.profile_id = data.profile_id
    this.level_id = data.level_id
    this.points = data.points
    this.badge_id = data.badge_id
    this.badges = []
    this.level = null // Initialize level as null
  }

  static async fetchUser(userId) {
    const { data, error } = await supabase
      .from('users')
      .select('*, level(*), badges(*)')
      .eq('id', userId)
      .single()

    if (error) throw error

    return new User(data)
  }

  async updatePoints(points) {
    const { error } = await supabase
      .from('users')
      .update({ points: this.points + points })
      .eq('id', this.id)

    if (error) throw error

    this.points += points
  }

  async awardBadge(badgeId) {
    const { error } = await supabase
      .from('user_badges')
      .insert({ user_id: this.id, badge_id: badgeId })

    if (error) throw error

    // Fetch the updated badges for the user
    const { data } = await supabase.from('badges').select('*').in('id', [badgeId])

    this.badges.push(data[0])
  }

  async levelUp(levelId) {
    const { error } = await supabase.from('users').update({ level_id: levelId }).eq('id', this.id)

    if (error) throw error

    this.level = await Level.fetchLevel(levelId)
  }
}
