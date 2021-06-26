<template>
  <div class="login">
    <p>Username&nbsp;<input v-model="register.username"></p>
    <p>Password&nbsp;<input v-model="register.password"></p>
    <p>Confirm Password&nbsp;<input v-model="register.confirmPassword"></p>
    <p>Temporary Login (will logout on refresh)<input type="checkbox" v-model="register.tempLogin"></p>
    <button @click="doRegister">Register</button>
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
          .post('/api/v1/register', {
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