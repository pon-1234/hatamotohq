<template>
  <div class="overlay" v-if="loading">
    <div class="spinner-border text-primary" role="status"></div>
  </div>
</template>
<script>
export default {
  props: ['loading']
};
</script>

<style lang="scss" scoped>
.card .overlay, .info-box .overlay, .overlay-wrapper .overlay, .small-box .overlay {
  border-radius: .25rem;
  -webkit-align-items: center;
  -ms-flex-align: center;
  align-items: center;
  background-color: rgba(255,255,255,.7);
  display: -webkit-flex;
  display: -ms-flexbox;
  display: flex;
  -webkit-justify-content: center;
  -ms-flex-pack: center;
  justify-content: center;
  z-index: 50;
}

.card>.loading-img, .card>.overlay, .info-box>.loading-img, .info-box>.overlay, .overlay-wrapper>.loading-img, .overlay-wrapper>.overlay, .small-box>.loading-img, .small-box>.overlay {
  height: 100%;
  left: 0;
  position: absolute;
  top: 0;
  width: 100%;
}
</style>