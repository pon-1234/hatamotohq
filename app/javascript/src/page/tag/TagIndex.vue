<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="tag"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onFolderChanged"
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
                <tr v-if="showTagInput" class="tag-item">
                  <td class="mw-200 vetical-align-middle">
                    <div class="folder-item">
                      <div class="input-group newgroup-inputs">
                        <input type="text"
                          placeholder="タグ名"
                          class="form-control"
                          @click.stop
                          v-model="tagData.name"
                          ref="tagName"
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
                  @deleteTag="curTagIndex = index"
                  @editTag="submitUpdateTag"
                  @detailFriends="detailFriends"
                />
              </tbody>
            </table>
            <div v-if="curFolder && curFolder.tags.length === 0" class="mt-4 text-md text-center">データはありません</div>
          </div>
        </div>
      </div>

      <modal-confirm title="こちらのフォルダを削除します。よろしいですか？" id='modalDeleteFolder' type='delete' @confirm="submitDeleteFolder">
        <template v-slot:content v-if="curFolder">
          <div>フォルダ名：<b>{{ curFolder.name }}</b></div>
        </template>
      </modal-confirm>

      <modal-confirm title="このタグを削除します。よろしいですか？" type='delete' id="modalConfirmDelTag" @confirm="submitDeleteTag">
        <template v-slot:content v-if="curFolder && curTag">
          <div>フォルダ名：<b>{{ curFolder.name }}</b></div>
          <div class="mt-2">タグ名：<b>{{ curTag.name }}</b></div>
        </template>
      </modal-confirm>
      <modal-list-friends-tag :friends="friends"/>
    </div>

    <loading-indicator :loading="loading"></loading-indicator>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';
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
      showFolderInput: false,
      showTagInput: false,
      isPc: true,
      curTagIndex: 0,
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
    },

    curTag() {
      return this.curFolder ? this.curFolder.tags[this.curTagIndex] : null;
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
      'createFolder',
      'updateFolder',
      'deleteFolder',
      'addNewTag',
      'createTag',
      'updateTag',
      'deleteTag'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    backToFolder() {
      this.isPc = false;
    },

    async onFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.showTagInput = false;
      this.isPc = true;
    },

    addMoreFolder() {
      this.showFolderInput = !this.showFolderInput;
      if (this.showTagInput) {
        this.showTagInput = false;
      }
      this.folderData.name = '';
    },

    async submitCreateFolder(value) {
      await this.createFolder(value);
    },

    async submitUpdateFolder(value) {
      await this.updateFolder(value);
    },

    async submitDeleteFolder() {
      await this.deleteFolder(this.curFolder.id);
      this.onFolderChanged(0);
    },

    addTag() {
      this.showTagInput = !this.showTagInput;
      if (this.showFolderInput) {
        this.showFolderInput = false;
      }
      this.tagData.name = '';
    },

    async submitUpdateTag(tag) {
      this.showFolderInput = false;
      this.showTagInput = false;
      await this.updateTag(tag);
    },

    async submitDeleteTag() {
      const response = await this.deleteTag(this.curTag.id);
      if (response) {
        Util.showSuccessThenRedirect('タグの削除は完了しました。', window.location.href);
      }
    },

    async submitCreateTag() {
      if (this.tagData.name && this.tagData.name.trim().length > 0) {
        const payload = {
          folder_id: this.curFolder.id,
          name: this.tagData.name
        };
        await this.createTag(payload);
        this.resetTagInput();
      }
    },

    resetTagInput() {
      this.showTagInput = false;
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

    showNewTagInput(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonAddTag.click();
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
