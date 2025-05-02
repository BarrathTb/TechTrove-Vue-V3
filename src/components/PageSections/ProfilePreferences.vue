<template>
  <transition name="fade">
    <section v-show="preferencesVisible">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-12">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Personal Preferences
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Edit your profile preferences.
            </p>

            <img
              :src="localUser?.avatar_url || defaultAvatarUrl"
              class="avatar ms-4"
              alt="Avatar"
            />
          </div>
        </div>
        <div class="container-fluid my-2 mt-2 ms-4">
          <div class="row">
            <div class="col-12 col-lg-7">
              <div class="preference my-2">
                <span class="preference-label">Enable Notifications</span>
                <VaSwitch v-model="preferences.notifications" color="custom-success" />
              </div>

              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center">Dark Mode</span>
                <VaSwitch v-model="preferences.darkMode" color="custom-success" />
              </div>

              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  >Email Updates</span
                >
                <VaSwitch v-model="preferences.emailUpdates" color="custom-success" />
              </div>

              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  >Location Tracking</span
                >
                <VaSwitch v-model="preferences.locationTracking" color="custom-success" />
              </div>

              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  >Social Media Visibility</span
                >
                <VaSwitch v-model="preferences.socialVisibility" color="custom-success" />
              </div>

              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  >Auto-Play Videos</span
                >
                <VaSwitch v-model="preferences.autoPlayVideos" color="custom-success" />
              </div>
            </div>
            <div class="col-12 col-lg-5 h-100 bg-primary ms-lg-4 mt-4">
              <div class="container-fluid ms-4">
                <div class="bg-secondary p-4 rounded-2 me-4">
                  <h3 class="text-white">Exclusive Offers!</h3>
                  <p>
                    Get access to exclusive offers and the best prices for high-quality computer
                    parts and accessories. Join our VIP club now!
                  </p>
                  <button class="btn btn-success btn-sm px-4 text-black btn-bold my-2">
                    Join Now
                  </button>
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
import { useUserStore } from '@/stores/User'
export default {
  data() {
    return {
      preferencesVisible: false,

      avatar_url: '',
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      loading: false,

      preferences: {
        notifications: true,
        darkMode: false,
        emailUpdates: true,
        locationTracking: false,
        socialVisibility: true,
        autoPlayVideos: false
      }
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
  }
}
</script>

<style scoped>
.profile-preferences-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}

.preference {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #2c2c2c;
}

.preference-label {
  font-weight: 500;
  font-size: 16px;
}
@media (max-width: 991.98px) {
  /* Target screens smaller than lg breakpoint */
  .col-12.col-lg-5.bg-primary {
    margin-left: 0 !important; /* Remove left margin on offers box when
stacked */
    margin-top: 2rem; /* Add top margin to offers box when stacked */
  }
  .container-fluid.my-2.mt-2.ms-4 {
    margin-left: 0 !important; /* Remove left margin on main container
*/
  }
}
</style>
