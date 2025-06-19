<template>
  <div>
    <span v-if="status === 'wait'"><i class="mdi mdi-circle text-info"></i> 空室待ち </span>
    <span v-else-if="status === 'cancelled'"><i class="mdi mdi-circle"></i> キャンセル済 </span>
    <span v-else> <i class="mdi mdi-circle text-success"></i> 完了</span>
  </div>
</template>

<script setup>
defineProps(['status'])
</script>