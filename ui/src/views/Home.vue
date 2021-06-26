<template>
  <div id="home" v-if="$store.state.authEnabled && $store.state.user.username || !$store.state.authEnabled">
    <div class="header">
      <div class="header-meta">
        <h1>{{$store.state.user.username}}'s Library</h1>
        <h2>You have {{books.count}} books in your library.</h2>
        <button @click="syncLibrary()">Scan Library</button>&nbsp;<button @click="refreshLibrary()">Refresh Library</button>
      </div>
      <div class="header-icons">
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">turned_in_not</span>
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">style</span>
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">library_books</span>
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">manage_accounts</span>
      </div>
    </div>
    <div class="main-container">
      <div class="card" v-for='(book) in books.items' :key='"book-" + book.id'>
        <div class="cover-img"><img :src="book.cover"></div>
        <div class="card-text">
          <h1>{{book.title}}</h1>
          <h2>{{book.author}}</h2>
          <h3>{{book.date | moment}}</h3>
        </div>
      </div>
      <div v-if="!books.items">
        <div class="card-text">
          <h1>You have no books</h1>
          <h2>Might as well add some?</h2>
        </div>
      </div>
    </div>
    <br>
    <h2 v-if="loading">Loading...</h2>
  </div>
  <div v-else>
    <div class="main-container">
      <p>(There is a better way of doing this, perhaps using a component, since there's only 1 auth required route, this is fine I guess)</p>
      <h1>You need to be authenticated to access this route.</h1><br>
      <button @click="$router.push('/login')">Login</button>&nbsp;
      <button @click="$store.commit('setAuth', false)">Disable authentication in state</button>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from 'moment'
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
  filters: {
    moment: function (date) {
      return moment(date).format('MMMM Do YYYY, h:mm:ss a');
    }
  },
  methods: {
    refreshLibrary() {
      this.loading = true
      this.axios
          .get('/api/v1/auth/fetch_library')
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
          .get('/api/v1/auth/scan_library')
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
    this.$store.commit('updateToken', localStorage.getItem("token"))
    Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
    this.refreshLibrary()
  }
}
</script>