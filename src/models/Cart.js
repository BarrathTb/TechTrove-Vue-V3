import { supabase } from '@/utils/Supabase'
import Product from './Product'
import { useUserStore } from '@/stores/User'

class CartItem {
  constructor(productData, quantity = 1) {
    // Instantiate a new Product object using the product data
    this.product = new Product(productData)
    this.quantity = quantity
  }

  getTotal() {
    if (this.product && typeof this.product.price === 'number') {
      return this.product.price * this.quantity
    } else {
      console.error('Trying to get total of a CartItem with missing product or price', this)
      return 0
    }
  }
}

class CartCollection {
  constructor() {
    this.items = new Map()
    this.userStore = useUserStore()
  }

  async fetchCartItems() {
    // Check if user is logged in
    if (this.userStore.isLoggedIn) {
      const user = this.userStore.getUser()

      // fetching cart items using user.id, including product data
      const { data, error } = await supabase
        .from('carts')
        .select('*, product:products(*)')
        .eq('user_id', user.id)

      if (error) {
        throw error
      }

      this.items.clear()

      data.forEach((item) => {
        if (item.product && typeof item.product_id !== 'undefined') {
          this.items.set(item.product_id, new CartItem(item.product, item.quantity))
        }
      })

      console.log(this.items) // Return the populated items Map
    }
  }

