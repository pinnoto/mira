import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: {
      bg: "#1c1d1f",
      fg: "#dfdfdf",
      a: "#f8f8f8",
      id: 1,
      username: 'Troplo',
      token: localStorage.getItem("token"),
      isAuthenticated: true,
      bookmarks: [],
      books: {
        count: 0,
        items: []
      }
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
    },
    saveCustomization(state, data) {
      state.user.a = data.a
      state.user.bg = data.bg
      state.user.fg = data.fg
    }
  },
  actions: {
  },
  modules: {
  }
})
