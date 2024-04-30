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
              <a class="nav-link text-light-bold" href="#" @click="toggleDetails">orders</a>
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
      <div class="col-9 bg-primary mt-4">
        <ProfileAchievments v-show="achievmentsVisible" :session="session" v-if="session" />
        <ProfileDetails
          v-show="detailsVisible"
          :session="session"
          v-if="session"
          @Update="updateProfile"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { supabase } from '@/utils/Supabase'
import LoginModal from '@/components/modals/LoginModal.vue'
import ProfileDetails from '@/components/PageSections/ProfileDetails.vue'
import ProfileAchievments from '@/components/PageSections/ProfileAchievments.vue'

export default {
  name: 'ProfilePage',
  props: {
    session: {
      type: Object,
      default: () => ({}),
      required: true
    }
  },
  components: {
    LoginModal,
    ProfileDetails,
    ProfileAchievments
  },

  data() {
    return {
      achievmentsVisible: false,
      detailsVisible: true,
      loading: true,
      username: '',
      website: '',
      avatar_url: '',
      isModalVisible: false
    }
  },

  created() {
    this.getProfile()
  },
  methods: {
    toggleAchievments() {
      this.achievmentsVisible = true
      this.detailsVisible = false
    },
    toggleDetails() {
      this.detailsVisible = true
      this.achievmentsVisible = false
    },
    async getProfile() {
      try {
        this.loading = true
        // Check if session exists and has a user
        if (!this.session || !this.session.user) {
          throw new Error('Session or user information is unavailable.')
        }

        const { data, error, status } = await supabase
          .from('profiles')
          .select(`username, website, avatar_url`)
          .eq('id', this.session.user.id) // Now we're confident user exists
          .single()

        if (error && status !== 406) throw error

        if (data) {
          this.username = data.username
          this.website = data.website
          this.avatar_url = data.avatar_url
        }
      } catch (error) {
        alert(error.message)
      } finally {
        this.loading = false
      }
    },

    async updateProfile() {
      try {
        this.loading = true
        const { user } = this.session
        if (!this.session || !this.session.user) {
          throw new Error('Session or user information is unavailable.')
        }

        const updates = {
          id: user.id,
          username: this.username,
          website: this.website,
          avatar_url: this.avatar_url,
          updated_at: new Date()
        }

        const { error } = await supabase.from('profiles').upsert(updates)

        if (error) throw error
      } catch (error) {
        alert(error.message)
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
