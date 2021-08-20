<template>
  <div>
    <span v-if="status === 'active'" class="status complete">
      正常
    </span>
    <span v-else-if="status === 'block'" class="status draft">
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