<template>
  <span v-if="user.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="user.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロック中 </span>
</template>

<script>
export default {
  props: ['user']
};
</script>