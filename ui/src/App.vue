<template>
  <div id="app">
    <div id="header">
      <div v-if="$store.state.user.username">
        <button @click="$router.push('/')">Home</button><br>
        <p>Hello, {{$store.state.user.username}}, you have {{$store.state.user.bookmarks.count}} bookmarks.</p>`
      </div>
      <div v-else>
        <button @click="$router.push('/')">Home</button>&nbsp;
        <button @click="$router.push('/login')">Login</button>&nbsp;
        <button @click="$router.push('/register')">Register</button>
      </div>
    </div>
    <p class="errorText" v-if="$store.state.error.enabled">{{$store.state.error.message}}</p>
    <router-view/>
  </div>
</template>
<script>
export default {
  name: 'app',
  mounted() {
    this.$store.commit('updateToken', localStorage.getItem("token"))
      Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
      this.axios.get('/api/v1/auth/user_info')
          .then(res => {
            this.$store.commit('login', res.data)
          }).catch(err => {
        this.$store.commit('throwError', err)
      })
  }
}
</script>
<style>
@import './assets/style.css';
</style>