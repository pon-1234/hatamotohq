<template>
  <div>
    <span v-if="status === 'pending'"><i class='mdi mdi-circle text-primary'></i> 配信予約</span>
    <span v-else-if="status === 'sending'"><i class='mdi mdi-circle text-info'></i> 配信中</span>
    <span v-else-if="status === 'done'"><i class='mdi mdi-circle text-success'></i> 配信済</span>
    <span v-else-if="status === 'error'"><i class='mdi mdi-circle text-danger'></i> エラー</span>
    <span v-else-if="status === 'draft'"><i class='mdi mdi-circle text-secondary'></i> 下書き</span>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String
  }
})
</script>