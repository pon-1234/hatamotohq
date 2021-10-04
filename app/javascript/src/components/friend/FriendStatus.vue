<template>
  <span v-if="lineFriend.status == 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="lineFriend.status == 'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロック中 </span>
</template>

<script>
export default {
  props: ['lineFriend']
};
</script>