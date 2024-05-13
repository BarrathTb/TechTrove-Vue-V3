<template>
  <transition name="slide">
    <section v-show="toggleBuildVisibility" class="bg-primary py-5" id="pc-builder">
      <div class="container">
        <div class="card bg-secondary rounded-3 text-light mx-auto" style="max-width: 900px">
          <div class="card-body">
            <h2 class="text-center tube-text-purple mb-4">Build Your Custom PC</h2>
            <form @submit.prevent="createBuild">
              <!-- Motherboards selection -->
              <div class="mb-3">
                <label for="motherboardSelect" class="form-label">Motherboards</label>
                <select
                  v-model="selectedParts.motherboard"
                  class="form-select text-light select-input"
                  id="motherboardSelect"
                >
                  <option disabled value="">Select a motherboard</option>
                  <option
                    v-for="motherboard in motherboards"
                    :key="motherboard.id"
                    :value="motherboard"
                  >
                    {{ motherboard.name }}
                  </option>
                </select>
              </div>

              <!-- Processors selection -->
              <div class="mb-3">
                <label for="cpuSelect" class="form-label">PROCESSOR</label>
                <select
                  v-model="selectedParts.processor"
                  class="form-select text-light select-input"
                  id="cpuSelect"
                >
                  <option disabled value="">Select a processor</option>
                  <option v-for="processor in processors" :key="processor.id" :value="processor">
                    {{ processor.name }}
                  </option>
                </select>
              </div>

              <!-- Memory selection -->
              <div class="mb-3">
                <label for="ramSelect" class="form-label">MEMORY</label>
                <select
                  v-model="selectedParts.memory"
                  class="form-select text-light select-input"
                  id="ramSelect"
                >
                  <option disabled value="">Select memory</option>
                  <option v-for="memory in memoryModules" :key="memory.id" :value="memory">
                    {{ memory.name }}
                  </option>
                </select>
              </div>

              <!-- Graphics Card selection -->
              <div class="mb-3">
                <label for="gpuSelect" class="form-label">GRAPHICS CARD</label>
                <select
                  v-model="selectedParts.graphicsCard"
                  class="form-select text-light select-input"
                  id="gpuSelect"
                >
                  <option disabled value="">Select a graphics card</option>
                  <option
                    v-for="graphicsCard in graphicsCards"
                    :key="graphicsCard.id"
                    :value="graphicsCard"
                  >
                    {{ graphicsCard.name }}
                  </option>
                </select>
              </div>

              <!-- Power Supply selection -->
              <div class="mb-3">
                <label for="powerSelect" class="form-label">POWER SUPPLY</label>
                <select
                  v-model="selectedParts.powerSupply"
                  class="form-select text-light select-input"
                  id="powerSelect"
                >
                  <option disabled value="">Select a power supply</option>
                  <option
                    v-for="powerSupply in powerSupplies"
                    :key="powerSupply.id"
                    :value="powerSupply"
                  >
                    {{ powerSupply.name }}
                  </option>
                </select>
              </div>

              <!-- Hard Drive selection -->
              <div class="mb-3">
                <label for="ssdSelect" class="form-label">Hard Drive</label>
                <select
                  v-model="selectedParts.hardDrive"
                  class="form-select text-light select-input"
                  id="ssdSelect"
                >
                  <option disabled value="">Select a hard drive</option>
                  <option v-for="hardDrive in hardDrives" :key="hardDrive.id" :value="hardDrive">
                    {{ hardDrive.name }}
                  </option>
                </select>
              </div>

              <!-- Buttons -->
              <div class="text-center d-flex justify-content-between">
                <button category="reset" class="btn btn-danger-2 mt-2" @click="handleGoBack">
                  &lt; Go Back
                </button>
                <button
                  @click="createBuild, closeBuilder"
                  category="submit"
                  class="btn btn-purple mt-2"
                >
                  Create Build >
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
0

export default {
  name: 'PcBuilder',
  props: {
    products: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      buildVisible: false,
      selectedParts: {
        motherboards: null,
        processor: null,
        memory: null,
        graphicsCard: null,
        powerSupply: null,
        hardDrive: null
      }
    }
  },
  computed: {
    // Filter products by category and assign them to their respective arrays
    motherboards() {
      return this.products.filter((product) => product.category === 'Motherboards')
    },
    processors() {
      return this.products.filter((product) => product.category === 'Processors')
    },
    memoryModules() {
      return this.products.filter((product) => product.category === 'Memory')
    },
    graphicsCards() {
      return this.products.filter((product) => product.category === 'Graphics Cards')
    },
    powerSupplies() {
      return this.products.filter((product) => product.category === 'Power Supply')
    },
    hardDrives() {
      return this.products.filter((product) => product.category === 'SSD')
    }
  },
  methods: {
    createBuild() {
      Object.values(this.selectedParts).forEach((part) => {
        if (part) {
          // Assume the quantity for each part is 1
          this.$emit('manage-cart', { product: part, quantity: 1 })
        }
      })
      this.handleGoBack()
    },
    toggleBuildVisibility() {
      this.$emit('toggle-build')
    },
    closeBuilder() {
      this.$emit('toggle-build')
    },
    handleGoBack() {
      this.resetBuilder()
      this.closeBuilder()
    },

    resetBuilder() {
      Object.keys(this.selectedParts).forEach((key) => {
        this.selectedParts[key] = null
      })
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

#pc-builder {
  .select-input {
    border-color: #4b0082;

    &:focus {
      box-shadow: 0 0 0 0.2rem rgba(#4b0082, 0.25);

      color: white;
      border-color: #4b0082;
    }

    &:active {
      border-color: #4b0082 0.5s ease;
    }
  }
}
</style>
