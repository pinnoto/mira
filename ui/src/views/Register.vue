<template>
  <div id="login" class="main-container">
    <h1 style="text-align: center;margin-bottom: -75px;margin-top:50px;">Register to Mira</h1>
    <div class="card auth-card" style="height: 375px;">
      <!--<p>Username<input v-model="login.username" class="input-box"></p>
      <p>Password<input v-model="login.password" class="input-box"></p>
      <p data-tooltip="Logout on refresh"><input type="checkbox" v-model="login.tempLogin" class="checkmark">Temporary Login</p>
      <button @click="doLogin">Login</button>&nbsp;<button @click="$router.push('/register')">Don't have an account?</button>
      <br><br>-->
      <p>Username</p><input v-model="register.username" class="input">
      <p>Password</p><input type="password" v-model="register.password" class="input">
      <p>Confirm Password</p><input type="password" v-model="register.confirmPassword" class="input">
      <a @click="doRegister" class="btn" >Sign Up</a> <a @click="$router.push('/login')" class="tip">Have an account?</a>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
export default {
  name: 'Register',
  data() {
    return {
      register: {
        username: '',
        password: '',
        confirmPassword: '',
        tempLogin: false,
        // Loading would be the button/page loading
        loading: false
      }
    }
  },
  methods: {
    doRegister() {
      this.register.loading  = true
      if(this.register.confirmPassword !== this.register.password) {
        this.$store.commit('throwError', "Password does not match, registration will not continue.")
        throw Error('Password does not match, registration will not continue.')
      }
      this.axios
          .post('/api/v1/auth/register', {
            username: this.register.username,
            password: this.register.password
          })
          .then((res) => {
            this.register.loading = false
            if(res.data.token) {
              this.$store.commit('login', res.data)
              if (!this.register.tempLogin) {
                localStorage.setItem('token', res.data.token);
              }
              Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
              this.axios.get('/api/v1/user')
                  .then(res => {
                    this.$store.commit('login', res.data)
                  }).catch(err => {
                this.$store.commit('throwError', err)
              })
              this.$router.push('/')
            } else {
              this.$store.commit('throwError', "Token wasn't in the response body.")
            }
          })
          .catch((e) => {
            this.register.loading = false
            if (!e.body.error) {
              this.$store.commit('throwError', e)
            } else {
              this.$store.commit('throwError', e.body.error)
            }
          })
    }
  }
}
</script>

<style scoped>

</style>