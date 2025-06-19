<template>
  <div class="overlay" v-if="loading">
    <BaseSpinner variant="primary" />
  </div>
</template>

<script setup>
import BaseSpinner from '../base/BaseSpinner.vue';

defineProps({
  loading: {
    type: Boolean,
    default: false
  }
});
</script>

<style lang="scss" scoped>
.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 50;
  border-radius: 0.25rem;
}

.card .overlay, 
.info-box .overlay, 
.overlay-wrapper .overlay, 
.small-box .overlay {
  border-radius: 0.25rem;
}
</style>