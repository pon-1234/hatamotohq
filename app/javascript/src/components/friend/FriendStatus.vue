<template>
  <div>
    <span v-if="status === 'active'" class="badge badge-success">
      正常
    </span>
    <span v-else-if="status === 'block'" class="badge badge-warning">
      友達からブロック
    </span>
  </div>
</template>

<script>
export default {
  props: ['status']
}
</script>

<style>

</style>