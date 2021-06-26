<template>
  <div id="app">
    <div id="header">
      <button @click="$router.push('/')">Home</button>&nbsp;
      <button @click="$router.push('/login')">Login</button>&nbsp;
      <button @click="$router.push('/register')">Register</button>
    </div>
    <p class="errorText" v-if="$store.state.error.enabled">Error: {{$store.state.error.message}}</p>
    <router-view/>
  </div>
</template>
<script>
export default {
  name: 'app',
  mounted() {
    Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
    this.axios.get('/api/v1/user_info')
        .then(res => {
          this.$store.commit('login', res.data)
        }).catch(err => {
      this.$store.commit('throwError', err)
    })
  }
}
</script>
<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
.errorText {
  color: red;
}
</style>