<template>
  <header class="header">
    <!-- Top Bar -->
    <div class="bg-primary text-white d-none d-md-block">
      <nav class="navbar navbar-expand-md navbar-dark bg-primary">
        <div class="container-fluid align-items-center justify-content-start">
          <!-- Search Bar -->
          <div class="d-none d-md-flex ms-2 flex-grow-1">
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
          </div>

          <!-- Links -->
          <div class="d-none d-md-flex justify-content-between flex-grow-1">
            <ul class="navbar-nav ms-auto" aria-label="Tertiary Navigation">
              <li class="nav-item mx-2">
                <a class="nav-link text-light-bold-2" href="#" @click.prevent="toggleMessageBoard"
                  >Message Board</a
                >
              </li>
              <li class="nav-item mx-2">
                <a
                  class="nav-link text-light-bold-2"
                  href="#"
                  @click.prevent="toggleBuilderZoneVisibility"
                  >Builder Zone</a
                >
              </li>
              <li class="nav-item mx-2">
                <a class="nav-link text-light-bold-2">Sale</a>
              </li>
              <li class="nav-item mx-2">
                <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
                  News
                </router-link>
              </li>
            </ul>
          </div>

          <!-- Cart and Login Icons -->
          <div class="d-none d-md-flex justify-content-end align-items-center flex-grow-1 pe-4">
            <button @click="toggleCartVisibility" class="nav-link border-0 bg-transparent">
              <i class="bi bi-cart fs-4 mb-2 mx-2 icon-success">
                <VaBadge
                  v-if="cartItemCount > 0"
                  :text="cartItemCount.toString()"
                  overlap
                  placement="bottom-right"
                  style="--va-badge-text-wrapper-border-radius: 50%"
                  color="#ee82ee"
                ></VaBadge>
              </i>
            </button>
            <button @click="toggleWishlistVisibility" class="nav-link border-0 bg-transparent">
              <i class="bi bi-heart fs-5 mb-2 mx-2 icon-success">
                <VaBadge
                  v-if="wishlistItemCount > 0"
                  :text="wishlistItemCount.toString()"
                  overlap
                  placement="bottom-right"
                  style="--va-badge-text-wrapper-border-radius: 50%"
                  color="#ee82ee"
                ></VaBadge>
              </i>
            </button>

            <button v-if="isLoggedIn" @click="toggleLoginModal" class="nav-link" id="login-modal">
              <i class="bi bi-box-arrow-left fs-4 mb-2 mx-2 icon-success"></i>
            </button>
            <button v-else @click="toggleLoginModal" class="nav-link" id="login-modal">
              <i class="bi bi-box-arrow-in-right fs-4 mb-2 mx-2 icon-success"></i>
            </button>
            <router-link to="/profile" class="nav-item avatar-container" id="profile-page-link">
              <img
                :src="localUser?.avatar_url || defaultAvatarUrl"
                alt="Profile Avatar"
                class="user-avatar ms-2"
              />
            </router-link>
          </div>
        </div>
      </nav>
    </div>

    <!-- Main Navbar -->

    <nav class="navbar navbar-expand-md bg-body-secondary bg-secondary">
      <div class="container-fluid align-items-center justify-content-between">
        <a href="/">
          <img
            src="@/assets/images/TechTrove-logo.png"
            alt="TechTrove Logo"
            width="150"
            height="30"
        /></a>

        <button
          class="navbar-toggler border-0 bg-transparent"
          type="button"
          @click="toggleOffcanvasVisibility"
        >
          <i class="bi bi-list fs-2 mx-2 icon-success"></i>
        </button>
        <div
          class="collapse navbar-collapse justify-content-end d-md-flex"
          id="navbarSupportedContent"
        >
          <ul class="nav nav-tabs d-none d-md-flex mx-2">
            <li class="nav-item left-tab border-0">
              <a
                class="nav-link text-light-bold main-nav-menu-item dropdown"
                href="#"
                id="navbarDropdownMenuLinkProducts"
                role="button"
                data-bs-toggle="dropdown"
                aria-expanded="true"
              >
                PRODUCTS
              </a>
              <ul
                class="dropdown-menu ms-2 border-primary"
                aria-labelledby="navbarDropdownMenuLinkProducts"
              >
                <li v-for="category in uniqueCategories" :key="category">
                  <a
                    @click="handleCategoryClick(category)"
                    class="dropdown-item text-light-bold menu-main"
                    href="#"
                    >{{ category }}</a
                  >
                </li>
              </ul>
            </li>

            <li class="nav-item left-tab border-none">
              <a
                class="nav-link text-light-bold main-nav-menu-item dropdown"
                href="#"
                id="navbarDropdownMenuLinkBrands"
                role="button"
                data-bs-toggle="dropdown"
                aria-expanded="false"
              >
                BRANDS
              </a>
              <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLinkBrands">
                <li v-for="brand in uniqueBrands" :key="brand">
                  <a
                    @click="handleBrandClick(brand)"
                    class="dropdown-item text-light-bold menu-main"
                    href="#"
                    >{{ brand }}</a
                  >
                </li>
              </ul>
            </li>

            <li class="nav-item">
              <a
                class="nav-link text-light-bold main-nav-menu-item"
                href="#"
                @click="toggleSupportVisibility"
              >
                SUPPORT
              </a>
            </li>
            <!-- Blog Link -->
            <li class="nav-item">
              <a
                class="nav-link text-light-bold main-nav-menu-item"
                href="#"
                @click="toggleBlogVisibility"
              >
                BLOG
              </a>
            </li>
            <!-- Build Link -->
            <li class="nav-item">
              <a
                class="nav-link text-light-bold main-nav-menu-item"
                href="#"
                @click="toggleBuildVisibility"
              >
                BUILD
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

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

        <VaAccordion class="max-w-sm border-1 border-light">
          <VaCollapse class="text-light-bold-2 p-2 menu-item" header="CATEGORY">
            <template #body>
              <!-- Dynamic Categories List Items -->
              <div v-for="(category, index) in uniqueCategories" :key="`category-item-${index}`">
                <VaSidebarItem
                  class="align-items-center menu-item"
                  @click="handleCategoryClick(category)"
                >
                  <VaSidebarItemContent>
                    <VaSidebarItemTitle class="text-light">{{ category }} </VaSidebarItemTitle>
                  </VaSidebarItemContent>
                </VaSidebarItem>
              </div>
            </template>
          </VaCollapse>
        </VaAccordion>

        <VaAccordion class="max-w-sm">
          <VaCollapse class="text-light-bold-2 p-2 menu-item" header="BRAND">
            <template #body>
              <div class="brand-grid text-align-left">
                <div
                  class="brand-item me-2"
                  v-for="(brand, index) in uniqueBrands"
                  :key="`brand-item-${index}`"
                >
                  <VaSidebarItem @click="handleBrandClick(brand)" class="menu-item">
                    <VaSidebarItemContent>
                      <VaSidebarItemTitle class="brand-item text-light">
                        {{ brand }}
                      </VaSidebarItemTitle>
                    </VaSidebarItemContent>
                  </VaSidebarItem>
                </div>
              </div>
            </template>
          </VaCollapse>
        </VaAccordion>

        <!-- Other Main Navigation Links -->
        <router-link to="/profile" class="nav-link text-light-bold-2 nav-item" id="news-link">
          <VaSidebarItem class="menu-item">
            <VaSidebarItemContent>
              <VaIcon color="white" name="person" />
              <VaSpacer class="spacer" />

              <VaSidebarItemTitle class="text-light-bold-2">PROFILE</VaSidebarItemTitle>
            </VaSidebarItemContent>
          </VaSidebarItem>
        </router-link>
        <VaSidebarItem @click.prevent="toggleLoginModal" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="login" />
            <VaSpacer class="spacer" />

            <VaSidebarItemTitle class="text-light-bold-2">LOGIN</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
        <VaSidebarItem @click.prevent="toggleMessageBoard" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="message" />
            <VaSpacer class="spacer" />

            <VaSidebarItemTitle class="text-light-bold-2">MESSAGE BOARD</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
        <VaSidebarItem @click.prevent="toggleBuilderZoneVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="computer" />
            <VaSpacer class="spacer" />

            <VaSidebarItemTitle class="text-light-bold-2">BUILDER ZONE</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
        <VaSidebarItem @click.prevent="toggleBuilderZoneVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="discount" />
            <VaSpacer class="spacer" />

            <VaSidebarItemTitle class="text-light-bold-2">SALE</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>

        <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
          <VaSidebarItem class="menu-item">
            <VaSidebarItemContent>
              <VaIcon color="white" name="article" />
              <VaSpacer class="spacer" />

              <VaSidebarItemTitle class="text-light-bold-2">NEWS</VaSidebarItemTitle>
            </VaSidebarItemContent>
          </VaSidebarItem>
        </router-link>
        <VaSidebarItem @click="toggleSupportVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="danger" name="help" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">SUPPORT</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
        <VaSidebarItem @click="toggleBlogVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="description" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">BLOG</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
        <VaSidebarItem @click="toggleCartVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="shopping_cart" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">Shopping Cart</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>

        <VaSidebarItem @click="toggleBuildVisibility" class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="white" name="build" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">BUILD</VaSidebarItemTitle>
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
</template>

