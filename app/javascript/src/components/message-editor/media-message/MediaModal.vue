<template>
  <div
    class="modal fade"
    :id="id ? id: 'imageModalCenter'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">アップロードする</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" ref="close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden" :key="contentKey">
          <b-tabs>
            <b-tab title="新規アップロード" active @click="changeTapDefault">
              <b-card-text>
                <!---->
                <div class="h-fix-360 d-flex justify-content-center align-items-center border"  @drop.prevent="addFile" @dragover.prevent>
                  <div class="text-center">
                    <p>
                      <label>ここにファイルをドラッグ＆ドロップ</label>
                      <br />または
                    </p>
                    <div class="custom-file w-fix-200">
                      <div class="custom-file-input h-100 w-100">
                        <input
                          :accept="tailOfFile()"
                          :maxsize="getMaxSize()"
                          type="file"
                          ref="file"
                          @change="addMedia($event.currentTarget.files[0])"
                        />
                      </div>
                      <label class="custom-file-label text-left">ファイルを選択</label>
                    </div>
                    <audio controls   v-if="defaults.type === 'audio'"  ref="audio"  @loadedmetadata="onTimeUpdate" class="hidden">
                      <source :src="this.audioUrl">
                    </audio>
                    <span v-if="errorMessage" class="error">{{errorMessage}}</span>
                  </div>
                </div>
                <small class="form-text text-muted text-pre-line small" v-if="defaults.type ==='image'">
                  ファイル形式：JPG、JPEG、PNG
                  ファイルサイズ：10MB以下
                </small>
                <small class="form-text text-muted text-pre-line small" v-if="defaults.type ==='imagemap'">
                  ファイル形式：JPG、JPEG、PNG
                  ファイルサイズ：10MB以下
                  <br>
                  画像サイズ： 1040px × 1040px
                </small>
                <small
                  class="form-text text-muted text-pre-line small"
                  v-else-if="defaults.type ==='video'"
                >
                  ファイル形式： MP4
                  ファイルサイズ：200MB以下
                </small>
                <small
                  class="form-text text-muted text-pre-line small"
                  v-else-if="defaults.type ==='audio'"
                >
                  ファイル形式：MP3
                  ファイルサイズ：200MB以下
                </small>
                <small class="form-text text-muted small"
                  style="display: flex;font-weight: 400;letter-spacing: 0px; margin-top: 20px;"
                  v-else-if="defaults.type ==='richmenu'"
                >
                  ファイル形式：JPG、JPEG、PNG
                  <br>
                  ファイルサイズ：1MB以下
                  <br>
                  画像サイズ：2500px × 1686px、2500px × 843px、1200px × 810px、1200px × 405px、800px × 540px、800px × 270px
                </small>
              </b-card-text>
            </b-tab>
            <b-tab title="アップロード済み">
              <div class="row">
                <div v-for="(media, index) in medias" :key="index"
                  class="col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-2"
                >
                  <media-preview
                    class="thumb-item"
                    :type="defaults.type"
                    :src="media.preview_url"
                    :duration="getDuration(media)"
                    @click.native="selectMedia(media)"
                    :width="defaults.type === 'image' || defaults.type === 'richmenu' || defaults.type === 'imagemap' ? '110px':'200px'"
                    :height="defaults.type === 'image' || defaults.type === 'richmenu' || defaults.type === 'imagemap' ? '110px':'100px'">
                  </media-preview>
                </div>
              </div>
              <div class="text-center">
                <b-pagination
                  v-model="currentPage"
                  :total-rows="totalRows"
                  :per-page="perPage"
                  @change="getMedias"
                  aria-controls="my-table"
                ></b-pagination>
              </div>
              <small
                class="form-text text-muted text-pre-line small error"
                v-if="errorMessageImageMap"
              >
              {{errorMessageImageMap}}
              </small>
            </b-tab>
          </b-tabs>

        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

