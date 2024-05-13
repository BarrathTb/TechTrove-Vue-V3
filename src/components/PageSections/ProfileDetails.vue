<template>
  <transition name="fade">
    <section v-show="detailsVisible == true">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-4">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Personal Details
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Edit your personal details here.
            </p>

            <img
              :src="localUser?.avatar_url || defaultAvatarUrl"
              class="avatar ms-4"
              alt="Avatar"
            />
          </div>
        </div>

        <div class="container-fluid mt-2 ms-4">
          <div class="row">
            <div class="col-6">
              <form class="form-widget mt-4" @submit.prevent="updateProfile">
                <div class="row">
                  <div class="col-4">
                    <label for="username" class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Full Name</label
                    >
                  </div>
                  <div class="col-8">
                    <input
                      id="username"
                      type="text"
                      v-model="localUser.full_name"
                      class="form-control select-input"
                      placeholder="John Doe"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>User Name</label
                    >
                  </div>
                  <div class="col-8">
                    <input
                      type="text"
                      v-model="localUser.username"
                      class="form-control select-input"
                      placeholder="username..."
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label for="email" class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Email</label
                    >
                  </div>
                  <div class="col-8">
                    <input
                      type="email"
                      class="form-control select-input"
                      placeholder="johndoe@example.com"
                      id="email"
                      v-model="localUser.email"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Date of Birth</label
                    >
                  </div>
                  <div class="col-8">
                    <input type="date" class="form-control select-input" />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Shipping Address</label
                    >
                  </div>
                  <div class="col-8">
                    <textarea
                      class="form-control select-input"
                      placeholder="123 Main St, Anytown AU"
                    ></textarea>
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Profile Avatar</label
                    >
                  </div>
                  <div class="col-8">
                    <Avatar @avatar-uploaded="onAvatarUpload($event)" />
                  </div>
                </div>

                <div>
                  <button
                    class="btn btn-success btn-sm px-4 mt-4 text-black btn-bold align-items-center justify-content-end"
                    type="submit"
                    :value="loading ? 'Loading ...' : 'Update'"
                    :disabled="loading"
                  >
                    <i class="bi bi-arrow-up fs-5 me-2 text-black"></i>
                    Update
                  </button>
                </div>
              </form>
            </div>
            <div class="col-4 h-100 bg-primary ms-4 mt-4">
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
import Avatar from '@/components/PageSections/ProfileAvatar.vue'
import Profile from '@/models/Profile'
import { useUserStore } from '@/stores/User'

export default {
  components: {
    Avatar // Make sure the Avatar component is correctly imported
  },
  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      loading: false,
      full_name: '',
      username: '',
      email: '', // Assuming we're displaying the email (email field is managed by Supabase Auth)
      avatar_url: '',
      src: null,
      detailsVisible: true
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

    async onAvatarUpload(publicURL) {
      console.log('New avatar URL:', publicURL)

      try {
        this.loading = true

        // Update the local user's avatar_url directly
        this.localUser.avatar_url = publicURL

        // Now that we have the URL, we display it
        this.src = publicURL
      } catch (error) {
        alert(error.message)
      } finally {
        this.loading = false
      }
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
  width: 100px;
  height: 100px;
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
