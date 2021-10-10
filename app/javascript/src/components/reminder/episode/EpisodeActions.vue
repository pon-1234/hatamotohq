<template>
  <div>{{ actions }}</div>
</template>

<script>
export default {
  props: {
    episode: {
      type: Object,
      required: true
    }
  },

  computed: {
    actions() {
      return this.episode.actions;
    }
  }
};
</script>

<style>
</style>