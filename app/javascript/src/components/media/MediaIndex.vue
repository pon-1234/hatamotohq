<template>
  <div :class="mode === 'manage' ? 'card mvh-60' : 'card'">
    <div class="card-header d-flex flex-wrap align-items-center">
      <div class="mr-auto" v-if="mode === 'manage'">
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#imageModalCenter"
          @click="curUploadType = 'image'"
        >
          画像アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#imageModalCenter"
          @click="curUploadType = 'audio'"
        >
          音声アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#imageModalCenter"
          @click="curUploadType = 'video'"
        >
          動画アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#imageModalCenter"
          @click="curUploadType = 'richmenu'"
        >
          メニュー画像アップロード
        </a>
        <a
          href="#"
          class="btn btn-success mb-2"
          data-toggle="modal"
          data-target="#imageModalCenter"
          @click="curUploadType = 'pdf'"
        >
          PDFアップロード
        </a>
      </div>
      <div class="ml-auto">
        <media-filter @filterChanged="getMedias"></media-filter>
      </div>
    </div>
    <div class="card-body d-flex flex-column" :key="contentKey">
      <div :class="mode === 'read' ? 'flex-grow-1' : ''">
        <div class="row">
          <div
            v-for="(media, index) in medias"
            :key="index"
            @click="selectMedia(media)"
            :class="mode === 'manage' ? 'col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-2 mb-4 d-flex' : 'col-xs-12 col-md-6 col-lg-4 col-xl-3 mb-4 d-flex'"
          >
            <div class="card w-100">
              <div class="card-body d-flex align-items-center justify-content-center">
                <div class="text-center">
                  <div :class="mode === 'read' ? 'media-preview' : 'media-preview'">
                    <template v-if="media.type === 'image' || media.type === 'richmenu'">
                      <expandable-image
                        v-if="mode === 'manage'"
                        class="image"
                        :src="media.url"
                      />
                      <img v-if="mode === 'read'" :src="media.preview_url" border="0" align="center" role="button"/>
                    </template>
                    <div
                      role="button"
                      class="video"
                      v-if="media.type === 'video'"
                    >
                      <img :src="media.preview_url" border="0" align="center"/>
                    </div>

                    <div
                      role="button"
                      class="file"
                      v-else-if="media.type === 'pdf'"
                    >
                      <img src="/img/pdf_temp.png" border="0" align="center"/>
                    </div>

                    <div
                      role="button"
                      class="file"
                      v-else-if="media.type === 'audio'"
                    >
                      <i class="fas fa-file-audio preview-icon"></i>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card-footer">
                <div class="d-flex align-items-center mt-1">
                  <input
                    v-if="mode === 'manage'"
                    class="select-media-cb mr-1"
                    type="checkbox"
                    :value="media"
                    v-model="selectedMedias"
                  />
                  <b>{{ media.type }}</b>
                  <a
                    v-if="mode === 'manage'"
                    :href="media.url"
                    class="ml-auto text-sm text-info"
                    download
                    ><i class="fas fa-download"></i></a>
                </div>
                <small class="w-100">
                  登録：<b>{{ formattedDate(media.created_at) }}</b>
                </small>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="d-flex align-items-center mt-auto" v-if="medias && medias.length > 0">
        <b-pagination
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="loadPage"
          aria-controls="my-table"
        ></b-pagination>

        <div class="d-flex align-items-center ml-auto" v-if="mode === 'manage'">
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

      <div
        class="text-center mt-5"
        v-if="(!medias || medias.length === 0) && !loading"
      >
        <b>登録したメディアはありません。</b>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>

    <modal-confirm title="選択したものを削除してもよろしいですか？" id='modalDeleteConfirm' type='delete' @confirm="deleteSelectedMedia" v-if="mode === 'manage'">
      <template v-slot:content>
        選択したメディア数：{{ selectedMedias.length }}
      </template>
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
      loading: true,
      contentKey: 0,
      currentPage: 1,
      selectedMedias: [],
      checkedAll: false,
      curUploadType: 'image'
    };
  },
  async beforeMount() {
    await this.getMedias();
    this.loading = false;
  },

  computed: {
    ...mapState('media', {
      medias: (state) => state.medias,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    })
  },

  methods: {
    ...mapMutations('media', ['setCurPage']),
    ...mapActions('media', [
      'getMedias',
      'deleteMedias'
    ]),

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
    }
  }
};
</script>

<style lang="scss" scoped>
  .mvh-90 {
    min-height: 90vh !important;
  }

  .media-preview:hover {
    opacity: 0.5;
  }

  .preview-icon {
    color: #408254;
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
</style>
