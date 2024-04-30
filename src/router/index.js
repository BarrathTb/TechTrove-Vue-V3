import { createRouter, createWebHistory } from 'vue-router'
import WelcomePage from '@/pages/WelcomePage.vue'
import HomePage from '@/pages/HomePage.vue'
import NewsPage from '@/pages/NewsPage.vue'
import ProfilePage from '@/pages/ProfilePage.vue'
import { supabase } from '@/utils/Supabase'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Welcome',
      component: WelcomePage
    },
    {
      path: '/home',
      name: 'Home',
      component: HomePage
    },
    {
      path: '/profile',
      name: 'Profile',
      component: ProfilePage,
      meta: { requiresAuth: true }
    },
    {
      path: '/news',
      name: 'News',
      component: NewsPage
    }
    // ... other routes
  ]
})

// This helper function checks if the user is authenticated.
async function isAuthenticated() {
  const {
    data: { session },
    error
  } = await supabase.auth.getSession()
  if (error) {
    console.error('Error getting session:', error)
  }
  return session
}

router.beforeEach(async (to, _, next) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth)

  if (requiresAuth) {
    const userSession = await isAuthenticated()

    if (!userSession) {
      // If there's no session, redirect to the welcome page.
      next({ name: 'Welcome' })
    } else {
      // If there is a session, proceed to the requested route.
      next()
    }
  } else {
    // If authentication is not required for the route, just proceed.
    next()
  }
})

export default router
