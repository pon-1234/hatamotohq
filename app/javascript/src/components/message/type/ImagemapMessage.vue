<template>
  <div class="chat-item">
    <img v-if="baseUrl" class="imagemap" v-lazy:background-image="baseUrl" />
  </div>
</template>
<script>
export default {
  props: ['baseUrl']
};
</script>
<style lang="scss" scoped>
  .imagemap {
    border-radius: 8px;
    max-width: 200px;
    background: white;
    object-fit: contain;
  }
</style>
