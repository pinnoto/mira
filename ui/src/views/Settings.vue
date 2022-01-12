<template>
  <div>
    <input v-model="customization.bg" name="Background Color">
    <input v-model="customization.fg" name="Foreground Color">
    <input v-model="customization.a" name="Link Color">
    <button @click="save">Save</button>
    <button @click="$router.push('/read/1')">Read Test</button>
  </div>
</template>

<script>
export default {
  name: "Settings",
  data() {
    return {
      customization: {
        bg: this.$store.state.user.bg,
        fg: this.$store.state.user.fg,
        a: this.$store.state.user.a
      }
    }
  },
  methods: {
    save() {
      this.$store.commit("saveCustomization", this.customization);
    }
  }
}
</script>

<style scoped>

</style>