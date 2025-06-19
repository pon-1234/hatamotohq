<template>
  <span class="text-prewrap max-1-lines">{{
    truncatedMessage || "メッセージなし"
  }}</span>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  message: String
})

const truncatedMessage = computed(() => {
  if (!props.message) return ''
  return props.message.length > 15 ? props.message.substring(0, 15) + '...' : props.message
})
</script>
