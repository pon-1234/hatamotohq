<template>
  <div
    class="modal fade modal-template modal-common01"
    :id="id ? id: 'imageModalCenter'"
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
            <b-tab title="新規アップロード" active @click="changeTapDefault">
              <b-card-text>
                <!---->
                <div class="h-fix-360 d-flex justify-content-center align-items-center border"  @drop.prevent="dropFile" @dragover.prevent>
                  <div class="text-center">
                    <p>
                      <label>ここにファイルをドラッグ＆ドロップ</label>
                      <br />または

                    </p>
                    <div class="custom-file w-fix-200">
                      <div class="custom-file-input h-100 w-100">
                        <input
                          accept="image/*, .pdf"
                          :maxsize="getMaxSize()"
                          type="file"
                          ref="file"
                          @change="addFile($event.currentTarget.files[0])"
                        />
                      </div>
                      <label class="custom-file-label text-left">ファイルを選択</label>
                    </div>
                    <span v-if="errorMessage" class="error">{{errorMessage}}</span>
                  </div>
                </div>
                <small class="form-text text-muted text-pre-line small">
                  ファイル形式：JPG、JPEG、PNG、GIF、PDF
                  ファイルサイズ：10MB以下
                </small>
              </b-card-text>
            </b-tab>
            <b-tab title="アップロード済み" @click="changeTapDefault">
              <b-card-text>
                <div class="tab-media d-flex flex-column border">
                  <div class=" medias-content" v-if="isMediaPreviewRendered">
                    <div v-for="(media, index) in medias" :key="index" class="col-xs-12 col-sm-3 col-md-2 text-center">
                      <media-preview
                        class="thumb-item"
                        :type="'image'"
                        :src="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${media.alias}`"
                        @click.native="selectMedia(media)"
                        :width="'110px'"
                        :height="'110px'"
                        />
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
import { mapState } from 'vuex';

export default {
  props: ['data', 'id'],
  data() {
    return {
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      errorMessage: '',
      description: '',
      rerender: true,
      currentPage: 1,
      totalRows: 0,
      perPage: 0,
      medias: [],
      isMediaPreviewRendered: true,
      inputFile: null
    };
  },
  computed: {
    ...mapState('global', {
      key: state => state.key
    })
  },
  created() {
    this.getMedias();
  },

  methods: {
    getMaxSize() {
      return '10M';
    },
    dropFile(e) {
      this.addFile(e.dataTransfer.files[0]);
    },

    async addFile(file) {
      const query = {
        file: file
      };

      const formData = new FormData();
      formData.append('fileData', query.file);
      var $res = await window.$.ajax({
        url: '/surveys/74d00577e7c18f07da6785da7ebb94e1/upload',
        method: 'POST',
        data: formData,
        processData: false,
        contentType: false
      });
      $res = JSON.parse($res);
      if ($res) {
        this.$emit('input', {
          alias: $res.id,
          name: file.name,
          type: file.type
        });
        this.$refs.close.click();
      }
    },

    getMedias(page = 1) {
      const query = {
        page: page
      };

      this.$store
        .dispatch('friend/getFiles', query)
        .done(res => {
          this.medias = res.data;
          this.perPage = res.meta.per_page;
          this.totalRows = res.meta.total;
          this.isMediaPreviewRendered = false;

          this.$nextTick(() => {
            this.isMediaPreviewRendered = true;
          });
        }).fail(e => {
        });
    },

    selectMedia(media) {
      this.$emit('input', {
        alias: media.alias,
        name: media.name,
        type: media.mine_type
      });
      this.$refs.close.click();
    },

    changeTapDefault() {
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
