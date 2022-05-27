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
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="fw-200">流入経路名称</th>
                  <th>アクション</th>
                  <th>友達追加時設定</th>
                  <th>集計</th>
                  <th>登録日時</th>
                  <th>フォルダー</th>
                  <th>操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(streamRoute, index) in curFolder.stream_routes" v-bind:key="streamRoute.id">

                  <td style="min-width: 300px;">
                    <div class="stream-url-text-wrap">
                      <label for="itemcheck_307640" style="display: block;">
                          {{streamRoute.name}}
                      </label>
                      <div class="input-group input-group-sm d-flex">
                        <input type="text" class="form-control input-sm" :value="streamRoute.stream_route_url" disabled>
                        <span class="input-group-btn">
                          <button type="button" class="btn btn-default copy-btn" @click="copyUrl(streamRoute.stream_route_url)">
                            <span class="glyphicon glyphicon-copy uil-copy"></span>
                          </button>
                          <a href="" target="_blank" class="btn btn-default qr-btn" @click="showQrCodeOfStreamRoute = streamRoute" data-toggle="modal" data-target="#modalTemplatePreview">QR</a>
                        </span>
                      </div>
                    </div>
                  </td>

                  <td class="">
                    <ChoseActionsPresentor v-if="streamRoute.actions" :actions="streamRoute.actions[0].data.actions"></ChoseActionsPresentor>
                    <span v-else>-</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{streamRoute.run_add_friend_actions ? '無視しない' : '無視する'}}</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{streamRoute.friend_count}}人</span>
                  </td>
                  <td>
                    <div class="text-sm text-nowrap">{{streamRoute.created_at | formatted_time}}</div>
                  </td>
                  <td>
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
                          role="button"
                          class="dropdown-item"
                          @click="toggleUpdateSiteItem(index)"
                        >
                        編集する
                        </a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteSite"
                          @click="curSiteIndex = index"
                        >
                          複製する
                        </a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteSite"
                          @click="curSiteIndex = index"
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

    <!-- START: Delete site modal -->
    <modal-confirm
      title="このサイトを削除してもよろしいですか？"
      id="modalDeleteSite"
      type="delete"
      @confirm="submitDeleteSite"
    >
      <template v-slot:content>
        <div v-if="curSite">
          サイト名：<b>{{ curSite.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete site modal -->
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
      listUpdate: false,
      selectedFolderIndex: 0,
      selectedSiteIndex: null,
      curSiteIndex: null,
      loading: false,
      contentKey: 0,
      showQrCodeOfStreamRoute: null
    };
  },
  async beforeMount() {
    await this.getStreamRoutes();
    await this.getSites();
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
    // ...mapState('site', {
    //   folders: state => state.folders
    // }),

    ...mapState('streamRoute', {
      folders: state => state.foldersIncludeStreamRoutes
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curSite() {
      return this.curFolder && this.curSiteIndex ? this.curFolder.sites[this.curSiteIndex] : null;
    }
  },
  methods: {
    ...mapActions('site', [
      'getSites',
      'deleteFolder',
      'createFolder',
      'updateFolder',
      'updateSite',
      'deleteSite'
    ]),

    ...mapActions('streamRoute', ['getStreamRoutes']),

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

    toggleUpdateSiteItem(no) {
      if (this.selectedSiteIndex === no) this.selectedSiteIndex = null;
      else this.selectedSiteIndex = no;
    },

    async submitUpdateSite(site) {
      if (!site.notChange) {
        const response = await this.updateSite(site);
        if (response) {
          window.toastr.success('サイト名の変更は完了しました。');
        } else {
          window.toastr.error('サイト名の変更は失敗しました。');
        }
        this.selectedSiteIndex = null;
        await this.getSites();
      } else {
        this.selectedSiteIndex = null;
      }
      this.forceRerender();
    },

    async submitDeleteSite() {
      const response = await this.deleteSite(this.curSite.id);
      const url = `${this.rootPath}/user/sites?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('サイトの削除は完了しました。', url);
      } else {
        window.toastr.error('サイトの削除は失敗しました。');
      }
      this.forceRerender();
    },

    formattedDate(date) {
      return Util.formattedDate(date);
    },

    copyUrl(url) {
      navigator.clipboard.writeText(url);
      window.toastr.success('コピーしました');
    }
  }
};
</script>
<style lang="scss">
  .copy-btn, .qr-btn {
    padding-top: 4.2px;
    padding-bottom: 4.2px;
    border: 1px solid #dee2e6;
  }
  .copy-btn {
    border-left: none;
  }

</style>