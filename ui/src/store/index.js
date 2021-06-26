import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: {
      id: '',
      username: '',
      token: '',
      isAuthenticated: false,
      bookmarks: []
    },
    error: {
      message: '',
      enabled: false
    },
    authEnabled: true
  },
  mutations: {
    login(state, data) {
      state.user.token = data.token
      state.user.username = data.username
      state.user.isAuthenticated = true
    },
    logout(state) {
      state.user.token = ''
      state.user.username = ''
      state.user.isAuthenticated = false
    },
    updateToken(state, data) {
      state.user.token = data
    },
    throwError(state, data) {
      state.error.message = data
      state.error.enabled = true
    },
    dismissError(state) {
      state.enabled = false
    },
    setAuth(state, data) {
      state.authEnabled = data
    }
  },
  actions: {
  },
  modules: {
  }
})
