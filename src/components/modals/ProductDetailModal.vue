<template>
  <VaModal ref="modal" v-model="detailsVisible" class="rounded product-detail-modal">
    <template #content>
      <div class="modal-lg rounded bg-primary p-4" style="border-radius: 10px">
        <div class="modal-header d-flex justify-content-end align-items-center mb-2">
          <button
            class="btn btn-outline-success p-0 m-0"
            style="text-decoration: none; background-color: transparent; border: light"
            @click="closeModal"
          >
            <i class="bi bi-x fs-4"></i>
          </button>
        </div>

        <div class="modal-body rounded justify-content-center">
          <img
            :src="product.image"
            class="img-fluid card-img-top"
            style="border-radius: 10px; margin-bottom: 20px"
            :alt="product.name"
          />
          <div class="row">
            <h5 class="col text-white">{{ product.name }}</h5>

            <div class="col-3 text-right">
              <input
                type="checkbox"
                id="heartCheckbox"
                v-model="isFavorite"
                class="hidden-checkbox"
              />
              <label for="heartCheckbox" class="heart"></label>
            </div>
          </div>
          <p class="text-white">{{ productFormattedPrice }}</p>
          <p class="text-white">{{ product.description }}</p>
          <hr class="bg-white" />
          <h5 class="text-white">Features</h5>
          <ul class="row list-unstyled text-light">
            <li v-for="(feature, index) in product.features" :key="index">
              {{ feature }}
            </li>
          </ul>
          <hr class="bg-white" />
          <div class="row align-items-center">
            <div class="col-6">
              <h5 class="text-white float-left">Price</h5>
            </div>
            <div class="col-6">
              <h5 class="text-white float-right">{{ total }}</h5>
            </div>
          </div>
          <div class="row mt-3">
            <div class="col">
              <div class="btn-group">
                <button
                  size="small"
                  class="rounded-circle me-2 btn btn-success-2"
                  @click="decrementQuantity"
                >
                  -
                </button>
                <va-input
                  v-model.number="quantity"
                  type="number"
                  min="1"
                  class="form-control ms-2 me-2"
                />
                <button
                  size="small"
                  class="rounded-circle ms-2 btn btn-success-2"
                  @click="incrementQuantity"
                >
                  +
                </button>
              </div>
            </div>
            <div class="col-3">
              <button class="flex-end btn btn-success-2" @click="handleCartOperation">
                {{ buttonText }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </template>
  </VaModal>
</template>

<script>
import { CartCollection } from '@/models/Cart.js'
import { VaInput, VaModal } from 'vuestic-ui'
export default {
  name: 'ProductDetailModal',
  components: {
    VaModal,

    VaInput
  },
  props: {
    product: {
      type: Object,
      required: false
    },
    cart: {
      type: CartCollection,
      required: false
    },
    isEditMode: {
      type: Boolean,
      default: false
    },
    initialQuantity: {
      type: Number,
      default: 1
    }
  },
  emits: ['update:modelValue', 'add-to-cart'],
  data() {
    return {
      detailsVisible: false,
      quantity: 1,
      isFavorite: false
    }
  },
  computed: {
    productFormattedPrice() {
      return `$${parseFloat(this.product.price).toFixed(2)}`
    },
    total() {
      const totalPrice = this.product.price * this.quantity
      return `$${totalPrice.toFixed(2)}`
    },
    buttonText() {
      return this.isEditMode ? 'Update Cart' : 'Add to Cart'
    }
  },
  watch: {
    initialQuantity(newQty) {
      this.quantity = newQty
    }
  },
  methods: {
    closeModal() {
      this.detailsVisible = false
      this.$emit('update:modelValue', false)
    },
    incrementQuantity() {
      this.quantity++
    },
    decrementQuantity() {
      if (this.quantity > 1) {
        this.quantity--
      }
    },
    handleCartOperation() {
      if (this.isEditMode) {
        this.updateCartItem()
      } else {
        this.addToCart()
      }
    },
    updateCartItem() {
      try {
        this.cart.updateQuantity(this.product, this.quantity)
        this.closeModal()
        this.cartVisible = true
        this.scrollToCart()
      } catch (error) {
        console.log(error)
      }
    },
    addToCart() {
      try {
        this.cart.addItem(this.product, this.quantity)
        this.closeModal()
        this.cartVisible = true
        this.scrollToCart()
      } catch (error) {
        console.error(error.message)
      }
    },
    scrollToCart() {
      const cartElement = document.getElementById('shopping-cart')
      if (cartElement) {
        cartElement.scrollIntoView({ behavior: 'smooth' })
      }
    }
  }
}
</script>
<style scoped>
.product-detail-modal {
  position: relative;
  z-index: 1000;
  width: 50vw;
  height: 60vh;
}

.hidden-checkbox {
  display: none;
}

.heart {
  cursor: pointer;
  background-color: transparent;
  height: 30px;

  width: 30px;

  display: inline-block;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50"><path d="M24.8,47l-2.9-2.7C9.6,31.1,1,22.9,1,14.5C1,7.1,6.6,1,13.4,1c4.3,0,8.1,2.2,10.6,5.7C26,3.2,29.8,1,34.1,1C40.9,1,46.5,7.1,46.5,14.5c0,8.5-8.6,16.6-20.9,30L24.8,47z" fill="%23CCCCCC"/></svg>');

  background-size: cover;
}

.hidden-checkbox:checked + .heart {
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 50 50"><path d="M24.8,47l-2.9-2.7C9.6,31.1,1,22.9,1,14.5C1,7.1,6.6,1,13.4,1c4.3,0,8.1,2.2,10.6,5.7C26,3.2,29.8,1,34.1,1C40.9,1,46.5,7.1,46.5,14.5c0,8.5-8.6,16.6-20.9,30L24.8,47z" fill="%23FF0000"/></svg>');
}
</style>
