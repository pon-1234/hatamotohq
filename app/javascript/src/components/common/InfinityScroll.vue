<template>
  <div class="d-flex justify-content-center fh-60" id="observer">
    <div class="spinner-border" role="status"></div>
  </div>
</template>

<script>
export default {
  props: ['options'],
  data: () => ({
    observer: null
  }),

  mounted() {
    const options = this.options || {};
    this.observer = new IntersectionObserver(([entry]) => {
      if (entry && entry.isIntersecting) {
        this.$emit('intersect');
      }
    }, options);

    this.observer.observe(this.$el);
  },
  destroyed() {
    this.observer.disconnect();
  }
};
</script>