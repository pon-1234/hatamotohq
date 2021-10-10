<template>
  <div v-if="episode.is_initial">開始時</div>
  <div v-else>
    <span>{{ episode.date === 0 ? "開始当日" : `${episode.date}日前` }}</span>
    <span>{{ episode.time }}</span>
  </div>
</template>

<script>
export default {
  props: {
    episode: {
      type: Object,
      required: true
    }
  }
};
</script>