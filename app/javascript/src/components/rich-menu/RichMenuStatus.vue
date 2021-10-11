<template>
  <div>
    <span v-if="status === 'enabled'"><i class="mdi mdi-circle text-primary"></i> 有効</span>
    <span v-else-if="status === 'disabled'"><i class="mdi mdi-circle"></i> 無効</span>
    <span v-else-if="status === 'error'"><i class="mdi mdi-circle text-warning"></i> エラー</span>
  </div>
</template>

<script>
export default {
  props: {
    status: {
      type: String
    }
  }
};
</script>

<style>
</style>