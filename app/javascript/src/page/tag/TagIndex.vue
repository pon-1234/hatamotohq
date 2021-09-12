<template>
  <div class="card">
    <div class="card-body">
      <div class="tag-list">
        <div class="d-flex">
          <div class="fw-300">
            <div class="tag-header">
              <div class="group_list_head">
                <div class="add_group btn btn-sm btn-success" @click="addMoreFolder">
                  <i class="fa fa-plus"></i> 新しいフォルダ
                </div>
              </div>
            </div>
            <div class="tag-content">
              <div class="folder-list-title">
                <table class="table table-tags-header">
                  <thead class="thead-light">
                    <tr>
                      <th scope="col">フォルダ</th>
                    </tr>
                  </thead>
                </table>
              </div>
              <div class="tag-scroll folder-list">
                <div class="folder-item new-folder" v-if="isAddMoreFolder">
                  <div class="input-group newgroup-inputs">
                  <input type="text"  placeholder="フォルダ名" v-model="folderData.name" class="form-control" @click.stop ref="folderName"
                    @keyup.enter='entersubmitAddNewFolder'
                    @compositionend="compositionend($event)"
                    @compositionstart="compositionstart($event)"
                    >
                    <span class="input-group-btn">
                      <button type="button" class="btn btn-default" @click="submitCreateFolder" ref="buttonAddFolder">
                        決定
                      </button>
                    </span>
                  </div>
                </div>

                <folder-item
                  v-for="(item, index) in tags"
                  :data="item"
                  :active="selected_tag == index"
                  :index="index"
                  :key="index"
                  @changeSelected="changeSelectedFolder(index)"
                  @editTag="submitEditTag"
                  @deleteTag="setSelectedTag"
                  />
              </div>
            </div>
          </div>
          <div class="flex-grow-1">
            <div class="btn btn-primary btn-sm" @click="addTag">
              <i class="fa fa-plus"></i> 新しいタグ
            </div>
            <div class="tag-content">
              <div class="tag-scroll tag-list">
                <table class="table">
                  <thead>
                    <tr>
                      <th  style="min-width: 200px;"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i>タグ名</th>
                      <th class="fw-150">メンバー数</th>
                      <th class="fw-200">作成日</th>
                    </tr>
                  </thead>
                  <tbody v-if="tags && tags[selected_tag]">
                    <tr v-if="isAddMoreTag" class="tag-item">
                      <td style="min-width: 200px; vertical-align: middle;">
                        <div class="folder-item">
                          <div class="input-group newgroup-inputs">
                            <input type="text"  placeholder="タグ名" class="form-control" @click.stop v-model="tagData.name" ref="tagName"
                              @keyup.enter='showNewTagInput'
                              @compositionend="compositionend($event)"
                              @compositionstart="compositionstart($event)"
                              >
                            <span class="input-group-btn">
                              <button type="button" class="btn btn-default" @click="submitAddNewTag" ref="buttonAddTag">
                                決定
                              </button>
                            </span>
                          </div>
                        </div>
                      </td>
                      <td class="text-center">0人</td>
                      <td class="text-center">{{getCreatedAt()}}</td>
                    </tr>
                    <tag-item :data="item" v-for="(item, index) in tags[selected_tag].tags"
                      :key="index"
                      @deleteTag="setSelectedTag"
                      @editTag="submitEditTag"
                      @detailFriends="detailFriends"
                    />
                  </tbody>
                </table>
                <div v-if="tags[selected_tag].tags.length === 0" class="mt-4 text-md">データはありません</div>
              </div>
            </div>
          </div>
        </div>
        <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteTag"/>
        <modal-confirm title="このタグを削除します。よろしいですか？" type='delete' id="modal-confirm-tag" @input="submitDeleteTag"/>
        <modal-list-friends-tag :friends="friends"/>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import moment from 'moment';

export default {
  data() {
    return {
      folderData: {
        type: 'folder',
        name: null
      },
      tagData: {
        name: null,
        folder_id: null
      },
      selected_tag: 0,
      isAddMoreFolder: false,
      isAddMoreTag: false,
      isPc: true,
      tagSelected: null,
      friends: [],
      isEnter: true
    };
  },
  async beforeMount() {
    await this.getTags({ low: false });

    if (this.tags && this.tags.length === 0) {
    }
  },
  computed: {
    ...mapState('tag', {
      tags: state => state.tags
    }),
    ...mapState('system', {
      success: state => state.success
    })
  },
  watch: {
    success: {
      handler(val) {
        if (val.status) {
          window.toastr.success(val.message);
        } else {
          window.toastr.error(val.message);
        }
      },
      deep: true
    }
  },
  methods: {
    ...mapActions('tag', [
      'getTags',
      'deleteTag',
      'addNewFolder',
      'addNewTag',
      'editTag',
      'createTag'
    ]),

    backToFolder() {
      this.isPc = false;
    },
    async changeSelectedFolder(index) {
      this.selected_tag = index;
      this.isAddMoreTag = false;
      this.isPc = true;
    },

    submitDeleteTag() {
      if (this.tagSelected.type === 'folder') {
        this.selected_tag = 0;
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

    async submitCreateTag(value) {
      this.isAddMoreFolder = false;
      this.isAddMoreTag = false;
      const response = await this.createTag(value);
      this.onReceiveCreateTagResponse(response);
    },

    setSelectedTag(value) {
      this.tagSelected = value;
    },

    submitCreateFolder() {
      if (this.folderData.name) {
        this.submitCreateTag(this.folderData);
        this.folderData.name = '';
      }
    },

    submitAddNewTag() {
      if (this.tagData.name) {
        this.tagData.folder_id = this.tags[this.selected_tag].id;
        this.submitCreateTag(this.tagData);
        this.tagData.name = '';
      }
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
