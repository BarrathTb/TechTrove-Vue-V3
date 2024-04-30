<template>
  <transition name="fade">
    <section v-show="detailsVisible">
      <div class="container-fluid">
        <div class="row bg-primary">
          <div class="col-4">
            <h4 class="text-white ms-4 align-items-center justify-content-start">
              Personal Details
            </h4>
            <p class="text-white ms-4 align-items-center justify-content-start">
              Edit your personal details here.
            </p>

            <VaAvatar v-if="src" :src="src" alt="Avatar" :size="size + 'em'" />
            <div
              v-else
              class="avatar no-image"
              :style="{ height: size + 'em', width: size + 'em' }"
            ></div>
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
                      v-model="username"
                      class="form-control"
                      placeholder="John Doe"
                    />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Location</label
                    >
                  </div>
                  <div class="col-8">
                    <input type="text" class="form-control" placeholder="e.g. Sydney, Australia" />
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
                      class="form-control"
                      placeholder="johndoe@example.com"
                      id="email"
                      :value="email"
                      disabled
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
                    <input type="date" class="form-control" />
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Shipping Address</label
                    >
                  </div>
                  <div class="col-8">
                    <textarea class="form-control" placeholder="123 Main St, Anytown AU"></textarea>
                  </div>
                </div>
                <div class="row mt-4">
                  <div class="col-4">
                    <label class="text-white d-flex align-items-center"
                      ><i class="bi bi-pencil-fill me-4"></i>Profile Avatar</label
                    >
                  </div>
                  <div class="col-8">
                    <Avatar v-model="avatar_url" @upload="updateProfile" size="10" />
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
import { supabase } from '@/utils/Supabase'

import Avatar from '@/components/PageSections/ProfileAvatar.vue'

export default {
  props: ['session'],
  components: {
    Avatar
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
      detailsVisible: true
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
