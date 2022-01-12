<template>
  <div id="app">
    <center>
    <p class="errorText" v-if="$store.state.error.enabled">{{$store.state.error.message}}</p>
    </center>
    <router-view/>
  </div>
</template>
<script>
export default {
  name: 'app',
  mounted() {
    this.$store.commit('updateToken', localStorage.getItem("token"))
      Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
      this.axios.get('/api/v1/get_user_info')
          .then(res => {
            this.$store.commit('login', res.data)
          }).catch(err => {
        this.$store.commit('throwError', err)
      })
  }
}
</script>