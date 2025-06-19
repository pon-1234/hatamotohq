<template>
  <span v-if="animation" class="sticker-item animation" data-dismiss="modal">
    <img
      :src="`https://stickershop.line-scdn.net/stickershop/v1/sticker/${sticker.line_emoji_id}/PC/sticker_animation.png`"
      class="sticker-animation position-absolute"
      style="top: 0px"
    />
    <img
      v-if="animation"
      :src="`https://stickershop.line-scdn.net/stickershop/v1/sticker/${sticker.line_emoji_id}/PC/sticker.png`"
      class="sticker-static"
      @click="onSelectSticker"
      style
    />
  </span>
  <span v-else class="sticker-item" data-dismiss="modal">
    <img
      :src="`https://stickershop.line-scdn.net/stickershop/v1/sticker/${sticker.line_emoji_id}/PC/sticker.png`"
      class="sticker-static"
      @click="onSelectSticker"
      style
    />
  </span>
</template>
<script setup>
import { useStore } from 'vuex'

const props = defineProps(['sticker', 'animation'])
const emit = defineEmits(['input'])

const store = useStore()

const onSelectSticker = () => {
  store.commit('global/addLog', props.sticker)
  emit('input', props.sticker)
}
</script>

<style lang="scss" scoped>
  .sticker-item {
    -webkit-box-flex: 0;
    flex: 0 0 108px;
    height: 100px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }

  .sticker-item > img {
    max-width: 108px;
    max-height: 100px;
    transform: scale(0.8);
  }

  .sticker-item:hover > img {
    transform: scale(1);
  }

  /* sticker-animation */
  .sticker-item.animation:hover .sticker-animation {
    opacity: 1;
  }

  .sticker-item.animation .sticker-animation {
    opacity: 0;
  }

  .sticker-item.animation {
    position: relative;
  }

  .sticker-item.animation:hover .sticker-static {
    opacity: 0;
  }
</style>
