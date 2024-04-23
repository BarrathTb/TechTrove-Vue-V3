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
                <router-link to="/home" class="nav-link text-light-bold-2 nav-item" id="news-link">
                  Store
                </router-link>
              </li>

              <li class="nav-item mx-2">
                <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
                  News
                </router-link>
              </li>
              <li class="nav-item mx-2">
                <router-link to="/news" class="nav-link text-light-bold-2 nav-item" id="news-link">
                  Message Board
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
        </div>
      </nav>
    </div>

    <!-- Main Navbar -->

    <nav class="navbar navbar-expand-md bg-body-secondary bg-secondary">
      <div class="container-fluid align-items-center justify-content-between">
        <a href="/">
          <img src="/images/TechTrove-logo.png" alt="TechTrove Logo" width="250" height="53"
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
export default {
  name: 'NewsHeader',
  components: {
    LoginModal
  },
  data() {
    return {
      isModalVisible: false
    }
  },
  methods: {
    toggleLoginModal() {
      this.isModalVisible = !this.isModalVisible
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
