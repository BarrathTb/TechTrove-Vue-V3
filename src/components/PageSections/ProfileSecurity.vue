<template>
  <transition name="fade">
    <section v-show="securityVisible">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-12">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Security Settings
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Manage your account security settings.
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
            <div class="col-12 col-lg-7">
              <form class="form-widget mt-4" @submit.prevent="updateSecuritySettings">
                <!-- Change Password Section -->
                <h5 class="text-white mb-3">Change Password</h5>
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="currentPassword" class="text-white d-flex align-items-center"
                      ><i class="bi bi-lock-fill me-4"></i>Current Password</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="currentPassword"
                      type="password"
                      v-model="security.currentPassword"
                      class="form-control select-input"
                      placeholder="Enter current password"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="newPassword" class="text-white d-flex align-items-center"
                      ><i class="bi bi-key-fill me-4"></i>New Password</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="newPassword"
                      type="password"
                      v-model="security.newPassword"
                      class="form-control select-input"
                      placeholder="Enter new password"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-12 col-lg-4">
                    <label for="confirmPassword" class="text-white d-flex align-items-center"
                      ><i class="bi bi-key-fill me-4"></i>Confirm Password</label
                    >
                  </div>
                  <div class="col-12 col-lg-8">
                    <input
                      id="confirmPassword"
                      type="password"
                      v-model="security.confirmPassword"
                      class="form-control select-input"
                      placeholder="Confirm new password"
                    />
                  </div>
                </div>

                <!-- Two-Factor Authentication Section -->
                <h5 class="text-white mt-5 mb-3">Two-Factor Authentication (2FA)</h5>
                <div class="preference my-2">
                  <span class="preference-label text-white d-flex align-items-center"
                    >Enable 2FA</span
                  >
                  <VaSwitch v-model="security.enable2FA" color="custom-success" />
                </div>
                <p class="text-muted small mt-2">
                  Enhance your account security by enabling two-factor authentication.
                </p>

                <div>
                  <button
                    class="btn btn-success btn-sm px-4 mt-4 text-black btn-bold align-items-center justify-content-end"
                    type="submit"
                    :disabled="loading"
                  >
                    <i class="bi bi-shield-lock fs-5 me-2 text-black"></i>
                    {{ loading ? 'Saving...' : 'Save Security Settings' }}
                  </button>
                </div>
              </form>
            </div>
            <!-- Optional Offers Box -->
            <div class="col-12 col-lg-5 h-100 bg-primary ms-lg-4 mt-4">
              <div class="container-fluid ms-4">
                <div class="bg-secondary p-4 rounded-2 me-4">
                  <h3 class="text-white"><i class="bi bi-shield-check me-2"></i>Security Tips</h3>
                  <ul class="text-white small">
                    <li>Use a strong, unique password.</li>
                    <li>Enable Two-Factor Authentication.</li>
                    <li>Be cautious of phishing attempts.</li>
                    <li>Keep your software updated.</li>
                  </ul>
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
// Assuming VaSwitch is globally registered or imported as needed

export default {
  name: 'ProfileSecurity',
  props: {
    securityVisible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      loading: false,
      security: {
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
        enable2FA: false // Example state
      }
    }
  },
  computed: {
    localUser() {
      const userStore = useUserStore()
      return userStore.profile || {}
    }
  },
  methods: {
    async updateSecuritySettings() {
      this.loading = true
      console.log('Updating security settings:', this.security)
      // Add actual logic to update password and 2FA settings via API/store
      // Example: Check if newPassword matches confirmPassword
      if (this.security.newPassword !== this.security.confirmPassword) {
        alert('New passwords do not match.')
        this.loading = false
        return
      }
      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1500))
      console.log('Security settings updated (simulated).')
      this.loading = false
      // Reset password fields after submission for security
      this.security.currentPassword = ''
      this.security.newPassword = ''
      this.security.confirmPassword = ''
    }
  }
}
</script>

<style scoped>
.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 1rem; /* Added margin */
}
.preference {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  border: 1px solid #444; /* Adjusted border */
  border-radius: 8px;
  background-color: #2c2c2c;
}

.preference-label {
  font-weight: 500;
  font-size: 16px;
  color: #fff; /* Ensure label text is white */
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Responsive adjustments */
@media (max-width: 991.98px) {
  .form-widget .row .col-12.col-lg-4 label {
    margin-bottom: 0.5rem;
  }
  .col-12.col-lg-5.bg-primary {
    margin-left: 0 !important;
    margin-top: 2rem;
  }
  .container-fluid.mt-2.ms-4 {
    margin-left: 0 !important;
  }
}
</style>
