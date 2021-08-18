<template>
  <div
    class="modal fade modal-template modal-common01"
    :id="name"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content" style="    padding: 0 15px;">
        <div class="modal-header">
          <h4 class="modal-title">Flexメッセージを選択</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <div class="tag-list">
            <div class="">
              <div class="col-md-4 tag-content-left p-0">
                <div class="tag-content">
                  <div class="folder-list-title">
                    <table class="table table-tags-header">
                      <thead class="thead-light">
                      <tr>
                        <th scope="col" class="header-title">フォルダ</th>
                        <th scope="col" style="text-align: right">
                        </th>
                      </tr>
                      </thead>
                    </table>
                  </div>
                  <div class="tag-scroll folder-list">
                    <div class="folder-item new-folder" v-if="isAddMoreFolder">
                      <div class="input-group newgroup-inputs">
                        <input type="text" placeholder="フォルダ名" v-model.trim="folderForm.name" class="form-control">
                        <span class="input-group-btn"></span>
                      </div>
                    </div>
                    <div v-if="loading.folderLoading">
                      Loading...
                    </div>
                    <flexmesasge-folder-item
                      v-else
                      v-for="(item, index) in folderLists"
                      :key="index"
                      :data="item"
                      :active="folderId == item.id"
                      :disableEditor="true"
                      :index="index"
                      @changeSelected="folderId = ($event).folderId"
                    />
                  </div>
                </div>
              </div>
              <div class="col-md-8 tag-content-right" :class="currentFolder !== null? 'show': ''">
                <div class="tag-content" style="background: rgb(249, 249, 249);">
                  <table class="table table-tags-header" v-if="currentFolder !== null">
                    <thead class="thead-light">
                    <tr>
                      <th class="hidden-pc">
                        <i class="fa fa-arrow-left" @click="backToFolder"></i>
                      </th>
                      <th class="header-title folder-title">
                        {{ currentFolder.name || '' }}
                      </th>
                      <!--<th style="text-align: right">-->
                      <!---->
                      <!--</th>-->
                    </tr>
                    </thead>
                  </table>

                  <div class="tag-scroll tag-list">
                    <div v-if="loading.flexMessageLoading">
                      Loading...
                    </div>
                    <table class="table" style="max-width: initial !important;" v-else>
                      <tbody>
                      <div v-if="flexMessageList && flexMessageList.length">
                        <template v-for="(item, index) in flexMessageList" >
                          <tr style="display: flex;" :key="index">
                            <td class="flex-item">
                              <span>{{item.name}}</span>
                            </td>
                            <td style="text-align: right; width: auto">
                              <a
                                @click="(currentFlexMessage === item? currentFlexMessage= null: currentFlexMessage = item)"
                                class="btn-more btn-more-linebot btn-block cursor-pointer">
                                プレビュー
                              </a>
                              <a class="btn-more btn-more-linebot btn-block cursor-pointer" @click="pickFlexMessage(item)"
                                data-dismiss="modal">
                                選択
                              </a>
                            </td>
                          </tr>
                          <tr v-if="item === currentFlexMessage" style="background: #ededed;" :key="index+'_preview'">
                            <td colspan="2">
                              <div v-html="item.html_template" style="zoom: 0.6"></div>
                            </td>
                          </tr>
                        </template>
                      </div>
                      <div v-else class="text-center mt40">
                        データーがありません
                      </div>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <flexmessage-modal-preview
              :id="'flexMessagePreview'"
              :model="currentFlexMessage"
              v-if="currentFlexMessage != null"/>

          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['name'],
  data() {
    return {
      isAddMoreFolder: false,
      folderId: this.folder_id,
      currentFolder: null,
      currentFlexMessage: null,
      folderForm: {
        name: ''
      },
      loading: {
        folderLoading: false,
        flexMessageLoading: false
      },

      folderLists: [],
      flexMessageList: []
    };
  },

  watch: {
    folderId(val) {
      if (val && val > 0) {
        this.folderFlexMessages(val);
      }
    }
  },

  mounted() {
    this.indexFolders();
  },
  methods: {
    backToFolder() {
      this.currentFolder = null;
    },

    folderFlexMessages(id, isLoading = true) {
      this.currentFolder = this.folderLists.firstWhere((folder) => folder.id === id);
      if (this.currentFolder) {
        this.folderId = id;
      }

      this.loading.flexMessageLoading = isLoading;
      this.$store.dispatch('flexMessage/folderFlexMessages', {
        folderId: id
      }).done((res) => {
        this.flexMessageList = res;
      }).always(() => {
        this.loading.flexMessageLoading = false;
      });
    },
    indexFolders(isLoading = true) {
      this.loading.folderLoading = isLoading;
      this.$store.dispatch('flexMessage/indexFolders').done((res) => {
        this.folderLists = res;
        if (this.folderId && this.folderId > 0) {
          this.folderFlexMessages(this.folderId, isLoading);
        } else if (this.folderLists.length > 0) {
          this.folderId = this.folderLists[0].id;
        }
      }).always(() => {
        this.loading.folderLoading = false;
      });
    },

    pickFlexMessage(item) {
      this.$emit('input', item);
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .modal-common01.fade .modal-dialog {
      -webkit-transform: translateY(-50%);
      transform: translateY(-50%);
    }

    .sample-item {
      width: 30%;
      margin-bottom: 20px;
      cursor: pointer;
      display: inline-block;
    }
    .label {
      color: #1b1b1b;
    }

    .modal-dialog {
      top: 0 !important;
      margin: auto;
      transform: translateY(0) !important;
      padding: 80px !important;
      max-width: 1000px;
    }
    .flex-item {
      flex: 1;
      max-width: 400px;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      line-height: 2em;
    }
    @media (max-width: 1000px) {
      .flex-item {
        max-width: 700px;
      }

      .tag-content {
        height: 70vh !important;
      }
      .sample-item {
        width: 40%;
      }
      .modal-dialog {
        margin: auto;
        padding: 80px 20px !important;

      }
    }
    @media (max-width: 768px) {
      .flex-item {
        flex: 1;
        max-width: 500px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
        line-height: 2em;
      }

      .tag-content {
        height: 45vh !important;
      }
      .modal-dialog {
        padding: 40px 0 !important;

        position: relative;
        width: auto;
        margin: auto;
        max-width: 95%;
      }
    }

  }

  .btn-block {
    display: inline-block;
    width: auto;
    font-size: 13px;
    padding: 7px;
  }

  .header-title {
    font-size: 19px;
    flex: 1;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .tag-list {
    position: relative;

  }

  .tag-header {
    color: white;
  }

  .tag-content {
    height: 70vh;
    background-color: #f0f0f0;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    .tag-scroll {
      height: 100%;
      overflow-x: auto;
      overflow-y: auto;
      margin: 0 0;
      display: flex;
      flex-direction: column;
    }
  }

  .tag-content-left {
    padding-right: 0px !important;
    min-width: 250px;
  }

  .tag-content-right {
    max-width: calc(100% - 250px);

  }

  .thead-light {
    width: 100%;
  }

  .table-tags-header {
    margin-bottom: 0px !important;
    min-height: 47px;
    display: flex;
    max-width: initial !important;
    margin-top: 0px!important;
  }

  .table-tags-header tr {
    display: flex;
    vertical-align: middle;
  }

  .item-sm {
    display: none;
  }

  .folder-list {
    min-width: 200px;
  }

  .hidden-pc {
    display: none;
  }

  .new-folder {
    background: #fff3a0 !important;
    padding: 10px;
  }

  .tag-item {
    background: white;
  }

  .show {
    display: initial;
  }

  @media (max-width: 991px) {
    .hidden-pc {
      display: initial;
      width: auto;
      line-height: 2em;
    }

    .item-pc {
      display: none !important;
    }

    .item-sm {
      display: inline-block !important;
    }

    .fa-arrow-left {
      margin-right: 10px;
      cursor: pointer;
      line-height: 1.9em;
    }

    .tag-content-left {
      /*padding-right: 15px !important;*/
      min-width: initial;
    }

    .tag-content-right {
      display: none;
      max-width: initial;
      position: absolute;
      z-index: 1;
      top: 0;
      right: 0;
      left: 0;
      bottom: 0;
      .tag-scroll {
        padding-left: 10px;
        padding-right: 10px;

      }
    }

  }

  .btn-sm {
    font-size: 12px !important;
    padding: 5px 8px;
    color: white;
  }

  ::v-deep {
    .modal-common01.fade .modal-dialog {
      -webkit-transform: translateY(-50%);
      transform: translateY(-50%);
    }

    .folder-title {
      white-space: nowrap;
      width: 20%;
    }

    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }
    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }

  }

.tag-scroll {
  table {
    margin-top: 0px!important;
  }
}
</style>
