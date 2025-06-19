<template>
  <span v-if="user.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="user.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロックした </span>
</template>

<script setup>
defineProps({
  user: {
    type: Object,
    required: true
  }
})
</script>