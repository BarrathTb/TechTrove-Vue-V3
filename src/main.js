import { createApp } from 'vue'
import App from './App.vue'
import { supabase } from '@/utils/Supabase.js'
import 'bootstrap-icons/font/bootstrap-icons.css'
import 'bootstrap/dist/css/bootstrap.min.css'
import authService from '@/utils/AuthService.js'
import 'bootstrap'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'material-design-icons-iconfont/dist/material-design-icons.min.css'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { createVuestic } from 'vuestic-ui'
import 'vuestic-ui/css'
import './assets/Styles/_site.scss'
import './assets/main.css'
import router from './router/index.js'
import Scrollbar from './smooth-scrollbar-plugin.js'
import { createPinia } from 'pinia'
const vuestic = createVuestic({
  config: {
    colors: {
      variables: {
        // Default colors
        primary: '#23e066',
        secondary: '#002c85',
        success: '#40e583',
        info: '#2c82e0',
        danger: '#e34b4a',
        warning: '#ffc200',
        gray: '#babfc2',
        dark: '#34495e',
        white: '#ffffff',

        // Custom colors
        customPrimary: '#161616',
        customsSecondary: '#2c2c2c',
        customSuccess: '#0ee636',
        customDanger: '#f00'
      }
    }
  }
})
window.addEventListener('unhandledrejection', (event) => {
  console.warn(`UNHANDLED PROMISE REJECTION: ${event.reason}`)
})

const app = createApp(App)
app.config.globalProperties.$supabase = supabase
app.config.globalProperties.$authService = authService
app.config.globalProperties.$toast = toast
app.use(toast, {
  autoClose: 3000,
  position: 'bottom-right',
  theme: 'dark'
})
app.use(vuestic)
app.use(router)
app.use(Scrollbar)
app.use(createPinia())
app.use(ElementPlus)
app.mount('#app')
