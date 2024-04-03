<template>
  <router-view>
    <HeaderComponent
      :products="allProducts"
      @search="performSearch"
      @load-product-cards="filterProducts"
      @toggle-cart="toggleCartVisibility"
      @toggle-wish="toggleWishlistVisibility"
      @toggle-blog="toggleBlogVisibility"
      @toggle-build="toggleBuildVisibility"
      @toggle-support="toggleSupportVisibility"
      @toggle-builder-zone="toggleBuilderZoneVisibility"
      @toggle-board="toggleMessageBoard"
      :cart-item-count="cartItemCount"
      :wish-item-count="wishItemCount"
      @update-cart-count="updateCartItemCount"
    />
    <ShoppingCart
      class="shopping-cart"
      :cart-items="cartItems"
      v-if="cartVisible"
      @remove-cart-item="removeCartItem"
      @update-cart="updateCart"
      @edit-item="editIteminCart"
      @toggle-shipping="toggleShippingVisibility"
    />
    <WishListSection
      :wishlistItems="wishlistItems"
      :wish-items="wishItems"
      @remove-wishlist-item="handleRemoveWishlistItem"
      @move-to-cart="handleMoveToCart"
    />
    <ShippingSection v-show="shippingVisible" />
    <BuilderZone v-show="builderZoneVisible" />
    <BlogSection v-show="blogVisible" />
    <SupportSection v-show="isSupportVisible" />
    <MessageBoard :products="allProducts" v-show="boardVisible" />
    <PcBuilder
      :products="allProducts"
      v-show="buildVisible"
      @add-to-cart="addToCart"
      @toggle-build="closeBuilder"
    />
    <ProductDetailModal
      :product="selectedProduct"
      :wishlistItems="wishlistItems"
      :initialQuantity="selectedProductQuantity"
      :isEditMode="isEditModal"
      v-model="detailsVisible"
      @add-to-cart="addToCart"
      @update-cart-item="updateCartItem"
      @toggle-wishlist="toggleWishlistItem"
    />

    <HeroImage />

    <ProductCarousel :products="filteredProducts" @view-details="handleViewDetails" />
  </router-view>
  <AppFooter />
</template>

<script>
import AppFooter from '@/components/PageSections/AppFooter.vue'
import BlogSection from '@/components/PageSections/BlogSection.vue'
import BuilderZone from '@/components/PageSections/BuilderZone.vue'
import HeroImage from '@/components/PageSections/HeroImage.vue'
import MessageBoard from '@/components/PageSections/MessageBoard.vue'
import PcBuilder from '@/components/PageSections/PcBuilder.vue'
import ProductCarousel from '@/components/PageSections/ProductCarousel.vue'
import ShippingSection from '@/components/PageSections/ShippingSection.vue'
import ShoppingCart from '@/components/PageSections/ShoppingCart.vue'
import SupportSection from '@/components/PageSections/SupportSection.vue'
import WishListSection from '@/components/PageSections/WishListSection.vue'
import ProductDetailModal from '@/components/modals/ProductDetailModal.vue'
import HeaderComponent from '@/components/siteNavs/HeaderComponent.vue'
import { products } from '@/data.js'

