<template>
  <div
    class="modal fade modal-template modal-common01"
    :id="id ? id : 'modal-template'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">テンプレートを選択してください</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden">
          <div class="d-flex" v-if="folders && folders.length">
            <folder-left
              type="template_message"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="changeSelectedFolderTemplate"
            />
            <div class="flex-grow-1">
              <table class="table table-hover">
                <thead class="thead-light">
                  <tr>
                    <th>
                      <span v-if="folders[selectedFolder]">{{ folders[selectedFolder].name }}</span>
                    </th>
                  </tr>
                </thead>
                <tbody v-if="folders[this.selectedFolder].templates && folders[this.selectedFolder].templates.length">
                  <tr
                    v-for="(item, index) in folders[this.selectedFolder].templates"
                    :key="index"
                    class="folder-item"
                    data-dismiss="modal"
                  >
                    <td class="d-flex w-100">
                      <div>{{ item.name }}</div>
                      <div class="btn btn-info btn-sm ml-auto" @click="selectTemplate(item)">選択</div>
                    </td>
                  </tr>
                </tbody>
                <tbody v-else>
                  <tr>
                    <td class="text-center pt40">データーがありません</td>
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
import { mapState, mapActions } from 'vuex';
export default {
  props: ['id'],

  data() {
    return {
      selectedFolder: 0,
      isPc: true
    };
  },

  computed: {
    ...mapState('template', {
      folders: state => state.folders
    })
  },

  async beforeMount() {
    await this.getTemplates();
  },

  methods: {
    ...mapActions('template', [
      'getTemplates'
    ]),

    backToFolder() {
      this.isPc = false;
    },

    selectTemplate(template) {
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(template);
      this.$emit('selectTemplate', data);
    },

    changeSelectedFolderTemplate(index) {
      this.selectedFolder = index;
      this.isPc = true;
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
