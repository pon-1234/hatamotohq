<template>
  <div>
    <span v-if="status === 'published'"><i class="mdi mdi-circle text-success"></i> 公開</span>
    <span v-else-if="status === 'unpublished'"><i class="mdi mdi-circle text-warning"></i> 非公開</span>
    <span v-else-if="status === 'draft'"><i class="mdi mdi-circle"></i> 下書き</span>
  </div>
</template>

<script setup>
defineProps({
  status: {
    type: String
  }
})
</script>