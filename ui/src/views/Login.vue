<template>
  <div id="login" class="main-container">
    <div class="card-alt">
      <div class="card-text">
        <p>Username&nbsp;<input v-model="login.username"></p>
        <p>Password&nbsp;<input v-model="login.password"></p>
        <p data-tooltip="Logout on refresh"><input type="checkbox" v-model="login.tempLogin">Temporary Login</p>
        <button @click="doLogin">Login</button>&nbsp;<button @click="$router.push('/register')">Don't have an account?</button>
        <br><br>
      </div>
    </div>
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
            this.axios.get('/api/v1/get_user_info')
                .then(res => {
                  this.$store.commit('login', res.data)
                }).catch(err => {
              this.$store.commit('throwError', err)
            })
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