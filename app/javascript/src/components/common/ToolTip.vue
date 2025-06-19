<template>
  <div v-tooltip="title" class="ml-1">
    <i class="mdi mdi-information-outline icon"></i>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  }
});
</script>

<style lang="scss" scoped>
  .icon {
    font-size: 1.2rem;
  }
</style>