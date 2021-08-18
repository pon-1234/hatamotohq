<template>
  <div class="media-content">
    <div class="thumbnail-item" v-if="type === 'image' || type === 'video' || type=== 'richmenu' || type=== 'imagemap'"
         :style="style">
      <div class="play-button" v-if=" type==='video' && !showMedia">
      </div>
      <div class="" v-else-if=" type==='video' && showMedia">
        <video :width="style.width" :height="style.height" controls>
          <source :src="src">
        </video>
      </div>
    </div>

    <div v-if="type === 'audio'">
      <div class="chat-item-voice">
        <div v-if="!showMedia">
          <div class="chat-item-voice-control">
            <span class="play-audio"></span>
          </div>
          <div class="chat-item-voice-text">
            <span>{{duration}}</span>
          </div>
        </div>
        <div v-else>
          <audio controls style="width: 160px; height: -webkit-fill-available; background-color: #f1f3f4;">
            <source :src="src">
          </audio>
        </div>
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
  }

  .thumbnail-item {
    background-repeat: no-repeat;
    background-position: center center;
    background-size: cover;
    cursor: pointer;
    display: inline-block;
    position: relative;
  }

  .play-button {
    height: 30px;
    width: 30px;
    top: 50%;
    left: 50%;
    margin-top: -2rem;
    margin-left: -2rem;
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
