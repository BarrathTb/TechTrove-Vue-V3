<template>
  <transition name="fade">
    <section v-show="ordersVisible">
      <div class="profile-orders">
        <h3 class="text-white text-center mb-4">Recent Orders</h3>
        <div v-if="loading" class="text-center">
          <div class="spinner-border text-light" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        <div v-else-if="orders.length === 0" class="text-center text-muted">No orders found.</div>
        <div v-else class="order-list">
          <div
            v-for="order in orders"
            :key="order.id"
            class="order-item bg-secondary p-4 rounded mb-3"
          >
            <div class="row">
              <div class="col-12 col-md-3 mb-3 mb-md-0">
                <h5 class="text-white">Order #{{ order.id }}</h5>
                <p class="text-muted">Placed on {{ formatDate(order.created_at) }}</p>
              </div>
              <div class="col-12 col-md-6 mb-3 mb-md-0">
                <div v-for="item in order.items" :key="item.id" class="order-product">
                  <div class="d-flex align-items-center mb-2">
                    <img
                      :src="item.product.image"
                      :alt="item.product.name"
                      class="order-product-image me-3"
                    />
                    <div>
                      <h6 class="text-white mb-0">{{ item.product.name }}</h6>
                      <p class="text-muted mb-0">
                        Quantity: {{ item.quantity }} | {{ formatPrice(item.price) }}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-12 col-md-3 text-md-end">
                <h5 class="text-white">Total: {{ formatPrice(order.total_amount) }}</h5>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
import { useUserStore } from '@/stores/User'

export default {
  data() {
    return {
      orders: [],
      loading: true
    }
  },
  async mounted() {
    const userStore = useUserStore()

    // Run this only if there is an existing session
    if (userStore.isLoggedIn) {
      await userStore.fetchProfile()
    }
  },

  computed: {
    isLoggedIn() {
      const userStore = useUserStore()
      return userStore.isLoggedIn
    },
    // Use the user information from the profile in the store
    localUser() {
      const userStore = useUserStore()
      return userStore.profile || {} // Fallback to an empty object if no profile found
    }
  },
  watch: {
    isLoggedIn: {
      handler(loggedIn) {
        if (loggedIn) {
          const userStore = useUserStore()
          userStore.fetchProfile() // Fetch profile on login
        } else {
          console.log('No user is logged in.')
        }
      },
      immediate: true // This ensures the handler runs immediately after mount
    }
  },
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString()
    },
    formatPrice(price) {
      return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
      }).format(price)
    }
  }
}
</script>

<style scoped>
.profile-orders {
  max-width: 800px;
  margin: 0 auto;
}

.order-item {
  background-color: #343a40;
}

.order-product-image {
  width: 50px;
  height: 50px;
  object-fit: cover;
}
.fade-enter-active {
  transition:
    opacity 1.5s,
    transform 1.5s;
  transition-delay: 0.6s;
}
.fade-leave-active {
  transition:
    opacity 0.5s,
    transform 0.5s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
@media (max-width: 767.98px) { /* Target screens smaller than md breakpoint */ .profile-orders {
max-width: none; /* Allow container to use full width */ padding-left: 1rem; /* Add some padding */
padding-right: 1rem; } .order-item { padding: 1rem; /* Adjust padding for smaller screens */ } }
