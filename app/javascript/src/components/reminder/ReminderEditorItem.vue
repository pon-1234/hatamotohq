<template>
  <div class="card">
    <div class="card-header">{{ cardTitle }}</div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  item: {
    type: Object,
    required: true
  }
})

const deliverAt = () => {
  let sb = ''
  if (props.item.date === 0) {
    sb += '当日'
  } else {
    sb += `${props.item.date}日前`
  }
  return sb
}

const cardTitle = computed(() => {
  if (props.item.is_initial) {
    return '開始時に配信'
  } else {
    return deliverAt()
  }
})
</script>

<style>
</style>