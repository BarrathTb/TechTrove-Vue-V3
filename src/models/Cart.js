import { supabase } from '@/utils/Supabase'

class CartItem {
  constructor(product, quantity = 1) {
    this.product = product
    this.quantity = quantity
  }

  getTotal() {
    return this.product.price * this.quantity
  }
}

class CartCollection {
  constructor(user) {
    this.user = user
    this.items = new Map()
  }

  async fetchCartItems() {
    const { data, error } = await supabase
      .from('carts')
      .select('*, products(*)')
      .eq('user_id', this.user.id)

    if (error) {
      throw error
    }

    data.forEach((item) => {
      this.items.set(item.product.id, new CartItem(item.product, item.quantity))
    })
  }

  addItem(product, quantity = 1) {
    if (quantity <= 0) {
      throw new Error('Quantity must be a positive number')
    }

    if (quantity > product.stock) {
      throw new Error(`Not enough stock available for ${product.name}`)
    }

    if (this.items.has(product.id)) {
      this.updateQuantity(product, this.items.get(product.id).quantity + quantity)
    } else {
      this.items.set(product.id, new CartItem(product, quantity))
    }
  }

  updateQuantity(product, quantity) {
    if (quantity <= 0) {
      this.removeItem(product)
    } else if (quantity > product.stock) {
      throw new Error(`Not enough stock available for ${product.name}`)
    } else {
      const item = this.items.get(product.id)
      item.quantity = quantity
    }
  }

  removeItem(product) {
    this.items.delete(product.id)
  }

  clearCart() {
    this.items.clear()
  }

  get total() {
    return Array.from(this.items.values()).reduce((total, item) => total + item.getTotal(), 0)
  }

  get itemCount() {
    return Array.from(this.items.values()).reduce((count, item) => count + item.quantity, 0)
  }
}

export { CartItem, CartCollection }
