<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="rich_menu"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="changeSelectedFolder"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />

        <div class="flex-grow-1">
          <div v-if="curFolder">
            <a :href="`${MIX_ROOT_PATH}/user/rich_menus/new?folder_id=${curFolder.id}`" class="btn btn-primary btn-sm">
              <i class="fa fa-plus"></i> 新規作成
            </a>
          </div>
          <div class="mt-2" v-if="curFolder">
            <table class="table index">
              <thead>
                <tr>
                  <th class="w-30p">リッチメニュー名</th>
                  <th class="w-5p">状況</th>
                  <th class="w-15p">メニュー初期状態</th>
                  <th class="w-20p">画像</th>
                  <th class="w-10p">メンバー数</th>
                  <th class="w-10p">操作</th>
                  <th class="w-10p">フォルダ</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(richmenu, index) in curFolder.rich_menus"
                  v-bind:key="index"
                >
                  <td class="font-weight-bold">{{ richmenu.name }}</td>
                  <td>
                    <div class="badge badge-success">有効</div>
                  </td>
                  <td>表示しない</td>
                  <td>
                    <img :src="richmenu.image_url" class="fw-120 fh-81">
                  </td>
                  <td>0</td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-primary" @click="openEdit(richmenu)">編集</button>
                      <button type="button" class="btn btn-primary dropdown-toggle dropdown-icon" data-toggle="dropdown" aria-expanded="false"></button>
                      <div class="dropdown-menu bg-white" role="menu" style="">
                        <a role="button" class="dropdown-item" @click="openEdit(richmenu)">リッチメニューを編集</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item" @click="openEdit(richmenu)">無効にする</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item">リッチメニューをコビー</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteRichmenu" @click="showConfirmDeleteModal(richmenu)">リッチメニューを削除</a>
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
    <!-- モーダル -->
    <div
      class="modal fade modal-delete modal-common01"
      id="modal-delete"
      tabindex="-1"
      role="dialog"
      aria-labelledby="myModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
            <p class="mb10 fz14">
              以下のリッチメニューを削除します。よろしいですか？
            </p>
            <dl
              class="flex group-modal01 no-mgn flex-wrap justify-content-between"
            >
              <dt>タイトル</dt>
              <dd>{{ curRichMenu.title }}</dd>
              <dt>表示期間</dt>
              <dd>
                {{ formatDateTime(curRichMenu.start_date) }} ～
                {{ formatDateTime(curRichMenu.end_date) }}
              </dd>
            </dl>
          </div>
          <div class="modal-footer flex center">
            <button
              type="button"
              class="btn btn-common01 btn-modal-delete"
              @click="deleteRichMenu"
              data-dismiss="modal"
            >
              削除
            </button>
            <button
              type="button"
              class="btn btn-common01 btn-modal-cancel"
              data-dismiss="modal"
            >
              キャンセル
            </button>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm
      title="このフォルダを削除します。よろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @input="submitDeleteFolder"
    />
  </div>
</template>

<script>
import moment from 'moment';
import { mapActions, mapState } from 'vuex';

export default {
  props: [],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      loading: true,
      curRichMenu: {
        title: '',
        start_date: '',
        end_date: ''
      },
      isBusy: true,
      richMenusContent: [],
      isPc: true,
      selectedFolderIndex: 0
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
    }
  },

  methods: {
    ...mapActions('richmenu', [
      'getRichMenus',
      'createFolder',
      'updateFolder'
    ]),

    async deleteRichMenu() {
      await this.$store.dispatch('richmenu/destroyRichmenu', {
        richMenuId: this.curRichMenu.id
      });

      this.folders[this.selectedFolderIndex].richmenus.deleteWhere(
        (richmenu) => richmenu.id === this.curRichMenu.id
      );
    },

    async changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
      this.foldersContent = this.folders[this.selectedFolderIndex].richmenus;
    },

    async submitCreateFolder(folder) {
      await this.createFolder(folder);
    },

    async submitUpdateFolder(folder) {
      await this.updateFolder(folder);
    },

    async submitDeleteFolder() {
      await this.deleteFolder();
      // this.$store
      //   .dispatch('global/deleteFolder', {
      //     id: this.folders[this.selectedFolderIndex].id,
      //     type: 'scenario'
      //   })
      //   .done((res) => {
      //     this.folders.splice(this.selectedFolderIndex, 1);
      //   })
      //   .fail((e) => {});
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
