<template>
  <div class="media-content d-flex align-items-center justify-content-center">
    <img v-lazy="src" v-if="isImage" class="image" :alt="altText">
    <div v-else-if="isVideo">
      <video :width="200" :height="150" controls>
        <source :src="src" />
      </video>
    </div>
    <div v-else-if="isAudio">
      <div class="chat-item-voice">
        <audio controls class="audio-player">
          <source :src="src" />
        </audio>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

// Props
const props = defineProps({
  src: {
    type: String,
    required: true
  },
  type: {
    type: String,
    required: true
  },
  duration: {
    type: [String, Number],
    default: null
  },
  showMedia: {
    type: Boolean,
    default: true
  }
});

// Computed
const isImage = computed(() => {
  return props.type === 'image' || props.type === 'richmenu' || props.type === 'imagemap';
});

const isVideo = computed(() => {
  return props.type === 'video';
});

const isAudio = computed(() => {
  return props.type === 'audio';
});

const altText = computed(() => {
  const typeMap = {
    image: '画像',
    richmenu: 'リッチメニュー',
    imagemap: 'イメージマップ'
  };
  return typeMap[props.type] || 'メディア';
});
</script>

<style lang="scss" scoped>
.media-content {
  display: inline-flex;

  .image {
    object-fit: contain;
    height: auto;
    width: 200px;
    max-width: 100%;
  }
}

.chat-item-voice {
  width: 200px;
  height: 54px;
  display: flex;
  border: 1px solid #dee2e6 !important;
  border-radius: 4px;

  .audio-player {
    width: 100%;
    height: 100%;
    background-color: #f1f3f4;
  }
}
</style>
