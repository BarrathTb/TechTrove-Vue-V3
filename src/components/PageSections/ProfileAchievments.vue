<template>
  <transition name="fade">
    <section v-show="achievmentsVisible">
      <div class="container-fluid">
        <div class="row">
          <div class="col-12 col-lg-3 mb-4 mb-lg-0">
            <h3 class="text-white text-center align-items-center">Achievments</h3>

            <img
              class="avatar rounded-4 d-flex align-items-center justify-content-center mt-4 mb-4 ms-4"
              :src="localUser?.avatar_url || defaultAvatarUrl"
            />

            <div class="row">
              <h1 class="text-light-bold text-center align-items-center me-2">
                <i class="bi bi-star-fill me-4"></i>874
              </h1>
            </div>

            <p class="text-light-bold text-center">Total Points</p>
          </div>

          <div class="col-12 col-lg-5 mb-4 mb-lg-0">
            <div class="container-fluid mt-2">
              <div class="bg-secondary p-4 rounded-4">
                <h4 class="text-white text-center">User Level</h4>
                <div class="row">
                  <div class="col-4">
                    <h5 class="text-white text-center">Level 8</h5>
                    <h5 class="text-white text-center">874</h5>
                  </div>
                  <div class="col-4">
                    <h5 class="tube-text-aqua text-center mt-2">
                      <i class="bi bi-chevron-right text-center"
                        ><i class="bi bi-chevron-right text-center"></i
                      ></i>
                    </h5>
                  </div>
                  <div class="col-4">
                    <h5 class="text-white text-center">Level 9</h5>
                    <h5 class="text-white text-center">900</h5>
                  </div>
                </div>
              </div>
            </div>
            <div class="container-fluid mt-2">
              <div class="bg-primary rounded-4 mt-4">
                <div class="row">
                  <div class="col-4 col-md-3 mb-3 mb-md-0">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge1.png" />
                    </div>
                  </div>
                  <div class="col-4 col-md-3 mb-3 mb-md-0">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge2.png" />
                    </div>
                  </div>
                  <div class="col-4 col-md-3 mb-3 mb-md-0">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge3.png" />
                    </div>
                  </div>
                  <div class="col-4 col-md-3">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge4.png" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-12 col-lg-4">
            <div class="container-fluid mt-2 ms-4">
              <div class="bg-secondary p-4 rounded-4">
                <h5 class="text-light-bold p-2">
                  Discover How to Earn Badges and Unlock Amazing Rewards and Discounts.
                </h5>
                <div class="row d-flex align-items-center justify-content-between me-2">
                  <div class="col-4 col-md-3 mb-3 mb-md-0">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge2.png" />
                    </div>
                  </div>
                  <div class="col-4 col-md-3 mb-3 mb-md-0">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge3.png" />
                    </div>
                  </div>
                  <div class="col-4 col-md-3">
                    <div
                      class="bg-secondary d-flex align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar src="images/badge4.png" />
                    </div>
                  </div>
                </div>
                <button
                  class="btn btn-success btn-sm mt-4 text-black align-items-center justify-content-center"
                  type="button"
                >
                  <i class="bi bi-info-circle fs-5 me-2 text-black"></i>
                  Learn More
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row ms-4 me-4 mt-4">
        <div class="col-12">
          <div class="container-fluid mt-2">
            <div class="bg-secondary p-4 rounded-4">
              <div class="bg-primary p-4 rounded-4">
                <div class="row">
                  <div class="col-12 col-md-9">
                    <!-- Adjusted the column sizes here -->
                    <h4 class="text-white">Achievement Stats</h4>
                  </div>
                  <div class="col-12 col-md-3 d-flex justify-content-md-end mt-2 mt-md-0">
                    <!-- Added d-flex and adjusted classes for responsive behavior -->
                    <select
                      name="stat-graph"
                      class="form-select text-light select-input"
                      id="stats-select"
                    >
                      <option disabled selected value="">Daily</option>
                      <option value="week">Weekly</option>
                      <option value="month">Monthly</option>
                    </select>
                  </div>
                </div>

                <div class="row">
                  <div class="col-12">
                    <div class="mt-4 rounded-4 bg-secondary">
                      <!-- <luzmo-dashboard
                        dashboardId="945620d9-3013-4ec5-986c-d858008faa0b"
                        authKey="< embed key (id property) returned by step 1 >"
                        authToken="< embed token (token property) returned by step 1 >"
                        appServer="https://app.us.luzmo.com/"
                      >
                      </luzmo-dashboard> -->

                      <img width="100%" :src="stats" class="" alt="display tech image" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </transition>
</template>

<script>
// import { LuzmoDashboard } from '@luzmo/vue-embed'
// import Avatar from '@/components/PageSections/ProfileAvatar.vue'
import stats from '@/assets/images/stats.png'
import { useUserStore } from '@/stores/User'

export default {
  name: 'ProfileAchievments',
  // components: {
  //   Avatar
  //   // LuzmoDashboard
  // },
  props: {
    achievmentsVisible: {
      type: Boolean,
      default: false
    }
  },

  emits: ['update'],

  data() {
    return {
      stats: stats,
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      src: null,
      size: 10,
      loading: true,
      username: '',
      website: '',
      avatar_url: '',
      isModalVisible: false
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
    // async fetchAndUpdateUser() {
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

    async signOut() {
      this.authService.signOut()
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
  max-width: 70px;
  max-height: 70px;
  border-radius: 50%;
  object-fit: cover;
}
.fade-enter-active {
  transition:
    opacity 1.5s,
    transform 1.5s;
  transition-delay: 0.6s;
}
.fade-leave-active {
  transition:
    opacity 0.5s,
    transform 0.5s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
@media (max-width: 991.98px) { /* Target screens smaller than lg breakpoint */ .col-12.col-lg-5 {
margin-right: 0 !important; /* Remove right margin when stacked */ } .col-12.col-lg-4
.container-fluid.mt-2.ms-4 { margin-left: 0 !important; /* Remove left margin on right column
container */ } .col-12.col-lg-3.mb-4.mb-lg-0 { text-align: center; /* Center text in the first
column */ } .col-12.col-lg-3.mb-4.mb-lg-0 .avatar { margin-left: auto; /* Center avatar */
margin-right: auto; } } @media (max-width: 767.98px) { /* Target screens smaller than md breakpoint
*/ .col-12.col-md-3.d-flex.justify-content-md-end { justify-content: flex-start !important; /* Align
dropdown to start on small screens */ } .col-4.col-md-3 .bg-secondary { padding: 0.5rem !important;
/* Reduce padding for badges on smaller screens */ } .col-12.col-lg-4 .bg-secondary { text-align:
center; /* Center content in the right column box */ } }
