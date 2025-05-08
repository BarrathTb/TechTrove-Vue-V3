<template>
  <div class="product-item-card product-card h-100 bg-secondary d-flex flex-column py-auto my-auto">
    <div class="card-img-container bg-white p-4 d-flex justify-content-center align-items-center">
      <img :src="product.image" class="product-img-top" :alt="product.name" />
    </div>
    <div class="card-body text-light d-flex flex-column justify-content-between my-auto py-auto">
      <h5 class="card-title text-center font-size-sm">{{ product.name }}</h5>
      <p class="product-card-text text-left mx-2 font-size-sm">{{ product.description }}</p>
      <button type="button" class="btn btn-success-2 my-2" @click="handleViewDetails">
        View Product Details
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductCard',

  props: {
    product: {
      type: Object,
      required: true
    },
    modelValue: {
      type: Boolean,
      default: false
    }
  },
  watch: {
    modelValue(newValue) {
      this.detailsVisible = newValue
    }
  },
  emits: ['view-details'],
  methods: {
    handleViewDetails() {
      this.$emit('view-details', this.product)
    }
  }
}
</script>
<style scoped>
/* Styles specific to the news card */
.product-item-card {
  padding: 1rem;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  border-radius: 0.5rem;
  background: linear-gradient(rgba(18, 18, 18, 0.8), rgba(44, 44, 44, 0.95)),
    url('/images/card-back.jpg');
  background-size: cover; /* Ensure the background image covers the entire element */
  background-position: center; /* Center the background image */
}
.card-img-container {
  width: 95%; /* Width is 100% of the card */
  max-height: 40vh;
  min-height: 20vh; /* Maximum height for your image */
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 0.25rem;
}

.product-img-top {
  max-width: 90%; /* The image can be as wide as its container */
  max-height: 90%; /* The image can be as tall as its container */

  border-radius: 0.25rem; /* Ensures image maintains aspect ratio but fits within the space */
}

.product-card .card-body {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  max-width: 95%;
}

.product-card .card-title {
  text-align: center;
  margin-top: 1rem; /* Add spacing above title if needed */
}
.product-card-text {
  flex-grow: 1;
  text-align: left;
  margin: 1rem;

  /* Add spacing above title if needed */
}

.product-card .btn-success-2 {
  align-self: center; /* Center button horizontally */
  margin-top: auto; /* Pushes the button to the bottom */
}
@media (max-width: 768px) {
  .product-card-text {
    display: none;
  }
}
</style>
