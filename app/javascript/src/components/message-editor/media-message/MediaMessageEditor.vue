<template>
  <div>
    <div class="border" v-if="data.originalContentUrl" style="max-height: 121px;">
      <div :class="'mr-3 position-relative d-inline-flex align-items-center ' + data.type+'_item'">
        <!-- preview image and video -->
        <div
          v-if="data.type =='image' || data.type =='video'"
          class="figure figure-grid figure-grid-sm thumbnail-item"
        >
          <media-preview
            :type="data.type"
            :src="data.type =='video' ? data.previewImageUrl : data.originalContentUrl"
            :width="data.type === 'image'? '120px':'200px'"
            :height="data.type === 'image'? '120px':'120px'"
          />
        </div>

        <!-- preview audio -->
        <div v-if="data.type ==='audio'" class="d-flex align-items-center">
          <div class="d-flex align-items-center justify-content-center audio_icon_item">
            <i class="fas fa-microphone fa-3x"></i>
          </div>
          <div class="flex-1 p-3">
            <div>Audio file</div>
            <small class="text-muted">Duration: {{getDuration()}}</small>
          </div>
        </div>
        <button
          type="button"
          class="position-absolute close"
          style="top: 0px; right: -20px;"
          @click="removeMedia"
        >
          <i class="fas fa-times"></i>
        </button>
      </div>

    </div>

    <div v-else>
      <div class="border text-center" :class="errors.first('media-template' + index)?'invalid-box':'' ">
        <div class="figure figure-grid-sm my-4">
          <a
            href="#"
            class="text-primary"
            data-toggle="modal"
            data-target="#imageModalCenter"
          >
            <span v-if="data.type === 'image'">写真をアップロード</span>
            <span v-if="data.type === 'video'">動画をアップロード</span>
            <span v-if="data.type === 'audio'">ボイスメッセージをアップロード</span>
          </a>
          <div class="text-muted opacity-30">
            <i v-if="data.type === 'image'" class="fas fa-image fa-2x"></i>
            <i v-if="data.type === 'video'" class="fas fa-video fa-2x"></i>
            <i v-if="data.type === 'audio'" class="fas fa-volume-up fa-2x"></i>
          </div>
        </div>
      </div>
      <error-message :message="errors.first('media-template' + index)"></error-message>
      <modal-select-media :types="[data.type]" @select="addMedia($event)"></modal-select-media>
    </div>
    <input type="hidden" v-model="data.originalContentUrl" :name="'media-template' + index" v-validate="'required'" data-vv-as="ファイル" />
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['data', 'index'],
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },
  methods: {
    removeMedia() {
      this.data.originalContentUrl = '';

      if (this.data.type === 'image' || this.data.type === 'video') {
        this.data.previewImageUrl = '';
      }

      if (this.data.type === 'audio') {
        this.data.duration = '';
      }

      this.$emit('input', this.data);
    },
    addMedia(media) {
      const messageData = {
        type: media.type,
        originalContentUrl: media.url,
        previewImageUrl: media.preview_url,
        duration: media.duration
      };
      this.$emit('input', messageData);
    },
    getDuration() {
      return Util.getDuration(this.data);
    }
  }
};
</script>

<style  lang="scss"  scoped>
::v-deep {
  .audio_icon_item {
    width: 80px;
    height: 80px;
  }

  .image_item,
  .video_item {
    height: 120px;
  }

  .thumbnail-item {
    position: relative;
    display: inline-flex;
    img {
      max-width: fit-content!important;
    }
  }

  .play-button {
    height: 32px;
    width: 32px;
    top: 50%;
    left: 50%;
    margin-top: -2rem;
    margin-left: -2rem;
    position: absolute;
    background: url("/img/play.png") no-repeat;
    background-size: cover;
  }
}
</style>
