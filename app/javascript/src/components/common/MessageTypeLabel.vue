<template>
  <div class="d-inline-block text-nowrap">
    <span>{{ messageLabel }}</span>
  </div>
</template>

<script setup>
import { computed } from 'vue';

// Props
const props = defineProps({
  data: {
    type: Object,
    required: true
  }
});

// Computed
const messageLabel = computed(() => {
  const typeLabels = {
    text: '【テキスト】',
    sticker: '【スタンプ】',
    image: '【画像】',
    video: '【動画】',
    audio: '【音声】',
    location: '【位置情報】',
    imagemap: '【リッチ画像】',
    flex: '【Flex】'
  };

  if (props.data.type === 'template' && props.data.template) {
    const templateLabels = {
      buttons: '【ボタン】',
      confirm: '【質問】',
      carousel: '【カルーセル】',
      image_carousel: '【画像カルーセル】'
    };
    return templateLabels[props.data.template.type] || '【テンプレート】';
  }

  return typeLabels[props.data.type] || '【不明】';
});
</script>
