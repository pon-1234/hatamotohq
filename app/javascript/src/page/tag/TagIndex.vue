<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="tag"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
          />
        <div class="flex-grow-1">
          <div class="btn btn-primary btn-sm" @click="addTag">
            <i class="fa fa-plus"></i> 新規登録
          </div>
          <div class="mt-2">
            <table class="table index">
              <thead>
                <tr>
                  <th class="mw-200"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i>タグ名</th>
                  <th class="fw-150">メンバー数</th>
                  <th class="fw-200">作成日</th>
                </tr>
              </thead>
              <tbody v-if="curFolder">
                <tr v-if="isAddMoreTag" class="tag-item">
                  <td class="mw-200 vetical-align-middle">
                    <div class="folder-item">
                      <div class="input-group newgroup-inputs">
                        <input type="text"  placeholder="タグ名" class="form-control" @click.stop v-model="tagData.name" ref="tagName"
                          @keyup.enter='showNewTagInput'
                          @compositionend="compositionend($event)"
                          @compositionstart="compositionstart($event)"
                          >
                        <span class="input-group-btn">
                          <button type="button" class="btn btn-default" @click="submitCreateTag" ref="buttonAddTag">
                            決定
                          </button>
                        </span>
                      </div>
                    </div>
                  </td>
                  <td class="text-center">0人</td>
                  <td class="text-center">{{getCreatedAt()}}</td>
                </tr>
                <tag-item
                  v-for="(item, index) in curFolder.tags"
                  :data="item"
                  :key="index"
                  @deleteTag="setSelectedTag"
                  @editTag="submitEditTag"
                  @detailFriends="detailFriends"
                />
              </tbody>
            </table>
            <div v-if="curFolder && curFolder.tags.length === 0" class="mt-4 text-md text-center">データはありません</div>
          </div>
        </div>
      </div>
      <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modalDeleteFolder' type='delete' @input="submitDeleteTag"/>
      <modal-confirm title="このタグを削除します。よろしいですか？" type='delete' id="modal-confirm-tag" @input="submitDeleteTag"/>
      <modal-list-friends-tag :friends="friends"/>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import moment from 'moment';

export default {
  data() {
    return {
      loading: true,
      tagData: {
        id: null,
        name: null,
        folder_id: null
      },
      tags: [],
      selectedFolderIndex: 0,
      isAddMoreFolder: false,
      isAddMoreTag: false,
      isPc: true,
      tagSelected: null,
      friends: [],
      isEnter: true
    };
  },
  async beforeMount() {
    await this.getTags();
    this.loading = false;
  },
  computed: {
    ...mapState('tag', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    }
  },
  watch: {
    folders: {
      handler(val) {
        this.tags = val[this.selectedFolderIndex] ? val[this.selectedFolderIndex].tags : [];
      },
      deep: true
    }
  },
  methods: {
    ...mapActions('tag', [
      'getTags',
      'deleteTag',
      'createFolder',
      'updateFolder',
      'deleteFolder',
      'addNewTag',
      'createTag',
      'updateTag'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    backToFolder() {
      this.isPc = false;
    },

    async onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isAddMoreTag = false;
      this.isPc = true;
    },

    submitDeleteTag() {
      if (this.tagSelected.type === 'folder') {
        this.selectedFolderIndex = 0;
      }
      this.deleteTag(this.tagSelected);
    },

    addMoreFolder() {
      this.isAddMoreFolder = !this.isAddMoreFolder;
      if (this.isAddMoreTag) {
        this.isAddMoreTag = false;
      }
      this.folderData.name = '';
    },

    addTag() {
      this.isAddMoreTag = !this.isAddMoreTag;
      if (this.isAddMoreFolder) {
        this.isAddMoreFolder = false;
      }
      this.tagData.name = '';
    },

    submitEditTag(value) {
      this.isAddMoreFolder = false;
      this.isAddMoreTag = false;
      this.editTag(value);
    },

    // async submitCreateTag(value) {
    //   this.isAddMoreFolder = false;
    //   this.isAddMoreTag = false;
    //   const response = await this.createTag(value);
    //   this.onReceiveCreateTagResponse(response);
    // },

    setSelectedTag(value) {
      this.tagSelected = value;
    },

    async submitCreateFolder(value) {
      await this.createFolder(value);
    },

    async submitUpdateFolder(value) {
      await this.updateFolder(value);
    },

    submitCreateTag() {
      if (this.tagData.name && this.tagData.name.trim().length > 0) {
        const payload = {
          folder_id: this.folders[this.selectedFolderIndex].id,
          name: this.tagData.name
        };
        this.createTag(payload);
        this.resetTagInput();
      }
    },

    resetTagInput() {
      this.tagData = {
        id: null,
        name: null,
        folder_id: null
      };
    },

    getCreatedAt(item) {
      return moment().format('YYYY.MM.DD');
    },

    detailFriends(value) {
      this.friends = value;
    },

    entersubmitAddNewFolder(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonAddFolder.click();
    },

    showNewTagInput(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonAddTag.click();
    },

    compositionend() {
      this.isEnter = false;
    },

    compositionstart() {
      this.isEnter = true;
    },

    onReceiveCreateTagResponse(response) {
      if (response && response.id) {
        window.toastr.success('フォルダまたはタグの作成は完了しました。');
      } else {
        window.toastr.error(response.message);
      }
    }
  }
};
</script>
<style lang="scss" scoped>

.tag-header {
  color: white;
}

.tag-content {
  height: 85vh;
  margin-top: 10px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  .tag-scroll {
    height: 100%;
    overflow-x: hidden;
    overflow-y: auto;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }

  .tag-list {
    overflow-y: hidden;
  }
}

.tag-content-left {
  padding-right: 0px!important;
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
    float: left;
    margin-right: 10px;
  }

  .tag-content-right {
    .tag-scroll {
      overflow-x: scroll;
    }
  }

  .tag-scroll {
    overflow-x: scroll;
  }
}

.new-folder {
  background: #fff3a0 !important;
  padding: 10px;
}

.tag-item {
  background: white;
}

.table-responsive {
  overflow: auto;
  height: 100%;
  margin-bottom: 0px!important;
  thead {
    border-bottom: none!important;
    th {
      color: #333;
      z-index: 5;
      padding: 8px!important;
      height: 52px;
      border-bottom: none!important;
      box-shadow: inset 0 -2px 0 #ddd;
      position: sticky; top: 0;
      background:#F0F0F0;
      border-radius: 0px!important;
    }
    th:first-child {
      text-align: left!important;
    }
  }
}

.thead-light {
  th {
    height: 52px;
  }
}

.folder-list {
  border-right: thin solid #ccc;
}

</style>
