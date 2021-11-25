<template>
  <div>
    <span v-if="status === 'active'"><i class="mdi mdi-circle text-success"></i> 稼働中</span>
    <span v-else-if="status === 'cancelled'"><i class="mdi mdi-circle text-warning"></i> 停止中</span>
  </div>
</template>

<script>
export default {
  props: {
    status: {
      type: String
    }
  }
};
</script>