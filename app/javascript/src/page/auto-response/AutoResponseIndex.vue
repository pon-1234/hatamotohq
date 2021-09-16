<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="auto_response"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolder"
          @changeSelectedFolder="changeSelectedFolder"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
          />
        <div class="flex-grow-1">
          <div class="tag-header">
            <div class="col-r">
              <a v-if="folders && folders.length && folders[selectedFolder]" :href="MIX_ROOT_PATH + '/user/auto_responses/new?folder_id='+folders[selectedFolder].id" class="btn btn-primary">
                <i class="fa fa-plus"></i> 新規作成
              </a>
            </div>
          </div>
          <div class="mt-2">
            <table class="table">
              <thead>
                <tr>
                  <th>自動応答名</th>
                  <th>キーワード</th>
                  <th>メッセージ</th>
                  <th class="fw-100">操作</th>
                  <th>登録日</th>
                  <th>状況</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="autoResponse in autoResponses" v-bind:key="autoResponse.id">
                  <td>{{autoResponse.name}}</td>
                  <td>
                    <div><small>どれか1つにマッチ</small></div>
                    <span class="mr-1" v-for="(tag, index) in autoResponse.keywords" v-bind:key="index"><span v-if="index > 0">or</span>「{{tag}}」</span>
                  </td>
                  <td>
                    <div v-for="(item, index) in autoResponse.messages" v-bind:key="index" class="mt-2">
                      <message-content :data="item.content" ></message-content>
                    </div>
                  </td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-warning" @click="openEdit(autoResponse)">編集</button>
                      <button type="button" class="btn btn-warning dropdown-toggle dropdown-icon" data-toggle="dropdown" aria-expanded="false"></button>
                      <div class="dropdown-menu bg-white" role="menu" style="">
                        <a role="button" class="dropdown-item" @click="updateAutoResponseStatus(autoResponse)">{{ autoResponse.status === 'enable' ? 'OFF' : 'ON'}}にする</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item" >自動応答を編集する</a>
                        <div class="dropdown-divider"></div>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modal-delete" @click="showModal(autoResponse)">自動応答を削除する</a>
                      </div>
                    </div>
                  </td>

                  <td><span>{{ formattedDate(autoResponse.created_at) }}</span></td>
                  <td>
                    <template v-if="autoResponse.status === 'enable'">
                      <span class="badge badge-success p-2">有効</span>
                    </template>
                    <template v-else>
                      <span class="badge badge-warning p-2">無効</span>
                    </template>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="!autoResponses || autoResponses.length === 0">自動応答はありません。</div>
          </div>
        </div>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>
    <div class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <p class="mb10 fz14">以下の自動応答メッセージを削除します。よろしいですか？</p>
            <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between" v-if="autoResponse">
              <dt>タイトル</dt>
              <dd>{{autoResponse.title}}</dd>
              <dt>キーワード</dt>
              <dd>
                <ul class="list-tag list-unstyled no-mgn">
                  <li class="tag mr-1" v-for="tag in tags(autoResponse.keyword)" v-bind:key="tag">{{tag}}</li>
                </ul>
              </dd>
              <dt>内容</dt>
              <dd>
                <div v-for="(item, index) in autoResponse.messages" v-bind:key="index">
                  <message-content :data="item.content" ></message-content>
                </div>
              </dd>
            </dl>
          </div>
          <div class="modal-footer flex center">
            <button type="button" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="submitDeleteAutoResponse(autoResponse)">削除</button>
            <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteFolder"/>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      autoResponse: null,
      isPc: true,
      selectedFolder: 0,
      autoResponses: [],
      loading: true
    };
  },

  async beforeMount() {
    await this.$store.dispatch('autoResponse/getAutoResponses');
    this.loading = false;
  },

  computed: {
    ...mapState('system', {
      success: state => state.success
    }),
    ...mapState('autoResponse', {
      folders: state => state.folders
    })
  },

  watch: {
    folders: {
      handler(val) {
        this.autoResponses = val[this.selectedFolder] ? val[this.selectedFolder].auto_responses : [];
      },
      deep: true
    }
  },

  created() {
    if (PerformanceNavigation.type !== PerformanceNavigation.TYPE_RELOAD) {
      if (Util.getParamFromUrl('is_updated') === 'true') {
        window.toastr.success('自動応答メッセージの変更は完成しました');
      }

      if (Util.getParamFromUrl('is_created') === 'true') {
        window.toastr.success('自動応答を登録しました');
      }
    }
  },

  methods: {
    ...mapActions('auto_response', [
      'deleteAutoResponse',
      'updateAutoResponse',
      'createFolder',
      'deleteFolder',
      'editFolder'
    ]),

    showModal(message) {
      this.autoResponse = message;
    },

    tags(strtag) {
      return typeof (strtag) === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    async updateAutoResponseStatus(autoResponse) {
      const payload = { id: autoResponse.id, status: autoResponse.status === 'enable' ? 'disable' : 'enable' };
      await this.updateAutoResponse(payload);
    },

    async submitDeleteAutoResponse() {
      if (this.autoResponse) {
        await this.deleteAutoResponse({ id: this.autoResponse.id, folder_id: this.autoResponse.folder_id });
      }
    },

    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.autoResponses = this.folders[index].autoResponses;
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
      this.$store.dispatch('autoResponse/createFolder', value);
    },

    backToFolder() {
      this.isPc = false;
    },

    submitDeleteFolder() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.folders[this.selectedFolder].id, type: 'auto_message' })
        .done(res => {
          this.deleteFolder(this.folders[this.selectedFolder].id);
          this.selectedFolder -= 1;
          this.autoResponses = this.folders[this.selectedFolder].autoResponses;
        }).fail(e => {
        });
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

    td .chat-item>.sticker-static {
      width: 50px !important;
    }

    td .chat-item {
      padding: 0px;
    }
  }
</style>
