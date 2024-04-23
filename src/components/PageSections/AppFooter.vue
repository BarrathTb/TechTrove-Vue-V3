<template>
  <div class="app-footer">
    <footer class="da-fade text-light app-footer">
      <div class="container">
        <div class="row g-4 justify-content-between px-2">
          <div class="col-lg-4 col-md-6">
            <h5>About Us</h5>
            <p>
              Our mission is to deliver outstanding service and products to our customers. Learn
              more about our story and how we work hard to ensure you're always satisfied.
            </p>
            <a href="/about" class="text-decoration-none btn btn-outline-light">Learn More</a>
          </div>

          <div class="col-lg-4 col-md-6">
            <h5>Newsletter</h5>
            <p>
              Stay updated with the latest news and special offers by subscribing to our newsletter.
            </p>

            <form @submit.prevent="subscribeToNewsletter">
              <div class="input-group">
                <input
                  v-model="email"
                  type="email"
                  class="form-control"
                  placeholder="Enter your email"
                  aria-label="Recipient's email"
                />
                <button class="btn btn-outline-light ms-1 subscribe-button" type="submit">
                  Subscribe
                </button>
              </div>
            </form>
          </div>

          <div class="col-lg-2 col-md-6">
            <h5>Quick Links</h5>
            <div class="row g-2">
              <div class="col-6">
                <a href="/" class="text-decoration-none btn btn-outline-light my-1 w-100">Home</a>
              </div>
              <div class="col-6">
                <a href="/products" class="text-decoration-none btn btn-outline-light my-1 w-100"
                  >Products</a
                >
              </div>
              <div class="col-6">
                <a href="/services" class="text-decoration-none btn btn-outline-light my-1 w-100"
                  >Services</a
                >
              </div>
              <div class="col-6">
                <a href="/contact" class="text-decoration-none btn btn-outline-light my-1 w-100"
                  >Contact</a
                >
              </div>
            </div>
          </div>

          <div class="col-12 text-center mb-2">
            <p>Follow us on social media:</p>

            <a href="#" class="btn btn-light mx-1">
              <i class="bi bi-facebook"></i>
            </a>
            <a href="#" class="btn btn-light mx-1">
              <i class="bi bi-twitter"></i>
            </a>
            <a href="#" class="btn btn-light mx-1">
              <i class="bi bi-instagram"></i>
            </a>
            <a href="#" class="btn btn-light mx-1">
              <i class="bi bi-youtube"></i>
            </a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'AppFooter',
  data() {
    return {
      email: ''
    }
  },
  methods: {
    subscribeToNewsletter() {
      console.log('Subscribing with email:', this.email)
    }
  }
}
</script>

<style scoped>
.subscribe-button {
  z-index: -10;
}

.da-fade {
  background: linear-gradient(180deg, black 0%, #2c2c2c 100%);
}
</style>
