import { defineStore } from 'pinia'
import Profile from '@/models/Profile'

export const useUserStore = defineStore({
  id: 'user',
  persist: true,
  state: () => ({
    user: null,
    profile: null,
    session: null,
    loading: false
  }),
  actions: {
    async fetchProfile() {
      this.loading = true
      try {
        if (!this.session || !this.session.user) {
          throw new Error('Session or user information is unavailable.')
        }

        const profile = await Profile.fetchUser(this.session.user.id)
        this.profile = profile // Set the fetched profile into the store's state
      } catch (error) {
        console.error(error.message)
      } finally {
        this.loading = false
      }
    },
    setUser(userInfo) {
      this.user = userInfo
    },

    clearUser() {
      this.user = null
      this.session = null
    },

    // Optionally, handle session here
    setSession(sessionInfo) {
      this.session = sessionInfo
    },
    updateAvatar(avatarUrl) {
      if (this.user) {
        this.user.avatar_url = avatarUrl
      }
    },
    getUser() {
      return this.user
    }
  },

  // Getters
  getters: {
    isLoggedIn(state) {
      return state.session !== null // Use session to determine if the user is logged in
    }
  }
})
