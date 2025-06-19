<template>
  <div class="d-flex">
    <div class="mx-auto mxw-300 p-1 text-center message">
      <div>{{ readableTime }}</div>
      <div>{{ message.text }}</div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import Util from '@/core/util'

const props = defineProps({
  message: {
    type: Object,
    required: true
  }
})

const readableTime = computed(() => {
  return Util.formattedTime(props.message.timestamp)
})
</script>

<style lang="scss" scoped>
  .message {
    font-size: 0.7rem !important;
    border-radius: 5px;
    background-color: #dfdfdf;
  }
</style>