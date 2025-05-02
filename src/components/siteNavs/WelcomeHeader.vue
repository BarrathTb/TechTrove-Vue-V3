<template>
  <header class="header">
    <div class="bg-primary text-white">
      <nav class="navbar navbar-expand navbar-dark bg-primary">
        <div class="container-fluid align-items-center justify-content-start">
          <div class="d-none d-lg-flex justify-content-end align-items-center flex-grow-1 pe-4">
            <router-link to="/login">
              <button class="nav-link border-0 bg-transparent" id="login-modal">
                <i class="bi bi-person fs-4 mb-2 mx-2 icon-success"></i>
              </button>
            </router-link>
          </div>
        </div>
      </nav>
    </div>

    <div class="header-main mx-auto w-100 h-100">
      <nav class="navbar bg-body-secondary bg-secondary">
        <div class="container-lg mx-auto">
          <router-link class="navbar-brand me-5" to="/">
            <img :src="logo" alt="TechTrove Logo" width="250" height="53" />
          </router-link>

          <ul class="nav nav-tabs d-none d-lg-flex mx-2">
            <li class="nav-item left-tab border-none">
              <a
                class="nav-link text-light-bold main-nav-menu-item"
                href="#"
                role="button"
                @click="toStore"
              >
                PRODUCTS
              </a>
            </li>
            <router-link to="/login">
              <li class="nav-item left-tab border-none">
                <a
                  class="nav-link text-light-bold main-nav-menu-item"
                  href="#"
                  role="button"
                  aria-expanded="true"
                >
                  LOGIN
                </a>
              </li>
            </router-link>
          </ul>

          <button
            class="d-lg-none border-0 bg-transparent"
            type="button"
            data-bs-toggle="offcanvas"
            data-bs-target="#offcanvasNavbar"
            aria-controls="offcanvasNavbar"
          >
            <i class="bi bi-list fs-2 mb-2 mx-2 icon-success"></i>
          </button>

          <div
            class="offcanvas offcanvas-end bg-secondary"
            id="offcanvasNavbar"
            data-bs-toggle="offcanvas"
            title="Menu"
            right
          >
            <ul class="nav nav-tabs flex-column mx-2">
              <li class="nav-item left-tab border-none">
                <a
                  class="nav-link text-light-bold main-nav-menu-item"
                  href="#"
                  role="button"
                  @click="toStore"
                >
                  PRODUCTS
                </a>
              </li>

              <li class="nav-item left-tab border-none">
                <router-link to="/login" class="nav-link text-light-bold main-nav-menu-item">
                  LOGIN
                </router-link>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
  </header>
</template>

<script>
import logo from '@/assets/images/TechTrove-logo.png'
export default {
  name: 'HeaderComponent',
  // props: {
  //   modelValue: {
  //     type: Boolean,
  //     default: false
  //   }
  // },
  // watch: {
  //   modelValue(newValue) {
  //     this.isModalVisible = newValue
  //   }
  // },
  // emits: ['toggle-login-modal'],
  data() {
    return {
      logo: logo,
      searchTerm: ''
    }
  },
  methods: {
    performSearch(event) {
      event.preventDefault()
      this.$emit('search', this.searchTerm)
    },

    // toggleLoginModal() {
    //   this.$emit('toggle-login-modal')
    // },
    toStore() {
      this.$router.push('/home')
    },
    toLogin() {
      this.$router.push('/login')
    }
  }
}
</script>
