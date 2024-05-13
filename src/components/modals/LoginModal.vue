<template>
  <VaModal v-model="isModalVisible" class="rounded">
    <template #content>
      <div class="modal-lg rounded bg-primary p-4" style="border-radius: 10px">
        <div class="modal-dialog text-light" role="login-area">
          <div class="modal-content p-4">
            <div class="modal-header bg-primary">
              <h5 class="modal-title mb-2" id="login-modal-area">Login to Your Account</h5>
              <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                <i class="fas fa-close"></i>
              </button>
            </div>
            <div class="modal-body rounded bg-secondary p-4">
              <div class="text-center text-light p-2">
                <p>Login via magic link with email below</p>
                <a
                  href="#"
                  class="btn btn-outline btn-block mb-2 me-2"
                  style="background-color: #3b5998; color: white"
                >
                  <i class="fab fa-facebook-f"></i> Facebook
                </a>
                <a
                  href="#"
                  @click="signInWithGoogle"
                  class="btn btn-outline-danger btn-block mb-2 ms-2 me-2"
                  style="background-color: #dd4b39; color: white"
                >
                  <i class="fab fa-google"></i> Google
                </a>
                <a
                  href="#"
                  class="btn btn-outline-info btn-block mb-2 ms-2"
                  style="background-color: #55acee; color: white"
                >
                  <i class="fab fa-twitter"></i> Twitter
                </a>

                <hr />
              </div>

              <form v-show="!showSignUpForm" @submit.prevent="login">
                <div class="form-group p-2">
                  <label for="email">Email</label>
                  <input
                    v-model="credentials.email"
                    type="text"
                    class="form-control text-light bg-primary login-input"
                    id="email"
                    placeholder=" Enter email"
                  />
                </div>
                <div class="form-group p-2">
                  <label for="password">Password</label>
                  <input
                    v-model="credentials.password"
                    type="password"
                    class="form-control text-light bg-primary login-input"
                    id="password"
                    placeholder="Enter a password..."
                  />
                </div>

                <div class="form-check mt-2">
                  <input
                    v-model="credentials.rememberMe"
                    type="checkbox"
                    class="form-check-input"
                    id="rememberMe"
                  />
                  <label for="rememberMe">Remember me</label>
                </div>
              </form>
              <form v-if="showSignUpForm" @submit.prevent="signUp">
                <!-- Sign-up form fields -->
                <div class="form-group p-2">
                  <label for="username">Username</label>
                  <input
                    v-model="signUpData.username"
                    type="text"
                    class="form-control text-light bg-primary login-input"
                    id="username"
                    placeholder="Enter a username"
                  />
                </div>
                <div class="form-group p-2">
                  <label for="fullName">Full Name</label>
                  <input
                    v-model="signUpData.fullName"
                    type="text"
                    class="form-control text-light bg-primary login-input"
                    id="fullName"
                    placeholder="Enter your full name"
                  />
                </div>
                <div class="form-group p-2">
                  <label for="email">Email</label>
                  <input
                    v-model="signUpData.email"
                    type="text"
                    class="form-control text-light bg-primary login-input"
                    id="email"
                    placeholder=" Enter email"
                  />
                </div>
                <div class="form-group p-2">
                  <label for="password">Password</label>
                  <input
                    v-model="signUpData.password"
                    type="password"
                    class="form-control text-light bg-primary login-input"
                    id="password"
                    placeholder="Enter a password..."
                  />
                </div>
                <div class="d-flex mt-2 justify-content-between">
                  <button
                    type="button"
                    class="btn btn-transparent btn-sm"
                    @click="showSignUpForm = false"
                  >
                    <i class="bi bi-arrow-left fs-4 me-2 tube-text-pink me-4"></i>
                  </button>
                  <button
                    v-if="!isLoggedIn"
                    type="submit"
                    class="btn btn-outline-success btn-sm rounded-4 text-bold ms-2 me-2 custom-size"
                    @click="signUp"
                  >
                    Create Account
                  </button>
                </div>
              </form>
            </div>

            <div v-if="!showSignUpForm" class="modal-footer bg-primary p-2 mx-auto">
              <div class="row mt-3">
                <div class="col">
                  <div class="btn-group">
                    <button
                      v-if="!isLoggedIn"
                      type="button"
                      class="btn btn-outline-success text-bold ms-2 me-2"
                      @click="login"
                    >
                      Login
                    </button>
                    <button
                      v-else
                      type="button"
                      class="btn btn-outline-danger text-bold me-2"
                      @click="logout"
                    >
                      Logout
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-secondary text-bold ms-2 me-2"
                      @click="closeModal"
                    >
                      Close
                    </button>
                    <button
                      v-if="!isLoggedIn"
                      type="button"
                      class="btn btn-outline-success text-bold ms-2"
                      @click="toggleSignUpForm"
                    >
                      Sign Up
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  </VaModal>
</template>

