<template>
  <span v-if="client.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="client.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> 無効 </span>
</template>

<script setup>
defineProps(['client'])
</script>