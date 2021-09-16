<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex mt-2">
        <folder-left
          type="template_message"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
          />
        <div class="flex-grow-1">
          <div class="tag-header">
            <div class="col-r">
              <a v-if="folders && folders.length && folders[selectedFolderIndex]" :href="MIX_ROOT_PATH + '/user/templates/new?folder_id='+folders[selectedFolderIndex].id" class="btn btn-primary">
                <i class="fa fa-plus"></i> 新規作成
              </a>
            </div>
          </div>
          <div class="mt-2">
            <table class="table">
              <thead>
                <tr>
                  <th>テンプレート名</th>
                  <th>メッセージ数</th>
                  <th class="fw-120">操作</th>
                  <th class="fw-150">フォルダ</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="template in templates" v-bind:key="template.id">
                  <td>{{template.name}}</td>
                  <td>{{template.template_messages_count}}</td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-primary" @click="openEdit(template)">編集</button>
                      <button type="button" class="btn btn-primary dropdown-toggle dropdown-icon" data-toggle="dropdown" aria-expanded="false"></button>
                      <div class="dropdown-menu bg-white" role="menu" style="">
                        <a role="button" class="dropdown-item" @click="openEdit(template)">テンプレートを編集</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item">テンプレートをコビー</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteTemplate" @click="showConfirmDeleteModal(template)">テンプレートを削除</a>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div>{{ folders[selectedFolderIndex].name }}</div>
                    <div class="text-sm">{{ formattedDate(template.created_at) }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="templates.length === 0">テンプレートはありません。</div>
          </div>
        </div>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>

    <!-- START: Delete folder modal -->
    <modal-confirm id="modalDeleteFolder" type='delete' @confirm="submitDeleteFolder">
      <template v-slot:content v-if="folders[selectedFolderIndex]">
        <span>フォルダ名：{{ folders[selectedFolderIndex].name }}</span>
      </template>
    </modal-confirm>
    <!-- END: Delete folder modal -->

    <!-- START: Delete auto response modal -->
    <modal-confirm id='modalDeleteTemplate' type='delete' @confirm="submitDeleteTemplate(template)">
      <template v-slot:content>
        <div v-if="template">
          {{template.name}}
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete auto response modal -->
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
      templates: [],
      template: null,
      loading: true
    };
  },

  async beforeMount() {
    await this.getTemplates();
    this.loading = false;
  },

  computed: {
    ...mapState('system', {
      success: state => state.success
    }),
    ...mapState('template', {
      folders: state => state.folders
    })
  },

  watch: {
    folders: {
      handler(val) {
        this.templates = val[this.selectedFolderIndex] ? val[this.selectedFolderIndex].templates : [];
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('template', [
      'getTemplates',
      'botDelete',
      'updateAutoResponse',
      'deleteFolder',
      'editFolder',
      'createFolder'
    ]),

    showConfirmDeleteModal(template) {
      this.template = template;
    },

    tags(strtag) {
      return typeof (strtag) === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    async updateAutoResponseStatus(autoResponse) {
      const payload = { id: autoResponse.id, status: autoResponse.status === 'enable' ? 'disable' : 'enable' };
      await this.updateAutoResponse(payload);
    },

    async deleteBotMessage() {
      if (this.template) {
        await this.botDelete({ id: this.template.id, folder_id: this.template.folder_id });
      }
    },

    onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
      this.templates = this.folders[index].templates;
    },

    submitUpdateFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.editFolder(res);
        }).fail(e => {
        });
    },

    async submitCreateFolder(value) {
      this.createFolder(value);
    },

    backToFolder() {
      this.isPc = false;
    },

    submitDeleteFolder() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.folders[this.selectedFolderIndex].id, type: 'auto_message' })
        .done(res => {
          this.deleteFolder(this.folders[this.selectedFolderIndex].id);
          this.selectedFolderIndex -= 1;
          this.templates = this.folders[this.selectedFolderIndex].templates;
        }).fail(e => {
        });
    },

    openEdit(autoResponse) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/templates/${autoResponse.id}/edit`);
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

    td .chat-item>.sticker-static {
      width: 50px !important;
    }

    td .chat-item {
      padding: 0px;
    }
  }
</style>
