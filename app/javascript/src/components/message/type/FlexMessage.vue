<template>
  <div class="overflow-auto">
    <div class="preview"><div v-html="html"></div></div>
  </div>
</template>
<script setup>
import { ref, onMounted, nextTick } from 'vue'
import Util from '@/core/util'

defineProps(['html'])

const isLoading = ref(false)

onMounted(() => {
  nextTick(() => {
    Util.addMouseScrollHorizontal($('.preview>div'))
  })
})
</script>

<style scoped lang="scss">
  :deep() {
    .reservation-item {
      -webkit-box-flex: 0;
      flex: none;
      display: inherit;
      width: 80%;
      max-width: 300px;
      margin-left: 7px;
    }

    .preview {
      display: flex;
      zoom: 0.6;
      overflow: auto;
      padding: 10px;
      width: 400px;
      text-align: initial;
    }
    .preview > div {
      margin: auto !important;
      > div {
        display: inline;
        width: 100%;
      }
    }

    .preview:hover {
      cursor: col-resize;
    }

    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }
    .preview > div {
      display: contents;
    }
  }
</style>
