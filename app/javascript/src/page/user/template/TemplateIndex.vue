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
            :href="`${MIX_ROOT_PATH}/user/templates/new?folder_id=${curFolder.id}`"
            data-turbolinks="false"
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
                  <th>フォルダ</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(template, index) in curFolder.templates" v-bind:key="template.id">
                  <td>{{ template.name }}</td>
                  <td>{{ template.template_messages_count }}</td>
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
                        <a role="button" class="dropdown-item" @click="openEdit(template)">テンプレートを編集する</a>
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
                    <div>{{ curFolder.name }}</div>
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
      title="このフォルダを削除してもよろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @confirm="submitDeleteFolder"
    >
      <template v-slot:content v-if="curFolder">
        <span>フォルダ名：{{ curFolder.name }}</span>
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
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      isPc: true,
      selectedFolderIndex: 0,
      curTemplateIndex: null,
      loading: true,
      contentKey: 0
    };
  },

  async beforeMount() {
    await this.getTemplates();
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

    showConfirmDeleteModal(template) {
      this.template = template;
    },

    tags(strtag) {
      return typeof (strtag) === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
    },

    async submitCreateFolder(folder) {
      await this.createFolder(folder);
    },

    async submitUpdateFolder(folder) {
      await this.updateFolder(folder);
    },

    async submitDeleteFolder() {
      await this.deleteFolder(this.curFolder.id);
      this.onSelectedFolderChanged(0);
    },

    async submitDeleteTemplate() {
      const response = await this.deleteTemplate(this.curTemplate.id);
      if (response) {
        window.toastr.success('テンプレートの削除は完了しました。');
      } else {
        window.toastr.error('テンプレートの削除は失敗しました。');
      }
      this.forceRerender();
    },

    async submitCopyTemplate() {
      const response = await this.copyTemplate(this.curTemplate.id);
      if (response) {
        Util.showSuccessThenRedirect('テンプレートのコピーは完了しました。', window.location.href);
      } else {
        Util.showSuccessThenRedirect('テンプレートのコピーは失敗しました。', window.location.href);
      }
      this.forceRerender();
    },

    backToFolder() {
      this.isPc = false;
    },

    openEdit(template) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/templates/${template.id}/edit`);
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
  }
</style>
