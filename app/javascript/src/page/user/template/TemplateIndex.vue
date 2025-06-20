<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="template_message"
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
            :href="`${rootPath}/user/templates/new?folder_id=${curFolder.id}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規作成
          </a>
          <div class="mt-2" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>テンプレート名</th>
                  <th>メッセージ数</th>
                  <th>操作</th>
                  <th>フォルダー</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(template, index) in curFolder.templates" v-bind:key="template.id">
                  <td>
                    <div class="fw-300 text-truncate">{{ template.name }}</div>
                  </td>
                  <td class="fw-150 d-flex justify-content-center align-items-center template-message-count-wrapper">
                    <span class="template-message-count">{{ template.template_messages_count }}</span>
                    <div
                      class="btn btn-sm btn-light my-1"
                      data-toggle="modal"
                      data-target="#modalTemplatePreview"
                      @click="curTemplateIndex = index"
                    >
                      プレビュー
                    </div>
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
                          :href="`${rootPath}/user/templates/${template.id}/edit`"
                          target="_blank"
                          >テンプレートを編集</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopyTemplate"
                          @click="curTemplateIndex = index"
                          >テンプレートをコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteTemplate"
                          @click="curTemplateIndex = index"
                          >テンプレートを削除</a
                        >
                      </div>
                    </div>
                  </td>
                  <td>
                    <div>
                      <div class="mxw-200 text-truncate">{{ curFolder.name }}</div>
                    </div>
                    <div class="text-sm">{{ formattedDate(template.created_at) }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.templates.length === 0">
              <b>テンプレートはありません。</b>
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

    <!-- START: Delete template modal -->
    <modal-confirm
      title="このテンプレートを削除してもよろしいですか？"
      id="modalDeleteTemplate"
      type="delete"
      @confirm="submitDeleteTemplate"
    >
      <template v-slot:content>
        <div v-if="curTemplate">
          テンプレート名：<b>{{ curTemplate.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete template modal -->

    <!-- START: Copy template modal -->
    <modal-confirm
      title="このテンプレートをコピーしてもよろしいですか？"
      id="modalCopyTemplate"
      type="confirm"
      @confirm="submitCopyTemplate"
    >
      <template v-slot:content>
        <div v-if="curTemplate">
          テンプレート名：<b>{{ curTemplate.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy template modal -->
    <modal-template-preview :templateId="curTemplate.id" v-if="curTemplate"></modal-template-preview>
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
      curTemplateIndex: null,
      loading: true,
      contentKey: 0
    };
  },

  async beforeMount() {
    await this.getTemplates();
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
    ...mapState('template', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curTemplate() {
      return this.curFolder ? this.curFolder.templates[this.curTemplateIndex] : null;
    }
  },

  methods: {
    ...mapActions('template', [
      'getTemplates',
      'deleteTemplate',
      'copyTemplate',
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

    async submitDeleteTemplate() {
      const response = await this.deleteTemplate(this.curTemplate.id);
      const url = `${this.rootPath}/user/templates?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('テンプレートの削除は完了しました。', url);
      } else {
        window.toastr.error('テンプレートの削除は失敗しました。');
      }
      this.forceRerender();
    },

    async submitCopyTemplate() {
      const response = await this.copyTemplate(this.curTemplate.id);
      const url = `${this.rootPath}/user/templates?folder_id=${this.curFolder.id}`;
      if (response) {
        Util.showSuccessThenRedirect('テンプレートのコピーは完了しました。', url);
      } else {
        Util.showSuccessThenRedirect('テンプレートのコピーは失敗しました。', url);
      }
      this.forceRerender();
    },

    backToFolder() {
      this.isPc = false;
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
  
  :deep(.template-message-count-wrapper) {
    gap: 0 6px;

    .template-message-count {
      margin-top: 1px;
    }
  }
</style>
