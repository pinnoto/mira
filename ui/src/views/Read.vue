<template>
  <div id="view">
    <div class="header main-container">
      <div class="header-icons noSelect">
        <span style="cursor: pointer" @click="prevPage" class="material-icons-outlined">arrow_backward</span>
        <span style="cursor: pointer" @click="nextPage" class="material-icons-outlined">arrow_forward</span>
      </div>
    </div>
    <div class="epub-container">
      <div id="book-area" style="background: #ffffff;"></div>
    </div>
    <slot name="progress-bar" :onChange="onChange" :ready="ready">
      <center>
        <input type="range" max="100" min="0" step="1"
               @change="onChange($event.target.value)"
               :value="progressValue"
        /><input type="number" :value="progressValue" @change="onChange($event.target.value)">%
      </center>
    </slot>
  </div>
</template>
<script>
import ePub from 'epubjs'

export default {
  name: 'View',
  data() {
    return {
      ready: false,
      progress: 0,
      fontSize: 100,
      contentBookModify: 0,
      book: null,
      rendition: null,
      section: null,
      toc: [],
      progressValue: 0,
      slide: null,
      cfi: null,
      width: 600,
      height: 1000,
      locations: null,
    }
  },
  methods: {
    nextPage() {
      this.rendition.next()
    },
    prevPage() {
      this.rendition.prev()
    },
    onChange (value) {
      const percentage = value / 100
      const target = percentage > 0 ? this.book.locations.cfiFromPercentage(percentage) : 0
      this.rendition.display(target)
      if (percentage === 1) this.nextPage()
    },
    screenSize() {
      this.width = Math.max(document.documentElement.clientWidth, window.innerWidth || 0)
      this.height = Math.max(document.documentElement.clientHeight, window.innerHeight || 0) - this.contentBookModify
    },
    keyListener (e) {
      if ((e.keyCode || e.which) === 37) {
        this.rendition.prev()
      }
      if ((e.keyCode || e.which) === 39) {
        this.rendition.next()
      }
    },
    initReader() {
      this.rendition = this.book.renderTo("book-area", {
        contained: true,
        height: this.height
      })
      this.screenSize()
      this.rendition.display()
    }
  },
  mounted() {
    window.addEventListener('keyup', this.keyListener)
    this.book = ePub("/epub2.epub")
    this.book.loaded.navigation.then(({ toc }) => {
      this.toc = toc
      this.$emit('toc', this.toc)
      this.initReader()
      this.rendition.on('click', () => {
        this.$emit('click')
      })
    })
    this.book.ready.then(() => {
      return this.book.locations.generate(160)
    }).then(() => {
      this.locations = JSON.parse(this.book.locations.save())
      this.ready = true
      this.$emit('ready')
      this.rendition.on('relocated', (location) => {
        const percent = this.book.locations.percentageFromCfi(location.start.cfi)
        this.progressValue = Math.floor(percent * 100)
        this.$emit('relocated')
      })
    })
  },
  watch: {
    progressValue (val) {
      this.$emit('update:progress', val)
    }
  },
  beforeDestroy () {
    window.removeEventListener('keyup', this.keyListener)
  }
}
</script>