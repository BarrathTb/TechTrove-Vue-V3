<template>
  <transition name="fade">
    <section v-show="paymentMethodsVisible">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-12">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Payment Methods
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Manage your saved payment methods.
            </p>
            <img
              :src="localUser?.avatar_url || defaultAvatarUrl"
              class="avatar ms-4"
              alt="Avatar"
            />
          </div>
        </div>

        <div class="container-fluid mt-2 ms-4">
          <div class="row">
            <div class="col-12 col-lg-7">
              <!-- Saved Payment Methods List -->
              <h5 class="text-white mb-3 mt-4">Saved Methods</h5>
              <div v-if="savedMethods.length === 0" class="text-muted p-3 bg-secondary rounded-2">
                No payment methods saved.
              </div>
              <div v-else>
                <div
                  v-for="(method, index) in savedMethods"
                  :key="index"
                  class="saved-method bg-secondary p-3 rounded-2 mb-2 d-flex justify-content-between align-items-center"
                >
                  <div>
                    <span class="text-white">{{ method.type }} ending in {{ method.last4 }}</span>
                    <p class="text-muted small mb-0">Expires {{ method.expiry }}</p>
                  </div>
                  <button class="btn btn-danger btn-sm" @click="removeMethod(index)">Remove</button>
                </div>
              </div>

              <!-- Add New Payment Method Form -->
              <h5 class="text-white mt-5 mb-3">Add New Card</h5>
              <form class="form-widget" @submit.prevent="addPaymentMethod">
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="cardNumber" class="text-white d-flex align-items-center"
                      ><i class="bi bi-credit-card-2-front-fill me-4"></i>Card Number</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="cardNumber"
                      type="text"
                      v-model="newMethod.cardNumber"
                      class="form-control select-input"
                      placeholder="•••• •••• •••• ••••"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="expiryDate" class="text-white d-flex align-items-center"
                      ><i class="bi bi-calendar-event-fill me-4"></i>Expiry Date</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="expiryDate"
                      type="text"
                      v-model="newMethod.expiry"
                      class="form-control select-input"
                      placeholder="MM/YY"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="cvc" class="text-white d-flex align-items-center"
                      ><i class="bi bi-lock-fill me-4"></i>CVC</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="cvc"
                      type="text"
                      v-model="newMethod.cvc"
                      class="form-control select-input"
                      placeholder="•••"
                    />
                  </div>
                </div>

                <div>
                  <button
                    class="btn btn-success btn-sm px-4 mt-4 text-black btn-bold align-items-center justify-content-end"
                    type="submit"
                    :disabled="loading"
                  >
                    <i class="bi bi-plus-circle-fill fs-5 me-2 text-black"></i>
                    {{ loading ? 'Saving...' : 'Add Card' }}
                  </button>
                </div>
              </form>
            </div>
            <!-- Optional Offers Box -->
            <div class="col-12 col-lg-5 h-100 bg-primary ms-lg-4 mt-4">
              <div class="container-fluid ms-4">
                <div class="bg-secondary p-4 rounded-2 me-4">
                  <h3 class="text-white">
                    <i class="bi bi-shield-lock-fill me-2"></i>Secure Payments
                  </h3>
                  <p class="text-white small">
                    Your payment information is securely processed and stored. We use
                    industry-standard encryption to protect your data.
                  </p>
                </div>
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
  name: 'ProfilePaymentMethods',
  props: {
    paymentMethodsVisible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      loading: false,
      savedMethods: [
        // Example data
        { type: 'Visa', last4: '1234', expiry: '12/25' },
        { type: 'Mastercard', last4: '5678', expiry: '06/26' }
      ],
      newMethod: {
        cardNumber: '',
        expiry: '',
        cvc: ''
      }
    }
  },
  computed: {
    localUser() {
      const userStore = useUserStore()
      return userStore.profile || {}
    }
  },
  methods: {
    async addPaymentMethod() {
      this.loading = true
      console.log('Adding payment method:', this.newMethod)
      // Add actual logic to validate and save the payment method via API/store
      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1500))
      // Add to saved methods list (example)
      this.savedMethods.push({
        type: 'New Card', // Determine type based on number if possible
        last4: this.newMethod.cardNumber.slice(-4),
        expiry: this.newMethod.expiry
      })
      console.log('Payment method added (simulated).')
      // Clear form
      this.newMethod = { cardNumber: '', expiry: '', cvc: '' }
      this.loading = false
    },
    removeMethod(index) {
      console.log('Removing method at index:', index)
      // Add logic to remove method via API/store
      this.savedMethods.splice(index, 1)
      // Show confirmation or handle errors
    }
  }
}
</script>

<style scoped>
.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 1rem;
}
.saved-method {
  /* Styles for saved method items */
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Responsive adjustments */
@media (max-width: 991.98px) {
  .form-widget .row .col-12.col-lg-4 label {
    margin-bottom: 0.5rem;
  }
  .col-12.col-lg-5.bg-primary {
    margin-left: 0 !important;
    margin-top: 2rem;
  }
  .container-fluid.mt-2.ms-4 {
    margin-left: 0 !important;
  }
}
</style>