<script>
import LoginModal from '../modals/LoginModal.vue'

import { useUserStore } from '@/stores/User'
export default {
  components: {
    LoginModal
  },
  name: 'HeaderComponent',
  props: {
    cartItemCount: {
      type: Number,
      required: true
    },
    wishlistItemCount: {
      type: Number,
      required: true
    },
    products: {
      type: Array,
      required: true
    }
  },

  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      src: null,
      avatar_url: '',
      sidebarVisible: false,
      searchTerm: '',
      isModalVisible: false
    }
  },
  async mounted() {
    const userStore = useUserStore()

    // Run this only if there is an existing session
    if (userStore.isLoggedIn) {
      await userStore.fetchProfile()
    }

    window.addEventListener('resize', this.handleResize)
  },

  methods: {
    // async getProfile() {
    //   this.loading = true

    //   try {
    //     const userStore = useUserStore()

    //     if (!userStore.session || !userStore.session.user) {
    //       console.warn('Guest session or no user; skipping profile fetch.')
    //       return
    //     }

    //     const profile = await Profile.fetchUser(userStore.session.user.id)

    //     if (profile) {
    //       this.localUser = profile
    //       console.log('User profile:', this.localUser)
    //     } else {
    //       console.warn('No profile could be fetched.')
    //     }
    //   } catch (error) {
    //     console.error('Error fetching profile:', error.message)
    //   } finally {
    //     this.loading = false
    //   }
    // },
    handleResize() {
      this.windowWidth = window.innerWidth
    },
    toggleOffcanvasVisibility() {
      this.sidebarVisible = !this.sidebarVisible
    },
    loadProductCards(selectedItem) {
      this.$emit('load-product-cards', selectedItem)
    },
    performSearch(event) {
      event.preventDefault()
      this.$emit('search', this.searchTerm)
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleBuilderZoneVisibility() {
      this.$emit('toggle-builder-zone')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleWishlistVisibility() {
      this.$emit('toggle-wishlist')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },

    toggleCartVisibility() {
      this.$emit('toggle-cart')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleBuildVisibility() {
      this.$emit('toggle-build')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleSupportVisibility() {
      this.$emit('toggle-support')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleBlogVisibility() {
      this.$emit('toggle-blog')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleMessageBoard() {
      this.$emit('toggle-board')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
    },
    toggleLoginModal() {
      this.$emit('toggle-login-modal')
      if (this.windowWidth < 768) {
        this.toggleOffcanvasVisibility()
      }
      this.isModalVisible = true
    },
    filterProducts(filterType, filterValue) {
      this.$emit('filter-products', { type: filterType, value: filterValue })
    },
    handleCategoryClick(category) {
      this.loadProductCards(category)
      if (this.windowWidth < 996) {
        this.toggleOffcanvasVisibility()
      }
      // this.scrollToProductCarousel()
    },
    handleBrandClick(brand) {
      this.loadProductCards(brand)
      if (this.windowWidth < 996) {
        this.toggleOffcanvasVisibility()
      }
      // this.scrollToProductCarousel()
    }
    // scrollToProductCarousel() {
    //   const carouselElement = document.getElementById('productCarousel')
    //   if (carouselElement) {
    //     carouselElement.scrollIntoView({ behavior: 'smooth' })
    //   }
    // }
  },

  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
  },
  watch: {
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
  computed: {
    uniqueCategories() {
      return Array.from(
        this.products.reduce((acc, product) => {
          acc.add(product.category)
          return acc
        }, new Set())
      )
    },
    uniqueBrands() {
      return Array.from(
        this.products.reduce((acc, product) => {
          acc.add(product.brand)
          return acc
        }, new Set())
      )
    },
    isLoggedIn() {
      const userStore = useUserStore()
      return userStore.isLoggedIn
    },
    // Use the user information from the profile in the store
    localUser() {
      const userStore = useUserStore()
      return userStore.profile || {} // Fallback to an empty object if no profile found
    }
  }
}
</script>
<style>
.login-modal {
  z-index: 300;
}

#body {
  z-index: 400;
}

.brand-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  grid-gap: 10px;
  justify-content: center;
  align-items: center;
}

.brand-item {
  text-align: start;
}

.menu-item {
  border-bottom: 1px solid white;
}
.avatar-container {
  display: flex;
  align-items: center;
  justify-content: center;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  cursor: pointer;
}
.va-sidebar {
  z-index: 900;
}
</style>
