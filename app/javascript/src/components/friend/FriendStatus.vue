<template>
  <span v-if="locked"><i class="mdi mdi-circle text-warning"></i> 自分からブロック</span>
  <span v-else-if="!visible"><i class="mdi mdi-circle"></i> 非表示</span>
  <span v-else-if="status === 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
  <span v-else-if="status === 'blocked'"><i class="mdi mdi-circle"></i> 友達からブロック </span>
</template>

<script>
export default {
  props: ['status', 'locked', 'visible']
};
</script>