<template>
  <div class="upload-container my-auto d-flex flex-column">
    <div class="border flex-grow-1 d-flex justify-content-center align-items-center position-relative" @drop.prevent="addFile" @dragover.prevent>
      <div class="text-center" v-if="isPreview">
        <button class="btn-delete-media" @click="deleteMedia()"><span class="close">×</span></button>
        <img class="fw-120 fh-120" v-if="mediaData.type === 'pdf'" :src="fileURL">
        <img v-if="mediaData.type === 'image' || mediaData.type === 'richmenu'" :src="fileURL">
        <audio controls v-if="mediaData.type === 'audio'" @loadedmetadata="onTimeUpdate" ref="audio">
          <source :src="fileURL">
        </audio>
        <video v-else-if="mediaData.type === 'video'" width="320" height="240" controls autoplay>
          <source :src="fileURL" type="video/mp4">
        </video>
      </div>
      <div class="text-center text-md" v-else>
        <p><label>ここにファイルをドラッグ＆ドロップ<br>または</label></p>
        <div class="custom-file w-fix-200">
          <div class="custom-file-input h-100 w-100">
            <input
              class="fh-50"
              :accept="getAcceptedMineTypes()"
              :maxsize="getMaxSize()"
              type="file"
              ref="file"
              @change="addMedia($event)"
            />
          </div>
          <label class="custom-file-label text-left">ファイルを選択</label>
        </div>
        <span v-if="errorMessage" class="w-100 error">{{errorMessage}}</span>
        <media-upload-hint class="m-4" :type="mediaData.type"></media-upload-hint>
      </div>
    </div>
    <div class="d-flex align-items-center">
      <button v-if="isPreview" class="btn btn-info ml-auto mr-4 fw-120" @click="handleUpload">確認する</button>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: {
    types: {
      type: Array,
      default: () => ['image', 'audio', 'video']
    }
  },
  data() {
    return {
      mediaData: {
        type: 'image',
        originalContentUrl: '',
        previewImageUrl: ''
      },
      errorMessage: '',
      description: '',
      isPreview: false,
      input: null,
      fileURL: '',
      inputFile: null,
      duration: null
    };
  },

  watch: {
    types: {
      handler(val) {
        this.mediaData.type = val[0];
      }
    }
  },

  methods: {
    ...mapActions('media', [
      'uploadMedia',
      'uploadRichMenu',
      'uploadImageMap'
    ]),
    getMaxSize() {
      return Util.getMaxSizeByType(this.mediaData.type);
    },

    getAcceptedMineTypes() {
      return Util.getAcceptedMineTypes(this.types);
    },

    addFile(event) {
      this.addMedia(event);
    },

    async addMedia(event) {
      const input = event.currentTarget.files[0];
      this.inputFile = input;
      const mediaType = Util.convertMineTypeToMediaType(input.type);
      if (mediaType === 'image') {
        if (this.types.includes('richmenu')) this.mediaData.type = 'richmenu';
        if (this.types.includes('imagemap')) this.mediaData.type = 'imagemap';
      } else {
        this.mediaData.type = mediaType;
      }
      const validationResult = Util.validateFileSizeByType(this.mediaData.type, input.size);
      if (!validationResult) return;

      if (!validationResult.valid) {
        this.errorMessage = validationResult.message;
        return;
      }
      // Generate preview
      if (this.mediaData.type === 'image') {
        this.generateImagePreview(input);
      } else if (this.mediaData.type === 'video') {
        this.generateVideoPreview(input);
      } else if (this.mediaData.type === 'pdf') {
        this.generatePdfPreview(input);
      } else if (this.mediaData.type === 'audio') {
        this.generateAudioPreview(input);
      } else if (this.mediaData.type === 'richmenu') {
        this.generateRichMenuPreview(input);
      }
      this.errorMessage = '';
      // Clear file input data
      event.target.value = '';
    },

    generateImagePreview(input) {
      const _this = this;
      const reader = new FileReader();
      reader.readAsDataURL(input);
      reader.onload = function(e) {
        _this.fileURL = e.target.result;
        _this.isPreview = true;
      };
    },

    generateVideoPreview(input) {
      this.fileURL = URL.createObjectURL(input);
      this.isPreview = true;
    },

    generatePdfPreview(input) {
      this.fileURL = '/img/pdf_temp.png';
      this.isPreview = true;
    },

    generateAudioPreview(input) {
      this.fileURL = URL.createObjectURL(input);
      this.isPreview = true;
    },

    generateRichMenuPreview(input) {
      const _this = this;
      const reader = new FileReader();
      reader.readAsDataURL(input);
      reader.onload = function(e) {
        const img = new Image();
        img.onload = function() {
          const size = this.width + 'x' + this.height;
          if (_this.ImageRichMenuSize.includes(size)) {
            _this.fileURL = e.target.result;
            _this.isPreview = true;
          } else {
            _this.isPreview = false;
            _this.errorMessage = '指定されたサイズの画像をアップロードしてください。';
          }
        };
        img.src = e.target.result;
      };
    },

    async handleUpload() {
      const query = {
        file: this.inputFile
      };

      if (this.mediaData.type === 'audio') {
        query.duration = this.duration;
      }

      let response = null;
      if (this.mediaData.type === 'imagemap') {
        response = await this.uploadImageMap({ file: this.inputFile });
      } else if (this.mediaData.type === 'richmenu') {
        response = await this.uploadRichMenu(this.inputFile);
      } else {
        response = await this.uploadMedia(query);
      }

      if (response.url) {
        this.mediaData = _.pick(response, ['id', 'type', 'url', 'preview_url', 'duration']);
        this.$emit('upload', this.mediaData);
      }
      this.errorMessage = null;
    },

    getDuration(media) {
      return media.duration ? Util.getDuration(media) : '00:00';
    },

    deleteMedia() {
      this.isPreview = false;
    },

    onTimeUpdate() {
      this.duration = this.$refs.audio.duration * 1000;
    }
  }
};
</script>

<style lang="scss" scoped>
  .upload-container  {
    min-height: 500px;
  }

  ::v-deep {
    .custom-file {
      position: relative;
      display: inline-block;
      height: 40px;
      margin-bottom: 0;
    }

    .h-100 {
      height: 100% !important;
    }

    .w-100 {
      width: 100% !important;
    }

    input {
      overflow: visible;
    }

    .custom-file-input {
      position: relative;
      z-index: 2;
      margin: 0;
      opacity: 0;
    }

    .custom-file-label {
      position: absolute;
      top: 0;
      right: 0;
      left: 0;
      z-index: 1;
      height: 40px;
      color: #495057;
      background-color: #fff;
      border: 1px solid #cfd4da;
      border-radius: 2px;
      display: flex;
      align-items: center;
      padding-left: 10px;
      font-weight: 200;
      font-size: 15px;
    }

    .custom-file-label::after {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      z-index: 3;
      display: flex;
      align-items: center;
      height: 38px;
      color: #495057;
      content: "+";
      background-color: #f8f9fa;
      border-left: 1px solid #cfd4da;
      border-radius: 0 2px 2px 0;
      padding-left: 10px;
      padding-right: 10px;
    }

    .text-muted {
      color: #adb5bd !important;
      display: block;
      font-size: 10px;
    }

    .text-center {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    .error {
      color: red;
    }

    .btn-delete-media {
      top: 9px;
      right: 8px;
      position: absolute;
      border: none;
    }

    .text-center img {
      max-width: 100%;
      height: 350px;
      object-fit: contain;
    }
    #preview-file{
      width: 100px;
      height: 100px;
    }

  }
</style>
