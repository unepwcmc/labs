// dependencies
import Vue from 'vue/dist/vue.esm'

// store
// import store from './store/store.js'

// components
import KpiPage from '../components/KpiPage/KpiPage.vue'

export const eventHub = new Vue()

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementById('v-app')) {
    Vue.prototype.$eventHub = new Vue()

    const app = new Vue({
      el: '#v-app',
      store,
      components: {
        KpiPage
      }
    })
  }
})