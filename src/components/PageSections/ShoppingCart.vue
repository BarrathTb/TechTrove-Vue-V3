<!-- eslint-disable vue/no-mutating-props -->
<template>
  <transition name="slide">
    <div v-show="toggleCartVisibility" id="shopping-cart" class="bg-primary">
      <!-- Shopping Cart Section -->
      <section class="shopping-cart py-5">
        <div class="container">
          <div class="row">
            <div class="col-md-6 col-sm-12 mx-auto">
              <!-- Shopping Cart Table -->
              <div class="card mx-auto bg-secondary mb-3">
                <h2 class="tube-text p-4">Your Cart</h2>
                <div class="table-responsive">
                  <table class="table mx-auto table-dark bg-secondary col-md-4" style="width: 100%">
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
                      <tr v-for="item in cartItems" :key="item.id">
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
                            <button class="border-0 bg-transparent" @click="emitEditItem(item)">
                              <i class="bi bi-pencil icon-light fs-4"></i>
                            </button>
                            <button
                              class="border-0 bg-transparent"
                              @click="emitRemoveCartItem(item)"
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
                          <button class="btn btn-pill-light my-2" @click="toggleCartContinue">
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
    </div>
  </transition>
</template>

<script>
import { CartCollection } from '@/models/Cart.js'

export default {
  name: 'ShoppingCart',

  props: {
    cart: {
      type: CartCollection,
      required: true
    }
  },
  data() {
    return {
      cartVisible: false
    }
  },

  computed: {
    cartTotal() {
      return this.cart.total.toFixed(2)
    },

    cartItems() {
      return Array.from(this.cart.items.values())
    },

    cartItemCount() {
      return this.cart.items.size
    }
  },

  methods: {
    toggleCartVisibility() {
      this.$emit('toggle-cart')
    },
    toggleCartContinue() {
      this.toggleCartVisibility()
    },
    emitRemoveCartItem(item) {
      this.$emit('remove-cart-item', item)
    },

    emitEditItem(item) {
      this.$emit('edit-item', item)
    },

    toggleShippingVisibility() {
      this.$emit('toggle-shipping')
    },
    updateCart(updatedCartItems) {
      this.$emit('update-cart', updatedCartItems)
    },

    addToCart(item, quantity = 1) {
      this.cart.addItem(item, quantity)
      this.updateCart()

      this.$emit('update-cart')
    },
    clearCart() {
      this.cart.clearCart()
    },
    addToWishlist(product) {
      if (!this.wishlistItems.find((item) => item.id === product.id)) {
        this.wishlistItems.push(product)
      }
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
.fade-enter-active,
.fade-leave-active {
  transition:
    opacity 1s,
    transform 1s;
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