<script>
import { useUserStore } from '@/stores/User'
export default {
  name: 'LoginModal',

  data() {
    return {
      showLoginForm: true,
      isModalVisible: false,
      credentials: {
        email: '',
        password: '',
        rememberMe: false,
        errorMessage: ''
      },
      showSignUpForm: false,
      signUpData: {
        username: '',
        fullName: '',
        email: '',
        password: '',
        errorMessage: ''
      }
    }
  },
  computed: {
    isLoggedIn() {
      const userStore = useUserStore() // Correct usage of useUserStore
      return userStore.isLoggedIn
    }
  },

  methods: {
    openModal() {
      this.isModalVisible = true
      this.$emit('update:modelValue', true)
    },

    closeModal() {
      this.isModalVisible = false
      this.$emit('update:modelValue', false)
    },
    toggleSignUpForm() {
      this.showSignUpForm = !this.showSignUpForm
    },

    async login() {
      try {
        const response = await this.$authService.login(
          this.credentials.email,
          this.credentials.password
        )
        const userStore = useUserStore()
        userStore.setUser(response.user)
        this.$toast.show('Welcome back!', {
          type: 'success',
          position: 'bottom-left',
          duration: 3000,
          theme: 'bubble'
        })
        this.$router.push({ name: 'Home' })
      } catch (error) {
        this.credentials.errorMessage = error.message
      }
    },

    async signUp() {
      try {
        const options = {
          data: {
            username: this.signUpData.username,
            fullName: this.signUpData.fullName
          }
        }

        const response = await this.$authService.signUp(
          this.signUpData.email,
          this.signUpData.password,
          options // Pass the options object with the data property
        )

        console.log(`Sign up successful for ${this.signUpData.email}`)
        const userStore = useUserStore()
        userStore.setUser(response.user)
        this.$toast.show('Thanks for signing up!', {
          type: 'success',
          position: 'bottom-left',
          duration: 3000,
          theme: 'bubble'
        })
        this.$router.push({ name: 'Home' })
      } catch (error) {
        this.signUpData.errorMessage = error.message
      }
    },

    async logout() {
      try {
        await this.$authService.logout()
        const userStore = useUserStore()
        userStore.clearUser()
        this.$toast('Goodbye! Come back soon!', {
          type: 'success',
          position: 'bottom-left',
          duration: 3000
        })
        this.$router.push({ name: 'Welcome' })
      } catch (error) {
        this.credentials.errorMessage = error.message
      }
    },

    // async logout() {
    //   try {
    //     // Perform any pre-logout actions needed (like calling clearAndPersistCart)
    //     await this.clearAndPersistCart()

    //     await this.$authService.logout()
    //     const userStore = useUserStore()
    //     userStore.clearUser() // Clears user data from the store
    //     // Possibly perform other cleanup tasks here (e.g., clearing session tokens, cookies)

    //     this.closeModal() // Close the modal if it's open
    //     this.$router.push({ name: 'Welcome' }) // Redirects user to the welcome page
    //   } catch (error) {
    //     this.credentials.errorMessage = error.message
    //   }
    // },

    async signInWithGoogle() {
      try {
        // Make sure "google" is passed as the provider name
        const response = await this.$authService.loginWithProvider('google')
        const userStore = useUserStore()
        userStore.setUser(response.user)
        this.$toast.show('Welcome back!', {
          type: 'success',
          position: 'bottom-left',
          duration: 3000,
          theme: 'bubble'
        })
        this.$router.push({ name: 'Home' })
      } catch (error) {
        console.error('Login error:', error.message)
        this.credentials.errorMessage = error.message
      }
    }
  }
}
</script>

<style>
.login-modal {
  z-index: 999;
}
.btn-facebook {
  background-color: #3b5998;
  color: white;
}
.btn-google {
  background-color: #dd4b39;
  color: white;
}
.btn-twitter {
  background-color: #55acee;
  color: white;
}
.custom-size {
  padding: 1rem;
  font-size: 0.875rem;
}
</style>
