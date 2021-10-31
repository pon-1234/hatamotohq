<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="rich_menu"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />

        <div class="flex-grow-1">
          <div v-if="curFolder">
            <a :href="`${rootPath}/user/rich_menus/new?folder_id=${curFolder.id}`" class="btn btn-primary">
              <i class="uil-plus"></i> 新規作成
            </a>
          </div>
          <div class="mt-2 table-responsive" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>リッチメニュー名</th>
                  <th class="mw-120">状況</th>
                  <th>メニュー初期状態</th>
                  <th class="mw-200">画像</th>
                  <!-- <th class="mw-120">メンバー数</th> -->
                  <th class="mw-80">操作</th>
                  <th>フォルダー</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(richmenu, index) in curFolder.rich_menus" v-bind:key="index">
                  <td class="font-weight-bold">{{ richmenu.name }}</td>
                  <td>
                    <rich-menu-status :status="richmenu.status"></rich-menu-status>
                  </td>
                  <td>
                    <span v-if="richmenu.selected">表示する</span>
                    <span v-else>表示しない</span>
                  </td>
                  <td>
                    <div v-lazy:background-image="richmenu.image_url" class="fw-120 fh-81 thumbnail"></div>
                  </td>
                  <!-- <td>{{ richmenu.member_count }}</td> -->
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
                        <a role="button" class="dropdown-item" :href="`${rootPath}/user/rich_menus/${richmenu.id}/edit`"
                          >リッチメニューを編集</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalToggleRichMenu"
                          @click="curRichMenuIndex = index"
                          >{{ richmenu.status === "enabled" ? "無効" : "有効" }}にする</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyRichMenu"
                          @click="curTemplateIndex = index"
                          >リッチメニューをコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteRichMenu"
                          @click="curTemplateIndex = index"
                          >リッチメニューを削除</a
                        >
                      </div>
                    </div>
                  </td>
                  <td>
                    <div>{{ curFolder.name }}</div>
                    <div>{{ richmenu.created_at }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.rich_menus.length === 0">
              <b>リッチメニューはありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>
    <!-- START: modal delete folder -->
    <modal-confirm
      title="こちらのフォルダーを削除してもよろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @confirm="submitDeleteFolder"
    >
      <template v-slot:content v-if="curFolder"> フォルダー名：{{ curFolder.name }} </template>
    </modal-confirm>
    <!-- END: modal delete folder -->

    <!-- START: modal delete richmenu -->
    <modal-confirm
      title="こちらのリッチメニューを削除してもよろしいですか？"
      id="modalDeleteRichMenu"
      type="delete"
      @confirm="submitDeleteRichMenu"
    >
      <template v-slot:content v-if="curRichMenu"> リッチメニュー名：{{ curRichMenu.name }} </template>
    </modal-confirm>
    <!-- END: modal delete richmenu -->

    <!-- START: modal copy richmenu -->
    <modal-confirm
      title="こちらのリッチメニューをコピーしてもよろしいですか？"
      id="modalCopyRichMenu"
      type="confirm"
      @confirm="submitCopyRichMenu"
    >
      <template v-slot:content v-if="curRichMenu"> リッチメニュー名：{{ curRichMenu.name }} </template>
    </modal-confirm>
    <!-- END: modal copy richmenu -->

    <!-- START: modal enable/disable richmenu -->
    <modal-confirm
      :title="`このリッチメニューの状況を変更してもよろしいですか？`"
      id="modalToggleRichMenu"
      type="confirm"
      @confirm="submitToggleRichMenu"
    >
      <template v-slot:content v-if="curRichMenu">
        状況変更：<b>{{ curRichMenu.status === "enabled" ? "有効" : "無効" }}</b>
        <i class="mdi mdi-arrow-right-bold"></i> <b>{{ curRichMenu.status === "enabled" ? "無効" : "有効" }}</b>
      </template>
    </modal-confirm>
    <!-- END: modal delete richmenu -->
  </div>
</template>

<script>
import moment from 'moment';
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: [],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: true,
      isPc: true,
      selectedFolderIndex: 0,
      curRichMenuIndex: 0
    };
  },

  async beforeMount() {
    await this.getRichMenus();
    this.loading = false;
  },

  computed: {
    ...mapState('richmenu', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curRichMenu() {
      return this.curFolder ? this.curFolder.rich_menus[this.curRichMenuIndex] : null;
    }
  },

  methods: {
    ...mapActions('richmenu', [
      'getRichMenus',
      'createFolder',
      'updateFolder',
      'deleteFolder',
      'updateRichMenu',
      'copyRichMenu',
      'deleteRichMenu'
    ]),

    async onFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
      this.foldersContent = this.folders[this.selectedFolderIndex].richmenus;
    },

    // TODO: should move it to folder component
    async submitCreateFolder(folder) {
      await this.createFolder(folder);
    },

    async submitUpdateFolder(folder) {
      await this.updateFolder(folder);
    },

    async submitDeleteFolder() {
      await this.deleteFolder(this.curFolder.id);
      this.onFolderChanged(0);
    },

    async submitCopyRichMenu() {
      const response = await this.copyRichMenu(this.curRichMenu.id);
      if (response) {
        Util.showSuccessThenRedirect('リッチメニュのコピーは完了しました。', window.location.href);
      } else {
        window.$toastr.error('リッチメニュのコピーは失敗しました。');
      }
    },

    async submitDeleteRichMenu() {
      const response = await this.deleteRichMenu(this.curRichMenu.id);
      if (response) {
        Util.showSuccessThenRedirect('リッチメニュの削除は完了しました。', window.location.href);
      } else {
        window.$toastr.error('リッチメニュの削除は失敗しました。');
      }
    },

    async submitToggleRichMenu() {
      const payload = {
        id: this.curRichMenu.id,
        status: this.curRichMenu.status === 'enabled' ? 'disabled' : 'enabled'
      };
      const response = await this.updateRichMenu(payload);
      if (response) {
        Util.showSuccessThenRedirect('リッチメニュ状況の変更は完了しました。', window.location.href);
      } else {
        window.$toastr.error('リッチメニュ状況の変更は失敗しました。');
      }
    },

    formatDateTime(time) {
      return moment(time)
        .tz(moment.tz.guess())
        .format('YYYY年MM月DD日 HH:mm');
    },

    backToFolder() {
      this.isPc = false;
    }
  }
};
</script>

<style scoped lang="scss">
  .thumbnail {
    background-size: cover;
  }
</style>
