<template>
  <div>
    <filter-message type="template" @input="changeFilter" :folderId="messages[selectedFolder] && messages[selectedFolder].id"/>
    <div>
      <folder-left
        type="template_message"
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
          </div>
        </div>
        <div class="tag-content">
          <!--<table class="table table-tags-header">-->
            <!--<thead>-->
            <!--<tr>-->
              <!--<th class="w5" style="height: 42px"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
              <!--<th v-if="messages[selectedFolder]">{{messages[selectedFolder].name}}</th>-->
            <!--</tr>-->
            <!--</thead>-->
          <!--</table>-->

          <div class="x-tag-header">
            <div class="x-btn-back">
              <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
            <div class="x-title"
                 v-if="messages[selectedFolder]">{{messages[selectedFolder].name}}
            </div>
          </div>

          <div class="tag-scroll">
            <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
              <table class="table table-hover table-message-content">
                <thead>
                  <tr>
                    <th class="w10">No.</th>
                    <th class="w15">タイトル</th>
                    <th class="w25"></th>
                  </tr>
                </thead>
                <tbody v-if="messagesContent && messagesContent.length">
                  <tr v-for="(item, index) in messagesContent" :key="index">
                    <td >{{index + 1}}</td>
                    <td >{{item.title}}</td>
                    <td>
                      <div class="row-btn row-btn-customize">
                        <div class="btn-edit01 mr-2" data-toggle="tooltip" title="編集"><a :href="`${MIX_ROOT_PATH}/template/streams/${item.id}`" class="btn-more btn-more-linebot btn-block"><i class="fas fa-edit"></i></a></div>
                        <div class="btn-copy01 mr-2" data-toggle="tooltip" title="複製">
                          <a href="#" class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-confirm"  @click="setMessageDetail(item, index)"><i class="fas fa-copy"></i></a></div>
                        <div class="btn-delete01" data-toggle="tooltip"  title="削除">
                          <a class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-delete" @click="setMessageDetail(item, index)">
                            <i class="fas fa-trash-alt"></i>
                          </a>
                        </div>
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
    <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteFolder"/>
    <modal-confirm title="コピーしますか？" type='confirm' @input="confirmCopy"/>
    <modal-confirm title="以下のメッセージを削除します。よろしいですか？" type='delete' @input="submitDeleteMessage" id="modal-delete"/>
    <modal-tags :tags="tags"/>
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
      tags: [],
      isPc: true,
      selectedFolder: 0,
      messageContentIndex: 0,
      messagesContent: []
    };
  },
  watch: {
    messages: {
      handler(val) {
        this.messagesContent = val[this.selectedFolder] ? val[this.selectedFolder].message_templates : [];
      },
      deep: true
    },
    success: {
      handler(val) {
        if (val.status) {
          this.$toastr.s(val.message);
        } else {
          this.$toastr.e(val.message);
        }
      },
      deep: true
    }
  },

  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getQueryParamsUrl('is_updated') === 'true') {
        this.$toastr.s('メッセージテンプレートの変更は完成しました');
      }

      if (Util.getQueryParamsUrl('is_created') === 'true') {
        this.$toastr.s('メッセージを登録しました');
      }
    }
  },

  computed: {
    ...mapState('messageTemplate', {
      messages: state =>
        state.messages,
      params: state =>
        state.params
    }),
    ...mapState('system', {
      success: state => state.success
    })
  },

  beforeMount() {
    this.fetchItem();
  },

  methods: {
    ...mapActions('messageTemplate', [
      'fetchListMessageTemplate',
      'copyMessage',
      'deleteMessage',
      'editFolder',
      'deleteFolder',
      'createFolder'
    ]),

    async fetchItem() {
      await this.fetchListMessageTemplate(this.params);
    },

    setMessageDetail(message, index) {
      this.messageDetail = message;
      this.messageContentIndex = index;
    },

    submitDeleteMessage() {
      this.deleteMessage({ id: this.messageDetail.id, index: this.messageContentIndex, folder_id: this.messageDetail.folder_id });
    },

    async changeFilter(value) {
      this.messagesContent = this.messages[this.selectedFolder].message_templates.filter(item => item.title.includes(value.keyword));
    },

    confirmCopy() {
      this.copyMessage({ id: this.messageDetail.id, index: this.messageContentIndex });
    },

    async changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.messagesContent = this.messages[this.selectedFolder].message_templates;
    },

    async submitEditFolder(value) {
      await this.editFolder(value);
    },

    async submitAddNewFolder(value) {
      await this.createFolder(value);
    },

    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    backToFolder() {
      this.isPc = false;
    },

    submitDeleteFolder() {
      this.deleteFolder({ id: this.messages[this.selectedFolder].id, type: 'template_message' });
      if (this.selectedFolder === this.messages.length - 1) {
        this.selectedFolder -= 1;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
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
  margin-bottom: 0px!important;
  thead {
    border-bottom: none!important;
    th {
      height: 49px;
      border-bottom: none!important;
      position: sticky; top: 0;
      background:#e0e0e0;
      border-radius: 0px!important;
    }
  }
}
</style>
