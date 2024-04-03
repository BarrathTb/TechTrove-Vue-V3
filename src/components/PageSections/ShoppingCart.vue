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
                      <tr
                        v-for="(item, index) in cartItems"
                        :key="item.id"
                        class="align-items-center mx-auto"
                      >
                        <td>
                          <img :src="item.image" :alt="item.name" class="cartImage mx-2 my-2" />
                        </td>
                        <td>{{ item.name }}</td>
                        <td>${{ item.price.toFixed(2) }}</td>
                        <td>{{ item.quantity }}</td>
                        <td>${{ (item.price * item.quantity).toFixed(2) }}</td>
                        <td style="vertical-align: middle">
                          <div class="d-flex align-items-center justify-content-center mx-2 gap-2">
                            <button class="border-0 bg-transparent" @click="editItem(index)">
                              <i class="bi bi-pencil icon-light fs-4"></i>
                            </button>
                            <button class="border-0 bg-transparent" @click="removeCartItem(index)">
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
    </div>
  </transition>
</template>

<script>
export default {
  name: 'ShoppingCart',
  components: {},

  props: {
    cartItems: Array
  },
  data() {
    return {
      products: Array,
      wishlistItems: []
    }
  },

  computed: {
    cartTotal() {
      const total = this.cartItems.reduce((total, item) => {
        return total + item.price * item.quantity
      }, 0)
      return total.toFixed(2)
    },

    cartItemCount() {
      return this.cartItems.reduce((count, item) => count + item.quantity, 0)
    }
  },

  methods: {
    toggleCartVisibility() {
      this.$emit('toggle-cart')
      this.cartVisible = !this.cartVisible
    },
    toggleShippingVisibility() {
      this.$emit('toggle-shipping')
    },
    updateCart() {
      this.$emit('update-cart-count', this.cartItemCount)
    },

    removeCartItem(index) {
      this.$emit('remove-cart-item', index)
    },
    editItem(index) {
      this.$emit('edit-item', index)
    },

    addToCart(item) {
      const productToAdd = item.product || item
      const quantityToAdd = item.quantity || 1

      const foundIndex = this.cartItems(
        (cartItem) => cartItem.id === productToAdd.id && cartItem.quantity === quantityToAdd
      )

      if (foundIndex !== -1) {
        this.$emit('update-cart', this.cartItems)
      }
    },
    clearCart() {
      this.$emit('update-cart', this.cartItems)
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
      this.addToCart({ product: wishlistItem, quantity: 1 })
      this.removeFromWishlist(this.wishlistItems.indexOf(wishlistItem))
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
