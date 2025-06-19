<template>
  <span class="mt-2 error-explanation">{{ message }}</span>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: ''
  }
});
</script>

<style scoped>
.error-explanation {
  color: #dc3545;
  font-size: 0.875rem;
  display: block;
}
</style>
