<template>
  <transition name="fade">
    <section v-show="achievmentsVisible">
      <div class="container-fluid">
        <div class="row">
          <div class="col-3">
            <h3 class="text-white text-center align-items-center">Achievments</h3>

            <Avatar v-if="src" :src="src" alt="Avatar" :size="size + 'em'" />
            <div
              v-else
              class="avatar no-image"
              :style="{ height: size + 'em', width: size + 'em' }"
            ></div>

            <div class="row">
              <h1 for="username" class="text-light-bold text-center align-items-center">
                <i class="bi bi-star-fill me-4"></i>874
              </h1>
            </div>

            <p class="text-light-bold text-center">Total Points</p>
          </div>

          <div class="col-5 me-4">
            <div class="container-fluid mt-2">
              <div class="bg-secondary p-4 rounded-4 me-4">
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
                  <div class="col-3">
                    <div
                      class="bg-secondary align-items-center justify-content-center p-4 rounded-4"
                    >
                      <VaAvatar
                        size="large"
                        position="center"
                        class="centeralign-items-center justify-content-center"
                        src="images/badge1.png"
                      />
                    </div>
                  </div>
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge2.png"
                      />
                    </div>
                  </div>
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge3.png"
                      />
                    </div>
                  </div>
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge4.png"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="container-fluid mt-2 ms-4">
              <div class="bg-secondary p-4 rounded-4">
                <h5 class="text-light-bold p-4">
                  Discover How to Earn Badges and Unlock Amazing Rewards and Discounts.
                </h5>
                <div class="row">
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge2.png"
                      />
                    </div>
                  </div>
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge3.png"
                      />
                    </div>
                  </div>
                  <div class="col-3">
                    <div class="bg-secondary p-4 rounded-4 me-4">
                      <VaAvatar
                        class="ms-2 align-items-center justify-content-center"
                        src="images/badge4.png"
                      />
                    </div>
                  </div>
                </div>
                <button
                  class="btn btn-success btn-sm px-4 mt-4 text-black btn-bold align-items-center justify-content-center"
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
                  <div class="col-md-9 col-6">
                    <!-- Adjusted the column sizes here -->
                    <h4 class="text-white">Achievement Stats</h4>
                  </div>
                  <div class="col-md-3 col-6 d-flex justify-content-end">
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
                      <!-- <LuzmoDashboard
                        mainColor="#000000"
                        accent-color="#000000"
                        class="mt-4 rounded-4 bg-secondary"
                      /> -->
                      <img width="100%" src="/images/stats.png" class="" alt="display tech image" />
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
import { supabase } from '@/utils/Supabase'
// import { LuzmoDashboard } from '@luzmo/vue-embed'
import Avatar from '@/components/PageSections/ProfileAvatar.vue'

export default {
  props: ['session'],
  components: {
    Avatar
    // LuzmoDashboard
  },
  computed: {
    user() {
      return this.session.user
    }
  },
  emits: ['update'],
  data() {
    return {
      loading: true,
      username: '',
      website: '',
      avatar_url: '',
      isModalVisible: false,
      achievmentsVisible: false
    }
  },
  created() {
    console.log(this.session)
    this.getProfile()
  },
  methods: {
    async getProfile() {
      if (!this.session || !this.session.user) {
        console.error('Invalid session object:', this.session)
        return
      }
      try {
        this.loading = true
        const { user } = this.session

        const { data, error, status } = await supabase
          .from('profiles')
          .select(`username, website, avatar_url`)
          .eq('id', user.id)
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
        // Get the current session directly from supabase.auth
        const session = supabase.auth.session

        if (!session || !session.user) {
          throw new Error('User not authenticated')
        }

        const updates = {
          id: session.user.id,
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
