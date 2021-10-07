<template>
  <div class="media-content d-flex align-items-center justify-content-center">
    <div
      v-if="isImage"
      class="fw-200 fh-150 image"
      v-lazy:background-image="src"
    ></div>
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

<script>
export default {
  props: ['src', 'type', 'duration', 'showMedia'],
  data() {
    return {
    };
  },

  computed: {
    isImage() {
      return this.type === 'image' || this.type === 'richmenu' || this.type === 'imagemap';
    },
    isVideo() {
      return this.type === 'video';
    },
    isAudio() {
      return this.type === 'audio';
    }
  }
};
</script>
<style lang="scss" scoped>
  .media-content {
    display: inline-flex;

    .image {
      background-size: cover;
    }
  }

  .chat-item-voice {
    width: 200px;
    height: 54px;
    display: flex;
    border: 1px solid #dee2e6 !important;
    border-radius: 4px;

    .audio-player {
      width: 200px;
      height: -webkit-fill-available;
      background-color: #f1f3f4;
    }
  }
</style>
