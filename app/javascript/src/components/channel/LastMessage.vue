<template>
  <span>{{ message || 'メッセージなし' }}</span>
</template>

<script>
export default {
  props: {
    message: String
  }
};
</script>

<style>

</style>