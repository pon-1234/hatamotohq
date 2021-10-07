<template>
  <div>
    <span v-if="locked"><i class="mdi mdi-circle text-danger"></i> ブロックした</span>
    <span v-else-if="status === 'active'"><i class="mdi mdi-circle text-success"></i> 有効 </span>
    <span v-else-if="status === 'blocked'"><i class="mdi mdi-circle text-warning"></i> ブロックされた </span>
    <span v-if="!visible"> <i class="mdi mdi-circle"></i> 非表示</span>
  </div>
</template>

<script>
export default {
  props: ['status', 'locked', 'visible']
};
</script>