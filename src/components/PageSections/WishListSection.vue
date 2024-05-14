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
                      <tr v-for="item in wishlistItems" :key="item.id">
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
                            <button
                              @click="$emit('move-wish-item', item)"
                              class="border-0 bg-transparent"
                            >
                              <i class="bi bi-cart-plus fs-4 icon-success"></i>
                            </button>
                            <button
                              @click="removeFromWishlist(item)"
                              class="border-0 bg-transparent"
                            >
                              <i class="bi bi-trash fs-4 icon-danger"></i>
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
  props: {
    wishlist: {
      type: Wishlist,
      required: true
    },
    cart: {
      type: CartCollection,
      required: true
    }
  },

  data() {
    return {
      wishlistVisible: false
      // wishlist: new Wishlist(),
    }
  },

  computed: {
    wishlistTotal() {
      return this.wishlist.total.toFixed(2)
    },

    wishlistItems() {
      return Array.from(this.wishlist.items.values())
    },

    wishlistItemCount() {
      return this.wishlist.items.size
    }
  },
  watch: {
    wishlistItemCount(newCount) {
      this.$emit('update-wishlist-count', newCount)
    }
  },
  methods: {
    toggleWishlistVisibility() {
      this.wishlistVisible = !this.wishlistVisible
    },

    moveToCart(item) {
      this.$emit('move-to-cart', item)
    },
    removeFromWishlist(item) {
      // Make sure you're passing the correct item structure
      this.$emit('remove-wish-item', item)
    },
    updateWishlist(updatedWishlistItems) {
      this.$emit('update-wishlist', updatedWishlistItems)
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
