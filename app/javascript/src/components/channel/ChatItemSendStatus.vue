<template>
  <div class="text-sm">
    <span v-if="status === 'sending'">送信中</span>
    <span v-else-if="status === 'sent'">済</span>
    <span class="text-danger" v-else-if="status === 'error'">失敗</span>
  </div>
</template>

<script>
export default {
  props: {
    status: {
      type: String,
      required: true
    }
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.6rem;
  }
</style>