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
          <div class="btn btn-primary" @click="addTag"><i class="uil-plus"></i> 新規登録</div>
          <div class="mt-2">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>タグ名</th>
                  <th>メンバー数</th>
                  <th>作成日</th>
                </tr>
              </thead>
              <tbody v-if="curFolder">
                <tr v-if="showTagInput">
                  <td class="mw-200 vetical-align-middle">
                    <div class="folder-item">
                      <div class="input-group newgroup-inputs">
                        <input
                          type="text"
                          placeholder="タグ名"
                          class="form-control"
                          @click.stop
                          v-model="tagData.name"
                          ref="tagName"
                        />
                        <span class="input-group-btn">
                          <button type="button" class="btn btn-light" @click="submitCreateTag" ref="buttonAddTag">
                            決定
                          </button>
                        </span>
                      </div>
                    </div>
                  </td>
                  <td>0人</td>
                  <td>{{ getCreatedAt() }}</td>
                </tr>
                <tag-item
                  v-for="(item, index) in curFolder.tags"
                  :tag="item"
                  :key="index"
                  @deleteTag="curTag = item"
                  @editTag="submitUpdateTag"
                  @showFriends="curTag = $event"
                />
              </tbody>
            </table>
            <div v-if="curFolder && curFolder.tags.length === 0" class="mt-5 text-md text-center">
              <b>タグはありません</b>
            </div>
          </div>
        </div>
      </div>

      <modal-confirm
        title="このフォルダーを削除してもよろしいですか？"
        id="modalDeleteFolder"
        type="delete"
        @confirm="submitDeleteFolder"
      >
        <template v-slot:content v-if="curFolder">
          <div>
            フォルダー名：<b>{{ curFolder.name }}</b>
          </div>
        </template>
      </modal-confirm>

      <modal-confirm
        title="このタグを削除してもよろしいですか？"
        type="delete"
        id="modalConfirmDelTag"
        @confirm="submitDeleteTag"
      >
        <template v-slot:content v-if="curFolder && curTag">
          <div>
            フォルダー名：<b>{{ curFolder.name }}</b>
          </div>
          <div class="mt-2">
            タグ名：<b>{{ curTag.name }}</b>
          </div>
        </template>
      </modal-confirm>

      <modal-tag-friends :tag="curTag"></modal-tag-friends>
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
      selectedFolderIndex: 0,
      showFolderInput: false,
      showTagInput: false,
      isPc: true,
      curTag: null,
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

    tags() {
      return this.curFolder ? this.curFolder.tags : [];
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
      const response = await this.createFolder(value);
      if (response) {
        window.toastr.success('フォルダーの作成は完了しました。');
      } else {
        window.toastr.error('フォルダーの作成は失敗しました。');
      }
    },

    async submitUpdateFolder(value) {
      const response = await this.updateFolder(value);
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
        this.onFolderChanged(0);
      } else {
        window.toastr.error('フォルダーの削除は完了しました。');
      }
    },

    addTag() {
      this.showTagInput = !this.showTagInput;
      if (this.showFolderInput) {
        this.showFolderInput = false;
      }
      this.tagData.name = '';
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
        const response = await this.createTag(payload);
        if (response) {
          window.toastr.success('タグの作成は完了しました。');
        } else {
          window.toastr.error('フォルダーの作成は失敗しました。');
        }
        this.resetTagInput();
      }
    },

    async submitUpdateTag(tag) {
      this.showFolderInput = false;
      this.showTagInput = false;
      const response = await this.updateTag(tag);
      if (response) {
        window.toastr.success('タグの変更は完了しました。');
      } else {
        window.toastr.error('フォルダーの変更は失敗しました。');
      }
      this.forceRerender();
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

    showNewTagInput(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonAddTag.click();
    },

    onReceiveCreateTagResponse(response) {
      if (response && response.id) {
        window.toastr.success('フォルダーまたはタグの作成は完了しました。');
      } else {
        window.toastr.error(response.message);
      }
    }
  }
};
</script>
