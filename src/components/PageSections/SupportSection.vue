<template>
  <transition name="slide">
    <section v-show="isSupportVisible" class="bg-primary py-5" id="support-section">
      <div class="container">
        <div class="card bg-secondary rounded-3 text-light mx-auto" style="max-width: 900px">
          <div class="card-body">
            <h3 class="tube-text-yellow">Support Information</h3>
            <p>
              If you need assistance with any of our products or services, please reach out to us:
            </p>
            <ul>
              <li><strong>Email:</strong> support@techtrove.com</li>
              <li><strong>Phone:</strong> 1-800-TECH-TROVE</li>
              <li><strong>Live Chat:</strong> Available 24/7 on our website</li>
            </ul>
            <p>Our support team is here to help you with:</p>
            <ul>
              <li>Product Inquiries</li>
              <li>Order Status and Shipping Information</li>
              <li>Returns and Exchanges</li>
              <li>Technical Support and Troubleshooting</li>
            </ul>
            <p>Thank you for choosing TechTrove for your computer parts needs!</p>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
export default {
  data() {
    return {
      isSupportVisible: false
    }
  },
  methods: {
    toggleSupportVisibility() {
      this.isSupportVisible = !this.isSupportVisible
    }
  }
}
</script>

<style>
.slide-enter-active,
.slide-leave-active {
  transition:
    opacity 1.5s,
    transform 1.5s;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-enter-from,
.slide-leave-to {
  opacity: 0;
  transform: translateY(20px) ease in-out;
}
</style>
