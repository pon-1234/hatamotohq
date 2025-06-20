<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="variable"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />
        <div class="flex-grow-1 folder-right" :key="contentKey">
          <a
            v-if="folders && folders.length && curFolder"
            :href="`${rootPath}/user/variables/new?folder_id=${curFolder.id}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規作成
          </a>
          <div class="table-responsive mt-2" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="mw-150">友だち情報欄名</th>
                  <th class="mw-120">既定値</th>
                  <th class="mw-60">人数</th>
                  <th class="mw-60">操作</th>
                  <th class="mw-150">フォルダー</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(variable, index) in curFolder.variables" v-bind:key="variable.id">
                  <td>
                    <p class="item-name vw-10">{{ variable.name }}</p>
                  </td>
                  <td>
                    <p class="item-name vw-10">{{ variable.default || "-" }}</p>
                  </td>
                  <td>{{ variable.friends_count }}</td>
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
                        <a role="button" class="dropdown-item" @click="openEdit(variable)">友だち情報欄を編集</a>
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyVariable"
                          @click="curVariableIndex = index"
                          >友だち情報欄をコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteVariable"
                          @click="curVariableIndex = index"
                          v-if="variable.destroyable"
                          >友だち情報欄を削除</a
                        >
                      </div>
                    </div>
                  </td>
                  <td>
                    <div>{{ curFolder.name }}</div>
                    <div class="text-sm">{{ formattedDate(variable.created_at) }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.variables.length === 0">
              <b>友だち情報欄はありません。</b>
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

    <!-- START: Delete variable modal -->
    <modal-confirm
      title="この友だち情報欄を削除してもよろしいですか？"
      id="modalDeleteVariable"
      type="delete"
      @confirm="submitDeleteVariable"
    >
      <template v-slot:content>
        <div v-if="curVariable">
          友だち情報欄名：<b>{{ curVariable.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete variable modal -->

    <!-- START: Copy variable modal -->
    <modal-confirm
      title="この友だち情報欄をコピーしてもよろしいですか？"
      id="modalCopyVariable"
      type="confirm"
      @confirm="submitCopyVariable"
    >
      <template v-slot:content>
        <div v-if="curVariable">
          友だち情報欄名：<b>{{ curVariable.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy variable modal -->
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: import.meta.env.VITE_ROOT_PATH,
      isPc: true,
      selectedFolderIndex: 0,
      curVariableIndex: null,
      loading: true,
      contentKey: 0
    };
  },

  async beforeMount() {
    await this.getFolders();
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
    ...mapState('variable', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curVariable() {
      return this.curFolder ? this.curFolder.variables[this.curVariableIndex] : null;
    }
  },

  methods: {
    ...mapActions('variable', [
      'getFolders',
      'deleteVariable',
      'copyVariable',
      'deleteFolder',
      'createFolder',
      'updateFolder'
    ]),

    forceRerender() {
      this.contentKey++;
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

    async submitCreateFolder(folder) {
      const response = await this.createFolder(folder);
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

    async submitDeleteVariable() {
      const response = await this.deleteVariable(this.curVariable.id);
      const url = `${this.rootPath}/user/variables?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('友だち情報欄の削除は完了しました。', url);
      } else {
        Util.showErrorThenRedirect('友だち情報欄の削除は失敗しました。', url);
      }
      this.forceRerender();
    },

    async submitCopyVariable() {
      const response = await this.copyVariable(this.curVariable.id);
      const url = `${this.rootPath}/user/variables?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('友だち情報欄のコピーは完了しました。', url);
      } else {
        Util.showErrorThenRedirect('友だち情報欄のコピーは失敗しました。', url);
      }
      this.forceRerender();
    },

    backToFolder() {
      this.isPc = false;
    },

    openEdit(variable) {
      window.open(`${import.meta.env.VITE_ROOT_PATH}/user/variables/${variable.id}/edit`);
    },

    formattedDate(date) {
      return Util.formattedDate(date);
    }
  }
};
</script>
<style lang="scss"  scoped>
  :deep(td .emojione) {
    width: 20px !important;
  }

  :deep(td .chat-item > .sticker-static) {
    width: 50px !important;
  }

  :deep(td .chat-item) {
    padding: 0px;
  }
</style>
