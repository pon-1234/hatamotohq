<template>
  <div :class="mode === 'manage' ? 'card mvh-60' : 'card'">
    <div class="card-header d-flex flex-wrap align-items-center">
      <div class="mr-auto" v-if="mode === 'manage'">
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#modalSelectMedia"
          @click="curUploadType = 'image'"
        >
          画像アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#modalSelectMedia"
          @click="curUploadType = 'audio'"
        >
          音声アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#modalSelectMedia"
          @click="curUploadType = 'video'"
        >
          動画アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#modalSelectMedia"
          @click="curUploadType = 'richmenu'"
        >
          メニュー画像アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#modalSelectMedia"
          @click="curUploadType = 'pdf'"
          hidden
        >
          PDFアップロード
        </a>
      </div>
      <div class="ml-auto">
        <media-filter @filterChanged="getMedias" v-if="filterable"></media-filter>
      </div>
    </div>
    <div class="card-body d-flex flex-column" :key="contentKey">
      <div :class="mode === 'read' ? 'row flex-grow-1' : 'row'">
        <div
          v-for="(media, index) in medias"
          :key="index"
          @click="selectMedia(media)"
          :class="isManageMode ? 'col-xl-2 col-lg-4 col-sm-6 overflow-hidden' : 'col-xl-4 col-md-6 overflow-hidden'"
        >
          <div class="card fw-200 mx-auto">
            <div class="card-body p-0 d-flex align-items-center justify-content-center">
              <div class="text-center overflow-hidden">
                <div class="media-preview" role="button">
                  <template v-if="isImage(media)">
                    <expandable-image
                      v-if="mode === 'manage'"
                      class="image fw-200 fh-150 bg-position-center"
                      :src="media.url"
                    />
                    <div
                      v-else
                      v-lazy:background-image="media.preview_url"
                      class="fw-200 fh-150 bg-position-center"
                    ></div>
                  </template>

                  <template v-if="isVideo(media)">
                    <video :width="200" :height="150" controls>
                      <source :src="media.url" />
                    </video>
                  </template>

                  <template v-else-if="isPdf(media)">
                    <div class="fw-200 fh-150 d-flex align-items-center justify-content-center">
                      <img src="/images/messages/pdf.png" width="100" />
                    </div>
                  </template>

                  <template v-else-if="isAudio(media)">
                    <div class="fw-200 fh-150 d-flex align-items-center justify-content-center">
                      <audio controls class="audio-player mx-2 mx-safari">
                        <source :src="media.url"/>
                      </audio>
                    </div>
                  </template>
                </div>
              </div>
            </div>
            <div class="card-footer" v-if="isManageMode">
              <div class="d-flex">
                <div class="d-flex align-items-center mt-1 mr-auto">
                  <input class="select-media-cb mr-1" type="checkbox" :value="media" v-model="selectedMedias" />
                  <b>{{ media.type }}</b>
                  <a @click="download(media)" role="button" class="ml-auto text-sm text-info"
                    ><i class="fas fa-download"></i
                  ></a>
                </div>
                <a @click="download(media)" role="button" class="download-icon mt-1"
                  ><i class="dripicons-cloud-download"></i
                ></a>
              </div>
              <small class="w-100">
                登録：<b>{{ formattedDate(media.created_at) }}</b>
              </small>
            </div>
          </div>
        </div>
      </div>

      <div class="d-flex align-items-center mt-2" v-if="medias && medias.length > 0">
        <b-pagination
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="loadPage"
          aria-controls="my-table"
        ></b-pagination>

        <div class="d-flex align-items-center ml-auto" v-if="isManageMode">
          <label for="selectAllMemberCb" class="d-flex align-items-center m-0 mr-2">
            <input
              id="selectAllMemberCb"
              class="mr-1"
              type="checkbox"
              value="1"
              v-model="checkedAll"
              @change="selectAllMedia"
            />
            全てのメディアをチェック
          </label>
          <button
            class="btn btn-danger btn-sm"
            :disabled="!(selectedMedias.length > 0)"
            data-toggle="modal"
            data-target="#modalDeleteConfirm"
          >
            チェックしたメディアをリストから削除する
          </button>
        </div>
      </div>

      <div class="text-center mt-5" v-if="(!medias || medias.length === 0) && !loading">
        <b>登録したメディアはありません。</b>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>

    <modal-confirm
      title="選択したものを削除してもよろしいですか？"
      id="modalDeleteConfirm"
      type="delete"
      @confirm="deleteSelectedMedia"
      v-if="isManageMode"
    >
      <template v-slot:content> 選択したメディア数：{{ selectedMedias.length }} </template>
    </modal-confirm>

    <modal-upload-media :types="[curUploadType]" @upload="onUploadFinished"></modal-upload-media>
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';
import * as moment from 'moment';