export default {
  components: {
    HeaderComponent,
    ShoppingCart,
    WishListSection,
    BlogSection,
    ShippingSection,
    MessageBoard,
    SupportSection,
    PcBuilder,
    ProductDetailModal,
    BuilderZone,
    AppFooter,
    ProductCarousel,
    HeroImage
  },
  data() {
    return {
      activeCategory: null,
      activeBrand: null,
      boardVisible: false,
      wishVisible: false,
      builderZoneVisible: false,
      selectedProductQuantity: 0,
      isEditModal: false,
      cartItemCount: 0,
      wishItemCount: 0,
      cartItems: [],
      wishlistItems: [],
      isSupportVisible: false,
      shippingVisible: false,
      quantity: 1,
      detailsVisible: false,
      selectedProduct: null,
      cartVisible: false,
      blogVisible: false,
      buildVisible: false,
      products: products,
      searchQuery: '',
      uniqueCategories: this.calculateUniqueCategories(products),
      uniqueBrands: this.calculateUniqueBrands(products),
      allProducts: products,
      filteredProducts: products
    }
  },
  mounted() {
    this.loadCart()
    this.loadWish()
  },
  watch: {
    cartItems: {
      handler() {
        this.saveCart()
        this.updateCartItemCount()
      },
      deep: true,
      immediate: false
    },
    wishItems: {
      handler() {
        this.saveWish()
        this.updateWishItemCount()
      },
      deep: true,
      immediate: false
    }
  },

  methods: {
    loadCart() {
      const storedCart = localStorage.getItem('cartItems')
      if (storedCart) {
        this.cartItems = JSON.parse(storedCart)
      }
    },
    loadWish() {
      const storedWish = localStorage.getItem('wishListItems')
      if (storedWish) {
        this.wishListItems = JSON.parse(storedWish)
      }
    },
    saveCart() {
      localStorage.setItem('cartItems', JSON.stringify(this.cartItems))
    },
    saveWish() {
      localStorage.setItem('wishListItems', JSON.stringify(this.wishListItems))
    },

    removeCartItem(index) {
      if (index !== -1) {
        this.cartItems.splice(index, 1)
      }
    },
    addToCart(item) {
      const product = item.product ? item.product : item
      const quantity = item.quantity ? item.quantity : 1

      const existingItemIndex = this.cartItems.findIndex((cartItem) => cartItem.id === product.id)
      console.log(existingItemIndex)

      if (existingItemIndex !== -1) {
        this.cartItems[existingItemIndex].quantity += quantity
      } else {
        this.cartItems.push({ ...product, quantity: quantity })
      }

      this.cartVisible = true

      this.scrollToCart()
    },
    updateCart(updatedCartItems) {
      this.cartItems = updatedCartItems
      this.updateCartItemCount()
    },
    editIteminCart(index) {
      const item = this.cartItems[index]
      this.selectedProduct = item.product || item
      this.selectedProductQuantity = item.quantity || 1
      this.isEditModal = true
      this.detailsVisible = true
    },
    updateCartItem(item) {
      const index = this.cartItems.findIndex((cartItem) => cartItem.id === item.product.id)

      if (index >= 0) {
        this.cartItems[index].quantity = item.quantity
        this.updateCart(this.cartItems)
      }

      this.detailsVisible = false
      this.isEditModal = false
    },

    updateCartItemCount() {
      this.cartItemCount = this.cartItems.reduce((total, item) => total + item.quantity, 0)
    },

    calculateUniqueCategories(products) {
      // Logic to get unique categories from products.
      return [...new Set(products.map((p) => p.category))]
    },
    calculateUniqueBrands(products) {
      // Logic to get unique brands from products.
      return [...new Set(products.map((p) => p.brand))]
    },
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
    performSearch(query) {
      if (typeof query !== 'string' || !query.trim()) {
        return { products: this.products, searchQuery: '' }
      }

      this.searchQuery = query.trim().toLowerCase()

      try {
        this.filteredProducts = this.allProducts.filter((product) => {
          return (
            (product.name && product.name.toLowerCase().includes(this.searchQuery)) ||
            (product.description && product.description.toLowerCase().includes(this.searchQuery)) ||
            (product.brand && product.brand.toLowerCase().includes(this.searchQuery)) ||
            (product.category && product.category.toLowerCase().includes(this.searchQuery))
          )
        })

        if (this.filteredProducts.length === 0) {
          alert('No results found. Showing all products.')
          // Return all products since no results matched the search query.
          return { products: this.allProducts, searchQuery: this.searchQuery }
        }

        // Return the filtered list of products and the search query.
        return { products: this.filteredProducts, searchQuery: this.searchQuery }
      } catch (error) {
        console.error('Error occurred during search:', error)
        return { products: this.allProducts, searchQuery: this.searchQuery }
      }
    },
    toggleBuilderZoneVisibility() {
      this.builderZoneVisible = !this.builderZoneVisible
    },
    toggleMessageBoard() {
      this.boardVisible = !this.boardVisible
    },

    toggleCartVisibility() {
      this.cartVisible = !this.cartVisible
    },
    toggleWishlistVisibility() {
      this.wishVisible = !this.wishVisible
    },
    toggleBlogVisibility() {
      this.blogVisible = !this.blogVisible
    },
    toggleBuildVisibility() {
      this.buildVisible = !this.buildVisible
    },
    closeBuilder() {
      this.buildVisible = !this.buildVisible
    },
    toggleSupportVisibility() {
      this.isSupportVisible = !this.isSupportVisible
    },
    toggleShippingVisibility() {
      this.shippingVisible = !this.shippingVisible
    },

    handleViewDetails(product) {
      this.selectedProduct = product
      this.detailsVisible = true
      console.log(this.selectedProduct)
    },
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
    toggleWishlistItem({ product, isFavorite }) {
      if (isFavorite) {
        // Remove the item from the wishlist
        const index = this.wishlistItems.findIndex((item) => item.id === product.id)
        if (index !== -1) {
          this.wishlistItems.splice(index, 1)
        }
      } else {
        // Add the item to the wishlist
        if (!this.wishlistItems.some((item) => item.id === product.id)) {
          this.wishlistItems.push(product)
        }
      }
    },
    handleRemoveWishlistItem(index) {
      this.wishlistItems.splice(index, 1)
    },
    handleMoveToCart(item) {
      this.addToCart({ product: item })
      this.handleRemoveWishlistItem(this.wishlistItems.indexOf(item))
    }
  }
}
</script>
<style>
.login-modal {
  z-index: 300;
}
</style>
