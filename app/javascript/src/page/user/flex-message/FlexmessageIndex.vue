<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">Flexメッセージ新規</h3>
    </div>
    <div class="tag-list">
      <div class="">
        <div class="col-md-4 tag-content-left p-0">
          <div class="tag-content">
            <div class="folder-list-title">
              <table class="table table-tags-header">
                <thead class="thead-light">
                  <tr>
                    <th scope="col" class="header-title">フォルダー</th>
                    <th scope="col" style="text-align: right">
                      <button class="add_group btn btn-sm btn-success" @click="addMoreFolder()">
                        <i class="glyphicon glyphicon-plus"></i>
                        新しいフォルダー
                      </button>
                    </th>
                  </tr>
                </thead>
              </table>
            </div>
            <div class="tag-scroll folder-list">
              <div class="folder-item new-folder" v-if="isAddMoreFolder">
                <div class="input-group newgroup-inputs">
                  <input
                    type="text"
                    placeholder="フォルダー名"
                    v-model.trim="folderForm.name"
                    class="form-control"
                    @keyup.enter="enterCreateFolder"
                    @compositionend="compositionend($event)"
                    @compositionstart="compositionstart($event)"
                  />
                  <span class="input-group-btn">
                    <button type="button" class="btn btn-default" @click="createFolder" ref="buttonChange">決定</button>
                  </span>
                </div>
              </div>
              <div v-if="loading.folderLoading">Loading...</div>
              <flexmesasge-folder-item
                v-else
                v-for="(item, index) in folderLists"
                :key="index"
                :data="item"
                :active="folderId == item.id"
                :index="index"
                @changeSelected="folderId = $event.folderId"
                @editFolder="editFolder(item, $event)"
                @deleteFolder="deleteFolder(item)"
              ></flexmesasge-folder-item>
            </div>
          </div>
        </div>
        <div class="col-md-8 tag-content-right" :class="currentFolder !== null ? 'show' : ''">
          <div class="tag-content" style="background: rgb(249, 249, 249)">
            <table class="table table-tags-header" v-if="currentFolder !== null">
              <thead class="thead-light">
                <tr>
                  <th class="">
                    <i class="mdi mdi-arrow-left hidden-pc" @click="backToFolder"></i>
                  </th>
                  <th class="header-title folder-title">
                    {{ currentFolder.name || "" }}
                  </th>
                  <th style="text-align: right">
                    <a
                      :href="`${MIX_ROOT_PATH}/template/flex-messages/folders/${currentFolder.id}/flex/create`"
                      class="btn btn-primary btn-sm"
                    >
                      <i class="glyphicon glyphicon-plus"></i> 新しいFlexメッセージ
                    </a>
                  </th>
                </tr>
              </thead>
            </table>

            <div class="tag-scroll tag-list">
              <div v-if="loading.flexMessageLoading">Loading...</div>
              <table class="table" v-else>
                <tbody>
                  <tr v-for="(item, index) in flexMessageList" :key="index">
                    <td
                      style="
                        max-width: 500px;
                        overflow: hidden;
                        white-space: nowrap;
                        text-overflow: ellipsis;
                        line-height: 2em;
                      "
                    >
                      {{ item.name }}
                    </td>
                    <td style="text-align: right">
                      <div class="d-inline-flex">
                        <a
                          @click="currentFlexMessage = item"
                          data-toggle="modal"
                          class="btn-more btn-more-linebot btn-block mr-2"
                          data-target="#flexMessagePreview"
                          >プレビュー
                        </a>
                        <div>
                          <base-dropdown>
                            <template v-slot:button-content class="btn btn-sm dropdown-toggle btn-primary action-tags">
                              操作<span class="caret"></span>
                            </template>
                            <base-dropdown-item @click.stop="copyFlexMessage(item)">複製</base-dropdown-item>
                            <base-dropdown-item
                              :href="`${MIX_ROOT_PATH}/template/flex-messages/folders/${item.folder_id}/flex/${item.id}/edit`"
                              >編集</base-dropdown-item
                            >
                            <base-dropdown-item @click.stop="deleteFlexMessage(item)">削除</base-dropdown-item>
                          </base-dropdown>
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

      <flexmessage-modal-preview
        :id="'flexMessagePreview'"
        :model="currentFlexMessage"
        v-if="currentFlexMessage != null"
      />

      <modal-confirm
        title="以下のメッセージを削除してもよろしいですか？"
        id="modal-confirm-delete-flexmessage"
        type="delete"
        @input="submitDeleteFlexMessage"
      />

      <modal-confirm
        title="こちらのフォルダーを削除してもよろしいですか？"
        id="modalDeleteFolder"
        type="delete"
        @input="submitDeleteFolder"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: ['folder_id'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,

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
      flexMessageList: [],
      isEnter: true
    };
  },

  mounted() {
    this.indexFolders();
  },

  watch: {
    folderId(val) {
      if (val && val > 0) {
        this.folderFlexMessages(val);
      }
    }
  },
  methods: {
    backToFolder() {
      this.currentFolder = null;
    },

    addMoreFolder() {
      this.folderForm.name = '';
      this.isAddMoreFolder = !this.isAddMoreFolder;
    },

    indexFolders(isLoading = true) {
      this.loading.folderLoading = isLoading;
      this.$store
        .dispatch('flexMessage/indexFolders')
        .done(res => {
          this.folderLists = res;
          if (this.folderId && this.folderId > 0) {
            this.folderFlexMessages(this.folderId, isLoading);
          } else if (this.folderLists.length > 0) {
            this.folderId = this.folderLists[0].id;
          }
        })
        .always(() => {
          this.loading.folderLoading = false;
        });
    },

    createFolder() {
      if (!this.folderForm.name) {
        return;
      }

      this.$store
        .dispatch('flexMessage/createFolder', {
          data: this.folderForm
        })
        .done(res => {
          this.folderLists.push(res);
          this.isAddMoreFolder = false;
        });
    },

    editFolder(old, folder) {
      this.$store
        .dispatch('flexMessage/editFolder', {
          folderId: folder.id,
          data: folder
        })
        .done(() => {
          old.name = folder.name;
        })
        .fail(err => {
          window.toastr.error(err.responseJSON.message);
        })
        .always(() => {});
    },
    deleteFolder(folder) {
      window.$('#modalDeleteFolder').modal('show');
      this.currentFolder = folder;
    },

    submitDeleteFolder() {
      if (this.currentFolder) {
        this.$store
          .dispatch('flexMessage/deleteFolder', {
            folderId: this.currentFolder.id
          })
          .done(() => {
            this.folderLists.deleteWhere(folder => folder.id === this.currentFolder.id);
            this.flexMessageList = [];
          })
          .fail(err => {
            window.toastr.error(err.responseJSON.message);
          });
      }
    },

    folderFlexMessages(id, isLoading = true) {
      this.currentFolder = this.folderLists.firstWhere(folder => folder.id === id);
      if (this.currentFolder) {
        window.history.replaceState(null, '', '/template/flex-messages/folders/' + id);
        this.folderId = id;
      }

      this.loading.flexMessageLoading = isLoading;
      this.$store
        .dispatch('flexMessage/folderFlexMessages', {
          folderId: id
        })
        .done(res => {
          this.flexMessageList = res;
        })
        .always(() => {
          this.loading.flexMessageLoading = false;
        });
    },

    deleteFlexMessage(flexMessage) {
      window.$('#modal-confirm-delete-flexmessage').modal('show');
      this.currentFlexMessage = flexMessage;
    },
    submitDeleteFlexMessage() {
      if (this.currentFlexMessage != null && this.currentFolder != null) {
        this.$store
          .dispatch('flexMessage/deleteFlexMessage', {
            flexMessageId: this.currentFlexMessage.id
          })
          .done(() => {
            this.flexMessageList.deleteWhere(flexMessage => flexMessage.id === this.currentFlexMessage.id);
          })
          .fail(err => {
            window.toastr.error(err.responseJSON.message);
          });
      }
    },
    copyFlexMessage(flexMessage) {
      this.$store
        .dispatch('flexMessage/copyFlexMessage', {
          flexMessageId: flexMessage.id
        })
        .done(() => {
          this.indexFolders(false);
        })
        .fail(err => {
          window.toastr.error(err.responseJSON.message);
        });
    },

    enterCreateFolder(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonChange.click();
    },

    compositionend() {
      this.isEnter = false;
    },

    compositionstart() {
      this.isEnter = true;
    }
  }
};
</script>
<style lang="scss" scoped>
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
    height: 85vh;
    background-color: #f0f0f0;
    margin-top: 10px;
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

  :deep(.modal-common01.fade .modal-dialog) {
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
  }

  :deep(.folder-title) {
    white-space: nowrap;
    width: 20%;
  }

  :deep(.btn-secondary) {
    background-color: #3097d1 !important;
    border-color: #2a88bd !important;
    color: white !important;
  }
</style>
