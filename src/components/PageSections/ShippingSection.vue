<template>
  <transition name="slide">
    <section v-show="toggleShippingVisibility" class="shipping-section bg-primary mb-2">
      <div class="container">
        <div class="row">
          <div class="col-md-6 col-sm-12 mx-auto">
            <div class="card bg-success rounder-3">
              <h2 class="text-primary-bold p-4">Shipping Information</h2>
              <div class="card-body">
                <form id="shippingForm">
                  <div class="mb-3">
                    <label for="first-name" class="form-label text-primary-bold">First Name</label>
                    <input
                      class="form-select text-primary input-black-line"
                      id="first-name"
                      required
                    />
                  </div>
                  <div class="mb-3">
                    <label for="last-name" class="form-label text-primary-bold">Last Name</label>
                    <input
                      class="form-select text-primary input-black-line"
                      id="last-name"
                      required
                    />
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
                    <input
                      class="form-select text-primary input-black-line"
                      id="address"
                      required
                    />
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
                    <label for="billing-addy" class="checkbox text-primary-bold"
                      >Same as Billing Address?</label
                    >
                  </div>
                  <div class="d-flex justify-content-between">
                    <div>
                      <button
                        type="button"
                        @click="toggleShippingVisibility"
                        class="btn btn-pill-light text-primary-bold mt-3"
                      >
                        <i class="bi bi-arrow-left me-2 icon-danger"></i> Back to Store
                      </button>
                    </div>
                    <div>
                      <button type="submit" class="btn btn-pill-light text-primary-bold mt-3">
                        Continue to Payment <i class="bi bi-arrow-right ms-2 icon-success"></i>
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>
<script>
export default {
  name: 'ShippingSection',
  props: {},
  data() {
    return {}
  },

  methods: {
    toggleShippingVisibility() {
      this.shippingVisible = !this.shippingVisible
      this.$emit('toggle-shipping')
    }
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
