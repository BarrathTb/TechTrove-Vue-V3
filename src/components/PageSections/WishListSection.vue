<template>
  <transition name="slide">
    <div v-show="toggleWishlistVisibility" id="wishlist" class="bg-primary">
      <!-- Wishlist Section -->
      <section class="wishlist py-3">
        <div class="container">
          <div class="row">
            <div class="col-md-6 col-sm-12 mx-auto">
              <!-- Shopping Cart Table -->
              <div class="card mx-auto bg-secondary mb-3">
                <h2 class="tube-text-pink p-2">Your Wishlist</h2>
                <div class="table-responsive">
                  <table class="table mx-auto table-dark bg-secondary col-md-4">
                    <thead>
                      <tr>
                        <th scope="col"></th>
                        <th scope="col">Product</th>
                        <th scope="col">Price</th>
                        <th scope="col">Actions</th>
                      </tr>
                    </thead>
                    <tbody class="mx-auto">
                      <tr
                        v-for="(item, index) in wishlist.items"
                        :key="`wishlist-item-${item.product.id}`"
                      >
                        <td>
                          <img
                            :src="item.product.image"
                            :alt="item.product.name"
                            class="cartImage mx-2 my-2"
                          />
                        </td>
                        <td>{{ item.product.name }}</td>
                        <td>${{ item.product.price.toFixed(2) }}</td>
                        <td style="vertical-align: middle">
                          <div class="d-flex align-items-center justify-content-center mx-2 gap-2">
                            <button @click="moveToCart(item.product)" class="btn btn-success">
                              Add to Cart
                              <i class="bi bi-trash"></i>
                            </button>
                            <button
                              @click="removeFromWishlist(item.product)"
                              class="btn btn-danger ml-2"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                    <tfoot>
                      <tr>
                        <td colspan="4" class="text-right">
                          <h5>Total Items: {{ wishlist.itemCount }}</h5>
                          <h5>Total Price: ${{ wishlist.totalValue.toFixed(2) }}</h5>
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
import { Wishlist } from '@/models/Wishlist'
import { CartCollection } from '@/models/Cart'

export default {
  name: 'WishlistSection',

  data() {
    return {
      wishlist: new Wishlist(),
      cart: new CartCollection()
    }
  },
  created() {
    this.loadWishlist()
  },
  methods: {
    toggleWishlistVisibility() {
      this.wishlistVisible = !this.wishlistVisible
    },
    loadWishlist() {
      this.wishlist.fetchWishlistItems().catch((error) => {
        console.error('Error fetching wishlist items:', error.message)
      })
    },

    async removeFromWishlist(product) {
      await this.wishlist.removeItem(product).catch((error) => {
        console.error('Error removing item from wishlist:', error.message)
      })
      // Optionally refresh the list or handle UI update
    },

    async moveToCart(product) {
      await this.wishlist.moveToCart(product).catch((error) => {
        console.error('Error moving item to cart:', error.message)
      })
      // Optionally refresh the cart/wishlist or handle UI updates
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
