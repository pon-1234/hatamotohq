<template>
  <span v-if="account.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="account.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロックした </span>
</template>

<script>
export default {
  props: ['account']
};
</script>