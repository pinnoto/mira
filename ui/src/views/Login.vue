<template>
  <div class="login">
    <p>Username&nbsp;<input v-model="login.username"></p>
    <p>Password&nbsp;<input v-model="login.password"></p>
    <p>Temporary Login (will logout on refresh)<input type="checkbox" v-model="login.tempLogin"></p>
    <button @click="doLogin">Login</button>&nbsp;<button @click="$router.push('/register')">Don't have an account?</button>
  </div>
</template>

<script>
// @ is an alias to /src
export default {
  name: 'Login',
  data() {
    return {
      login: {
        username: '',
        password: '',
        tempLogin: false,
        // Loading would be the button/page loading
        loading: false
      }
    }
  },
  methods: {
    doLogin() {
      this.login.loading  = true
      this.axios
          .post('/api/v1/login', {
            username: this.login.username,
            password: this.login.password
          })
          .then((res) => {
            this.login.loading = false
            this.$store.commit('login', res.data)
            if(!this.login.tempLogin) {
              localStorage.setItem('token', res.data.token);
            }
            Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
            this.$router.push('/')
          })
          .catch((e) => {
            this.login.loading = false
            this.$store.commit('throwError', e)
          })
    }
  }
}
</script>

<style scoped>

</style>