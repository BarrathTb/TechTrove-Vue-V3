<template>
  <header class="header bg-secondary align-items-center">
    <!-- Mobile Header -->
    <div
      class="bg-secondary text-white d-flex d-md-none justify-content-between align-items-center px-3 py-2"
    >
      <h5 class="text-white m-0">Profile</h5>
      <button
        class="btn btn-link text-white"
        type="button"
        data-bs-toggle="offcanvas"
        data-bs-target="#mobileProfileOffcanvas"
        aria-controls="mobileProfileOffcanvas"
      >
        <i class="bi bi-list fs-4"></i>
      </button>
    </div>

    <!-- Top Bar -->
    <div class="bg-secondary text-white d-none d-md-block">
      <nav class="navbar navbar-expand-md navbar-dark bg-secondary">
        <h5 class="text-white ms-4 align-items-center justify-content-start">Profile</h5>
        <div class="d-none d-md-none justify-content-between flex-grow-1">
          <ul class="navbar-nav ms-auto" aria-label="Tertiary Navigation">
            <li class="nav-item mx-2">
              <a class="nav-link text-light-bold" href="#" @click="toggleDetails">Personal</a>
            </li>

            <li class="nav-item mx-2">
              <a class="nav-link text-light-bold" href="#" @click="toggleOrders">orders</a>
            </li>
            <li class="nav-item mx-2">
              <a class="nav-link text-light-bold" href="#" @click="toggleAchievments"
                >Achievments</a
              >
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
              alt="Profile Avatar"
              class="user-avatar ms-2"
            />
          </router-link>
        </div>
      </nav>
    </div>

    <!-- Main Navbar -->

    <div class="bg-secondary d-none d-md-block" id="profileSidebar">
      <!-- Profile Menu Links -->
      <nav class="justify-content-center my-2 ms-4">
        <!-- left side nave 80% vh -->
        <ul class="nav flex-column">
          <li class="nav-item d-flex align-items-center">
            <router-link to="/home" id="news-link">
              <i class="bi bi-arrow-left fs-4 mb-4 tube-text"></i>
            </router-link>
          </li>
          <li class="nav-item mt-5 d-flex align-items-center">
            <i class="bi bi-person fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click.prevent="toggleDetails"
              >Edit Personal Details</a
            >
          </li>
          <li class="nav-item my-2 d-flex align-items-center">
            <i class="bi bi-credit-card fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click.prevent="togglePaymentMethods"
              >Payment Methods</a
            >
          </li>
          <li class="nav-item my-2 d-flex align-items-center">
            <i class="bi bi-shield-lock fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click.prevent="toggleSecurity"
              >Security</a
            >
          </li>
          <li class="nav-item my-2 d-flex align-items-center">
            <i class="bi bi-gear fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click="togglePreferences"
              >Preferences</a
            >
          </li>
          <li class="nav-item my-2 d-flex align-items-center">
            <i class="bi bi-bell fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click.prevent="toggleNotifications"
              >Notifications</a
            >
          </li>
          <li class="nav-item my-2 d-flex align-items-center">
            <i class="bi bi-person-plus fs-4 me-2 tube-text"></i>
            <a class="nav-link text-light-bold-2" href="#" @click.prevent="toggleDetails"
              >Add Family Member</a
            >
          </li>
          <li class="nav-item mt-4 d-flex me-4 justify-content-center">
            <button
              class="btn btn-success btn-sm px-4 text-black btn-bold"
              @click.prevent="toggleDetails"
            >
              <i class="bi bi-box-arrow-left fs-4 me-2 text-black"></i>
              Logout
            </button>
          </li>
        </ul>
      </nav>

      <!-- Other Main Navigation Links -->
      <VaSidebarItem class="menu-item">
        <VaSidebarItemContent>
          <VaIcon color="danger" name="help" />
          <VaSpacer class="spacer" />
          <VaSidebarItemTitle class="text-light-bold-2">SUPPORT</VaSidebarItemTitle>
        </VaSidebarItemContent>
      </VaSidebarItem>
    </div>
    <!-- Mobile Offcanvas Menu -->
    <div
      class="offcanvas offcanvas-end bg-secondary d-md-none"
      tabindex="-1"
      id="mobileProfileOffcanvas"
      aria-labelledby="mobileProfileOffcanvasLabel"
    >
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="mobileProfileOffcanvasLabel">Profile Menu</h5>
        <button
          type="button"
          class="btn-close text-reset"
          data-bs-dismiss="offcanvas"
          aria-label="Close"
        ></button>
      </div>
      <div class="offcanvas-body">
        <!-- Profile Menu Links -->
        <nav class="justify-content-center my-2 ms-4">
          <ul class="nav flex-column">
            <li class="nav-item d-flex align-items-center">
              <router-link to="/home" id="news-link">
                <i class="bi bi-arrow-left fs-4 mb-4 tube-text"></i>
              </router-link>
            </li>
            <li class="nav-item mt-5 d-flex align-items-center">
              <i class="bi bi-person fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click.prevent="toggleDetails"
                data-bs-dismiss="offcanvas"
                >Edit Personal Details</a
              >
            </li>
            <li class="nav-item my-2 d-flex align-items-center">
              <i class="bi bi-credit-card fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click.prevent="togglePaymentMethods"
                data-bs-dismiss="offcanvas"
                >Payment Methods</a
              >
            </li>
            <li class="nav-item my-2 d-flex align-items-center">
              <i class="bi bi-shield-lock fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click.prevent="toggleSecurity"
                data-bs-dismiss="offcanvas"
                >Security</a
              >
            </li>
            <li class="nav-item my-2 d-flex align-items-center">
              <i class="bi bi-gear fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click="togglePreferences"
                data-bs-dismiss="offcanvas"
                >Preferences</a
              >
            </li>
            <li class="nav-item my-2 d-flex align-items-center">
              <i class="bi bi-bell fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click.prevent="toggleNotifications"
                data-bs-dismiss="offcanvas"
                >Notifications</a
              >
            </li>
            <li class="nav-item my-2 d-flex align-items-center">
              <i class="bi bi-person-plus fs-4 me-2 tube-text"></i>
              <a
                class="nav-link text-light-bold-2"
                href="#"
                @click.prevent="toggleDetails"
                data-bs-dismiss="offcanvas"
                >Add Family Member</a
              >
            </li>
            <li class="nav-item mt-4 d-flex me-4 justify-content-center">
              <button
                class="btn btn-success btn-sm px-4 text-black btn-bold"
                @click.prevent="toggleDetails"
              >
                <i class="bi bi-box-arrow-left fs-4 me-2 text-black"></i>
                Logout
              </button>
            </li>
          </ul>
        </nav>
        <!-- Other Main Navigation Links -->
        <VaSidebarItem class="menu-item" data-bs-dismiss="offcanvas">
          <VaSidebarItemContent>
            <VaIcon color="danger" name="help" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">SUPPORT</VaSidebarItemTitle>
          </VaSidebarItemContent>
        </VaSidebarItem>
      </div>
    </div>

    <LoginModal
      class="login-modal"
      v-model="isModalVisible"
      @toggle-login-modal="toggleLoginModal"
    />
  </header>
  <div class="container-fluid d-flex flex-col-4 justify-content-start">
    <div class="row bg-primary flex-grow-1">
      <div class="col-12 bg-primary mt-4">
        <ProfileAchievments v-show="achievmentsVisible" />
        <ProfileDetails v-show="detailsVisible" @Update="updateProfile" />
        <ProfileOrders v-show="ordersVisible" />
        <ProfilePrefrences v-show="prefrencesVisible" />
        <ProfileSecurity v-show="securityVisible" />
        <ProfilePaymentMethods v-show="paymentMethodsVisible" />
        <ProfileNotifications v-show="notificationsVisible" />
      </div>
    </div>
  </div>
