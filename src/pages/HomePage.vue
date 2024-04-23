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
    :cart-item-count="cartItemCount"
    @update-cart-count="updateCartItemCount"
  />

  <ShoppingCart
    class="shopping-cart"
    :cart="cart"
    v-if="cartVisible"
    @remove-cart-item="removeCartItem"
    @update-cart="updateCart"
    @edit-item="editIteminCart"
    @toggle-Shipping="toggleShippingVisibility"
  />
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
    @add-to-cart="addToCart"
    @update-cart-item="updateCartItem"
    :cart="cart"
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
import SupportSection from '@/components/PageSections/SupportSection.vue'
import ProductDetailModal from '@/components/modals/ProductDetailModal.vue'
import HeaderComponent from '@/components/siteNavs/HeaderComponent.vue'
import { products } from '@/data.js'
import CartCollection from '@/models/Cart.js'

export default {
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
    ProductCard
  },
  data() {
    return {
      shippingVisibility: false,
      activeCategory: null,
      activeBrand: null,
      boardVisible: false,
      builderZoneVisible: false,
      selectedProductQuantity: 0,
      isEditModal: false,
      cartItemCount: 0,
      cart: new CartCollection(),
      isSupportVisible: false,
      quantity: 1,
      detailsVisible: false,
      selectedProduct: null,
      cartVisible: false,
      blogVisible: false,
      buildVisible: false,
      items: products,
      searchTerm: '',
      uniqueCategories: this.calculateUniqueCategories(products),
      uniqueBrands: this.calculateUniqueBrands(products),
      allProducts: products,
      filteredProducts: products
    }
  },
  mounted() {
    this.loadCart()
  },
  watch: {
    'cart.cartItems': {
      handler() {
        this.saveCart()
        this.updateCartItemCount()
      },
      deep: true,
      immediate: false
    }
  },

  methods: {
    loadCart() {
      const storedCart = localStorage.getItem('cartItems')
      if (storedCart) {
        const cartData = JSON.parse(storedCart)

        console.log('Loaded cart data:', cartData)

        cartData.forEach((productData, index) => {
          // Fix the 'in' operator issue
          if (
            productData &&
            productData.product &&
            Object.prototype.hasOwnProperty.call(productData.product, 'id')
          ) {
            const productInstance = this.products.find((p) => p.id === productData.product.id)
            if (productInstance) {
              this.cart.addItem(productInstance, productData.quantity)
            } else {
              console.error(`Could not find product with ID ${productData.product.id}`)
            }
          } else {
            console.error(`Invalid product data at index ${index}:`, productData)
          }
        })
      } else {
        console.log('No cart found in localStorage.')
      }
    },

    saveCart() {
      localStorage.setItem('cartItems', JSON.stringify(this.cart.cartItems))
    },

    removeCartItem(productId) {
      try {
        this.cart.removeItem(productId)
        this.saveCart()
        this.updateCartItemCount()
      } catch (error) {
        alert(error.message)
      }
    },
    addToCart(product) {
      try {
        this.cart.addItem(product)
        this.saveCart()

        this.toggleCartVisibility()

        this.scrollToCart()
      } catch (error) {
        alert(error.message)
      }
    },
    updateCart(updatedCartItems) {
      this.cart.cartItems = updatedCartItems
      this.updateCartItemCount()
    },
    editIteminCart(item) {
      // Assuming you want to edit the quantity of a cart item when editing
      try {
        this.cart.editItem(item.product, item.quantity) // This is calling the 'editItem' method correctly
        this.isEditModal = true
        this.detailsVisible = true
        this.saveCart()
      } catch (error) {
        alert(error.message)
      }
    },
    updateCartItem(item) {
      try {
        // Update the usage here to call the correct method, which is 'updateQuantity'
        this.cart.updateQuantity(item.product.id, item.quantity)

        // There seems to be additional logic referring to 'this.cartItems' and 'this.updateCart'
        // Please verify if these parts are relevant and correctly placed in the expected scope

        // The following code block may not be necessary if you are already watching the cart items
        // in another component to handle updates, or if updateQuantity method already covers this logic.
        const index = this.cart.cartItems.findIndex((cartItem) => cartItem.id === item.product.id)

        if (index >= 0) {
          this.cart.cartItems[index].quantity = item.quantity
          // Ensure 'updateCart' is an existing and correct method for updating the cart view.
          this.updateCart(this.cart.cartItems)
        }

        this.handleViewDetails(item)
        this.isEditModal = false
      } catch (error) {
        alert(error.message)
      }
    },

    updateCartItemCount() {
      this.cartItemCount = this.cart.cartItems.reduce((total, item) => total + item.quantity, 0)
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
    toggleBuilderZoneVisibility() {
      this.builderZoneVisible = !this.builderZoneVisible
    },
    toggleMessageBoard() {
      this.boardVisible = !this.boardVisible
    },

    toggleCartVisibility() {
      this.cartVisible = !this.cartVisible
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
      this.isShippingVisible = !this.isShippingVisible
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
