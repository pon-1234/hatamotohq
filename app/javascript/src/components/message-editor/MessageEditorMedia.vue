<template>
  <div>
    <div class="d-flex align-items-center border" v-if="data.originalContentUrl">
      <div class="my-4 ml-2">
        <media-preview :type="data.type" :src="data.originalContentUrl"></media-preview>
      </div>
      <div role="button" class="btn btn-sm btn-danger ml-2" @click="removeMedia">削除</div>
    </div>

    <div v-else>
      <div class="border text-center" :class="errors.first('media-template' + index) ? 'invalid-box' : ''">
        <div class="figure figure-grid-sm my-4">
          <a href="#" class="text-primary" data-toggle="modal" data-target="#modalSelectMedia">
            <span v-if="data.type === 'image'">写真をアップロード</span>
            <span v-else-if="data.type === 'video'">動画をアップロード</span>
            <span v-else-if="data.type === 'audio'">ボイスメッセージをアップロード</span>
          </a>
          <div class="text-muted opacity-30">
            <i v-if="data.type === 'image'" class="mdi mdi-image mdi-3x"></i>
            <i v-else-if="data.type === 'video'" class="mdi mdi-video mdi-3x"></i>
            <i v-else-if="data.type === 'audio'" class="mdi mdi-voice mdi-3x"></i>
          </div>
        </div>
      </div>
      <error-message :message="errors.first('media-template' + index)"></error-message>
      <modal-select-media :types="[data.type]" @select="addMedia($event)"></modal-select-media>
    </div>
    <input
      type="hidden"
      v-model="data.originalContentUrl"
      :name="'media-template' + index"
      v-validate="'required'"
      data-vv-as="ファイル"
    />
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

<style lang="scss" scoped>
  .btn-close {
    top: -50px;
    right: -50px;
  }
</style>