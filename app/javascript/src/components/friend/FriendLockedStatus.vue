<template>
  <div>
    <span v-if="!locked" class="badge badge-pill badge-success pt-1">
      正常
    </span>
    <span v-else-if="locked" class="badge badge-pill badge-warning pt-1">
      ブロック中
    </span>
  </div>
</template>
<script>
export default {
  props: ['status']
};
</script>