class CartItem {
  constructor(item) {
    this.product = item
    this.quantity = 1
  }
}

class CartCollection {
  constructor() {
    this.cartItems = []
  }
  addItem(product, quantity = 1) {
    let found = this.cartItems.find((item) => item.product.id === product.id)
    if (found) {
      found.quantity += quantity

      if (found.quantity > product.stock) {
        throw new Error('Not enough stock available')
      }
    } else {
      const newItem = new CartItem(product)
      newItem.quantity = quantity
      this.cartItems.push(newItem)
    }
  }

  editItem(product, newQuantity) {
    let found = this.cartItems.find((item) => item.product.id === product.id)

    if (!found) {
      throw new Error('Item not found in cart')
    }

    if (newQuantity <= 0) {
      this.removeItem(product.id)
    } else if (newQuantity > found.product.stock) {
      throw new Error('Not enough stock available')
    } else {
      const newItem = new CartItem(product)
      newItem.quantity = newQuantity
      this.cartItems.push(newItem)
    }
  }
  removeItem(product) {
    this.cartItems = this.cartItems.filter((item) => item.product.id !== product.id)
  }
  updateQuantity(product, quantity) {
    let found = this.cartItems.find((item) => item.product.id === product.id)
    if (found) {
      if (quantity <= 0) {
        this.removeItem(product.id)
      } else if (quantity <= found.product.stock) {
        found.quantity = quantity
      } else {
        throw new Error('Not enough stock available')
      }
    }
  }
  clearCart() {
    this.cartItems = []
  }
}

Object.defineProperty(CartCollection.prototype, 'total', {
  get: function () {
    return this.cartItems.reduce((total, item) => total + item.product.price * item.quantity, 0)
  }
})

Object.defineProperty(CartCollection.prototype, 'itemCount', {
  get: function () {
    return this.cartItems.reduce((count, item) => count + item.quantity, 0)
  }
})

export default CartCollection
