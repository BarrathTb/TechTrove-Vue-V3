<template>
  <transition name="fade">
    <section v-show="notificationsVisible">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-12">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Notification Settings
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Manage how you receive notifications from us.
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
              <h5 class="text-white mb-3 mt-4">Notification Channels</h5>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-envelope-fill me-3"></i>Email Notifications</span
                >
                <VaSwitch v-model="notifications.email" color="custom-success" />
              </div>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-phone-fill me-3"></i>SMS Notifications</span
                >
                <VaSwitch v-model="notifications.sms" color="custom-success" />
              </div>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-app-indicator me-3"></i>Push Notifications</span
                >
                <VaSwitch v-model="notifications.push" color="custom-success" />
              </div>

              <h5 class="text-white mb-3 mt-5">Notification Types</h5>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-tag-fill me-3"></i>Promotions & Offers</span
                >
                <VaSwitch v-model="notifications.promotions" color="custom-success" />
              </div>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-box-seam-fill me-3"></i>Order Updates</span
                >
                <VaSwitch v-model="notifications.orderUpdates" color="custom-success" />
              </div>
              <div class="preference my-2">
                <span class="preference-label text-white d-flex align-items-center"
                  ><i class="bi bi-newspaper me-3"></i>News & Announcements</span
                >
                <VaSwitch v-model="notifications.news" color="custom-success" />
              </div>

              <div>
                <button
                  class="btn btn-success btn-sm px-4 mt-4 text-black btn-bold align-items-center justify-content-end"
                  @click="saveNotificationSettings"
                  :disabled="loading"
                >
                  <i class="bi bi-check-circle-fill fs-5 me-2 text-black"></i>
                  {{ loading ? 'Saving...' : 'Save Settings' }}
                </button>
              </div>
            </div>
            <!-- Optional Offers Box -->
            <div class="col-12 col-lg-5 h-100 bg-primary ms-lg-4 mt-4">
              <div class="container-fluid ms-4">
                <div class="bg-secondary p-4 rounded-2 me-4">
                  <h3 class="text-white">
                    <i class="bi bi-info-circle-fill me-2"></i>Stay Informed
                  </h3>
                  <p class="text-white small">
                    Choose how you want to stay updated. You can adjust these settings anytime. We
                    recommend enabling order updates to track your purchases.
                  </p>
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
  name: 'ProfileNotifications',
  props: {
    notificationsVisible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      defaultAvatarUrl: 'https://avatarfiles.alphacoders.com/367/367929.jpg',
      loading: false,
      notifications: {
        // Example state
        email: true,
        sms: false,
        push: true,
        promotions: true,
        orderUpdates: true,
        news: false
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
    async saveNotificationSettings() {
      this.loading = true
      console.log('Saving notification settings:', this.notifications)
      // Add actual logic to save settings via API/store
      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1000))
      console.log('Notification settings saved (simulated).')
      this.loading = false
      // Optionally show a success message
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
  margin-bottom: 1rem;
}
.preference {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px;
  border: 1px solid #444;
  border-radius: 8px;
  background-color: #2c2c2c;
}
.preference-label {
  font-weight: 500;
  font-size: 16px;
  color: #fff;
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
  .col-12.col-lg-5.bg-primary {
    margin-left: 0 !important;
    margin-top: 2rem;
  }
  .container-fluid.my-2.mt-2.ms-4 {
    margin-left: 0 !important;
  }
}
</style>
