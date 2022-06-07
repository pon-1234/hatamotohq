<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="stream_route"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />
        <div class="flex-grow-1" :key="contentKey">
          <a
            v-if="folders && folders.length && curFolder"
            :href="`${rootPath}/user/stream_routes/new?folder_id=${curFolder.id}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規登録
          </a>
          <div class="mt-2 table-responsive" v-if="curFolder">
            <table class="table table-centered mb-0 text-nowrap">
              <thead class="thead-light">
                <tr>
                  <th class="fw-200 stream-route-name-column-label">流入経路名称</th>
                  <th>アクション</th>
                  <th>友達追加時設定</th>
                  <th>集計</th>
                  <th class="d-none d-xl-table-cell">登録日時</th>
                  <th class="d-none d-xl-table-cell">フォルダー</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(streamRoute, index) in curFolder.stream_routes" v-bind:key="streamRoute.id">
                  <td class="mw-300 stream-route-name-column-value">
                    <div class="stream-url-text-wrap">
                      <label style="display: block;">
                          {{streamRoute.name}}
                      </label>
                      <div class="input-group input-group-sm d-flex flex-column flex-xl-row stream-route-url-container">
                        <input type="text" class="form-control input-sm stream-route-url-input" :value="streamRoute.stream_route_url" disabled>
                        <span class="input-group-btn">
                          <button type="button" class="btn btn-default copy-btn" @click="copyUrl(streamRoute.stream_route_url)">
                            <span class="glyphicon glyphicon-copy uil-copy"></span>
                          </button>
                          <a href="" target="_blank" class="btn btn-default qr-btn" @click="showQrCodeOfStreamRoute = streamRoute" data-toggle="modal" data-target="#modalShowQRCode">QR</a>
                        </span>
                      </div>
                    </div>
                  </td>

                  <td>
                    <ChoseActionsPresentor v-if="streamRoute.actions" :actions="streamRoute.actions[0] && streamRoute.actions[0].data ? streamRoute.actions[0].data.actions : {}"></ChoseActionsPresentor>
                    <span v-else>-</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{streamRoute.run_add_friend_actions ? '無視しない' : '無視する'}}</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{streamRoute.friend_count}}人</span>
                    <a class="btn btn-default border p-1" :href="`${rootPath}/user/stream_routes/${streamRoute.id}`">詳細</a>
                  </td>
                  <td class="d-none d-xl-table-cell">
                    <div class="text-sm text-nowrap">{{streamRoute.created_at | formatted_time}}</div>
                  </td>
                  <td class="d-none d-xl-table-cell">
                    <div class="text-sm text-nowrap">{{curFolder.name}}</div>
                  </td>
                  <td>
                    <div class="btn-group">
                      <button
                        type="button"
                        class="btn btn-light btn-sm dropdown-toggle"
                        data-toggle="dropdown"
                        aria-expanded="false"
                      >
                        操作 <span class="caret"></span>
                      </button>
                      <div class="dropdown-menu">
                        <a
                          class="dropdown-item"
                          :href="`${rootPath}/user/stream_routes/${streamRoute.id}/edit`"
                        >
                        編集する
                        </a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyStreamRoute"
                          @click="curStreamRouteIndex = index"
                        >
                          複製する
                        </a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteStreamRoute"
                          @click="curStreamRouteIndex = index"
                        >
                          削除する
                        </a>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.stream_routes && curFolder.stream_routes.length === 0">
              <b>流入経路はありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>

    <!-- START: Delete folder modal -->
    <modal-confirm
      title="このフォルダーを削除してもよろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @confirm="submitDeleteFolder"
    >
      <template v-slot:content v-if="curFolder">
        <span>フォルダー名：{{ curFolder.name }}</span>
      </template>
    </modal-confirm>
    <!-- END: Delete folder modal -->

    <modal-confirm
      title="この流入経路を削除してもよろしいですか？"
      id="modalDeleteStreamRoute"
      type="delete"
      @confirm="submitDeleteStreamRoute"
    >
      <template v-slot:content>
        <div v-if="curStreamRoute">
          流入経路名：<b>{{ curStreamRoute.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <modal-confirm
      title="この流入経路をコーピーしてもよろしいですか？"
      id="modalCopyStreamRoute"
      type="confirm"
      @confirm="submitCopyStreamRoute"
    >
      <template v-slot:content>
        <div v-if="curStreamRoute">
          流入経路名：<b>{{ curStreamRoute.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <show-qr-code-modal :streamRoute="showQrCodeOfStreamRoute"></show-qr-code-modal>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      isPc: true,
      selectedFolderIndex: 0,
      curStreamRouteIndex: null,
      loading: false,
      contentKey: 0,
      showQrCodeOfStreamRoute: null
    };
  },
  async beforeMount() {
    await this.getStreamRoutes();
    const folderId = Util.getParamFromUrl('folder_id');
    setTimeout(() => {
      if (folderId) {
        const index = _.findIndex(this.folders, _ => _.id === Number.parseInt(folderId));
        if (index >= 0) {
          this.onSelectedFolderChanged(index);
        }
      }
    }, 0);

    this.loading = false;
  },

  computed: {
    ...mapState('streamRoute', {
      folders: state => state.foldersIncludeStreamRoutes
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curStreamRoute() {
      return this.curFolder && this.curStreamRouteIndex ? this.curFolder.stream_routes[this.curStreamRouteIndex] : null;
    }
  },
  methods: {
    ...mapActions('streamRoute', [
      'getStreamRoutes',
      'deleteStreamRoute',
      'copyStreamRoute',
      'deleteFolder',
      'createFolder',
      'updateFolder'
    ]),

    onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
    },

    forceRerender() {
      this.contentKey++;
    },

    async submitCreateFolder(folder) {
      const response = await this.createFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの作成は完了しました。');
      } else {
        window.toastr.error('フォルダーの作成は失敗しました。');
      }
    },

    async submitUpdateFolder(folder) {
      const response = await this.updateFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの変更は完了しました。');
      } else {
        window.toastr.error('フォルダーの変更は失敗しました。');
      }
    },

    async submitDeleteFolder() {
      const response = await this.deleteFolder(this.curFolder.id);
      if (response) {
        window.toastr.success('フォルダーの削除は完了しました。');
        this.onSelectedFolderChanged(0);
      } else {
        window.toastr.error('フォルダーの削除は失敗しました。');
      }
    },

    async submitDeleteStreamRoute() {
      const response = await this.deleteStreamRoute(this.curStreamRoute.id);
      const url = `${this.rootPath}/user/stream_routes?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('流入経路の削除は完了しました。', url);
      } else {
        window.toastr.error('流入経路の削除は失敗しました。');
      }
      this.forceRerender();
    },

    copyUrl(url) {
      navigator.clipboard.writeText(url);
      window.toastr.success('コピーしました');
    },

    async submitCopyStreamRoute() {
      const response = await this.copyStreamRoute(this.curStreamRoute.id);
      if (response) {
        window.toastr.success('この流入経路をコーピは完了しました。');
        const url = `${this.rootPath}/user/stream_routes?folder_id=${this.curFolder.id}`;
        Util.showSuccessThenRedirect('この流入経路をコーピは完了しました。', url);
      } else {
        window.toastr.error('この流入経路をコーピは失敗しました。');
      }
    }
  }
};
</script>
<style lang="scss" scoped>
  .copy-btn, .qr-btn {
    padding-top: 4.2px;
    padding-bottom: 4.2px;
    border: 1px solid #dee2e6;
  }
  .copy-btn {
    border-left: none;
  }

  @media screen and (max-width: 1366px) {
    .stream-route-url-input {
      width: 180px !important;
    }
    .stream-route-name-column-label, .stream-route-name-column-value {
      min-width: auto !important;
      max-width: auto !important;
      width: auto !important;
    }
    .stream-route-url-container {
      gap: 5px 0;
    }
    .copy-btn {
      border-left: 1px solid #dee2e6;
    }
  }
</style>