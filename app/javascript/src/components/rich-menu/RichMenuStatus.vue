<template>
  <div>
    <span v-if="status === 'enabled'"><i class="mdi mdi-circle text-success"></i> 有効</span>
    <span v-else-if="status === 'disabled'"><i class="mdi mdi-circle"></i> 無効</span>
    <span v-else-if="status === 'error'"><i class="mdi mdi-circle text-warning"></i> エラー</span>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String
  }
})
</script>