<template>
  <div class="d-flex justify-content-center fh-60" ref="observerTarget">
    <BaseSpinner />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import BaseSpinner from '../base/BaseSpinner.vue';

// Props
const props = defineProps({
  options: {
    type: Object,
    default: () => ({})
  }
});

// Emits
const emit = defineEmits(['intersect']);

// Refs
const observerTarget = ref(null);
let observer = null;

// Lifecycle
onMounted(() => {
  observer = new IntersectionObserver(([entry]) => {
    if (entry && entry.isIntersecting) {
      emit('intersect');
    }
  }, props.options);

  if (observerTarget.value) {
    observer.observe(observerTarget.value);
  }
});

onUnmounted(() => {
  if (observer) {
    observer.disconnect();
  }
});
</script>

<style scoped>
.fh-60 {
  min-height: 60px;
}
</style>