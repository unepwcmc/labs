import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    lastUpdated: undefined
  },
  mutations: {
    updateLastUpdated (state, item) {
      state.lastUpdated = item
    }
  }
})
