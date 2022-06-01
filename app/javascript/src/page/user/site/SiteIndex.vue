<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="site"
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
            :href="`${rootPath}/user/sites/new?folder_id=${curFolder.id}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規登録
          </a>
          <div class="mt-2 table-responsive" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="fw-400">サイト名</th>
                  <th>フォルダー</th>
                  <th>訪問/発行</th>
                  <th>短縮登録</th>
                  <th>作成日</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(site, index) in curFolder.sites" v-bind:key="site.id">
                  <td>
                    <div class="d-flex justify-content-between fw-400">
                      <div class="text-truncate w-75">
                        <site-update-item
                        v-if="selectedSiteIndex === index"
                        :data="site"
                        @editSite="submitUpdateSite"
                        ></site-update-item>
                        <div v-else class="d-flex flex-column">
                          <span>{{site.name}}</span>
                          <a :href="`${site.url}`" target="_blank">{{ site.url}}</a>
                        </div>
                      </div>

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
                          名前を変える
                          </a>
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteSite"
                            @click="curSiteIndex = index"
                          >
                            サイトを削除
                          </a>
                        </div>
                      </div>
                    </div>
                  </td>
                  <td class="">
                    <span class="text-nowrap">{{ curFolder.name }}</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{ site.visitor_count }} 人 / {{site.receiver_count }} 人</span>
                  </td>
                  <td>
                    <span class="text-nowrap">{{ site.sending_count }}回</span>
                  </td>
                  <td>
                    <div class="text-sm text-nowrap">{{ formattedDate(site.created_at) }}</div>
                  </td>
                  <td>
                    <a :href="`/user/sites/${site.id}`"  class="btn btn-sm btn-light">詳細</a>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.sites && curFolder.sites.length === 0">
              <b>URLはありません。</b>
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
      contentKey: 0
    };
  },
  async beforeMount() {
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
    ...mapState('site', {
      folders: state => state.folders
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
    }
  }
};
</script>
<style lang="scss">
</style>