export default {
  props: {
    types: {
      type: Array,
      default: () => ['image', 'audio', 'video', 'richmenu']
    },
    mode: {
      type: String,
      default: 'read'
    },
    filterable: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      currentPage: 1,
      selectedMedias: [],
      checkedAll: false,
      curUploadType: 'image'
    };
  },
  async beforeMount() {
    this.setFilter(this.types);
    await this.getMedias();
    this.loading = false;
  },

  computed: {
    ...mapState('media', {
      medias: state => state.medias,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage
    }),

    isManageMode() {
      return this.mode === 'manage';
    }
  },

  methods: {
    ...mapMutations('media', ['setCurPage', 'setFilter', 'resetFilter']),
    ...mapActions('media', ['getMedias', 'deleteMedias']),

    forceRerender() {
      this.contentKey++;
    },

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getMedias();
        this.checkedAll = false;
        this.selectedMedias = [];
        this.forceRerender();
        this.loading = false;
      });
    },

    onUploadFinished() {
      location.reload();
    },

    // Select media for sending new message
    selectMedia(media) {
      this.$emit('select', media);
    },

    // Select all media for delete
    selectAllMedia() {
      this.selectedMedias = this.checkedAll === true ? this.medias : [];
    },

    async deleteSelectedMedia() {
      this.loading = true;
      const mediaIds = this.selectedMedias.map(_ => _.id);
      const response = await this.deleteMedias(mediaIds);
      if (response) {
        Util.showSuccessThenRedirect('選択したメディアの削除は完了しました。', window.location.href);
      } else {
        window.toastr.error('選択したメディアの削除は失敗しました。');
      }
      this.loading = false;
    },

    formattedDate(time) {
      return moment(time).format('YYYY年MM月DD日');
    },

    isImage(media) {
      return media.type === 'image' || media.type === 'richmenu' || media.type === 'imagemap';
    },

    isVideo(media) {
      return media.type === 'video';
    },

    isAudio(media) {
      return media.type === 'audio';
    },

    isPdf(media) {
      return media.type === 'pdf';
    },

    download(media) {
      var a = document.createElement('a');
      a.href = media.download_url;
      a.download = media.file_name;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    },

    resetData() {
      this.currentPage = 1;
      this.loadPage();
    }
  }
};
</script>

<style lang="scss" scoped>
  .mvh-90 {
    min-height: 90vh !important;
  }

  .media-preview {
    background-position-y: center;
  }

  .media-preview:hover {
    opacity: 0.5;
  }

  .preview-icon {
    color: #aab4ad;
    font-size: 8rem;
  }

  .thumb-item {
    margin: 0 auto 5px;
    cursor: pointer;
    display: inline-block;
    overflow: hidden;
  }
  .thumb-item:hover {
    .thumbnail-item {
      border: 2px solid #00b900;
      box-shadow: 0 0 2px 2px #e6ab92;
    }
    .chat-item-voice {
      border: 2px solid #00b900;
      box-shadow: 0 0 2px 2px #e6ab92;
    }
  }

  .select-media-cb {
    zoom: 1.4;
  }

  .bg-position-center {
    background-position: center;
    background-size: cover;
  }

  .download-icon {
    font-size: 1rem;
  }

  .audio-player {
    width: 100%;
  }

@media screen and (min-color-index:0) and(-webkit-min-device-pixel-ratio:0){
  .mx-safari {
    margin: 0 1px !important;
  }
}
</style>
