<template>
  <div
    class="modal fade"
    :id="id ? id : 'modal-template'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">友達情報名を選択してください</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden">
          <div class="d-flex">
            <folder-left
              type="variable"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolderIndex"
              @changeSelectedFolder="changeSelectedFolder"
            ></folder-left>
            <div class="flex-grow-1 scroll-table" :key="contentKey">
              <table class="table">
                <thead class="thead-light">
                  <tr>
                    <th>名称</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(variable, index) in variables" v-bind:key="index">
                    <td>{{ variable.name }}</td>
                    <td class="fw-120">
                      <div @click="selectVariable(variable)" class="btn btn-sm btn-light" data-dismiss="modal">
                        選択
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
  </div>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: ['id', 'type'],
  data() {
    return {
      contentKey: 0,
      folders: [],
      selectedFolderIndex: 0,
      surveyContents: 0,
      isPc: true,
      survey: null,
      textSearch: null
    };
  },

  computed: {
    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    variables() {
      return this.curFolder ? this.curFolder.variables : [];
    }
  },

  async beforeMount() {
    this.folders = await this.getFolders();
  },

  methods: {
    ...mapActions('variable', ['getFolders']),

    forceRerender() {
      this.contentKey++;
    },

    changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.forceRerender();
    },

    selectVariable(variable) {
      console.log(variable, 'survey');
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(variable);
      this.$emit('selectVariable', data);
    }
  }
};
</script>
<style lang="scss" scoped>
  .modal-template {
    .item-sm {
      display: none;
    }

    @media (max-width: 991px) {
      .item-pc {
        display: none !important;
      }

      .item-sm {
        display: inline-block !important;
      }

      .fa-arrow-left {
        margin-right: 10px;
        cursor: pointer;
      }
    }
    .message-title {
      width: 150px !important;
    }

    .modal-dialog {
      max-width: 800px;
      .table-tags-header {
        margin-bottom: 0px !important;
        max-width: none !important;
      }

      .template-list-content {
        background-color: #f0f0f0;

        .folder-item {
          cursor: pointer;
        }

        .folder-item:hover {
          background: #f0ad4e;
        }

        .list-content {
          height: 100%;
          max-height: 500px;
          overflow: hidden;
          display: flex;
          flex-direction: column;
          .list-scroll {
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            margin: 0 0;
            display: flex;
            flex-direction: column;
          }
        }
      }
    }
  }

  ::v-deep {
    .carousel-content {
      width: 130px !important;
      .carousel-thumb {
        height: 70px !important;
        line-height: 70px !important;
      }
    }

    .buttons-content,
    .imagemap,
    .location-content,
    .chat-item-voice,
    .thumbnail-item,
    .confirm-content {
      width: 150px;
      max-width: 150px;
    }

    .thumbnail-item {
      max-height: 100px;
      height: 100px;
    }

    .sticker-static {
      max-width: 110px !important;
      max-height: 100px !important;
    }
  }
</style>
