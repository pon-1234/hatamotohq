<template>
  <div class="modal fade modal-template modal-common01" :id="id" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body overflow-hidden">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <label class="mb15">ステップ配信を選択してください。</label>
          <div class=" template-list-content" v-if="scenarioTemps && scenarioTemps.length">
            <folder-left
              type="template_scenario"
              :isPerview="true"
              :data="scenarioTemps"
              :isPc="isPc"
              :selectedFolder="selectedTemplate"
              @changeSelectedFolder="changeSelectedFolderTemplate"
              />
            <div :class="getClassRightTag()">
              <!--<table class="table table-tags-header">-->
                <!--<thead>-->
                  <!--<tr>-->
                    <!--<th class="w5"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
                    <!--<th v-if="scenarioTemps[selectedTemplate]">{{scenarioTemps[selectedTemplate].name}}</th>-->
                  <!--</tr>-->
                <!--</thead>-->
              <!--</table>-->

              <div class="x-tag-header">
                <div class="x-btn-back">
                  <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
                <div class="x-title"
                     v-if="scenarioTemps[selectedTemplate]">{{scenarioTemps[selectedTemplate].name}}
                </div>
              </div>
              <div class="list-content">
                <div class="list-scroll message-template-list" v-if="scenarioTemps && scenarioTemps[this.selectedTemplate]">
                  <div v-if="scenarioTemps[this.selectedTemplate].scenarios && scenarioTemps[this.selectedTemplate].scenarios.length">
                    <div v-for="(item, index) in scenarioTemps[this.selectedTemplate].scenarios"
                      :key="index"
                      class="folder-item"
                      data-dismiss="modal"
                      @click="changeSelectedTemplate(item)">
                      <span class="tag-label">{{item.title}}</span>
                    </div>
                  </div>
                  <div v-else class="text-center mt40">
                  データーがありません
                </div>
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
import { mapActions } from 'vuex';

export default {
  props: ['type', 'id'],

  data() {
    return {
      scenarioTemps: [],
      selectedTemplate: 0,
      isPc: true
    };
  },

  created() {
    const response = this.getScenarios();
    this.scenarioTemps = response;
  },

  methods: {
    ...mapActions('scenario', ['getScenarios']),

    changeSelectedFolderTemplate(index) {
      this.selectedTemplate = index;
      this.isPc = true;
    },

    backToFolder() {
      this.isPc = false;
    },

    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    changeSelectedTemplate(scenario) {
      this.$emit('changeSelectedTemplate', scenario);
    }
  }
};
</script>

<style lang="scss" scoped>

::v-deep{
  .table-tags-header {
    margin-bottom: 0px!important;
    max-width: none!important;
    margin-top: 0px!important;
    tr {
      height: 40px;
    }
  }
}
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

  .modal-dialog {
    max-width: 800px;

    .template-list-content {
      background-color: #f0f0f0;

      .folder-item {
        height: 45px;
        min-height: 45px;
        cursor: pointer;
        padding: 10px;
        display: flex;
        align-items: center;
        white-space: nowrap;
        overflow: hidden;
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
</style>
