<template>
  <div>
    <span v-if="status === 'published'"><i class="mdi mdi-circle text-success"></i> 公開</span>
    <span v-else-if="status === 'unpublished'"><i class="mdi mdi-circle text-warning"></i> 未公開</span>
    <span v-else-if="status === 'draft'"><i class="mdi mdi-circle"></i> 下書き</span>
  </div>
</template>

<script>
export default {
  props: {
    status: {
      type: String
    }
  }
};
</script>