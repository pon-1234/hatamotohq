<template>
  <span v-if="'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロック中 </span>
</template>

<script>
export default {
  props: ['status']
};
</script>