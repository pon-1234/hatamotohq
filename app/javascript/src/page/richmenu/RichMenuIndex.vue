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
            <a :href="`${MIX_ROOT_PATH}/user/rich_menus/new?folder_id=${curFolder.id}`" class="btn btn-primary">
              <i class="uil-plus"></i> 新規作成
            </a>
          </div>
          <div class="mt-2" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>リッチメニュー名</th>
                  <th>状況</th>
                  <th>メニュー初期状態</th>
                  <th>画像</th>
                  <th>メンバー数</th>
                  <th>操作</th>
                  <th>フォルダ</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(richmenu, index) in curFolder.rich_menus"
                  v-bind:key="index"
                >
                  <td class="font-weight-bold">{{ richmenu.name }}</td>
                  <td>
                    <template v-if="richmenu.status === 'enabled'">
                      <i class='mdi mdi-circle text-success'></i> 有効
                    </template>
                    <template v-else>
                      <i class='mdi mdi-circle'></i> 無効
                    </template>
                  </td>
                  <td>表示しない</td>
                  <td>
                    <img :src="richmenu.image_url" class="fw-120 fh-81">
                  </td>
                  <td>0</td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"> 操作 <span class="caret"></span> </button>
                      <div class="dropdown-menu">
                        <a role="button" class="dropdown-item" @click="openEdit(richmenu)">リッチメニューを編集</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalToggleRichMenu" @click="curRichMenuIndex = index">{{ richmenu.status === 'enabled' ? '無効' : '有効' }}にする</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalCopyRichMenu" @click="curTemplateIndex = index">リッチメニューをコピー</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteRichMenu" @click="curTemplateIndex = index">リッチメニューを削除</a>
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
            <div class="text-center mt-5" v-if="curFolder.rich_menus.length === 0"><b>リッチメニューはありません。</b></div>
          </div>
        </div>
      </div>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>
    <!-- START: modal delete folder -->
    <modal-confirm
      title="こちらのフォルダを削除してもよろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @confirm="submitDeleteFolder">
      <template v-slot:content v-if="curFolder">
        フォルダ名：{{ curFolder.name }}
      </template>
    </modal-confirm>
    <!-- END: modal delete folder -->

    <!-- START: modal delete richmenu -->
    <modal-confirm
      title="こちらのリッチメニューを削除してもよろしいですか？"
      id="modalDeleteRichMenu"
      type="delete"
      @confirm="submitDeleteRichMenu">
      <template v-slot:content v-if="curRichMenu">
        リッチメニュー名：{{ curRichMenu.name }}
      </template>
    </modal-confirm>
    <!-- END: modal delete richmenu -->

    <!-- START: modal copy richmenu -->
    <modal-confirm
      title="こちらのリッチメニューをコピーしてもよろしいですか？"
      id="modalCopyRichMenu"
      type="confirm"
      @confirm="submitCopyRichMenu">
      <template v-slot:content v-if="curRichMenu">
        リッチメニュー名：{{ curRichMenu.name }}
      </template>
    </modal-confirm>
    <!-- END: modal copy richmenu -->

    <!-- START: modal enable/disable richmenu -->
    <modal-confirm
      :title="`このリッチメニューの状況を変更してもよろしいですか？`"
      id="modalToggleRichMenu"
      type="confirm"
      @confirm="submitToggleRichMenu">
      <template v-slot:content v-if="curRichMenu">
        状況変更：<b>{{ curRichMenu.status === 'enabled' ? '有効' : '無効' }}</b> <i class="mdi mdi-arrow-right-bold"></i> <b>{{ curRichMenu.status === 'enabled' ? '無効' : '有効' }}</b>
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
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
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
    },

    openEdit(richmenu) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/rich_menus/${richmenu.id}/edit`);
    }
  }
};
</script>

<style scoped lang="scss">
::v-deep {
  @media (min-width: 768px) and (max-width: 1199px) {
    .table-responsive > .table > tbody > tr > td,
    .table-responsive > .table > tbody > tr > th,
    .table-responsive > .table > tfoot > tr > td,
    .table-responsive > .table > tfoot > tr > th,
    .table-responsive > .table > thead > tr > td,
    .table-responsive > .table > thead > tr > th {
      white-space: nowrap !important;
    }
  }

  .form-control[disabled],
  .form-control[readonly],
  fieldset[disabled] .form-control {
    background: white;
  }
}

.tag-header {
  height: 40px;
  color: white;
  .col-r {
    display: inline-flex;
    float: right;
  }
  button {
    color: black !important;
  }
}

.tag-content {
  height: 85vh;
  background-color: #f0f0f0;
  margin-top: 10px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  .tag-scroll {
    height: 100%;
    overflow: hidden;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }
}

.table-tags-header {
  margin-bottom: 0px !important;
}

.richmenu-sm {
  display: none;
}

@media (max-width: 991px) {
  .richmenu-pc {
    display: none !important;
  }

  .richmenu-sm {
    display: inline-block !important;
  }

  .fa-arrow-left {
    margin-right: 10px;
    cursor: pointer;
  }

  .tag-content-right {
    .tag-scroll {
      overflow: hidden;
    }
  }

  .tag-scroll {
    overflow: hidden;
  }
}

.table-message-content {
  min-width: 800px;
}

.table-responsive {
  overflow: auto;
  height: 100%;
  margin-bottom: 0px !important;
  thead {
    border-bottom: none !important;
    th {
      height: 49px;
      border-bottom: none !important;
      position: sticky;
      top: 0;
      background: #e0e0e0;
      border-radius: 0px !important;
    }
  }
}
</style>
