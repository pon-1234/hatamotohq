<template>
  <div>
    <span v-if="status === 'active'"><i class="mdi mdi-circle text-primary"></i> 稼働中</span>
    <span v-else-if="status === 'cancelled'"><i class="mdi mdi-circle text-warning"></i> 停止中</span>
    <span v-else-if="status === 'done'"><i class="mdi mdi-circle text-success"></i> 完了</span>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String
  }
})
</script>