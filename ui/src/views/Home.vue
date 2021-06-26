<template>
  <div id="home" v-if="$store.state.authEnabled && $store.state.user.username || !$store.state.authEnabled">
    <h1>Books ({{books.count}})</h1>
    <button @click="syncLibrary()">Scan Library</button>&nbsp;<button @click="refreshLibrary()">Refresh Library</button>
    <br>
    <h2 v-if="loading">Loading...</h2>
    <div v-if="!loading">
      <div v-for='(book) in books.items' :key='"book-" + book.id'>
        <img :src='book.cover'>
        <br>
        <router-link :to="'/view/' + book.id">{{book.title}}</router-link>
        <br>
        Written by: {{book.author}}
      </div>
      <div v-if="!books.items.length">
        <p>There are no books in your library yet, or there was an issue scanning them.</p>
      </div>
    </div>
  </div>
  <div v-else>
    <p>(There is a better way of doing this, perhaps using a component, since there's only 1 auth required route, this is fine I guess)</p>
    <h1>You need to be authenticated to access this route</h1>
    <button @click="$router.push('/login')">Login</button>&nbsp;
    <button @click="$store.commit('setAuth', false)">Disable authentication in state</button>
  </div>
</template>

<script>
// @ is an alias to /src
export default {
  name: 'Home',
  data() {
    return {
      loading: true,
      books: {
        count: 0,
        items: []
      }
    }
  },
  methods: {
    refreshLibrary() {
      this.loading = true
      this.axios
          .get('/api/v1/get_library')
          .then((res) => {
            this.books.count = res.data.totalResults
            this.books.items = res.data.items
            this.loading = false
          })
          .catch((e) => {
            this.$store.commit('throwError', e)
            this.loading = false
          })
    },
    syncLibrary() {
      this.loading = true
      this.axios
          .get('/api/v1/scan_library')
          .then(() => {
            this.refreshLibrary()
          })
          .catch((e) => {
            this.$store.commit('throwError', e)
            this.refreshLibrary()
          })
    }
  },
  mounted() {
    this.refreshLibrary()
  }
}
</script>