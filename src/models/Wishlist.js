import { supabase } from '@/utils/Supabase'

class WishlistItem {
  constructor(product) {
    this.product = product
  }
}

class Wishlist {
  constructor(user) {
    this.user = user
    this.items = new Map()
  }

  async fetchWishlistItems() {
    const { data, error } = await supabase
      .from('wishlists')
      .select('*, products(*)')
      .eq('user_id', this.user.id)

    if (error) {
      throw error
    }

    data.forEach((item) => {
      this.items.set(item.product.id, new WishlistItem(item.product))
    })
  }

  addItem(product) {
    if (this.items.has(product.id)) {
      throw new Error(`${product.name} is already in your wishlist`)
    }

    this.items.set(product.id, new WishlistItem(product))
  }

  removeItem(product) {
    if (!this.items.has(product.id)) {
      throw new Error(`${product.name} is not in your wishlist`)
    }

    this.items.delete(product.id)
  }

  moveToCart(product) {
    if (!this.items.has(product.id)) {
      throw new Error(`${product.name} is not in your wishlist`)
    }

    try {
      this.cartCollection.addItem(product)
      this.removeItem(product)
    } catch (error) {
      throw new Error(`Failed to move ${product.name} to cart: ${error.message}`)
    }
  }

  hasItem(product) {
    return this.items.has(product.id)
  }

  clearWishlist() {
    this.items.clear()
  }

  get itemCount() {
    return this.items.size
  }
}

export { WishlistItem, Wishlist }
