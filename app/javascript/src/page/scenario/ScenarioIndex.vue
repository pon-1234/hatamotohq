<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <div class="col-l flex">
        <h3 class="hdg3" v-if="title">{{title}}</h3>
        <h3 class="hdg3" v-else>シナリオ配信一覧</h3>
      </div>
    </div>
    <div>
      <folder-left
        type="scenario"
        :data="scenarios"
        :isPc="isPc"
        :selectedFolder="selectedFolder"
        @changeSelectedFolder="changeSelectedFolder"
        @submitUpdateFolder="submitUpdateFolder"
        @submitCreateFolder="submitCreateFolder"
        />
      <div :class="getClassRightTag()">
        <div class="tag-header">
          <div class="col-r">
            <div class="btn-group btn-sort01 mr-2">
              <button type="button" class="btn dropdown-toggle" data-toggle="dropdown" aria-expanded="false">{{selectedStatus.text}}<span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-common01" role="menu">
                <li role="presentation" v-for="(item, index) in optionsStatusFilter" :key="index" @click="changeSelectedStatus(item)">
                  <a role="menuitem" tabindex="-1" href="#" :class="selectedStatus.value === item.value  ? 'active': ''">{{item.text}}</a>
                </li>
              </ul>
            </div>
            <div class="btn-common02 fz14">
              <a :href="getUrlCreateNewScenario()" v-if="scenarios && scenarios[selectedFolder]"><span>新規作成</span></a>
            </div>
          </div>
        </div>
        <div class="tag-content">
          <!--<table class="table table-tags-header">-->
            <!--<thead>-->
            <!--<tr>-->
              <!--<th class="w5" style="height: 42px"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
              <!--<th v-if="scenarios[selectedFolder]">{{scenarios[selectedFolder].name}}</th>-->
            <!--</tr>-->
            <!--</thead>-->
          <!--</table>-->

          <div class="x-tag-header">
            <div class="x-btn-back">
              <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
            <div class="x-title"
                 v-if="scenarios[selectedFolder]">{{scenarios[selectedFolder].name}}
            </div>
          </div>

          <div class="tag-scroll">
            <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center" style="overflow-x: scroll">
              <table class="table table-hover table-scenario">
                <thead>
                  <tr>
                    <th class="w10">No.</th>
                    <th class="w10">ステータス</th>
                    <th class="w15">ステップ名</th>
                    <th class="w20">内容</th>
                    <th class="w5">メッセージ数</th>
                    <th class="w20"></th>
                    <th class="w20"></th>
                  </tr>
                </thead>
                <tbody v-if="scenariosContent && scenariosContent.length">
                  <tr v-for="(scenario, index) in scenariosContent" v-bind:key="index">
                     <td >{{index+1}}</td>
                    <td class="fz14">
                        <span class="status complete" v-if="scenario.status === 'enable'">配信中</span>
                        <span class="status reserve" v-if="scenario.status === 'disable'">停止中</span>
                        <span class="status draft" v-if="scenario.status === 'draft'">下書き</span>
                    </td>
                    <td   style="max-width: 200px; text-overflow: ellipsis; white-space: nowrap; word-break: break-word; overflow: hidden;">{{scenario.title}}</td>
                    <td >{{scenario.content}}</td>
                    <td >{{scenario.messages_count}}</td>
                    <td >
                      <div class="row-btn row-btn-customize" v-if="type ==='template'">
                        <div class="btn-copy01 btn-action" >
                          <a class="btn-more btn-more-linebot btn-block"  :href="`${MIX_ROOT_PATH}/template/scenarios/${scenario.id}/edit`">
                            基本設定
                          </a>
                        </div>
                        <div class="btn-copy01 btn-action">
                          <a class="btn-more btn-more-linebot btn-block" :href="`${MIX_ROOT_PATH}/template/scenarios/${scenario.id}`" >
                            配信文設定
                          </a>
                        </div>
                      </div>
                      <div class="row-btn row-btn-customize" v-else>
                        <div class="btn-copy01 btn-action" >
                          <a class="btn-more btn-more-linebot btn-block"  :href="`${MIX_ROOT_PATH}/scenarios/${scenario.id}/edit`">
                            基本設定
                          </a>
                        </div>
                        <div class="btn-copy01 btn-action">
                          <a class="btn-more btn-more-linebot btn-block" :href="`${MIX_ROOT_PATH}/scenarios/${scenario.id}`" >
                            配信文設定
                          </a>
                        </div>
                      </div>
                    </td>
                    <td >
                      <div class="row-btn row-btn-customize">
                        <div class="btn-copy01" data-toggle="tooltip" title="複製">
                          <button class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-copy" @click="showModal(scenario, index)">
                            <i class="fas fa-copy"></i>
                          </button>
                        </div>
                        <div class="btn-delete01" data-toggle="tooltip" title="削除">
                          <button class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-delete" @click="showModal(scenario, index)">
                            <i class="fas fa-trash-alt"></i>
                          </button>
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
    </div>
    <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteTag"/>

    <div v-if="getScenario">
      <div  class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-body">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <p class="mb10 fz14">以下のステップを削除します。よろしいですか？</p>
              <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between">
                <dt >タイトル</dt>
                <dd>{{this.getScenario.title}}</dd>
              </dl>
            </div>
            <div class="modal-footer flex center">
              <button type="button" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="scenarioDelete(getScenario.id)">削除</button>
              <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <modal-confirm id="modal-copy" type="confirm" @input="scenarioCopy(getScenario.id)" title="コピーしますか？"/>
  </div>