</template>

<script>
import LoginModal from '@/components/modals/LoginModal.vue'
import ProfileAchievments from '@/components/PageSections/ProfileAchievments.vue'
import ProfileDetails from '@/components/PageSections/ProfileDetails.vue'
import ProfileNotifications from '@/components/PageSections/ProfileNotifications.vue'
import ProfileOrders from '@/components/PageSections/ProfileOrders.vue'
import ProfilePaymentMethods from '@/components/PageSections/ProfilePaymentMethods.vue'
import ProfilePrefrences from '@/components/PageSections/ProfilePreferences.vue'
import ProfileSecurity from '@/components/PageSections/ProfileSecurity.vue'
import Profile from '@/models/Profile'
import { useUserStore } from '@/stores/User'
import { supabase } from '@/utils/Supabase'

export default {
  name: 'ProfilePage',
  props: {
    // session: {
    //   type: Object,
    //   required: true
    // }
  },
  components: {
    LoginModal,
    ProfileDetails,
    ProfileAchievments,
    ProfileOrders,
    ProfilePrefrences,
    ProfileSecurity,
    ProfilePaymentMethods,
    ProfileNotifications
  },

  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg', // Placeholder image URL
      prefrencesVisible: false,
      sidebarVisible: false,
      ordersVisible: false,
      achievmentsVisible: false,
      detailsVisible: true, // Default visible section
      securityVisible: false,
      paymentMethodsVisible: false,
      notificationsVisible: false,
      loading: true,
      full_name: '',
      username: '',
      website: '',
      avatar_url: '',
      isModalVisible: false,
      src: ''
    }
  },
  async mounted() {
    const userStore = useUserStore()
    if (userStore.isLoggedIn) {
      await userStore.fetchProfile()
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
    isLoggedIn: {
      handler(loggedIn) {
        if (loggedIn) {
          const userStore = useUserStore()
          userStore.fetchProfile()
        } else {
          console.log('No user is logged in.')
        }
      },
      immediate: true
    }
  },

  methods: {
    toggleAchievments() {
      this.achievmentsVisible = true
      this.detailsVisible = false
      this.ordersVisible = false
      this.prefrencesVisible = false
      this.securityVisible = false
      this.paymentMethodsVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    toggleDetails() {
      this.detailsVisible = true
      this.achievmentsVisible = false
      this.ordersVisible = false
      this.prefrencesVisible = false
      this.securityVisible = false
      this.paymentMethodsVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    toggleOrders() {
      this.ordersVisible = true
      this.achievmentsVisible = false
      this.detailsVisible = false
      this.prefrencesVisible = false
      this.securityVisible = false
      this.paymentMethodsVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    togglePreferences() {
      this.prefrencesVisible = true
      this.detailsVisible = false
      this.achievmentsVisible = false
      this.ordersVisible = false
      this.securityVisible = false
      this.paymentMethodsVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    toggleSecurity() {
      this.securityVisible = true
      this.detailsVisible = false
      this.achievmentsVisible = false
      this.ordersVisible = false
      this.prefrencesVisible = false
      this.paymentMethodsVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    togglePaymentMethods() {
      this.paymentMethodsVisible = true
      this.detailsVisible = false
      this.achievmentsVisible = false
      this.ordersVisible = false
      this.prefrencesVisible = false
      this.securityVisible = false
      this.notificationsVisible = false
      this.sidebarVisible = false
    },
    toggleNotifications() {
      this.notificationsVisible = true
      this.detailsVisible = false
      this.achievmentsVisible = false
      this.ordersVisible = false
      this.prefrencesVisible = false
      this.securityVisible = false
      this.paymentMethodsVisible = false
      this.sidebarVisible = false
    },
    async updateProfile() {
      this.loading = true
      try {
        const userId = this.localUser.id // Extract the user ID from the localUser object
        const updates = {
          full_name: this.localUser.full_name,
          username: this.localUser.username,
          email: this.localUser.email,
          avatar_url: this.localUser.avatar_url,
          shipping_address: this.localUser.shipping_address
        }

        const result = await Profile.updateUser(userId, updates) // userId should be the first argument

        if (result && result.error) {
          throw new Error(result.error.message)
        }

        // Update the user store with the new user details after they have been successfully updated
        const userStore = useUserStore()
        userStore.setUser(this.localUser)

        // Possibly do something with the result, like showing a success message
      } catch (error) {
        console.error(error.message)
      } finally {
        this.loading = false
      }
    },

    async signOut() {
      try {
        this.loading = true
        const { error } = await supabase.auth.signOut()
        if (error) throw error
      } catch (error) {
        alert(error.message)
      } finally {
        this.loading = false
      }
    },
    toggleLoginModal() {
      this.isModalVisible = !this.isModalVisible
    },
    toggleOffcanvasVisibility() {
      this.sidebarVisible = !this.sidebarVisible
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

@media (min-width: 768px) {
  /* Target screens larger than or equal to md breakpoint */
  #profileSidebar {
    /* Target the inner div */
    display: block !important; /* Ensure it's displayed */
    position: fixed; /* Keep it fixed */
    top: 0;
    left: 0;
    height: 100vh; /* Full height */
    width: 25%; /* Set a width for the sidebar (col-4 equivalent) */
    /* Remove visibility and transform overrides as they might conflict */
  }

  .container-fluid {
    padding-left: 15%; /* Add padding to the main content to make space for the sidebar */
  }

  /* Hide the mobile header toggle button on large screens */
  .header .d-md-none {
    display: none !important;
  }

  /* Ensure the main header content is visible on large screens */
  .header .d-md-block {
    display: block !important;
  }

  .header .d-md-flex {
    display: flex !important;
  }
}

@media (max-width: 767.98px) {
  /* Target screens smaller than md breakpoint */
  .sidebar.bg-secondary {
    height: auto; /* Allow sidebar height to adjust based on content */
    margin-bottom: 1rem; /* Add some space below the sidebar when stacked */
  }
  .col-12.col-md-9.bg-primary {
    margin-top: 0 !important; /* Remove top margin for content when stacked */
  }
}
</style>
