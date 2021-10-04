<template>
  <span v-if="status === 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="status === 'blocked'"><i class="mdi mdi-circle"></i> ブロック中 </span>
</template>

<script>
export default {
  props: ['status']
};
</script>