<template>
  <div>
    <span v-if="status === 'enabled'"><i class="mdi mdi-circle text-success"></i> 稼働中</span>
    <span v-else-if="status === 'disabled'"><i class="mdi mdi-circle text-warning"></i> 停止中</span>
    <span v-else-if="status === 'draft'"><i class="mdi mdi-circle text-secondary"></i> 下書き</span>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String
  }
})
</script>