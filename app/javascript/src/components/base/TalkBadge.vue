<template>
  <div>
    <span class="badge"><i class="fas fa-exclamation-circle" v-if="badge"></i></span>
  </div>
</template>
<script>

export default {
  computed: {
    badge() {
      return this.$store.getters['global/BADGE'];
    }
  },

  created() {
    this.$store.dispatch('global/getBadge');
  }
};
</script>
<style lang="scss" scoped>

</style>