// TODO Refactor this shit
export default {
  props: ['data', 'id'],
  data() {
    return {
      contentKey: 0,
      defaults: {
        type: 'image',
        originalContentUrl: '',
        previewImageUrl: ''
      },
      url: null,
      preview_url: null,
      errorMessage: '',
      errorMessageImageMap: '',
      description: '',
      audioUrl: null,
      duration: null,
      currentPage: 1,
      totalRows: 0,
      perPage: 0,
      medias: [],
      inputFile: null
    };
  },
  created() {
    if (this.data) {
      // eslint-disable-next-line no-undef
      this.defaults = _.cloneDeep(this.data);
    }
    this.getMedias();
  },

  watch: {
    data: {
      handler(val) {
        if (this.data) {
          // eslint-disable-next-line no-undef
          this.defaults = _.cloneDeep(this.data);
        }
      },
      deep: true
    },
    duration: {
      handler(val) {
        if (this.data) {
          // eslint-disable-next-line no-undef
          if (val) {
            this.sendMediaToServer();
          }
        }
      },
      deep: true
    }
  },
  methods: {
    ...mapActions('global', [
      'sendMedia',
      'uploadImageForRichMenu',
      'uploadImageMap'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    getMaxSize() {
      if (this.defaults.type === this.MessageType.Image || this.defaults.type === this.MessageType.Imagemap) return '10M';
      if (this.data.type === 'richmenu') return '1M';
      return '200M';
    },

    onTimeUpdate() {
      this.duration = this.$refs.audio.duration * 1000;
    },

    addFile(e) {
      this.addMedia(e.dataTransfer.files[0]);
    },

    async addMedia(input) {
      const validationResult = this.validateFileExtension(input);
      if (!validationResult) return;

      if (!validationResult.valid) {
        this.errorMessage = validationResult.message;
        return;
      }

      this.inputFile = input;

      if (this.defaults.type === 'audio') {
        this.audioUrl = URL.createObjectURL(input);
        this.forceRerender();
      } else {
        if (this.defaults.type === 'richmenu') {
          const that = this;
          const reader = new FileReader();
          reader.readAsDataURL(input);
          reader.onload = function(e) {
            const img = new Image();
            img.onload = function() {
              const size = this.width + 'x' + this.height;
              if (that.ImageRichMenuSize.includes(size)) {
                that.sendMediaToServer();
              } else {
                that.errorMessage = '指定されたサイズの画像をアップロードしてください。';
              }
            };
            img.src = e.target.result;
          };
        } else if (this.defaults.type === 'imagemap') {
          const that = this;
          const reader = new FileReader();
          reader.readAsDataURL(input);
          reader.onload = function(e) {
            const img = new Image();
            img.onload = function() {
              const size = this.width + 'x' + this.height;
              if (size === that.ImageImagemapSize) {
                that.sendMediaToServer();
              } else {
                that.errorMessage = 'サイズが1040px × 1040pxの画像をアップロードしてください。';
              }
            };
            img.src = e.target.result;
          };
        } else {
          await this.sendMediaToServer();
        }
      }
      this.errorMessage = '';
    },

    validateFileExtension(input) {
      if (
        this.defaults.type === this.MessageType.Image &&
        this.ImageType.indexOf(input.type) === -1
      ) { return; }

      if (
        this.defaults.type === this.MessageType.Video &&
        this.VideoType.indexOf(input.type) === -1
      ) { return; }

      if (
        this.defaults.type === this.MessageType.Audio &&
        this.AudioType.indexOf(input.type) === -1
      ) { return; }

      //  Check size media
      return Util.checkMediaSize(input);
    },

    async sendMediaToServer() {
      const query = {
        file: this.inputFile
      };

      if (this.defaults.type === 'audio') {
        query.duration = this.duration;
      }

      if (this.data.type === 'imagemap') {
        // imagemap
        await this.uploadImageMap({ file: this.inputFile });

        if (this.url) {
          this.errorMessage = null;
          this.$emit('input', { id: this.url });
        }
        this.$refs.close.click();
      } else if (this.data.type === 'richmenu') {
        // richmenu
        await this.uploadImageForRichMenu({ file: this.inputFile });

        if (this.url) {
          this.errorMessage = null;
          this.$emit('input', this.url);
        }
        this.$refs.close.click();
      } else {
        // other
        const response = await this.sendMedia(query);
        if (response.url) {
          if (
            this.defaults.type === this.MessageType.Image ||
            this.defaults.type === this.MessageType.Video
          ) {
            this.defaults.originalContentUrl = response.url;
            this.defaults.previewImageUrl = response.preview_url;
          }

          if (this.defaults.type === this.MessageType.Audio) {
            this.defaults.originalContentUrl = response.url;
            this.defaults.duration = response.duration;
          }
          this.$emit('input', this.defaults);
        }

        this.$refs.close.click();
      }
    },

    getDuration(media) {
      return media.duration ? Util.getDuration(media) : '00:00';
    },

    async getMedias(page = 1) {
      const types = [];
      if (this.defaults.type.includes('image') || this.defaults.type.includes('imagemap')) {
        types.push('image');
      }
      if (this.defaults.type.includes('video')) {
        types.push('video');
      }
      if (this.defaults.type.includes('audio')) {
        types.push('audio');
      }
      if (this.defaults.type === 'richmenu') {
        types.push('menu');
      }

      const query = {
        page: page,
        types: types
      };

      const response = await this.$store.dispatch('media/getMedias', query);
      this.medias = response.data;
      this.perPage = response.meta.limit_value;
      this.totalRows = response.meta.total_count;
      this.isMediaPreviewRendered = false;
      this.$nextTick(() => {
        this.isMediaPreviewRendered = true;
      });
    },

    getUrlMedia(alias) {
      return this.defaults.type === 'video' ? Util.makeUrlfromKey(alias).previewImageUrl : Util.makeUrlfromKey(alias).originalContentUrl;
    },

    selectMedia(media) {
      if (
        this.defaults.type === this.MessageType.Image ||
            this.defaults.type === this.MessageType.Video
      ) {
        this.defaults.originalContentUrl = Util.makeUrlfromKey(media.alias).originalContentUrl;
        this.defaults.previewImageUrl = Util.makeUrlfromKey(media.alias).previewImageUrl;
      }

      if (this.defaults.type === this.MessageType.Audio) {
        this.defaults.originalContentUrl = Util.makeUrlfromKey(media.alias).originalContentUrl;
        this.audioUrl = Util.makeUrlfromKey(media.alias).originalContentUrl;
        this.defaults.duration = media.duration;
      }

      if (this.defaults.type === 'imagemap') {
        this.checkSizeImageMap(media).then(() => {
          this.$emit('input', { id: media.alias });
          this.errorMessageImageMap = '';
          this.$refs.close.click();
        }).catch(() => {
          this.errorMessageImageMap = 'サイズが1040px × 1040pxの画像をアップロードしてください。';
        });
      } else if (this.defaults.type === 'richmenu') {
        this.errorMessageImageMap = '';
        this.$emit('input', media.alias);
        this.$refs.close.click();
      } else {
        this.$emit('input', this.defaults);
        this.$refs.close.click();
      }
    },

    checkSizeImageMap(media) {
      return new Promise((resolve, reject) => {
        const img = new Image();
        img.onload = () => {
          const size = `${img.width}x${img.height}`;
          if (size !== this.ImageImagemapSize) {
            return reject(new Error('サイズが1040px × 1040pxの画像をアップロードしてください。'));
          }
          return resolve('ok');
        };
        img.src = Util.makeUrlfromKey(media.alias).originalContentUrl;
      });
    },

    tailOfFile() {
      return Util.tailOfFile(this.defaults.type);
    },

    changeTapDefault() {
      this.errorMessageImageMap = '';
    }
  }
};
</script>

<style  lang="scss"  scoped>

::v-deep {
  .hidden {
    display: none!important;
  }

  .custom-file {
    position: relative;
    display: inline-block;
    height: 40px;
    margin-bottom: 0;
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
    color: red !important;
    font-size: 16px!important;
  }

  .h-fix-360 {
    border-top: none!important;
  }

  .nav-tabs .nav-link.active {
    color: #495057;
    background-color: #fff;
    border-color: #dee2e6 #dee2e6 #fff
  }

  .nav-tabs > li {
    margin-bottom: -2px!important;
    width: 50%;
    text-align: center;
    a {
      margin-right: 0px!important;
    }
  }

  .modal-dialog {
    max-width: 900px!important;
  }

  .thumb-item {
    margin: 0 auto 5px;
    cursor: pointer;
    display: inline-block;
  }
  .thumb-item:hover {
    .thumbnail-item {
      border: 2px solid #00B900;
      box-shadow: 0 0 2px 2px #e6ab92;
    }
    .chat-item-voice {
      border: 2px solid #00B900;
      box-shadow: 0 0 2px 2px #e6ab92;
    }
  }

  .modal-body {
    min-height: 550px!important;
  }

  .medias-content {
    padding: 10px 10px;
    min-height: 380px!important;
    height: 380px!important;
    overflow-y: auto;
    overflow-x: hidden;
    margin: 0px!important;
  }

  .tab-media {
    border-top: none!important;
  }

.tab-content {
  height: 500px;
}
}
</style>
