<template>
  <span v-if="status === 'enabled'"><i class='mdi mdi-circle text-success'></i> 稼働中 </span>
  <span v-else-if="status === 'disabled'"><i class="mdi mdi-circle"></i> 停止中 </span>
</template>

<script>
export default {
  props: ['status']
};
</script>