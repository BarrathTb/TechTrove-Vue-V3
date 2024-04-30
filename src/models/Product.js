import { supabase } from '@/utils/Supabase'

class Product {
  constructor(data) {
    this.id = data.id
    this.name = data.name
    this.brand = data.brand
    this.category = data.category
    this.price = Number(data.price)
    this.image = data.image
    this.description = data.description
    this.stock = Number(data.stock)
    this.ratings = data.ratings
    this.features = data.features || []
    this.dimensions = data.dimensions
    this.weight = data.weight
    this.warranty = data.warranty
  }

  static async fetchProducts() {
    const { data: products, error } = await supabase.from('products').select('*')
    if (error) throw error
    return products.map((product) => new Product(product))
  }

  // Returns the formatted price as a string
  getFormattedPrice() {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(this.price)
  }

  // Updates the stock quantity
  updateStock(quantity) {
    if (quantity < 0 && Math.abs(quantity) > this.stock) {
      throw new Error('Not enough stock available')
    }
    this.stock += quantity
  }

  // Adds a new feature to the product
  addFeature(feature) {
    this.features.push(feature)
  }

  // Updates the overall rating based on a new review rating
  updateRating(newRating) {
    const totalRatings = this.ratings.totalReviews + 1
    const totalScore = this.ratings.average * this.ratings.totalReviews + newRating
    this.ratings.average = totalScore / totalRatings
    this.ratings.totalReviews = totalRatings
  }
}

export default Product
