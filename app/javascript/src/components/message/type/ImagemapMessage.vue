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
    width: 200px;
    height: 200px;
    background: white;
    object-fit: contain;
    background-size: cover;
  }
</style>
