<template>
  <div v-if="episode.is_initial">開始時</div>
  <div v-else>
    <span>{{ episode.date === 0 ? "当日" : `${episode.date}日前` }}</span>
    <span>{{ episode.time }}</span>
  </div>
</template>

<script setup>
defineProps({
  episode: {
    type: Object,
    required: true
  }
})
</script>