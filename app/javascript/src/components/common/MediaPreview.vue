<template>
  <div class="media-content d-flex align-items-center justify-content-center">
    <div v-if="isImage" class="fw-200 fh-150 image" v-lazy:background-image="src"></div>
    <div v-else-if="isVideo">
      <video :width="200" :height="150" controls>
        <source :src="src">
      </video>
    </div>
    <div v-else-if="isAudio">
      <div class="chat-item-voice">
        <audio controls class="audio-player">
          <source :src="src">
        </audio>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['src', 'type', 'height', 'width', 'duration', 'showMedia'],
  data() {
    return {
      heigthFixed: null,
      isRefreshed: true,
      style: {
        backgroundImage: 'url(' + this.src + ')',
        width: this.type === 'video' ? '160px' : '0px',
        backgroundSize: 'contain',
        height: this.type === 'video' ? '90px' : '0px'
      }
    };
  },

  mounted() {
    if (this.width && this.height) {
      this.style.width = this.width;
      this.style.height = this.height;
      return;
    }

    if (this.type === 'image' || this.type === 'video') {
      const img = new Image();
      img.onload = () => {
        const originWidth = parseInt(this.width) || 200;
        const originHeight = parseInt(this.height) || 300;
        const bound = this.boundSize(originWidth, originHeight, img.width, img.height);
        this.style.width = `${bound.w}px`;
        this.style.height = `${bound.h}px`;
      };
      img.src = this.src;
    }
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
  },

  methods: {
    boundSize(orgW, orgH, w, h) {
      if (h > orgH || w > orgW) {
        let wN, hN;
        if (h > orgH) {
          hN = orgH;
          wN = orgH * (w / h);
        }
        if (w > orgW) {
          wN = orgW;
          hN = orgW * (h / w);
        }
        return this.boundSize(orgW, orgH, wN, hN);
      }
      return {
        w: w,
        h: h
      };
    },
    getStyle() {
      const style = {
        backgroundImage: 'url(' + this.src + ')',
        width: '200px',
        backgroundSize: 'contain',
        height: this.heightFixed ? this.heightFixed : (this.type === 'video' ? '100px' : '200px')
      };

      if (this.width && this.height) {
        style.width = this.width;
        style.height = this.height;
      }

      return style;
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

  .thumbnail-item {
    background-repeat: no-repeat;
    background-position: center center;
    background-size: cover;
    cursor: pointer;
    display: inline-block;
    position: relative;
    overflow: hidden;
  }

  .play-button {
    height: 30px;
    width: 30px;
    top: calc(50% - 15px);
    left: calc(50% - 15px);
    position: absolute;
    background: url("/img/play.png") no-repeat;
    background-size: cover;
  }

  .chat-item-voice {
    width: 160px;
    height: 54px;
    display: flex;
    border: 1px solid #dee2e6 !important;
    border-radius: 4px;

    .audio-player {
      width: 160px;
      height: -webkit-fill-available;
      background-color: #f1f3f4;
    }
  }

  .chat-item-voice-control {
    width: 100px;
    display: flex;
    align-items: center;
    padding-left: 1.5rem;
  }

  .play-audio {
    height: 20px;
    width: 20px;
    background: url("/img/play-button-audio.png") no-repeat;
    background-size: cover;
  }

  .chat-item-voice-text {
    width: 60px;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
