<template>
  <HeaderComponent
    :products="allProducts"
    @search="performSearch"
    @load-product-cards="filterProducts"
    @toggle-cart="toggleCartVisibility"
    @toggle-blog="toggleBlogVisibility"
    @toggle-build="toggleBuildVisibility"
    @toggle-support="toggleSupportVisibility"
    @toggle-builder-zone="toggleBuilderZoneVisibility"
    @toggle-board="toggleMessageBoard"
    @toggle-wishlist="toggleWishlistVisibility"
    :cart-item-count="cartItemCount"
    :wishlist-item-count="wishlistItemCount"
    @update-cart-count="updateCartItemCount"
    @update-wishlist-count="updateWishlistItemCount"
  />

  <ShoppingCart
    class="shopping-cart"
    :cart="cart"
    v-show="activeSection === 'cart'"
    @remove-cart-item="removeCartItem"
    @manage-cart="manageCart"
    @edit-item="editIteminCart"
    @toggle-cart="toggleCartVisibility"
    @toggle-Shipping="toggleShippingVisibility"
  />
  <shipping-section
    v-show="activeSection === 'shipping'"
    @toggle-shipping="toggleShippingVisibility"
  />
  <WishlistSection
    v-show="activeSection === 'wishlist'"
    @move-wish-item="moveWishItem"
    @remove-wish-item="removeWishItem"
    @manage-wishlist-item="manageWishlist"
    :wishlist="wishlist"
    :cart="cart"
    @update-wishlist-count="updateWishlistItemCount"
  />
  <BuilderZone v-show="activeSection === 'builderZone'" />
  <BlogSection v-show="activeSection === 'blog'" />
  <SupportSection v-show="activeSection === 'support'" />
  <MessageBoard :products="allProducts" v-show="activeSection === 'messageBoard'" />
  <PcBuilder
    :products="allProducts"
    v-show="activeSection === 'build'"
    @manage-cart="manageCart"
    @toggle-build="closeBuilder"
  />

  <HeroImage />

  <CardCarousel :items="filteredProducts">
    <template v-slot:item="{ item }">
      <ProductCard :key="item.id" :product="item" @view-details="handleViewDetails" />
    </template>
  </CardCarousel>
  <ProductDetailModal
    class="product-detail-modal"
    :product="selectedProduct"
    :initialQuantity="selectedProductQuantity"
    :isEditMode="isEditModal"
    v-model="detailsVisible"
    @manage-cart="manageCart"
    :cart="cart"
    @manage-wishlist="manageWishlist"
  />
  <AppFooter />
</template>

<script>
import AppFooter from '@/components/PageSections/AppFooter.vue'
import BlogSection from '@/components/PageSections/BlogSection.vue'
import BuilderZone from '@/components/PageSections/BuilderZone.vue'
import CardCarousel from '@/components/PageSections/CardCarousel.vue'
import HeroImage from '@/components/PageSections/HeroImage.vue'
import MessageBoard from '@/components/PageSections/MessageBoard.vue'
import PcBuilder from '@/components/PageSections/PcBuilder.vue'
import ProductCard from '@/components/PageSections/ProductCard.vue'
import ShoppingCart from '@/components/PageSections/ShoppingCart.vue'
import ShippingSection from '@/components/PageSections/ShippingSection.vue'
import SupportSection from '@/components/PageSections/SupportSection.vue'
import ProductDetailModal from '@/components/modals/ProductDetailModal.vue'
import HeaderComponent from '@/components/siteNavs/HeaderComponent.vue'
import WishlistSection from '@/components/PageSections/WishListSection.vue'
import { useUserStore } from '@/stores/User'
import { CartCollection } from '@/models/Cart.js'
import Product from '@/models/Product'
import Profile from '@/models/Profile.js'

import { Wishlist } from '@/models/Wishlist'

