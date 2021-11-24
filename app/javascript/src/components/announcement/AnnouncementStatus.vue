<template>
  <span v-if="announcement.status == 'draft'"><i class="mdi mdi-circle text-secondary"></i> 下書き </span>
  <span v-else-if="announcement.status == 'published'"><i class="mdi mdi-circle text-success"></i> 公開 </span>
  <span v-else-if="announcement.status == 'unpublished'"><i class="mdi mdi-circle text-primary"></i> 非公開 </span>
</template>

<script>
export default {
  props: ['announcement']
};
</script>