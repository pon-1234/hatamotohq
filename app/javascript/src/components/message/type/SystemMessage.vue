<template>
  <div class="d-flex">
    <div class="mx-auto mxw-300 p-1 text-center message">
      <div>{{ readableTime }}</div>
      <div>{{ message.text }}</div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
export default {
  props: {
    message: {
      type: Object,
      required: true
    }
  },

  computed: {
    readableTime() {
      return moment(parseInt(this.message.timestamp)).format('HH:mm');
    }
  }
};
</script>

<style lang="scss" scoped>
  .message {
    font-size: 0.7rem !important;
    border-radius: 5px;
    background-color: #dfdfdf;
  }
</style>