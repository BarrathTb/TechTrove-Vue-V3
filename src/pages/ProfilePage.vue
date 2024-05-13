<template>
  <header class="header bg-secondary align-items-center">
    <!-- Top Bar -->
    <div class="bg-secondary text-white d-none d-md-block">
      <nav class="navbar navbar-expand-md navbar-dark bg-secondary">
        <h5 class="text-white ms-4 align-items-center justify-content-start">Profile</h5>
        <div class="d-none d-md-flex justify-content-between flex-grow-1">
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
        <VaSidebarItem class="menu-item">
          <VaSidebarItemContent>
            <VaIcon color="danger" name="help" />
            <VaSpacer class="spacer" />
            <VaSidebarItemTitle class="text-light-bold-2">SUPPORT</VaSidebarItemTitle>
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
      <div class="col-9 bg-primary mt-4">
        <ProfileAchievments v-show="achievmentsVisible" />
        <ProfileDetails v-show="detailsVisible" @Update="updateProfile" />
        <ProfileOrders v-show="ordersVisible" />
      </div>
    </div>
  </div>
</template>

<script>
import { supabase } from '@/utils/Supabase'
import LoginModal from '@/components/modals/LoginModal.vue'
import ProfileDetails from '@/components/PageSections/ProfileDetails.vue'
import ProfileAchievments from '@/components/PageSections/ProfileAchievments.vue'
import ProfileOrders from '@/components/PageSections/ProfileOrders.vue'
import Profile from '@/models/Profile'
import { useUserStore } from '@/stores/User'

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
    ProfileOrders
  },

  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg', // Placeholder image URL

      sidebarVisible: false,
      ordersVisible: false,
      achievmentsVisible: false,
      detailsVisible: true,
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

    // Run this only if there is an existing session
    if (userStore.isLoggedIn) {
      await userStore.fetchProfile()
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

  methods: {
    toggleAchievments() {
      this.achievmentsVisible = true
      this.detailsVisible = false
      this.ordersVisible = false
    },
    toggleDetails() {
      this.detailsVisible = true
      this.achievmentsVisible = false
      this.ordersVisible = false
    },
    toggleOrders() {
      this.ordersVisible = true
      this.achievmentsVisible = false
      this.detailsVisible = false
    },
    // async getProfile() {
    //   this.loading = true
    //   try {
    //     const userStore = useUserStore() // Obtain the store instance
    //     if (!userStore.session || !userStore.session.user) {
    //       throw new Error('Session or user information is unavailable.')
    //     }

    //     const profile = await Profile.fetchUser(userStore.session.user.id)
    //     if (profile) {
    //       this.localUser = profile // Update the local user with fetched profile info
    //     }
    //     console.log(this.localUser)
    //   } catch (error) {
    //     console.error(error.message)
    //   } finally {
    //     this.loading = false
    //   }
    // },

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