  async saveCartItem(product, quantity) {
    if (!this.userStore.isLoggedIn) {
      console.error('User must be logged in to save cart items.')
      return Promise.reject(new Error('User must be logged in to save cart items.'))
    }

    const user = this.userStore.getUser()

    if (!product || typeof product.id === 'undefined') {
      console.error('Invalid product structure:', product)
      return Promise.reject(new Error('Cannot save cart item without a valid product ID.'))
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

    // Check if the item already exists in the cart
    const existingCartItem = this.items.get(product.id)

    let data, error
    if (existingCartItem) {
      // Update the quantity of the existing cart item
      const { data: updatedData, error: updateError } = await supabase
        .from('carts')
        .update({ quantity: quantity })
        .eq('user_id', user.id)
        .eq('product_id', product.id)
        .single()
      data = updatedData
      error = updateError
    } else {
      // Insert a new cart item since it doesn't exist
      const { data: insertedData, error: insertError } = await supabase
        .from('carts')
        .insert({
          user_id: user.id,
          product_id: product.id,
          quantity: quantity
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
      this.items.set(product.id, new CartItem(productData, data.quantity))
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
    if (existingItem) {
      // If it does, update the quantity
      const newQuantity = existingItem.quantity + quantity
      await this.updateQuantity(product.id, newQuantity)
      console.log(`Updated quantity of ${product.id} to ${newQuantity}`)
    } else {
      try {
        const data = await this.saveCartItem(product, quantity)

        if (data && data.product) {
          this.items.set(product.id, new CartItem(data.product, data.quantity))

          this.items = new Map(this.items)
        }
        await this.fetchCartItems()
      } catch (error) {
        console.error('Failed to add item to cart:', error.message)
        throw error
      }
    }
  }

  async updateQuantity(productId, quantity) {
    if (typeof productId === 'undefined') {
      console.error(`Cannot remove a product without a valid id.`)
      return
    }
    if (quantity <= 0) {
      await this.removeItem(productId)
      return
    }

    const item = this.items.get(productId)
    if (!item) {
      throw new Error(`Product with ID ${productId} not found.`)
    }

    const product = item.product
    if (quantity > product.stock) {
      throw new Error(`Not enough stock available for ${product.name}`)
    }
    try {
      // Save the updated cart item quantity to the backend
      const updatedCartItem = await this.saveCartItem(product, quantity)

      if (updatedCartItem) {
        this.items.set(productId, new CartItem(updatedCartItem.product, updatedCartItem.quantity))
        // Ensure Vue reactivity by replacing the map
        this.items = new Map(this.items)
        console.log(`Updated quantity for product ${productId} to ${quantity}.`)
      }
      await this.fetchCartItems()
    } catch (error) {
      console.error(`Failed to update quantity for product ${productId}:`, error.message)
    }
  }

  async removeItem(productId) {
    if (typeof productId === 'undefined') {
      console.error(`Cannot remove a product without a valid id.`)
      return
    }

    const item = this.items.get(productId)
    if (item) {
      // Set the product property to null or undefined
      item.product = null || undefined
    }

    const success = this.items.delete(productId)
    if (!success) {
      console.error(`Product with id ${productId} not found in the local items.`)
      return
    }

    console.log(`Product with id ${productId} has been removed from the cart.`)

    // Then attempt to delete the item from the backend
    try {
      await this.deleteCartItem({ product: item.product, id: productId })
      await this.synchronizeCart()
    } catch (error) {
      console.error(`Failed to delete product ${productId} from cart:`, error.message)
      // If deletion fails, refresh the cart items from the backend
      await this.fetchCartItems()
    }
  }

  async deleteCartItem(product) {
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
        .from('carts')
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

      this.fetchCartItems()
      throw error
    }
  }

  clearCart() {
    this.items.clear()
    this.deleteAllCartItems()
  }

  async initializeCart() {
    if (this.userStore.isLoggedIn) {
      await this.fetchCartItems() // Load items from the database
    } else {
      this.loadCartFromLocalStorage() // Load items from local storage
    }
  }

  async synchronizeCart() {
    if (this.userStore.isLoggedIn) {
      await this.saveCartToDatabase()
      console.log(this.items)
    } else {
      await this.saveCartToLocalstorage()
    }
  }

  async loadCartFromLocalStorage() {
    const storedCart = localStorage.getItem('cartItems')
    if (storedCart) {
      const cartData = JSON.parse(storedCart)
      for (const item of cartData) {
        try {
          await this.addItem(item.product, item.quantity)
        } catch (error) {
          console.error('Failed to load cart item from local storage:', error)
        }
      }
    }
  }

  async saveCartToLocalstorage() {
    const cartItemsArray = Array.from(this.items.values())
    await new Promise((resolve) => {
      localStorage.setItem('cartItems', JSON.stringify(cartItemsArray), () => {
        resolve()
      })
    })
    console.log(cartItemsArray)
  }

  async saveCartToDatabase() {
    for (let [productId, cartItem] of this.items) {
      try {
        if (!cartItem.product || cartItem.product.id === undefined) {
          console.error('Product information is missing or incomplete', cartItem.product)
          continue // Skip to the next iteration of the loop
        }

        await this.saveCartItem(cartItem.product.id, cartItem.quantity)

        const item = this.items.get(productId)
        if (item) {
          item.quantity = cartItem.quantity

          this.items = new Map(this.items)
        }
        console.log(cartItem)
        console.log(this.items)
      } catch (error) {
        console.error(`Error saving product ${productId}:`, error.message)
      }
    }
  }

  async clearAndPersistCart() {
    this.clearCart()
    if (this.userStore.isLoggedIn) {
      await this.deleteAllCartItems()
    } else {
      localStorage.removeItem('cartItems')
    }
  }

  async deleteAllCartItems() {
    if (this.userStore.isLoggedIn) {
      const user = this.userStore.getUser()
      const { error } = await supabase.from('carts').delete().eq('user_id', user.id)

      if (error) {
        throw error
      }
    }
  }

  get total() {
    if (!this.items || this.items.size === 0) return 0

    for (let item of this.items.values()) {
      if (!item.product || typeof item.product.price !== 'number') {
        console.error('Invalid product data:', item)
      }
    }

    return Array.from(this.items.values()).reduce((total, item) => total + item.getTotal(), 0)
  }

  get itemCount() {
    if (!this.items || this.items.count === 0) return 0
    return Array.from(this.items.values()).reduce((count, item) => count + item.quantity, 0)
  }
}

export { CartItem, CartCollection }
