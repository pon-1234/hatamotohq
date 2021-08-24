<template>
  <div class="overlay" v-if="loading">
    <i class="fas fa-3x fa-sync-alt fa-spin"></i>
  </div>
</template>
<script>
export default {
  props: ['loading'],
};
</script>
