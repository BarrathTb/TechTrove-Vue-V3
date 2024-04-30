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
              <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>
              <form @submit.prevent="login">
                <div class="form-group p-2">
                  <label for="username">Username or Email</label>
                  <input
                    v-model="credentials.email"
                    type="text"
                    class="form-control text-light bg-primary login-input"
                    id="username"
                    placeholder="Enter username or email"
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
            </div>

            <div class="modal-footer bg-primary p-2 mx-auto">
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
                      @click="signUp"
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
export default {
  name: 'LoginModal',

  data() {
    return {
      isModalVisible: false,
      credentials: {
        email: '',
        password: '',
        rememberMe: false,
        errorMessage: ''
      }
    }
  },
  computed: {
    isLoggedIn() {
      return this.$authService.isLoggedIn()
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

    async login() {
      try {
        await this.$authService.login(this.credentials.email, this.credentials.password)
        console.log(this.credentials.email)
        this.$router.push({ name: 'Home' })
      } catch (error) {
        // Update local data property to show error message in template
        this.credentials.errorMessage = error.message
      }
    },

    async signUp() {
      try {
        await this.$authService.signUp(this.credentials.email, this.credentials.password)
        console.log(this.credentials.email)
        this.$router.push({ name: 'Home' })
      } catch (error) {
        // Update local data property to show error message in template
        this.credentials.errorMessage = error.message
      }
    },

    async logout() {
      try {
        await this.$authService.logout()
        this.$router.push({ name: 'Welcome' })
      } catch (error) {
        // Update local data property to show error message in template
        this.credentials.errorMessage = error.message
      }
    },

    async signInWithGoogle() {
      try {
        await this.$authService.loginWithProvider('google')
        this.closeModal()
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
</style>
