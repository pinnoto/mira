<template>
  <div id="login" class="main-container">
    <div class="card auth-card">
      <!--<p>Username<input v-model="login.username" class="input-box"></p>
      <p>Password<input v-model="login.password" class="input-box"></p>
      <p data-tooltip="Logout on refresh"><input type="checkbox" v-model="login.tempLogin" class="checkmark">Temporary Login</p>
      <button @click="doLogin">Login</button>&nbsp;<button @click="$router.push('/register')">Don't have an account?</button>
      <br><br>-->
      <h1>Login to Mira</h1>
      <p>Username</p><input v-model="login.username" class="input">
      <p>Password</p><input type="password" v-model="login.password" class="input">
      <a @click="doLogin" class="btn" >Sign In</a> <a @click="$router.push('/register')" class="tip">Don't have an account?</a>
    </div>
    <div class="card"></div>
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
      this.login.loading = true
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