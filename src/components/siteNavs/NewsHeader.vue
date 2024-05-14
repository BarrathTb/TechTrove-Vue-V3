<template>
  <header class="header">
    <!-- Top Bar -->
    <div class="bg-primary text-white d-none d-md-block">
      <nav class="navbar navbar-expand-md navbar-dark bg-primary">
        <div class="container-fluid align-items-center justify-content-start">
          <!-- Search Bar -->

          <!-- Links -->
          <div class="d-none d-md-flex justify-content-between flex-grow-1">
            <ul class="navbar-nav ms-auto" aria-label="Tertiary Navigation">
              <li class="nav-item mx-2">
                <router-link
                  to="/home"
                  class="nav-link align-items-center text-light-bold-2 nav-item"
                >
                  <i class="bi bi-arrow-left fs-4 mx-2 tube-text-pink icon-success"></i>
                  Back toStore
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
              <img
                :src="localUser?.avatar_url || defaultAvatarUrl"
                id="profile-avatar"
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
        <a href="/"> <img :src="logo" alt="TechTrove Logo" width="250" height="53" /></a>

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
                class="dropdown-menu ms-2 my-auto border-primary"
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
</template>

<script>
import LoginModal from '../modals/LoginModal.vue'
import logo from '@/assets/images/TechTrove-logo.png'
import { useUserStore } from '@/stores/User'
export default {
  name: 'NewsHeader',
  components: {
    LoginModal
  },
  data() {
    return {
      logo: logo,
      avatar_url: '',
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      isModalVisible: false
    }
  },
  async mounted() {
    const userStore = useUserStore()

    // Run this only if there is an existing session
    if (userStore.isLoggedIn) {
      await userStore.fetchProfile()
      this.getAvatarUrl() // Call getAvatarUrl only after the profile has been fetched
    }
  },
  methods: {
    toggleLoginModal() {
      this.isModalVisible = !this.isModalVisible
    },
    getAvatarUrl() {
      const userStore = useUserStore()
      this.avatar_url = userStore.profile.avatar_url
    }
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

<style scoped>
.news-header {
  background-color: #007bff; /* Primary color */
  color: #ffffff;
}

.news-header-title {
  font-size: 2rem; /* Adjust the font size as needed */
  margin-bottom: 0;
  text-align: center;
}
</style>
