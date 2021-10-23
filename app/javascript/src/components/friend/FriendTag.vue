<template>
  <div v-if="tags.length > 0">
    <span class="badge badge-pill badge-warning mr-1" v-for="(tag, index) in tags" :key="index">
      {{ tag.name }}
    </span>
  </div>
  <div v-else>なし</div>
</template>

<script>
export default {
  props: {
    tags: {
      type: Array,
      default: () => []
    }
  }
};
</script>