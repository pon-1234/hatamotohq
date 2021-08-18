<template>
  <div class="modal fade modal-template modal-common01" :id="id? id:'modal-template'" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body overflow-hidden">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <label class="mb15">テンプレートを選択してください</label>
          <div class=" template-list-content" v-if="messageTemplates && messageTemplates.length">
            <folder-left
              type="template_message"
              :isPerview="true"
              :data="messageTemplates"
              :isPc="isPc"
              :selectedFolder="selectedTemplate"
              @changeSelectedFolder="changeSelectedFolderTemplate"
              />
            <div :class="getClassRightTag()">
              <div class="list-content">
                <!--<table class="table table-tags-header">-->
                  <!--<thead>-->
                    <!--<tr>-->
                      <!--<th class="w5"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
                      <!--<th v-if="messageTemplates[selectedTemplate]">{{messageTemplates[selectedTemplate].name}}</th>-->
                    <!--</tr>-->
                  <!--</thead>-->
                <!--</table>-->

                <div class="x-tag-header">
                  <div class="x-btn-back">
                    <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
                  <div class="x-title"
                       v-if="messageTemplates[selectedTemplate]">{{messageTemplates[selectedTemplate].name}}
                  </div>
                </div>

                <div class="list-scroll message-template-list" v-if="messageTemplates && messageTemplates[this.selectedTemplate]">
                  <table class="table table-hover table-messages-template">
                    <tbody v-if="messageTemplates[this.selectedTemplate].message_templates && messageTemplates[this.selectedTemplate].message_templates.length">
                      <tr  v-for="(item, index) in messageTemplates[this.selectedTemplate].message_templates"  :key="index" @click="selectTemplate(item)" class="folder-item" data-dismiss="modal">
                        <td class="message-title">
                          {{item.title}}
                        </td>
                      </tr>
                    </tbody>
                    <tbody v-else>
                      <tr>
                        <td class="text-center pt40">
                           データーがありません
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
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';
export default {
  props: ['id'],

  data() {
    return {
      selectedTemplate: 0,
      isPc: true
    };
  },

  computed: {
    ...mapState('messageTemplate', {
      messageTemplates: state => state.messages
    })
  },

  created() {
    this.fetchListMessageTemplate();
  },

  methods: {
    ...mapActions('messageTemplate', [
      'fetchListMessageTemplate'
    ]),
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

    selectTemplate(template) {
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(template);
      this.$emit('setTemplate', data);
    },

    changeSelectedFolderTemplate(index) {
      this.selectedTemplate = index;
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
      display: none!important;
    }

    .item-sm {
      display: inline-block!important;
    }

    .fa-arrow-left {
      margin-right: 10px;
      cursor: pointer;
    }
  }
  .message-title {
    width: 150px!important;
  }

  .modal-dialog {
    max-width: 800px;
    .table-tags-header {
      margin-bottom: 0px!important;
      max-width: none!important;
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

  .table-messages-template {
    max-width: none;
    margin-top: 0px;
    tr {
      td {
        vertical-align: middle!important;
      }
    }
  }
}

::v-deep {
  .carousel-content {
    width: 130px!important;
    .carousel-thumb {
      height: 70px!important;
      line-height: 70px!important;
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

  .thumbnail-item{
    max-height: 100px;
    height: 100px;
  }

  .sticker-static {
    max-width: 110px!important;
    max-height: 100px!important;
  }
}
</style>
