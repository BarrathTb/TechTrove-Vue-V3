class WishlistItem {
  constructor(item) {
    this.product = item
  }
}

class Wishlist {
  constructor() {
    this.wishlistItems = []
  }

  addProduct(product) {
    const exists = this.wishlistItems.some((item) => item.product.id === product.id)
    if (!exists) {
      this.wishlistItems.push(new WishlistItem(product))
    }
  }

  removeProduct(productId) {
    this.wishlistItems = this.wishlistItems.filter((item) => item.product.id !== productId)
  }

  clearWishlist() {
    this.wishlistItems = []
  }

  moveToCart(productId, cart) {
    const productIndex = this.wishlistItems.findIndex((item) => item.product.id === productId)

    if (productIndex !== -1) {
      const [wishlistItem] = this.wishlistItems.splice(productIndex, 1) // Remove the item from the wishlist
      try {
        cart.addItem(wishlistItem.product) // Add the removed item's product to the cart
      } catch (error) {
        console.error(error.message)
        this.wishlistItems.splice(productIndex, 0, wishlistItem)
      }
    }
  }

  get itemCount() {
    return this.wishlistItems.length
  }
}

export default Wishlist
