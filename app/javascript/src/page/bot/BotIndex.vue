<template>
  <div>
    <div class="row-ttl01 d-flex ai_center mb40 flex-wrap justify-content-between bot  align-items-center">
      <div class="col-l flex">
        <h3 class="hdg3">自動応答一覧</h3>
      </div>
    </div>
   <div>
    <folder-left
      type="auto_message"
      :data="messages"
      :isPc="isPc"
      :selectedFolder="selectedFolder"
      @changeSelectedFolder="changeSelectedFolder"
      @submitEditFolder="submitEditFolder"
      @submitAddNewFolder="submitAddNewFolder"
      />
      <div :class="getClassRightTag()">
        <div class="tag-header">
          <div class="col-r">
            <div class="btn-common02 fz14" v-if="messages && messages.length && messages[selectedFolder]">
              <a :href="MIX_ROOT_PATH + '/bots/create?folder_id='+messages[selectedFolder].id"><span>新規作成</span></a>
            </div>
          </div>
        </div>
        <div class="tag-content">
          <div style="height: 41px; display: flex; padding-right: 10px">
            <div style="width: 41px;display: inline-flex;vertical-align: middle;height: 100%;justify-content: center; margin: 0">
              <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
            <div style="flex: 1 1 0%; overflow: hidden;text-overflow: ellipsis;margin: auto; font-weight: bold;"
                 v-if="messages && messages.length && messages[selectedFolder]">{{messages[selectedFolder].name}}
            </div>
          </div>
          <div class="tag-scroll">
            <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
              <table class="table table-hover table-bot">
                <thead>
                  <tr>
                    <th class="w10">設定</th>
                    <th class="w25" >タイトル</th>
                    <th class="w25">キーワード</th>
                    <th class="w25">内容</th>
                    <th class="w30" style="min-width: 150px">操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="message in messagesContent" v-bind:key="message.id">
                    <td class=" fz14">
                      <div class="toggle-switch" style="margin: auto;">
                        <input v-bind:id="message.id" class="toggle-input" type="checkbox"
                                v-model="message.status" true-value="enable"
                                false-value="disable" @change="botEditMessage(message)">
                        <label v-bind:for="message.id" class="toggle-label" />
                        <span></span>
                      </div>
                    </td>
                    <td class="w25" style="max-width: 200px; text-overflow: ellipsis; white-space: nowrap; word-break: break-word; overflow: hidden;">{{message.title}}</td>
                    <td class="">
                      <ul class="list-tag list-unstyled no-mgn" >
                        <li class="tag mr-1" v-for="tag in tags(message.keyword)" v-bind:key="tag">{{tag}}</li>
                      </ul>
                    </td>
                    <td class=" fz12">
                      <div v-for="(item, index) in message.auto_message_content_distributions" v-bind:key="index">
                        <view-message-content :data="item.content" ></view-message-content>
                      </div>
                    </td>
                    <td class=" row-btn">
                      <div class="btn-edit01" data-toggle="tooltip" title="編集">
                        <a v-bind:href="MIX_ROOT_PATH + '/bots/' + message.id + '/edit'" class="btn-more btn-more-linebot btn-block">
                          <i class="fas fa-edit"></i>
                        </a>
                      </div>
                      <div class="btn-delete01" data-toggle="tooltip" title="削除">
                        <a class="btn-more btn-more-linebot btn-block" @click="showModal(message)"
                            data-toggle="modal" data-target="#modal-delete">
                          <i class="fas fa-trash-alt"></i>
                        </a>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
         </div>
      </div>
   </div>

    <div class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <p class="mb10 fz14">以下の自動応答メッセージを削除します。よろしいですか？</p>
            <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between" v-if="messageDetail">
              <dt>タイトル</dt>
              <dd>{{messageDetail.title}}</dd>
              <dt>キーワード</dt>
              <dd>
                <ul class="list-tag list-unstyled no-mgn">
                  <li class="tag mr-1" v-for="tag in tags(messageDetail.keyword)" v-bind:key="tag">{{tag}}</li>
                </ul>
              </dd>
              <dt>内容</dt>
              <dd>
                <div v-for="(item, index) in messageDetail.auto_message_content_distributions" v-bind:key="index">
                  <view-message-content :data="item.content" ></view-message-content>
                </div>
              </dd>
            </dl>
          </div>
          <div class="modal-footer flex center">
            <button type="button" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="deleteBotMessage(messageDetail)">削除</button>
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
      messageDetail: null,
      isPc: true,
      selectedFolder: 0,
      messagesContent: []
    };
  },

  beforeMount() {
    this.getListBot();
  },

  computed: {
    ...mapState('system', {
      success: state => state.success
    }),
    ...mapState('bot', {
      messages: state => state.messages
    })
  },

  watch: {
    success: {
      handler(val) {
        if (val.status) {
          this.$toastr.s(val.message);
        } else {
          this.$toastr.e(val.message);
        }
      },
      deep: true
    },
    messages: {
      handler(val) {
        this.messagesContent = val[this.selectedFolder] ? val[this.selectedFolder].auto_messages : [];
      },
      deep: true
    }
  },

  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getQueryParamsUrl('is_updated') === 'true') {
        this.$toastr.s('自動応答メッセージの変更は完成しました');
      }

      if (Util.getQueryParamsUrl('is_created') === 'true') {
        this.$toastr.s('自動応答を登録しました');
      }
    }
  },

  methods: {
    ...mapActions('bot', [
      'getList',
      'botDelete',
      'botEdit',
      'deleteFolder',
      'editFolder',
      'createFolder'
    ]),

    showModal(message) {
      this.messageDetail = message;
    },

    tags(strtag) {
      return typeof (strtag) === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    async getListBot() {
      await this.getList();
    },

    async botEditMessage(message) {
      message.keywords = this.tags(message.keyword);
      await this.botEdit({ message: message, isLoad: false });
    },

    async deleteBotMessage() {
      if (this.messageDetail) {
        await this.botDelete({ id: this.messageDetail.id, folder_id: this.messageDetail.folder_id });
      }
    },

    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    async changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.messagesContent = this.messages[index].auto_messages;
    },

    submitEditFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.editFolder(res);
        }).fail(e => {
        });
    },

    submitAddNewFolder(value) {
      this.$store
        .dispatch('global/createFolder', value)
        .done(res => {
          this.createFolder(res);
        }).fail(e => {
        });
    },

    backToFolder() {
      this.isPc = false;
    },

    submitDeleteFolder() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.messages[this.selectedFolder].id, type: 'auto_message' })
        .done(res => {
          this.deleteFolder(this.messages[this.selectedFolder].id);
          this.selectedFolder -= 1;
          this.messagesContent = this.messages[this.selectedFolder].auto_messages;
        }).fail(e => {
        });
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

.table-responsive > .table > thead > tr > th {
  white-space: nowrap !important;
  height: 49px;
}

.btn-action {
  white-space: nowrap;
  width: auto!important;
}

.tag-header {
  height: 40px;
  color: white;
  .col-r {
    display: inline-flex;
    float: right;
  }
  button {
    color: black!important;
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
  margin-bottom: 0px!important;
}

.item-sm {
  display: none;
}

@media (max-width: 991px) {
  .item-pc {
    display: none!important;
  }

  .item-sm {
    display: inline-block!important;
  }

  .fa-arrow-left {
    cursor: pointer;
  }

}

.table-responsive {
  overflow-x: scroll;
  overflow-y: auto;
  height: 100%;
  margin-bottom: 0px!important;
  thead {
    border-bottom: none!important;
    th {
      padding: 8px!important;
      border-bottom: none!important;
      position: sticky; top: 0;
      background:#e0e0e0;
      border-radius: 0px!important;
    }
  }
}

.table-bot {
  min-width: 800px;
}

.col-r {
  float: right;
}
</style>
