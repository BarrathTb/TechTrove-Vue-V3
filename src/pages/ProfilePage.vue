<template>
  <header class="header bg-secondary align-items-center">
    <!-- Top Bar -->
    <div class="bg-secondary text-white d-none d-md-block">
      <nav class="navbar navbar-expand-md navbar-dark bg-secondary">
        <h5 class="text-white ms-4 align-items-center justify-content-start">Profile</h5>
        <div class="d-none d-md-flex justify-content-between flex-grow-1">
          <ul class="navbar-nav ms-auto" aria-label="Tertiary Navigation">
            <li class="nav-item mx-2">
              <router-link to="/home" class="nav-link text-light-bold-2 nav-item" id="news-link">
                Personal
              </router-link>
            </li>

            <li class="nav-item mx-2">
              <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
                Orders
              </router-link>
            </li>
            <li class="nav-item mx-2">
              <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
                Achievments
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Cart and Login Icons -->
        <div class="d-none d-md-flex justify-content-end align-items-center flex-grow-1 pe-4">
          <button @click="toggleLoginModal" class="nav-link" id="login-modal">
            <i class="bi bi-person fs-4 mb-2 mx-2 icon-success"></i>
          </button>
          <router-link to="/profile" class="nav-item avatar-container" id="profile-page-link">
            <img src="/images/avatar.png" alt="Profile Avatar" class="user-avatar ms-2" />
          </router-link>
        </div>
      </nav>
    </div>

    <!-- Main Navbar -->

    <VaSidebar>
      <div
        :class="{ show: sidebarVisible }"
        class="offcanvas offcanvas-end bg-primary"
        id="offcanvasNavbar"
        aria-labelledby="offcanvasNavbarLabel"
        style="visibility: visible"
      >
        <!-- VaButton to close offcanvas -->
        <button
          class="bg-transparent py-2"
          type="button"
          @click="toggleOffcanvasVisibility"
          :class="{ hide: !sidebarVisible }"
        >
          <VaIcon class="justify-content-end" color="white" name="close" size=" lg" />
        </button>

        <!-- Other Main Navigation Links -->
        <VaSidebarItem @click="toggleSupportVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="danger" name="help" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">SUPPORT</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>

        <VaSidebarItem class="menu-item">
          <VaSidebarItemContent>
            <form class="search-form w-100 d-flex">
              <input
                v-model="searchTerm"
                class="form-control search-input"
                type="search"
                placeholder="Search for computer parts, brands, and accessories"
                aria-label="Search"
              />
              <button
                class="btn btn-success-2 ms-2"
                @click.prevent="performSearch($event)"
                type="submit"
              >
                Search
              </button>
            </form>
          </VaSidebarItemContent>
        </VaSidebarItem>
      </div>
    </VaSidebar>

    <LoginModal
      class="login-modal"
      v-model="isModalVisible"
      @toggle-login-modal="toggleLoginModal"
    />
  </header>
  <div class="container-fluid d-flex flex-col-4 justify-content-start sidebar bg-secondary">
    <div class="row bg-primary">
      <div class="col-3 sidebar h-100 bg-secondary rounded-2">
        <div class="container-fluid">
          <nav class="justify-content-center my-2">
            <!-- left side nave 80% vh -->
            <ul class="nav flex-column">
              <li class="nav-item d-flex align-items-center">
                <router-link to="/home" id="news-link">
                  <i class="bi bi-arrow-left fs-4 mb-4 tube-text"></i>
                </router-link>
              </li>
              <li class="nav-item mt-5 d-flex align-items-center">
                <i class="bi bi-person fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Edit Personal Details</a
                >
              </li>
              <li class="nav-item my-2 d-flex align-items-center">
                <i class="bi bi-credit-card fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Payment Methods</a
                >
              </li>
              <li class="nav-item my-2 d-flex align-items-center">
                <i class="bi bi-shield-lock fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Security</a
                >
              </li>
              <li class="nav-item my-2 d-flex align-items-center">
                <i class="bi bi-gear fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Preferences</a
                >
              </li>
              <li class="nav-item my-2 d-flex align-items-center">
                <i class="bi bi-bell fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Notifications</a
                >
              </li>
              <li class="nav-item my-2 d-flex align-items-center">
                <i class="bi bi-person-plus fs-4 me-2 tube-text"></i>
                <a class="nav-link text-light-bold" href="#" @click.prevent="togglePersonalDetails"
                  >Add Family Member</a
                >
              </li>
              <li class="nav-item mt-4 d-flex me-4 justify-content-center">
                <button
                  class="btn btn-success btn-sm px-4 text-black btn-bold"
                  @click.prevent="togglePersonalDetails"
                >
                  <i class="bi bi-box-arrow-left fs-4 me-2 text-black"></i>
                  Logout
                </button>
              </li>
            </ul>
          </nav>
        </div>
      </div>
      <div class="col-6 h-100 bg-primary p-4 rounded-2">
        <div class="container-fluid">
          <h4 class="text-white ms-4 align-items-center justify-content-start">Personal Details</h4>
          <p class="text-white ms-4 align-items-center justify-content-start">
            Edit your personal details here.
          </p>

          <img src="/images/avatar.png" alt="Profile Avatar" class="ms-4 my-2 avatar" />
        </div>

        <div class="container-fluid mt-2 ms-4">
          <form class="mt-4">
            <div class="row">
              <div class="col-3">
                <label class="text-white d-flex align-items-center"
                  ><i class="bi bi-pencil-fill me-4"></i>Full Name</label
                >
              </div>
              <div class="col-6">
                <input type="text" class="form-control" placeholder="John Doe" />
              </div>
            </div>
            <div class="row mt-4">
              <div class="col-3">
                <label class="text-white d-flex align-items-center"
                  ><i class="bi bi-pencil-fill me-4"></i>Location</label
                >
              </div>
              <div class="col-6">
                <input type="text" class="form-control" placeholder="e.g. Sydney, Australia" />
              </div>
            </div>
            <div class="row mt-4">
              <div class="col-3">
                <label class="text-white d-flex align-items-center"
                  ><i class="bi bi-pencil-fill me-4"></i>Email</label
                >
              </div>
              <div class="col-6">
                <input type="email" class="form-control" placeholder="johndoe@example.com" />
              </div>
            </div>
            <div class="row mt-4">
              <div class="col-3">
                <label class="text-white d-flex align-items-center"
                  ><i class="bi bi-pencil-fill me-4"></i>Date of Birth</label
                >
              </div>
              <div class="col-6">
                <input type="date" class="form-control" />
              </div>
            </div>
            <div class="row mt-4">
              <div class="col-3">
                <label class="text-white d-flex align-items-center"
                  ><i class="bi bi-pencil-fill me-4"></i>Shipping Address</label
                >
              </div>
              <div class="col-6">
                <textarea class="form-control" placeholder="123 Main St, Anytown AU"></textarea>
              </div>
            </div>
          </form>
        </div>
      </div>
      <div class="col-3 h-100 bg-primary">
        <div class="container-fluid mt-2 ms-4">
          <div class="bg-secondary p-4 rounded-2 mt-4 me-4">
            <h3 class="text-white">Exclusive Offers!</h3>
            <p>
              Get access to exclusive offers and the best prices for high-quality computer parts and
              accessories. Join our VIP club now!
            </p>
            <button class="btn btn-success btn-sm px-4 text-black btn-bold my-2">Join Now</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import { products } from '@/data.js'
