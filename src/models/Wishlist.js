import { supabase } from '@/utils/Supabase'
import { useUserStore } from '@/stores/User'
import { CartCollection } from './Cart'
import Product from './Product'

class WishlistItem {
  constructor(productData) {
    this.product = new Product(productData)
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
        .select('*, product:products(*)')
        .eq('user_id', user.id)

      if (error) {
        throw error
      }

      this.items.clear()

      data.forEach((item) => {
        this.items.set(item.product.id, new WishlistItem(item.product))
      })
    }
  }

  async saveWishlistItem(product) {
    if (!this.userStore.isLoggedIn) {
      console.error('User must be logged in to save wishlist items.')
      return Promise.reject(new Error('User must be logged in to save wishlist items.'))
    }

    const user = this.userStore.getUser()

    if (!product) {
      console.error('Cannot save wishlist item without a valid product.', product)
      return null
    }

    // Validate product existence
    const { data: productData, error: productError } = await supabase
      .from('products')
      .select('*')
      .eq('id', product.id)
      .single()

    if (productError || !productData) {
      throw new Error(`Product with ID ${product.id} does not exist.`)
    }

    const existingCartItem = this.items.get(product.id)

    let data, error
    if (!existingCartItem) {
      // Insert a new cart item since it doesn't exist
      const { data: insertedData, error: insertError } = await supabase
        .from('wishlists')
        .insert({
          user_id: user.id,
          product_id: product.id
        })
        .single()
      data = insertedData
      error = insertError
    }

    if (error) {
      console.error('Error saving cart item:', error)
      throw error
    }

    // Always update local items Map with the latest data
    if (data && productData) {
      this.items.set(product.id, new WishlistItem(productData))
    }
    return data
  }

  async addItem(product, quantity) {
    if (quantity <= 0) {
      throw new Error('Quantity must be a positive number')
    }

    if (quantity > product.stock) {
      throw new Error(`Not enough stock available for ${product.name}`)
    }

    // Check if item already exists in cart
    const existingItem = this.items.get(product.id)
    if (!existingItem) {
      // If it does, update the quantity

      try {
        const data = await this.saveWishlistItem(product)

        if (data && data.product) {
          this.items.set(product.id, new WishlistItem(data.product))

          this.items = new Map(this.items)
        }
        await this.fetchWishlistItems()
      } catch (error) {
        console.error('Failed to add item to cart:', error.message)
        throw error
      }
    }
  }

  async removeItem(productId) {
    if (typeof productId === 'undefined') {
      console.error(`Cannot remove a product without a valid id.`)
      return
    }

    const success = this.items.delete(productId)

    if (!success) {
      console.error(`Product with id ${productId} not found in the local items.`)
      return
    }

    console.log(`Product with id ${productId} has been removed from the cart.`)

    // Then attempt to delete the item from the backend
    try {
      await this.deleteWishlistItem({ id: productId })
    } catch (error) {
      console.error(`Failed to delete product ${productId} from wishlist:`, error.message)

      // If deletion fails refreshing the cart items from the backend
      await this.fetchWishlistItems()
    }
  }

  async deleteWishlistItem(product) {
    if (!this.userStore.isLoggedIn) {
      console.error('User must be logged in to delete cart items.')
      return null
    }

    if (!product || typeof product.id === 'undefined') {
      console.error('Cannot delete a cart item without a valid product.', product)
      return null
    }

    const user = this.userStore.getUser()

    try {
      const { data, error } = await supabase
        .from('wishlists')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', product.id)

      if (error) {
        throw error
      }

      // Only update local state if backend deletion was successful.
      if (data) {
        data.forEach((row) => this.items.delete(row.product_id))
      }
      console.log(`Product with id ${product.id} has been removed from the cart. `)

      return data
    } catch (error) {
      console.error('Error occurred while deleting cart item:', error)

      this.fetchWishlistItems()
      throw error
    }
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

  async initializeWishlist() {
    if (this.userStore.isLoggedIn) {
      await this.fetchWishlistItems() // Load items from the database
    } else {
      this.loadWishlistFromLocalStorage() // Load items from local storage
    }
  }

  async synchronizeWishlist() {
    if (this.userStore.isLoggedIn) {
      await this.saveWishlistToDatabase()
      console.log(this.items)
    } else {
      await this.saveWishlistToLocalstorage()
    }
  }

  async loadWishlistFromLocalStorage() {
    const storedWishlist = localStorage.getItem('wishlistItems')
    if (storedWishlist) {
      const wishlistData = JSON.parse(storedWishlist)
      for (const item of wishlistData) {
        try {
          await this.addItem(item.product)
        } catch (error) {
          console.error('Failed to load cart item from local storage:', error)
        }
      }
    }
  }

  async saveWishlistToLocalstorage() {
    const wishlistItemsArray = Array.from(this.items.values())
    await new Promise((resolve) => {
      localStorage.setItem('wishlistItems', JSON.stringify(wishlistItemsArray), () => {
        resolve()
      })
    })
    console.log(wishlistItemsArray)
  }

  async saveWishlistToDatabase() {
    for (let [productId, wishlistItem] of this.items) {
      try {
        if (!wishlistItem.product || typeof wishlistItem.product.id === 'undefined') {
          console.error('Product information is missing or incomplete', wishlistItem.product)
          continue // Skip to the next iteration of the loop
        }

        await this.saveWishlistItem(wishlistItem.product.id)

        const item = this.items.get(productId)
        if (item) {
          this.items = new Map(this.items)
        }
        console.log(wishlistItem)
        console.log(this.items)
      } catch (error) {
        console.error(`Error saving product ${productId}:`, error.message)
      }
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