export default {
  name: 'HomePage',

  components: {
    HeaderComponent,
    ShoppingCart,
    BlogSection,
    MessageBoard,
    SupportSection,
    PcBuilder,
    ProductDetailModal,
    BuilderZone,
    AppFooter,
    CardCarousel,
    HeroImage,
    ProductCard,
    WishlistSection,
    ShippingSection
  },
  data() {
    return {
      products: [],
      shippingVisible: false,
      activeCategory: null,
      activeBrand: null,
      boardVisible: false,
      builderZoneVisible: false,
      selectedProductQuantity: 0,
      isEditModal: false,
      activeSection: null,
      cartItemCount: 0,
      wishlistItemCount: 0,
      cart: new CartCollection(),
      wishlist: new Wishlist(),
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      wishlistVisible: false,
      isSupportVisible: false,
      quantity: 1,
      detailsVisible: false,
      selectedProduct: null,
      cartVisible: false,
      blogVisible: false,
      buildVisible: false,
      items: [],
      searchTerm: '',
      uniqueCategories: [],
      uniqueBrands: [],
      allProducts: [],
      filteredProducts: [],
      toastShown: false,
      toastStyle: {
        position: 'center-right',
        type: 'success',
        theme: 'outline',
        style: 'color: custom-success',
        autoClose: 2000
      }
    }
  },
  async mounted() {
    try {
      await this.initializeProducts()
      await this.initializeUserProfile()
      await this.initializeCart()
      await this.initializeWishlist()
    } catch (error) {
      console.error(error)
    }
  },

  computed: {
    isLoggedIn() {
      const userStore = useUserStore()
      return userStore.isLoggedIn
    },

    localUser() {
      const userStore = useUserStore()
      return userStore.profile || {}
    }
  },

  watch: {
    'cart.items': {
      handler() {
        this.updateCartItemCount()
      },
      deep: true,
      immediate: true
    },
    'wishlist.items': {
      handler() {
        this.updateWishlistItemCount()
      },
      deep: true,
      immediate: true
    },

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
    /**
     * Initializes the products by fetching them from the server and setting them to the component's state.
     *
     * @return {Promise<void>} - A promise that resolves when the products have been fetched and the state has been updated.
     */
    async initializeProducts() {
      const products = await Product.fetchProducts()
      this.allProducts = products
      this.filteredProducts = products
      this.uniqueCategories = this.calculateUniqueCategories(products)
      this.uniqueBrands = this.calculateUniqueBrands(products)
    },

    /**
     * Initializes the user profile based on the user's login status.
     *
     * @return {Promise<void>} - A promise that resolves when the user profile is initialized.
     */
    async initializeUserProfile() {
      const userStore = useUserStore()

      if (userStore.isLoggedIn) {
        // Fetch user profile and set it in the store
        const profile = await userStore.fetchProfile()
        if (profile) {
          userStore.setUser(profile)
        }
      }
    },

    /**
     * Initializes the cart based on the user's login status.
     *
     * @return {Promise<void>} - A promise that resolves when the cart is initialized.
     */
    async initializeCart() {
      const userStore = useUserStore()

      if (userStore.isLoggedIn) {
        // Initialize cart for logged-in users
        await this.cart.initializeCart()
        if (this.cart.items.size === 0) {
          // Maybe notify user their cart is empty
        }
      } else {
        // Load cart from local storage for guests
        this.cart.loadCartFromLocalStorage()
      }
    },

    async initializeWishlist() {
      const userStore = useUserStore()

      if (userStore.isLoggedIn) {
        // Initialize cart for logged-in users
        await this.wishlist.initializeWishlist()
        if (this.wishlist.items.size === 0) {
          // Maybe notify user their cart is empty
        }
      } else {
        // Load cart from local storage for guests
        this.wishlist.loadWishlistFromLocalStorage()
      }
    },
    /**
     * Asynchronously fetches the user's profile and initializes the cart collection.
     *
     * @return {Promise<void>} Promise that resolves when the profile is fetched and the cart is initialized.
     */
    async getProfile() {
      this.loading = true

      try {
        const userStore = useUserStore()

        if (!userStore.session || !userStore.session.user) {
          console.warn('Guest session or no user; skipping profile fetch.')
          return
        }

        const profile = await Profile.fetchUser(userStore.session.user.id)

        if (profile) {
          this.localUser = profile
          console.log('User profile:', this.localUser)
          this.wishlist = new Wishlist(profile)
          this.cart = new CartCollection(profile)
          await this.cart.fetchCartItems()
          await this.wishlist.fetchWishlistItems()
          console.log('Authenticated user cart after fetching items:', this.cart)
        } else {
          console.warn('No profile could be fetched.')
        }
      } catch (error) {
        console.error('Error fetching profile:', error.message)
      } finally {
        this.loading = false
      }
    },

    /**
     * A function to remove an item from the cart.
     *
     * @param {Object} item - The item to be removed from the cart
     */
    removeCartItem(item) {
      try {
        console.log('Attempting to remove item from cart:', item)

        if (!item || !item.product || typeof item.product.id === 'undefined') {
          console.error('Invalid product structure:', item)
          throw new Error('Cannot remove a product without a valid id.')
        }

        const realProduct = this.unwrapProxy(item.product)

        this.cart.removeItem(realProduct.id) // Pass only the product ID

        console.log('Item successfully removed from cart:', realProduct)

        this.cart.synchronizeCart()
        this.$toast('Item removed from cart.', this.toastStyle)
        this.updateCartItemCount()
      } catch (error) {
        console.error('Error while removing item from cart:', error.message)
      }
    },

    unwrapProxy(proxy) {
      return JSON.parse(JSON.stringify(proxy))
    },

    /**
     * Manages the cart based on the payload provided.
     *
     * @param {Object} payload - The payload containing product, quantity, and isUpdate flag.
     */
    manageCart(payload) {
      try {
        const { product, quantity, isUpdate } = payload
        // const cartItem = this.cart.items.get(item)

        if (isUpdate) {
          this.cart.updateQuantity(product.id, quantity)
          this.$toast('Item quantity updated.', this.toastStyle)
        } else {
          this.cart.addItem(product, quantity)
          this.$toast('Item added to cart.', this.toastStyle)
        }

        // this.cart.synchronizeCart()
        console.log('Cart updated', this.cart.items)

        if (!isUpdate) {
          if (!this.cartVisible) {
            this.toggleCartVisibility()
          }
          this.scrollToCart()
        }

        this.updateCartItemCount()
      } catch (error) {
        console.error(`Manage Cart Item Error: ${error.message}`)
      }
    },

    editIteminCart(item) {
      this.selectedProduct = item.product
      this.isEditModal = true
      this.detailsVisible = true
    },

    updateCartItemCount() {
      this.cartItemCount = Array.from(this.cart.items.values()).reduce(
        (acc, cur) => acc + cur.quantity,
        0
      )
      console.log(this.cartItemCount)
    },

    updateWishlistItemCount() {
      this.wishlistItemCount = this.wishlist.items.size
      console.log(this.wishlistItemCount)
    },

    removeWishItem(item) {
      try {
        console.log('Attempting to remove item from wishlist:', item)

        if (!item || !item.product || typeof item.product.id === 'undefined') {
          console.error('Invalid product structure:', item)
          throw new Error('Cannot remove a product without a valid id.')
        }

        const realProduct = this.unwrapProxy(item.product)

        this.wishlist.removeItem(realProduct.id) // Pass only the product ID

        console.log('Item successfully removed from wishlist:', realProduct)

        this.wishlist.synchronizeWishlist()
        this.$toast('Item removed from wishlist.', this.toastStyle)
        this.updateWishlistItemCount()
      } catch (error) {
        console.error('Error while removing item from wishlist:', error.message)
      }
    },

    /**
     * A function to manage the wishlist items based on the payload.
     *
     * @param {Object} payload - The payload containing information about the product and whether it is a favorite.
     */

    manageWishlist({ action, product }) {
      if (action === 'add') {
        this.wishlist.addItem(product)
        this.$toast('Item added to wishlist.', this.toastStyle)
      } else if (action === 'remove') {
        this.wishlist.removeItem(product)
        this.$toast('Item removed from wishlist.', this.toastStyle)
      }

      this.wishlist.synchronizeWishlist()
      this.updateWishlistItemCount()
    },

    moveWishItem(item) {
      const product = item.product
      const quantity = 1 // Set the desired quantity for the cart

      this.wishlist.removeItem(product.id) // Remove from wishlist
      this.cart.addItem(product, quantity) // Add to cart
      this.$toast('Item moved from wishlist to cart.', this.toastStyle)
      this.wishlist.synchronizeWishlist()
      this.cart.synchronizeCart()

      this.updateWishlistItemCount()
      this.updateCartItemCount()
    },

    calculateUniqueCategories(products) {
      // Logic to get unique categories from products.
      return [...new Set(products.map((p) => p.category))]
    },
    calculateUniqueBrands(products) {
      // Logic to get unique brands from products.
      return [...new Set(products.map((p) => p.brand))]
    },

    /**
     * Filters the products based on the selected item.
     *
     * @param {string} selectedItem - The selected item to filter the products by.
     * @return {void} This function does not return anything.
     */
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
    resetFilters() {
      // Reset both active filters and show all products again.
      this.activeCategory = null
      this.activeBrand = null
      this.filteredProducts = this.allProducts
    },

    /**
     * Performs a search operation based on the provided query.
     *
     * @param {string} query - The search query to filter products.
     * @return {Object} An object containing filtered products and the search term used.
     */
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
    },

    closeBuilder() {
      this.buildVisible = !this.buildVisible
    },
    toggleBuilderZoneVisibility() {
      this.handleSectionVisibility('builderZone')
    },
    toggleMessageBoard() {
      this.handleSectionVisibility('messageBoard')
    },
    toggleCartVisibility() {
      this.handleSectionVisibility('cart')
    },
    toggleBlogVisibility() {
      this.handleSectionVisibility('blog')
    },
    toggleBuildVisibility() {
      this.handleSectionVisibility('build')
    },
    toggleSupportVisibility() {
      this.handleSectionVisibility('support')
    },
    toggleShippingVisibility() {
      this.handleSectionVisibility('shipping')
    },
    toggleWishlistVisibility() {
      this.handleSectionVisibility('wishlist')
    },

    handleSectionVisibility(sectionName) {
      // If the section is already active, then close it by setting activeSection to null
      if (this.activeSection === sectionName) {
        this.activeSection = null
      } else {
        // Otherwise, set the active section to the one that was clicked
        this.activeSection = sectionName
      }
    },

    handleViewDetails(product) {
      this.selectedProduct = product
      this.detailsVisible = true
      console.log(this.selectedProduct)
    },
    // handleViewDetails(product) {
    //   // Handle view details event here
    //   console.log('Product details:', product)
    //   // Optionally emit an event if the parent component needs to be notified
    //   this.$emit('view-details', product)
    // },
    scrollToCart() {
      this.$nextTick(() => {
        const cartElement = document.getElementById('shopping-cart')
        if (cartElement && typeof cartElement.scrollIntoView === 'function') {
          cartElement.scrollIntoView({ behavior: 'smooth' })
        } else {
          console.error(
            'Failed to get the shopping cart element or scrollIntoView is not available'
          )
        }
      })
    },
    scrollToWishlist() {
      this.$nextTick(() => {
        const wishElement = document.getElementById('wishlist')
        if (wishElement && typeof wishElement.scrollIntoView === 'function') {
          wishElement.scrollIntoView({ behavior: 'smooth' })
        } else {
          console.error('Failed to get the wishlist element or scrollIntoView is not available')
        }
      })
    }
  }
}
</script>
<style>
.login-modal {
  z-index: 300;
}
.product-detail-modal {
  z-index: 900;
}
</style>
