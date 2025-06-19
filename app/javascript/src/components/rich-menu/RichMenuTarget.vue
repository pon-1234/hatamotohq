<template>
  <div v-if="rich_menu.target === 'all'">全て</div>
  <div v-else-if="rich_menu.target === 'condition'">
    <div
      v-if="tagCondition && tagCondition.data.tags && tagCondition.data.tags.length > 0"
      class="d-flex align-items-center flex-wrap"
    >
      <span class="text-sm mr-2">タグ</span>
      <span
        v-for="(tag, index) in tagCondition.data.tags"
        :key="index"
        class="badge badge-warning badge-pill pt-1 mr-1 mb-1"
        >{{ tag.name }}</span
      >
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps(['rich_menu'])

const tagCondition = computed(() => {
  return props.rich_menu.conditions ? props.rich_menu.conditions.find(_ => _.type === 'tag') : null
})
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
</style>