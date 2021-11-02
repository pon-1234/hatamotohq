<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="auto_response"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />
        <div class="flex-grow-1">
          <div class="col-r">
            <a
              v-if="folders && folders.length && folders[selectedFolderIndex]"
              :href="rootPath + '/user/auto_responses/new?folder_id=' + folders[selectedFolderIndex].id"
              class="btn btn-primary"
            >
              <i class="uil-plus"></i> 新規作成
            </a>
          </div>
          <div class="mt-2">
            <table class="table mb-0 table-centered">
              <thead class="thead-light">
                <tr>
                  <th class="mw-100">自動応答名</th>
                  <th class="mw-120">キーワード</th>
                  <th class="mw-100">メッセージ</th>
                  <th class="fw-100">状況</th>
                  <th class="fw-100">ヒット数</th>
                  <th class="fw-100">操作</th>
                  <th class="mw-150">フォルダー</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="autoResponse in autoResponses" v-bind:key="autoResponse.id">
                  <td>
                    <div class="mxw-400 max-2-lines">{{ autoResponse.name }}</div>
                  </td>
                  <td>
                    <div><small>どれか1つにマッチ</small></div>
                    <div>
                      <span
                        class="badge badge-pill badge-warning mr-1 pt-1"
                        v-for="(keyword, index) in autoResponse.keywords"
                        v-bind:key="index"
                      >
                        <div class="mxw-200 text-truncate">{{ keyword }}</div>
                      </span>
                    </div>
                  </td>
                  <td>
                    <div v-for="(item, index) in autoResponse.messages" v-bind:key="index" class="text-left">
                      <message-content :data="item.content"></message-content>
                    </div>
                  </td>

                  <td>
                    <template v-if="autoResponse.status === 'enabled'">
                      <i class="mdi mdi-circle text-success"></i> 有効
                    </template>
                    <template v-else> <i class="mdi mdi-circle"></i> 無効 </template>
                  </td>

                  <td>
                    {{ autoResponse.hit_count }}
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
                        <a role="button" class="dropdown-item" @click="openEdit(autoResponse)">自動応答を編集</a>
                        <a role="button" class="dropdown-item" @click="updateAutoResponseStatus(autoResponse)"
                          >{{ autoResponse.status === "enabled" ? "OFF" : "ON" }}にする</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyAutoResponse"
                          @click="showConfirmCopyModal(autoResponse)"
                          >自動応答をコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteAutoResponse"
                          @click="showConfirmDeleteModal(autoResponse)"
                          >自動応答を削除</a
                        >
                      </div>
                    </div>
                  </td>
                  <td>
                    <div v-if="curFolder">{{ curFolder.name }}</div>
                    <span class="font-12">{{ formattedDate(autoResponse.created_at) }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="!autoResponses || autoResponses.length === 0">
              <b>自動応答はありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>

    <!-- START: Delete folder modal -->
    <modal-confirm id="modalDeleteFolder" title="フォルダー" type="delete" @confirm="submitDeleteFolder">
      <template v-slot:content v-if="folders[selectedFolderIndex]">
        <span>フォルダ名：{{ folders[selectedFolderIndex].name }}</span>
      </template>
    </modal-confirm>
    <!-- END: Delete folder modal -->

    <!-- START: Delete auto response modal -->
    <modal-confirm
      id="modalDeleteAutoResponse"
      title="自動応答を削除してもよろしいですか？"
      type="delete"
      @confirm="submitDeleteAutoResponse(autoResponse)"
    >
      <template v-slot:content v-if="autoResponse">
        <div>
          <span>自動応答: {{ autoResponse.name }}</span>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete auto response modal -->

    <!-- START: Copy auto response modal -->
    <modal-confirm
      id="modalCopyAutoResponse"
      type="confirm"
      title="自動応答をコピーしてもよろしいですか？"
      @confirm="submitCopyAutoResponse()"
    >
      <template v-slot:content v-if="autoResponse">
        <div>
          <span>自動応答: {{ autoResponse.name }}</span>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy auto response modal -->
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
      autoResponses: [],
      autoResponse: null,
      loading: true
    };
  },

  async beforeMount() {
    await this.getAutoResponses();
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
    ...mapState('autoResponse', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    }
  },

  watch: {
    folders: {
      handler(val) {
        this.autoResponses = val[this.selectedFolderIndex] ? val[this.selectedFolderIndex].auto_responses : [];
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('autoResponse', [
      'getAutoResponses',
      'deleteAutoResponse',
      'updateAutoResponse',
      'copyAutoResponse',
      'createFolder',
      'deleteFolder',
      'updateFolder'
    ]),

    showConfirmDeleteModal(autoResponse) {
      this.autoResponse = autoResponse;
    },

    showConfirmCopyModal(autoResponse) {
      this.autoResponse = autoResponse;
    },

    tags(strtag) {
      return typeof strtag === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    async updateAutoResponseStatus(autoResponse) {
      const payload = { id: autoResponse.id, status: autoResponse.status === 'enabled' ? 'disabled' : 'enabled' };
      const response = await this.updateAutoResponse(payload);
      const url = `${this.rootPath}/user/auto_responses?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('自動応答状況の変更は完了しました。', url);
      } else {
        window.toastr.error('自動応答状況の変更は失敗しました。');
      }
    },

    async submitDeleteAutoResponse() {
      if (!this.autoResponse) return;
      const response = await this.deleteAutoResponse(this.autoResponse.id);
      const url = `${this.rootPath}/user/auto_responses?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('自動応答の削除は完了しました。', url);
      } else {
        window.toastr.error('自動応答の削除は失敗しました。');
      }
    },

    onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
      this.autoResponses = this.folders[index].auto_responses;
    },

    async submitUpdateFolder(folder) {
      const response = await this.updateFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの変更は完了しました。');
      } else {
        window.toastr.error('フォルダーの変更は失敗しました。');
      }
    },

    async submitCreateFolder(value) {
      const response = await this.createFolder(value);
      if (response) {
        window.toastr.success('フォルダーの作成は完了しました。');
      } else {
        window.toastr.error('フォルダーの作成は失敗しました。');
      }
    },

    async submitDeleteFolder() {
      const response = await this.deleteFolder(this.folders[this.selectedFolderIndex].id);
      if (response) {
        window.toastr.success('フォルダーの削除は完了しました。');
        this.onSelectedFolderChanged(0);
      } else {
        window.toastr.error('フォルダーの削除は失敗しました。');
      }
    },

    async submitCopyAutoResponse() {
      const response = await this.copyAutoResponse(this.autoResponse.id);
      const url = `${this.rootPath}/user/auto_responses?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('自動応答のコピーは完了しました。', url);
      } else {
        window.toastr.error('自動応答のコピーは失敗しました。');
      }
    },

    backToFolder() {
      this.isPc = false;
    },

    openEdit(autoResponse) {
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/auto_responses/${autoResponse.id}/edit`;
    },

    formattedDate(date) {
      return Util.formattedDate(date);
    }
  }
};
</script>
<style lang="scss"  scoped>
  ::v-deep {
    td .emojione {
      width: 20px !important;
    }

    td .chat-item > .sticker-static {
      width: 50px !important;
    }

    td .chat-item {
      padding: 0px;
    }

    .chat-item-text {
      text-align: left;
    }
  }
</style>
