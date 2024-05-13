import { supabase } from '@/utils/Supabase'
import { useUserStore } from '@/stores/User'
import { CartCollection } from './Cart'

class WishlistItem {
  constructor(product) {
    this.product = product
  }
}

class Wishlist {
  constructor() {
    this.items = new Map()
    this.userStore = useUserStore()
  }

  async fetchWishlistItems() {
    if (this.userStore.isLoggedIn) {
      const user = this.userStore.getUser()

      const { data, error } = await supabase
        .from('wishlists')
        .select('*, products(*)')
        .eq('user_id', user.id)

      if (error) {
        throw error
      }

      data.forEach((item) => {
        this.items.set(item.product.id, new WishlistItem(item.product))
      })
    }
  }

  async addItem(product) {
    if (!this.userStore.isLoggedIn) {
      // Handle scenario when user is not logged in
      console.error('User must be logged in to save wishlist items.')
      return
    }

    const user = this.userStore.getUser()

    if (this.items.has(product.id)) {
      throw new Error(`${product.name} is already in your wishlist.`)
    }

    const { data, error } = await supabase
      .from('wishlists')
      .insert([{ product_id: product.id, user_id: user.id }])

    if (error) {
      throw error
    }

    this.items.set(product.id, new WishlistItem(data[0].product))
  }

  async removeItem(product) {
    if (!this.userStore.isLoggedIn) {
      // Handle scenario when user is not logged in
      console.error('User must be logged in to remove wishlist items.')
      return
    }

    const user = this.userStore.getUser()

    if (!this.items.has(product.id)) {
      throw new Error(`${product.name} is not in your wishlist.`)
    }

    const { error } = await supabase
      .from('wishlists')
      .delete()
      .match({ product_id: product.id, user_id: user.id })

    if (error) {
      throw error
    }

    this.items.delete(product.id)
  }

  async moveToCart(product) {
    if (!this.userStore.isLoggedIn) {
      // Handle scenario when user is not logged in
      console.error('User must be logged in to move items to cart.')
      return
    }

    const user = this.userStore.getUser()
    const product_id = product.id

    // Transactional operation - both remove from wishlist and add to cart
    try {
      // Start by removing the item from the wishlist
      const { error: wishlistError } = await supabase
        .from('wishlists')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', product_id)

      if (wishlistError) throw wishlistError

      this.items.delete(product_id)

      // Now, add the item to the cart
      // Assuming you have access to `cartInstance` which is an instance of CartCollection
      await CartCollection.addItem(product, 1) // Add one quantity of the item to the cart

      console.log(`${product.name} has been moved to the cart.`)
    } catch (error) {
      console.error(`Failed to move ${product.name} to cart:`, error.message)
      throw error // Optional: re-throw the error for further handling
    }
  }
  hasItem(product) {
    return this.items.has(product.id)
  }

  // A method to clear all items from the wishlist
  clearWishlist() {
    this.items.clear()
  }

  // Getter to return the number of items in the wishlist
  get itemCount() {
    return this.items.size
  }

  // Getter to return the total value of the wishlist items
  get totalValue() {
    let total = 0
    for (let item of this.items.values()) {
      total += item.product.price // Ensure 'price' exists on 'product'
    }
    return total
  }
}

export { WishlistItem, Wishlist }
