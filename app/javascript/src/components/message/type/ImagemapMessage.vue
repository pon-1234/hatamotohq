<template>
  <div class="chat-item">
    <img
    v-if="data"
      :src="getUrl()"
      class="imagemap"
    />
  </div>
</template>
<script>
export default {
  props: ['data'],
  methods: {
    getUrl() {
      return this.data ? this.data : process.env.MIX_MEDIA_FLEXA_URL + '/imagemap_default/700';
    }
  }
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
