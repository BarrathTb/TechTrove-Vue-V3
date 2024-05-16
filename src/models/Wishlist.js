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
    // if (!this.userStore.isLoggedIn) {
    //   console.error('User must be logged in to save wishlist items.')
    //   return Promise.reject(new Error('User must be logged in to save wishlist items.'))
    // }

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

  async addItem(product) {
    if (typeof product === 'undefined' || product === null) {
      console.error(`Cannot add an undefined or null product to the wishlist.`)
      return
    }

    // Check if item already exists in wishlist
    const existingItem = this.items.get(product.id)
    if (existingItem) {
      console.error(`Product with id ${product.id} is already in the wishlist.`)
      return
    }

    if (!this.userStore.isLoggedIn) {
      this.items.set(product.id, new WishlistItem(product))
      this.synchronizeWishlist()
      console.log(`Product with id ${product.id} has been added to the wishlist.`)
    } else {
      try {
        const data = await this.saveWishlistItem({ product })
        if (data && data.product) {
          this.items.set(product.id, new WishlistItem(data.product))
        }
        console.log(`Product with id ${product.id} has been added to the wishlist.`)
        await this.fetchWishlistItems()
      } catch (error) {
        console.error('Failed to add item to wishlist:', error.message)
      }
    }
  }

  async removeItem(productId) {
    if (typeof productId === 'undefined') {
      console.error(`Cannot remove a product without a valid id.`)
      return
    }

    // Attempt to delete the item from the local wishlist first
    const success = this.items.delete(productId)
    if (!success) {
      console.error(`Product with id ${productId} was not found in the wishlist.`)
      return
    } else {
      console.log(`Product with id ${productId} has been removed from the wishlist.`)
    }

    if (!this.userStore.isLoggedIn) {
      // Handle removing from wishlist for unauthenticated users using local storage
      this.synchronizeWishlist()
    } else {
      try {
        await this.deleteWishlistItem({ id: productId })
      } catch (error) {
        console.error(`Failed to delete product ${productId} from wishlist:`, error.message)

        await this.fetchWishlistItems()
      }
    }
  }

  async deleteWishlistItem(product) {
    // if (!this.userStore.isLoggedIn) {
    //   console.error('User must be logged in to delete cart items.')
    //   return null
    // }

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

  // async moveToCart(product) {
  //   // if (!this.userStore.isLoggedIn) {
  //   //   // Handle scenario when user is not logged in
  //   //   console.error('User must be logged in to move items to cart.')
  //   //   return
  //   // }

  //   const user = this.userStore.getUser()

  //   // Transactional operation - both remove from wishlist and add to cart
  //   try {
  //     // Start by removing the item from the wishlist
  //     const { error: wishlistError } = await supabase
  //       .from('wishlists')
  //       .delete()
  //       .eq('user_id', user.id)
  //       .eq('product_id', product.id)

  //     if (wishlistError) throw wishlistError

  //     this.items.delete(product.id)

  //     await CartCollection.addItem(product, 1)

  //     console.log(`${product.name} has been moved to the cart.`)
  //   } catch (error) {
  //     console.error(`Failed to move ${product.name} to cart:`, error.message)
  //     throw error
  //   }
  // }
  async moveToCart(product) {
    if (!product || typeof product.id === 'undefined') {
      console.error('Cannot move an undefined product to the cart.')
      return
    }

    if (!this.userStore.isLoggedIn) {
      localStorage.setItem('tempCartItem', JSON.stringify(product))
      console.log('User is not logged in. The product has been saved for later.')

      return
    }

    const user = this.userStore.getUser()

    try {
      const { data: deletedWishlistItems, error: wishlistError } = await supabase
        .from('wishlists')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', product.id)

      if (wishlistError) throw wishlistError

      // Ensure the selected product was deleted before proceeding
      if (deletedWishlistItems.length === 0) {
        console.error(`Product ${product.name} not found in the wishlist.`)
        return
      }

      this.items.delete(product.id)

      // Proceed to add the item to the cart
      const { error: cartError } = await CartCollection.addItem(product, 1)

      if (cartError) throw cartError

      console.log(`${product.name} has been moved to the cart.`)
    } catch (error) {
      console.error(`Failed to move ${product.name} to cart:`, error.message)
      throw error
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
      total += item.product.price
    }
    return total
  }
}

export { WishlistItem, Wishlist }
