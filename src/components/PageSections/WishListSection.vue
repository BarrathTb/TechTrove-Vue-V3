<template>
  <transition name="slide">
    <div v-show="toggleWishlistVisibility">
      <section class="wishlist py-3">
        <h2 class="tube-text p-2">Your Wishlist</h2>
        <div class="table-responsive">
          <table class="table bg-secondary col-md-4">
            <thead>
              <tr>
                <th scope="col"></th>
                <th scope="col">Product</th>
                <th scope="col">Price</th>
                <th scope="col">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in wishlistItems" :key="`wishlist-${item.id}`">
                <td><img :src="item.image" :alt="item.name" class="cartImage mx-2 my-2" /></td>
                <td>{{ item.name }}</td>
                <td>${{ item.price.toFixed(2) }}</td>
                <td style="vertical-align: middle">
                  <button @click="moveToCart(item)" class="btn btn-success">Add to Cart</button>
                  <button @click="removeFromWishlist(index)" class="btn btn-danger ml-2">
                    <i class="bi bi-trash"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </transition>
</template>
<script>
export default {
  name: 'WishlistSection',
  props: {
    wishlistItems: Array,
    toggleWishVisibility: Boolean
  },
  computed: {
    wishTotal() {
      const total = this.wishListItems.reduce((total, item) => {
        return total + item.price * item.quantity
      }, 0)
      return total.toFixed(2)
    },

    wishItemCount() {
      return this.wishListItems.reduce((count, item) => count + item.quantity, 0)
    }
  },
  methods: {
    removeFromWishlist(index) {
      this.$emit('remove-wishlist-item', index)
    },
    moveToCart(item) {
      this.$emit('move-to-cart', item)
    }
  }
}
</script>

<style scoped>
/* Add styles for your wishlist here */
</style>
