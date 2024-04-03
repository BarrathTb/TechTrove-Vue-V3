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
              <div class="card mx-auto bg-secondary mb-3 ">
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
                      <tr v-for="(item, index) in cartItems" :key="item.id" class="align-items-center mx-auto">
                        <td><img :src="item.image" :alt="item.name" class="cartImage mx-2 my-2" /></td>
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
                          <button class="btn btn-pill-light my-2" @click="closeCart"><i class="fas fa-chevron-left"></i>
                            &lt; Continue Shopping</button>
                        </td>
                        <td colspan="4" class="text-right">
                          <button id="checkoutButton" class="btn btn-pill-success my-2">Checkout</button>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
            <section class="wishlist py-3" >
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
                  <button @click="removeFromWishlist(index)" class="btn btn-danger ml-2"><i class="bi bi-trash"></i></button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
            <div class="col-md-6">
              <div class="card bg-success rounder-3">
                <h2 class="text-primary-bold p-4">Shipping Information</h2>
                <div class="card-body">
                  <form id="shippingForm">
                    <div class="mb-3">
                      <label for="first-name" class="form-label text-primary-bold">First Name</label>
                      <input class="form-select text-primary input-black-line" id="first-name" required />
                    </div>
                    <div class="mb-3">
                      <label for="last-name" class="form-label text-primary-bold">Last Name</label>
                      <input class="form-select text-primary input-black-line" id="last-name" required />
                    </div>
                    <div class="mb-3">
                      <label for="email" class="form-label text-primary-bold">Email</label>
                      <input class="form-select text-primary input-black-line" id="email" required />
                    </div>
                    <div class="mb-3">
                      <label for="phone" class="form-label text-primary-bold">Primary Phone</label>
                      <input class="form-select text-primary input-black-line" id="phone" required />
                    </div>

                    <div class="mb-3">
                      <label for="address" class="form-label text-primary-bold">Address</label>
                      <input class="form-select text-primary input-black-line" id="address" required />
                    </div>
                    <div class="mb-3">
                      <label for="city" class="form-label text-primary-bold">City</label>
                      <input class="form-select text-primary input-black-line" id="city" required />
                    </div>
                    <div class="mb-3">
                      <label for="state" class="form-label text-primary-bold">State</label>
                      <select class="form-select text-primary" id="state" required>
                        <option selected value="">Please Select a State...</option>
                        <option value="AL">Alabama</option>
                        <option value="AK">Alaska</option>
                        <option value="AZ">Arizona</option>
                        <option value="AR">Arkansas</option>
                        <option value="CA">California</option>
                        <option value="CO">Colorado</option>
                        <option value="CT">Connecticut</option>
                        <option value="DE">Delaware</option>
                        <option value="DC">District Of Columbia</option>
                        <option value="FL">Florida</option>
                        <option value="GA">Georgia</option>
                        <option value="HI">Hawaii</option>
                        <option value="ID">Idaho</option>
                        <option value="IL">Illinois</option>
                        <option value="IN">Indiana</option>
                        <option value="IA">Iowa</option>
                        <option value="KS">Kansas</option>
                        <option value="KY">Kentucky</option>
                        <option value="LA">Louisiana</option>
                        <option value="ME">Maine</option>
                        <option value="MD">Maryland</option>
                        <option value="MA">Massachusetts</option>
                        <option value="MI">Michigan</option>
                        <option value="MN">Minnesota</option>
                        <option value="MS">Mississippi</option>
                        <option value="MO">Missouri</option>
                        <option value="MT">Montana</option>
                        <option value="NE">Nebraska</option>
                        <option value="NV">Nevada</option>
                        <option value="NH">New Hampshire</option>
                        <option value="NJ">New Jersey</option>
                        <option value="NM">New Mexico</option>
                        <option value="NY">New York</option>
                        <option value="NC">North Carolina</option>
                        <option value="ND">North Dakota</option>
                        <option value="OH">Ohio</option>
                        <option value="OK">Oklahoma</option>
                        <option value="OR">Oregon</option>
                        <option value="PA">Pennsylvania</option>
                        <option value="RI">Rhode Island</option>
                        <option value="SC">South Carolina</option>
                        <option value="SD">South Dakota</option>
                        <option value="TN">Tennessee</option>
                        <option value="TX">Texas</option>
                        <option value="UT">Utah</option>
                        <option value="VT">Vermont</option>
                        <option value="VA">Virginia</option>
                        <option value="WA">Washington</option>
                        <option value="WV">West Virginia</option>
                        <option value="WI">Wisconsin</option>
                        <option value="WY">Wyoming</option>
                      </select>
                    </div>
                    <div class="mb-3">
                      <label for="zip" class="form-label text-primary-bold">Zip</label>
                      <input class="form-select text-primary input-black-line" id="zip" required />
                    </div>
                    <div class="mb-3">
                      <label for="country" class="form-label text-primary-bold">Country</label>
                      <select class="form-select text-primary" id="country" required>
                        <option selected value="">Please Select a Country...</option>
                        <option value="US">United States</option>
                        <option value="CA">Canada</option>
                        <option value="AU">Australia</option>
                        <option value="AT">Austria</option>
                        <option value="BE">Belgium</option>
                        <option value="BG">Bulgaria</option>
                        <option value="HR">Croatia</option>
                        <option value="CY">Cyprus</option>
                        <option value="CZ">Czech Republic</option>
                        <option value="DK">Denmark</option>
                        <option value="EE">Estonia</option>
                        <option value="FI">Finland</option>
                        <option value="FR">France</option>
                        <option value="DE">Germany</option>
                        <option value="GR">Greece</option>
                        <option value="HU">Hungary</option>
                        <option value="IE">Ireland</option>
                        <option value="IT">Italy</option>
                        <option value="LV">Latvia</option>
                        <option value="LT">Lithuania</option>
                        <option value="LU">Luxembourg</option>
                        <option value="MT">Malta</option>
                        <option value="NL">Netherlands</option>
                        <option value="PL">Poland</option>
                        <option value="PT">Portugal</option>
                        <option value="RO">Romania</option>
                        <option value="SK">Slovakia</option>
                        <option value="SI">Slovenia</option>
                        <option value="ES">Spain</option>
                        <option value="SE">Sweden</option>
                        <option value="CH">Switzerland</option>
                        <option value="TR">Turkey</option>
                        <option value="GB">United Kingdom</option>
                      </select>
                    </div>
                    <div class="mb-3">
                      <input type="checkbox" class="text-primary select-input" id="billing-addy" />
                      <label for="billing-addy" class="checkbox text-primary-bold">Same as Billing Address?</label>
                    </div>

                    <div class="text-center">
                      <button type="submit" class="btn btn-pill-light text-primary-bold mt-3">
                        Continue to Payment >
                      </button>
                    </div>
                  </form>
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
    props: {
      cartItems: Array
    },
    data() {
      return {
        // cartVisible: false,
        products: Array,
        wishlistItems: [],
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

        const foundIndex = this.cartItems((cartItem) => cartItem.id === productToAdd.id && cartItem.quantity === quantityToAdd)

        if (foundIndex !== -1) {
          this.$emit('update-cart', this.cartItems)
        }


      },
      clearCart() {

        this.$emit('update-cart', this.cartItems)
      },
      addToWishlist(product) {
        if (!this.wishlistItems.find((item) => item.id === product.id)) {
          this.wishlistItems.push(product);
        }
      },
      removeFromWishlist(index) {
        this.wishlistItems.splice(index, 1);
      },
      moveToCart(wishlistItem) {
        this.addToCart({ product: wishlistItem, quantity: 1 });
        this.removeFromWishlist(this.wishlistItems.indexOf(wishlistItem));
      },
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