// import CartCollection from '@/models/Cart.js'

export default {
  components: {},
  data() {
    return {
      // shippingVisibility: false,
      // activeCategory: null,
      // activeBrand: null,
      // boardVisible: false,
      // builderZoneVisible: false,
      // selectedProductQuantity: 0,
      // isEditModal: false,
      // cartItemCount: 0,
      // cart: new CartCollection(),
      // isSupportVisible: false,
      // quantity: 1,
      // detailsVisible: false,
      // selectedProduct: null,
      // cartVisible: false,
      // blogVisible: false,
      // buildVisible: false,
      // products: products,
      // searchTerm: '',
      // uniqueCategories: this.calculateUniqueCategories(products),
      // uniqueBrands: this.calculateUniqueBrands(products),
      // allProducts: products,
      // filteredProducts: products
    }
  },
  mounted() {
    // this.loadCart()
  },
  watch: {
    // 'cart.cartItems': {
    //   handler() {
    //     this.saveCart()
    //     this.updateCartItemCount()
    //   },
    //   deep: true,
    //   immediate: false
    // }
  },

  methods: {
    filterProducts(selectedItem) {
      // Determine if selectedItem is a category or a brand.
      this.resetFilters()
      const isCategory = this.uniqueCategories.includes(selectedItem)
      const isBrand = this.uniqueBrands.includes(selectedItem)

      // Update the active filters based on the selection.
      if (isCategory) {
        this.activeCategory = selectedItem
      } else if (isBrand) {
        this.activeBrand = selectedItem
      }

      // Perform filtering based on the active category and/or brand.
      this.filteredProducts = this.allProducts.filter((product) => {
        return (
          (!this.activeCategory || product.category === this.activeCategory) &&
          (!this.activeBrand || product.brand === this.activeBrand)
        )
      })
    },

    performSearch(query) {
      if (typeof query !== 'string' || !query.trim()) {
        return { products: this.products, searchTerm: '' }
      }

      this.searchTerm = query.trim().toLowerCase()

      try {
        this.filteredProducts = this.allProducts.filter((product) => {
          return (
            (product.name && product.name.toLowerCase().includes(this.searchTerm)) ||
            (product.description && product.description.toLowerCase().includes(this.searchTerm)) ||
            (product.brand && product.brand.toLowerCase().includes(this.searchTerm)) ||
            (product.category && product.category.toLowerCase().includes(this.searchTerm))
          )
        })

        if (this.filteredProducts.length === 0) {
          alert('No results found. Showing all products.')
          // Return all products since no results matched the search query.
          return { products: this.allProducts, searchTerm: this.searchTerm }
        }

        // Return the filtered list of products and the search query.
        return { products: this.filteredProducts, searchTerm: this.searchTerm }
      } catch (error) {
        console.error('Error occurred during search:', error)
        return { products: this.allProducts, searchTerm: this.searchTerm }
      }
    }
  }
}
</script>
<style>
.login-modal {
  z-index: 300;
}
.row.no-gutters {
  margin-right: 0;
  margin-left: 0;
}

.row.no-gutters > .col,
.row.no-gutters > [class*='col-'] {
  padding-right: 0;
  padding-left: 0;
}

/* Set the height of the left sidebar */
.sidebar.bg-secondary {
  /* Use height: 80vh; for 80% viewport height or height: 100vh; for full viewport height */
  height: 80vh; /* or height: 100vh; if you prefer it to be full height */
}
.avatar {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  object-fit: cover;
}
</style>
