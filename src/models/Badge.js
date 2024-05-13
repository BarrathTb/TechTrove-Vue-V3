import { supabase } from '@/utils/Supabase'

export default class Badge {
  constructor(data = {}) {
    this.id = data.id
    this.name = data.name
    this.imageUrl = data.image_url
    this.description = data.description
  }

  static async fetchBadge(badgeId) {
    const { data, error } = await supabase.from('badges').select('*').eq('id', badgeId).single()

    if (error) throw error

    return new Badge(data)
  }
}
