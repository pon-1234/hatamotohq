<template>
  <a href='#' v-bind:class='getClass()' @click='selectPackageId'>
    <img
      v-if='data.packageId'
      :src="'https://stickershop.line-scdn.net/stickershop/v1/product/'+ data.packageId+'/ANDROID/tab_on.png'"
    />
    <i v-bind:class='data.icon' v-if='data.icon'></i>
  </a>
</template>

<script>
export default {
  props: ['data'],
  methods: {
    selectPackageId() {
      this.$emit('input', this.data.packageId);
    },
    getClass() {
      let className = 'sticker-nav';
      if (this.data.active) {
        className += ' active';
      }
      if (this.data.animation) {
        className += ' sticker-nav-animation';
      }

      return className;
    }
  }
};
</script>
