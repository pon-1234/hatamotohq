<template>
  <span>{{ messageText }}</span>
</template>

<script>
export default {
  props: {
    message: String
  },
  computed: {
    messageText: function() {
      const messageJson = JSON.parse(this.message);
      return messageJson.text;
    }
  }
};
</script>

<style>

</style>