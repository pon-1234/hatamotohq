<template>
  <div v-b-tooltip.hover :title="title" class="ml-1">
    <i class="mdi mdi-information-outline mdi-2x"></i>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    }
  }
};
</script>