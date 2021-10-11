<template>
  <span class="text-prewrap max-1-lines">{{
    truncatedMessage || "メッセージなし"
  }}</span>
</template>

<script>
export default {
  props: {
    message: String
  },

  computed: {
    truncatedMessage() {
      return _.truncate(
        this.message, {
          length: 15
        }
      );
    }
  }
};
</script>