</template>
<script>
import { mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['route', 'type', 'title'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      isPc: true,
      selectedFolder: 0,
      scenarioIndex: 0,
      scenarios: [],
      scenariosContent: [],
      getScenario: null,
      selectedStatus: this.MessageDeliveriesStatusFilter[0],
      optionsStatusFilter: this.ScenarioStatusFilter
    };
  },

  beforeMount() {
    this.getScenarios();
  },

  computed: {
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

  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getQueryParamsUrl('is_updated') === 'true') {
        window.toastr.success('シナリオ配信の変更は完成しました');
      }

      if (Util.getQueryParamsUrl('is_created') === 'true') {
        window.toastr.success('シナリオ配信を登録しました');
      }
    }
  },

  methods: {
    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    submitCreateFolder(value) {
      if (this.type === 'template') {
        value.type = 'template_scenario';
      }

      this.$store
        .dispatch('global/createFolder', value)
        .done(res => {
          const data = res;
          data.scenarios = [];
          this.scenarios.push(data);
        }).fail(e => {
        });
    },

    async changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.selectedStatus = this.MessageDeliveriesStatusFilter[0];
      this.scenariosContent = this.scenarios[index].scenarios;
    },

    submitUpdateFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.scenarios[this.selectedFolder].name = res.name;
        }).fail(e => {
        });
    },

    submitDeleteTag() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.scenarios[this.selectedFolder].id, type: 'scenario' })
        .done(res => {
          this.scenarios.splice(this.selectedFolder, 1);
          this.selectedFolder -= 1;
          this.scenariosContent = this.scenarios[this.selectedFolder].scenarios;
        }).fail(e => {
        });
    },

    backToFolder() {
      this.isPc = false;
    },

    showDeliveryTiming(val) {
      return Util.showDeliveryTiming(val);
    },

    isNow(val) {
      return Util.isNow(val);
    },

    showModal(scenario, index) {
      this.getScenario = scenario;
      this.scenarioIndex = index;
    },

    getScenarios() {
      const query = {
        type: this.type || 'normal'
      };
      this.$store
        .dispatch('scenario/getList', query)
        .done(res => {
          this.scenarios = res;
          this.scenariosContent = this.scenarios[0] && this.scenarios[0].scenarios ? this.scenarios[0].scenarios : [];
        }).fail(e => {
        });
    },

    scenarioDelete(id) {
      const query = {
        id: id
      };
      this.$store
        .dispatch('scenario/scenarioDelete', query)
        .done(res => {
          this.scenariosContent.splice(this.scenarioIndex, 1);
        }).fail(e => {});
    },

    scenarioCopy(id) {
      const query = {
        id: id,
        page: this.currentPage,
        type: this.type
      };
      this.$store
        .dispatch('scenario/scenarioCopy', query)
        .done(res => {
          this.scenariosContent.splice(0, 0, res);
        }).fail(e => {});
    },

    changeSelectedStatus(value) {
      this.selectedStatus = value;
      if (value.value === 'all') {
        this.scenariosContent = this.scenarios[this.selectedFolder].scenarios;
      } else {
        this.scenariosContent = this.scenarios[this.selectedFolder].scenarios.filter(item => item.status === value.value);
      }
    },

    getUrlCreateNewScenario() {
      if (this.type === 'template') {
        return process.env.MIX_ROOT_PATH + '/template/scenarios/create?folder_id=' + this.scenarios[this.selectedFolder].id;
      }
      return process.env.MIX_ROOT_PATH + '/scenarios/create?folder_id=' + this.scenarios[this.selectedFolder].id;
    }
  }
};
</script>

<style lang="scss" scoped>
.table-responsive > .table > thead > tr > th {
  white-space: nowrap !important;
  height: 49px;
}

.btn-action {
  white-space: nowrap;
  width: auto!important;
}

.tag-header {
  height: 40px;
  color: white;
  .col-r {
    display: inline-flex;
    float: right;
  }
  button {
    color: black!important;
  }
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
    overflow: hidden;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }
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
    margin-right: 10px;
    cursor: pointer;
  }

}

.table-scenario {
  min-width: 800px;
}

.table-responsive {
  overflow: auto;
  height: 100%;
  margin-bottom: 0px!important;
  thead {
    border-bottom: none!important;
    th {
      padding: 8px!important;
      border-bottom: none!important;
      position: sticky; top: 0;
      background:#e0e0e0;
      border-radius: 0px!important;
    }
  }
}
</style>
