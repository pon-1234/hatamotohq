<template>
  <div>
    <span v-if="status === 'active'" class="badge badge-pill badge-success pt-1">
      正常
    </span>
    <span v-else-if="status === 'blocked'" class="badge badge-pill badge-warning pt-1">
      友達からブロック
    </span>
  </div>
</template>

<script>
export default {
  props: ['status']
};
</script>