import { supabase } from '@/utils/Supabase'

export default class Level {
  constructor(data = {}) {
    this.id = data.id
    this.name = data.name
    this.pointsRequired = data.points_required
    this.discountPercentage = data.discount_percentage
    this.badge = data.badge || null
  }

  static async fetchLevel(levelId) {
    const { data, error } = await supabase
      .from('levels')
      .select('*, badge(*)')
      .eq('id', levelId)
      .single()

    if (error) throw error

    return new Level(data)
  }
}
