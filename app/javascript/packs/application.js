// dependencies
import Vue from 'vue/dist/vue.esm'

// store
import store from '../store/store.js'

// components
import ChartDoughnut from '../components/charts/ChartDoughnut.vue'
import KpiPage from '../components/pages/KpiPage.vue'

document.addEventListener('DOMContentLoaded', () => {
  if(document.getElementById('v-app')) {
    Vue.prototype.$eventHub = new Vue()

    new Vue({
      el: '#v-app',
      store,
      components: {
        ChartDoughnut,
        KpiPage
      }
    })
  }
})