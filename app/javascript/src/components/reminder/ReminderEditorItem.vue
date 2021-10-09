<template>
  <div class="card">
    <div class="card-header">{{ cardTitle }}</div>
  </div>
</template>

<script>
export default {
  props: {
    item: {
      type: Object,
      required: true
    }
  },

  computed: {
    cardTitle() {
      if (this.item.is_initial) {
        return '開始時に配信';
      } else {
        return this.deliverAt();
      }
    }
  },

  methods: {
    deliverAt() {
      let sb = '';
      if (this.item.date === 0) {
        sb += '当日';
      } else {
        sb += `${this.item.date}日前`;
      }

      return sb;
    }
  }
};

</script>

<style>
</style>