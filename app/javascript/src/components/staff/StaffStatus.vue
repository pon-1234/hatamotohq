<template>
  <span v-if="staff.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="staff.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> 無効 </span>
</template>

<script>
export default {
  props: ['staff']
};
</script>