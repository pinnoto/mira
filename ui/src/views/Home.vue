<template>
  <div class="home">
    <h1>Books ({{books.count}})</h1>
    <button @click="syncLibrary()">Scan Library</button>&nbsp;<button @click="refreshLibrary()">Refresh Library</button>
    <br>
    <p class="errorText" v-if="error.enabled">{{error.message}}</p>
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
      },
      error: {
        enabled: false,
        message: ''
      }
    }
  },
  methods: {
    refreshLibrary() {
      this.error.enabled = false
      this.loading = true
      this.axios
          .get('/api/v1/get_library')
          .then((res) => {
            this.books.count = res.data.totalResults
            this.books.items = res.data.items
            this.loading = false
          })
          .catch((e) => {
            this.error.enabled = true
            this.error.message = e
            this.loading = false
          })
    },
    syncLibrary() {
      this.error.enabled = false
      this.loading = true
      this.axios
          .get('/api/v1/scan_library')
          .then(() => {
            this.refreshLibrary()
          })
          .catch((e) => {
            this.error.enabled = true
            this.error.message = e
            this.refreshLibrary()
          })
    }
  },
  mounted() {
    this.refreshLibrary()
  }
}
</script>

<style>
.errorText {
  color: red;
}
</style>