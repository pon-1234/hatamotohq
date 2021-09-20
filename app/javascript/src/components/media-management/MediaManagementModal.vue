<template>
  <div
    class="modal fade modal-template modal-common01"
    id="imageModalCenter"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
    ref="mediaModal"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
            <label>アップロードする</label>
            <!--<label v-if="data.type === 'audio'">Upload voice file</label>-->
          </h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" ref="close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <div class="modal-body mh-100 overflow-hidden">
            <!---->
            <div class="h-fix-360 d-flex justify-content-center align-items-center border"  @drop.prevent="addFile" @dragover.prevent>
              <div class="text-center" v-if="isPreview">
                <button class="btn-delete-image" @click="deleteMedia()"><span class="close">×</span></button>

                <img id="preview-file" v-if="data.type === 'pdf'" :src="fileURL">
                <img id="preview-image" v-if="data.type === 'image' || data.type === 'richmenu'" :src="fileURL">
                <audio controls   v-if="data.type === 'audio'" @loadedmetadata="onTimeUpdate" ref="audio">
                  <source :src="this.fileURL">
                </audio>
                <video v-else-if="data.type === 'video'" width="320" height="240" controls autoplay>
                  <source :src="this.fileURL" type="video/mp4">
                </video>

              </div>
              <div class="text-center" v-else>
                <p><label>ここにファイルをドラッグ＆ドロップ<br>または</label></p>
                <div class="custom-file w-fix-200">
                  <div class="custom-file-input h-100 w-100">
                    <input
                      :accept="getAcceptedMineTypes()"
                      :maxsize="getMaxSize()"
                      type="file"
                      ref="file"
                      @change="addMedia($event.currentTarget.files[0])"
                    />
                  </div>
                  <label class="custom-file-label text-left">ファイルを選択</label>
                </div>
                <span v-if="errorMessage" class="error">{{errorMessage}}</span>
              </div>
            </div>
            <small class="form-text text-muted text-pre-line small" v-if="data.type ==='pdf'">
              ファイル形式：PDF
              ファイルサイズ：Up to 10 MB
            </small>
            <small class="form-text text-muted text-pre-line small" v-if="data.type ==='image'">
              ファイル形式：JPG、JPEG、PNG
              ファイルサイズ：1MB以下
            </small>
            <small
              class="form-text text-muted text-pre-line small"
              v-else-if="data.type ==='video'"
            >
              ファイル形式： MP4
              ファイルサイズ：10MB以下
            </small>
            <small
              class="form-text text-muted text-pre-line small"
              v-else-if="data.type ==='audio'"
            >
              ファイル形式：WAV, MP3, M4A, AAC, OGG
              ファイルサイズ：10MB以下
            </small>
            <small class="form-text text-muted small"
              style="display: flex;font-weight: 400;letter-spacing: 0px;"
               v-else-if="data.type ==='richmenu'"
            >
              ファイル形式：JPG、JPEG、PNG
              <br>
              ファイルサイズ：1MB以下
              <br>
              画像サイズ：2500px × 1686px、2500px × 843px、1200px × 810px、1200px × 405px、800px × 540px、800px × 270px
            </small>
            <button v-if="isPreview" class="btn btn-default" @click="uploadMedia">確認する</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['data'],
  data() {
    return {
      defaults: {
        type: 'image',
        originalContentUrl: '',
        previewImageUrl: ''
      },
      errorMessage: '',
      description: '',
      isPreview: false,
      input: null,
      fileURL: '',
      duration: null
    };
  },
  computed: {
    ...mapState('global', {
      key: state => state.key
    })
  },
  created() {
    if (this.data) {
      this.defaults = this.data;
    }
  },
  mounted() {
    $(this.$refs.mediaModal).on('hidden.bs.modal', () => {
      this.defaults = { type: 'image', originalContentUrl: '', previewImageUrl: '' };
      this.errorMessage = '';
      this.description = '';
      this.isPreview = false;
      this.input = null;
      this.fileURL = '';
    });
  },
  methods: {
    ...mapActions('global', ['sendMedia', 'uploadRichMenu']),
    getMaxSize() {
      if (this.defaults.type === this.MessageType.Image) return '10M';
      if (this.data.type === 'richmenu') return '1M';
      return '200M';
    },

    getAcceptedMineTypes() {
      return Util.getAcceptedMineTypes(this.data.type);
    },

    addFile(e) {
      this.addMedia(e.dataTransfer.files[0]);
    },
    addMedia(input) {
      //  Check size media
      let message = Util.checkMediaSize(input);
      if (this.data.type === 'richmenu') {
        message = Util.checkRichMenuImage(input);
      }

      if (message.status) {
        this.input = input;
        this.errorMessage = '';
        this.isPreview = true;
      } else {
        this.errorMessage = message.message;
      }

      if (this.data.type === this.MessageType.Image) {
        const that = this;
        const reader = new FileReader();
        reader.readAsDataURL(input);
        reader.onload = function(e) {
          that.fileURL = e.target.result;
        };
      } else if (this.data.type === this.MessageType.Video) {
        this.fileURL = URL.createObjectURL(input);
      } else if (this.data.type === 'pdf') {
        this.fileURL = '/img/pdf_temp.png';
      } else if (this.data.type === 'audio') {
        this.fileURL = URL.createObjectURL(input);
      } else if (this.data.type === 'richmenu') {
        const that = this;
        const reader = new FileReader();
        reader.readAsDataURL(input);
        reader.onload = function(e) {
          const img = new Image();
          img.onload = function() {
            const size = this.width + 'x' + this.height;
            if (that.ImageRichMenuSize.includes(size)) {
              that.fileURL = e.target.result;
            } else {
              that.isPreview = false;
              that.errorMessage = '指定されたサイズの画像をアップロードしてください。';
            }
          };
          img.src = e.target.result;
        };
      }
    },

    async uploadMedia() {
      if (this.data.type === 'richmenu') {
        // richmenu
        await this.uploadRichMenu({ file: this.input });
        this.errorMessage = null;
        this.$refs.close.click();
        this.$emit('input', this.defaults);
      } else {
        await this.sendMedia({ file: this.input, duration: this.duration });
        this.$refs.close.click();
        this.isPreview = false;
        this.$emit('input', this.defaults);
      }
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

<style  lang="scss"  scoped>
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

    .btn-delete-image {
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
