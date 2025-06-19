<template>
  <div v-if="actions.length > 0">
    <div v-for="(action, index) in actions" :key="index" class="badge badge-warning pt-1 mr-1">
      <span v-if="action.type === 'text'">テキスト送信</span>
      <span v-else-if="action.type === 'template'">テンプレート送信</span>
      <span v-else-if="action.type === 'scenario'">シナリオ送信</span>
      <span v-else-if="action.type === 'email'">メール通知</span>
      <span v-else-if="action.type === 'tag'">タグ操作</span>
      <span v-else-if="action.type === 'reminder'">リマインダ配信</span>
      <span v-else-if="action.type === 'none'">何もしない</span>
    </div>
  </div>
  <div v-else>アクションなし</div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  episode: {
    type: Object,
    required: true
  }
})

const actions = computed(() => {
  return props.episode.actions.data.actions
})
</script>

<style>
</style>