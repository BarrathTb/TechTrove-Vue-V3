import { createApp } from 'vue'
import App from './App.vue'

import '@quasar/extras/animate/fadeIn.css'
import '@quasar/extras/animate/fadeOut.css'
import '@quasar/extras/roboto-font/roboto-font.css'
import '@quasar/extras/themify/themify.css'
import 'bootstrap-icons/font/bootstrap-icons.css'
import 'bootstrap/dist/css/bootstrap.min.css'

import 'bootstrap'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'material-design-icons-iconfont/dist/material-design-icons.min.css'
import { Quasar } from 'quasar'
import { createVuestic } from 'vuestic-ui'
import 'vuestic-ui/css'
import './assets/Styles/_site.scss'
import './assets/main.css'
import router from './router/index.js'
import Scrollbar from './smooth-scrollbar-plugin.js'

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

const app = createApp(App)
app.use(Quasar, {
  plugins: {},
  config: {
    brand: {
      primary: '#23e066',
      secondary: '#002c85',
      positive: '#40e583',
      info: '#2c82e0',
      negative: '#e34b4a',
      warning: '#ffc200',
      gray: '#babfc2',
      dark: '#34495e',

      // Custom colors
      customPrimary: '#161616',
      customsSecondary: '#2c2c2c',
      customSuccess: '#0ee636',
      customDanger: '#f00'
    }
  }
})
app.use(vuestic)
app.use(router)
app.use(Scrollbar)
app.use(ElementPlus)
app.mount('#app')
