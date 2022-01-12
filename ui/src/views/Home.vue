<template>
  <div id="home" v-if="$store.state.authEnabled && $store.state.user.username || !$store.state.authEnabled">
    <div class="header">
      <div class="header-meta">
        <h1>{{$store.state.user.username}}'s Library</h1>
        <h2>You have {{books.count}} books in your library.</h2>
      </div>
      <div class="header-icons" v-if="$store.state.user.username">
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">turned_in_not</span>
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">style</span>
        <span style="cursor: pointer" @click="$router.push('/test')" class="material-icons-outlined">library_books</span>
        <span style="cursor: pointer" @click="syncLibrary()" class="material-icons-outlined">sync</span>
      </div>
    </div>
    <div class="main-container" v-if="!loading">
      <div class="card" @click="$router.push('/view/' + book.id)" v-for='(book) in onlyParsed' :key='"book-" + book.id'>
        <div class="cover-img"><img :src="book.cover"></div>
        <div class="card-text">
          <h1>{{ book.title && 38 > book.title.length ? book.title : book.title.substring(0,38)+"..."  }}</h1>
          <h2>{{book.author}}</h2>
          <h3>{{book.date | moment()}}</h3>
        </div>
      </div>
    </div>
    <div class="main-container" v-if="loading">
      <div v-if="loading">
        <div class="card-text">
          <h1>Loading...</h1>
          <h2>Please wait.</h2>
        </div>
      </div>
      <div v-if="!books.items.length && !loading">
        <div class="card-text">
          <h1>You have no books.</h1>
          <h2>Might as well add some?</h2>
        </div>
      </div>
    </div>
    <br>
  </div>
  <div v-else>
    <div class="main-container">
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
  computed: {
    onlyParsed: function() {
      return this.books.items.filter(function(u) {
        return !u.failedParse
      })
    }
  },
  filters: {
    moment: function (date) {
      return moment(date).format('YYYY');
    }
  },
  methods: {
    refreshLibrary() {
      this.loading = true
      this.axios
          .get('/api/v1/fetch_library')
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
    },
    checkLogin() {
      if(this.$store.state.authEnabled) {
        this.axios
            .get('/api/v1/get_user_info')
            .catch((e) => {
              this.$store.commit('throwError', e)
              this.$router.push('/login')
            })
      }
    }
  },
  mounted() {
    this.$store.commit('updateToken', localStorage.getItem("token"))
    Object.assign(this.axios.defaults, {headers: {Authorization: this.$store.state.user.token}})
    this.refreshLibrary()
    this.checkLogin()
  }
}
</script>