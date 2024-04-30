<!-- eslint-disable vue/no-mutating-props -->
<template>
  <transition name="slide">
    <div v-if="toggleCartVisibility" id="shopping-cart" class="bg-primary">
      <!-- Shopping Cart Section -->
      <section class="shopping-cart py-5">
        <div class="container">
          <div class="row">
            <div class="col-md-6 col-sm-12 mx-auto">
              <!-- Shopping Cart Table -->
              <div class="card mx-auto bg-secondary mb-3">
                <h2 class="tube-text p-4">Your Cart</h2>
                <div class="table-responsive">
                  <table class="table mx-auto table-dark bg-secondary col-md-4">
                    <thead>
                      <tr>
                        <th scope="col"></th>
                        <th scope="col">Product</th>
                        <th scope="col">Price</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Total</th>
                        <th scope="col">Actions</th>
                      </tr>
                    </thead>
                    <tbody class="mx-auto">
                      <tr v-for="item in cart.cartItems" :key="item.product.id">
                        <td>
                          <img
                            :src="item.product.image"
                            :alt="item.product.name"
                            class="cartImage mx-2 my-2"
                          />
                        </td>
                        <td>{{ item.product.name }}</td>
                        <td>${{ item.product.price.toFixed(2) }}</td>
                        <td>{{ item.quantity }}</td>
                        <td>${{ (item.product.price * item.quantity).toFixed(2) }}</td>
                        <td style="vertical-align: middle">
                          <div class="d-flex align-items-center justify-content-center mx-2 gap-2">
                            <button class="border-0 bg-transparent" @click="editItem(item.product)">
                              <i class="bi bi-pencil icon-light fs-4"></i>
                            </button>
                            <button
                              class="border-0 bg-transparent"
                              @click="removeCartItem(item.product)"
                            >
                              <i class="bi bi-trash fs-4 icon-danger"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr class="align-items-center">
                        <td colspan="6" class="text-end">
                          <h5 class="my-2">Total: ${{ cartTotal }}</h5>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="4" class="text-left">
                          <button class="btn btn-pill-light my-2" @click="closeCart">
                            <i class="fas fa-chevron-left"></i> &lt; Continue Shopping
                          </button>
                        </td>
                        <td colspan="4" class="text-right">
                          <button
                            id="checkoutButton"
                            @click="toggleShippingVisibility"
                            class="btn btn-pill-success my-2"
                          >
                            Checkout
                          </button>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <shipping-section @toggle-shipping="toggleShippingVisibility" />
    </div>
  </transition>
</template>

<script>
import { CartCollection } from '@/models/Cart.js'
import ShippingSection from './ShippingSection.vue'
export default {
  name: 'ShoppingCart',
  components: {
    ShippingSection
  },

  props: {
    cart: {
      type: CartCollection,
      required: true
    }
  },
  data() {
    return {
      // cartVisible: false,
      shippingVisible: false
    }
  },

  computed: {
    cartTotal() {
      // Use the 'total' getter from CartCollection
      return this.cart.total.toFixed(2)
    },

    cartItemCount() {
      return this.cart.cartItems.reduce((count, item) => count + item.quantity, 0)
    }
  },

  methods: {
    toggleCartVisibility() {
      this.$emit('toggle-cart')
      this.cartVisible = !this.cartVisible
    },
    toggleShippingVisibility() {
      this.shippingVisible = !this.shippingVisible
    },
    updateCart() {
      this.$emit('update-cart-count', this.cartItemCount)
    },

    removeCartItem(item) {
      this.$emit('remove-cart-item', item)
    },
    editItem(item) {
      this.$emit('edit-item', item)
    },

    addToCart(item, quantity = 1) {
      this.cart.addItem(item, quantity) // Call the addItem of CartCollection
      this.updateCart() // Update the cart count after adding the item

      this.$emit('update-cart')
    },
    clearCart() {
      this.cart.clearCart() // Use clearCart method from CartCollection
    },
    addToWishlist(product) {
      if (!this.wishlistItems.find((item) => item.id === product.id)) {
        this.wishlistItems.push(product)
      }
    },
    removeFromWishlist(index) {
      this.wishlistItems.splice(index, 1)
    },
    moveToCart(wishlistItem) {
      this.addToCart(wishlistItem)
      const wishlistIndex = this.wishlistItems.findIndex((item) => item.id === wishlistItem.id)
      if (wishlistIndex !== -1) {
        this.removeFromWishlist(wishlistIndex)
      }
    }
  }
}
</script>

<style scoped>
.slide-enter-active,
.slide-leave-active {
  transition:
    opacity 0.5s,
    transform 0.5s;
}

.slide-enter-from,
.slide-leave-to {
  opacity: 0;
  transform: translateY(20px) ease in-out;
}

.card {
  max-width: 800px;
}

td {
  vertical-align: middle;
  justify-content: space-between;
}
</style>
