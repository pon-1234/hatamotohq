<template>
  <div class="message-preview-el">
    <div class="card card-sliding" :style="isHidden ? 'margin-bottom: -50vh;' : 'margin-bottom: 0px;'">
      <div
        class="card-header bg-dark d-flex justify-content-between align-items-center"
        role="button"
        @click="toggleVisible"
      >
        <div role="button" class="text-white">プレビュー</div>
        <i v-if="!isHidden" id="gijvq97" class="dripicons-chevron-down text-white font-weight-bold"></i>
        <i v-else id="gijvq97" class="dripicons-chevron-up text-white font-weight-bold"></i>
      </div>
      <div
        class="card-body bg-white overflow-x-hidden p-0 cursor-not-allowed no-select"
        style="width: 370px; height: 50vh; max-height: none"
      >
        <div class="bg-info" style="padding: 20px 0px 20px 20px; min-height: 50vh">
          <message-content-preview></message-content-preview>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import Util from '@/core/util'

const isHidden = ref(false)

onMounted(() => {
  if (Util.isMobile()) {
    isHidden.value = true
  }
})

const toggleVisible = () => {
  isHidden.value = !isHidden.value
}
</script>

<style lang="scss" scoped>
  :deep() {
    .card-sliding {
      border-bottom: 0;
      position: fixed;
      right: 1rem;
      bottom: 0;
      z-index: 10;
      box-shadow: 0 0 1rem 0 rgba(0, 0, 0, 0.5);
      transition: margin 0.3s ease-in-out;
    }

    .card-header {
      padding: 0.75rem 1.25rem;
      margin-bottom: 0;
      background-color: rgba(0, 0, 0, 0.03);
      border-bottom: 1px solid rgba(0, 0, 0, 0.125);
    }

    .mr-2,
    .mx-2 {
      margin-right: 0.5rem !important;
    }

    .card-sliding .card-body {
      overflow-y: auto;
    }

    .bg-info {
      background-color: #666f86 !important;
      color: black !important;
    }
  }
</style>
