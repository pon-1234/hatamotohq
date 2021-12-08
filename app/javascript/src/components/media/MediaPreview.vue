<template>
  <div>
    <div v-viewer="options">
      <img :src="src" class="image bg-position-center" :class="isMobile ? 'fw-140 fh-100' : 'fw-200 fh-150'">
    </div>
  </div>
</template>
<script>
import 'viewerjs/dist/viewer.css';
import Viewer from 'v-viewer';
import Vue from 'vue';
Vue.use(Viewer);

export default {
  props: {
    src: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      options: {
        toolbar: {
          zoomIn: 1,
          zoomOut: 1,
          oneToOne: 1,
          reset: 0,
          prev: 0,
          play: {
            show: 0,
            size: 'large'
          },
          next: 0,
          rotateLeft: 1,
          rotateRight: 1,
          flipHorizontal: 1,
          flipVertical: 1
        }
      }
    };
  }
};
</script>
<style lang="scss" scoped>
.bg-position-center {
  object-fit: cover;
}
</style>