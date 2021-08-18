<template>
  <div
    class="modal fade modal-template modal-common01"
    id="imageModalCenter"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
            <label>アップロードする</label>
          </h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" ref="close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <b-tabs>
            <b-tab title="新規アップロード" active>
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
                          accept="image/png, image/x-png, image/jpeg,video/mp4, audio/mp3, image/gif"
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
                <small class="form-text text-muted text-pre-line small">
                  ファイル形式：JPG、JPEG、PNG,
                  ファイルサイズ：1MB以下
                </small>
                <small
                  class="form-text text-muted text-pre-line small"
                >
                  ファイル形式： MP4
                  ファイルサイズ：10MB以下
                </small>
              </b-card-text>
            </b-tab>
            <b-tab title="アップロード済み">
              <b-card-text>
                <div class="tab-media d-flex flex-column border">
                  <div class="w-100 text-right filter-media">
                    <filter-checkbox @input="changefilter"/>
                  </div>
                  <div class=" medias-content" v-if="isRendered">
                    <div v-for="(media, index) in medias" :key="index">
                      <div v-if="getTypeMedia(media.mine_type) !=='pdf'" class="col-xs-12 col-sm-6 col-md-4 text-center mb-3">
                        <div class="media-preview-content" @click="selectMedia(media)">
                          <media-preview
                            class="thumb-item"
                            :type="getTypeMedia(media.mine_type)"
                            :src="getUrlMedia(media.mine_type, media.alias)"
                            :duration="getDuration(media)"
                            width="190px"
                            :height="getTypeMedia(media.mine_type) === 'image'? '100px':'100px'"
                            />
                            <div class="media-preview-info">
                              {{media.mine_type}}
                            </div>
                          </div>
                      </div>
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
                </div>
              </b-card-text>
            </b-tab>
          </b-tabs>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
// import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['data'],
  data() {
    return {
      errorMessage: '',
      currentPage: 1,
      totalRows: 0,
      perPage: 0,
      medias: [],
      typesFilter: [],
      isRendered: true
    };
  },

  created() {
    this.getMedias();
  },

  methods: {
    onTimeUpdate() {
      this.duration = this.$refs.audio.duration * 1000;
    },

    addFile(e) {
      this.addMedia(e.dataTransfer.files[0]);
    },
    async addMedia(input) {
      const message = Util.checkMediaSize(input);

      if (message.status) {
        this.$emit('sendFile', input);
        this.$refs.file.value = null;
        this.$refs.close.click();
      } else {
        this.errorMessage = message.message;
      }
    },

    getDuration(media) {
      return media.duration ? Util.getDuration(media) : '00:00';
    },

    getTypeMedia(type) {
      if (this.ImageType.indexOf(type) >= 0) {
        return 'image';
      }
      if (this.VideoType.indexOf(type) >= 0) {
        return 'video';
      }
      if (this.AudioType.indexOf(type) >= 0) {
        return 'audio';
      }

      return 'pdf';
    },

    getMedias(page = 1) {
      this.fetchMedias(page);
    },

    changefilter(types) {
      this.typesFilter = types;
      this.fetchMedias(1);
    },

    fetchMedias(page) {
      const query = {
        page: page,
        type: this.typesFilter
      };

      this.$store
        .dispatch('media/getMedias', query)
        .done(res => {
          this.medias = res.data;
          this.perPage = res.meta.per_page;
          this.totalRows = res.meta.total;
          this.isRendered = false;
          this.$nextTick(() => {
            this.isRendered = true;
          });
        }).fail(e => {
        });
    },

    getUrlMedia(type, alias) {
      return this.VideoType.indexOf(type) >= 0 ? Util.makeUrlfromKey(alias).previewImageUrl : Util.makeUrlfromKey(alias).originalContentUrl;
    },

    selectMedia(media) {
      this.$emit('sendMedia', media);
      this.$refs.close.click();
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

  .modal-body {
    min-height: 550px!important;
  }

  .medias-content {
    padding: 10px 10px;
    min-height: 400px!important;
    height: 400px!important;
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

  .filter-media {
    padding-right: 10px;
  }

  .media-preview-content{
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 4px;
    cursor: pointer;
    height: 150px;
    display: flex;
    flex-direction: column;
  }

  .media-preview-info {
    border-top: 1px solid #d3e0e9;
    padding: 5px 10px;
    background-color: #f5f5f5;
    border-bottom-right-radius: 4px;
    border-bottom-left-radius: 4px;
    margin: -4px;
    margin-top: auto;
  }

    .media-preview-content:hover {
      border: 2px solid #00B900;
      box-shadow: 0 0 2px 2px #e6ab92;
    }
}
</style>
