<template>
  <section>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">入力フォーム一覧</h3>
      <div style="display: flex">
        <input class="form-control" style="margin-right: 5px;" placeholder="名称" v-model="textSearch">

      </div>
    </div>
    <div>
      <folder-left
        type="survey"
        :data="surveys"
        :isPc="isPc"
        :selectedFolder="selectedFolder"
        @changeSelectedFolder="changeSelectedFolder"
        @submitEditFolder="submitEditFolder"
        @submitAddNewFolder="submitAddNewFolder"
      ></folder-left>
      <div :class="getClassRightTag()">
        <div class="tag-header">
          <div class="col-r">
            <div class="btn-common02 fz14">
              <a :href="`${route}/create`"
                 v-if="permission == 1 && surveys && surveys.length > selectedFolder && surveys[selectedFolder]"><span>新規作成</span></a>
            </div>
          </div>
        </div>
        <div class="tag-content">
          <div class="x-tag-header">
            <div class="x-btn-back">
              <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
            <div class="x-title"
                 v-if="surveys[selectedFolder]">{{surveys[selectedFolder].name}}
            </div>
          </div>

          <div class="tag-scroll" v-if="!isBlink">
            <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center" style="overflow-x: scroll">
              <table class="table table-hover table-scenario">
                <thead>
                <tr>
                  <th class="w5">No.</th>
                  <th class="" style="width: 100%">名称</th>
                  <th class="w10" style="min-width: 83px;">無効化</th>
                  <th class="w30"></th>
                </tr>
                </thead>
                <tbody v-if="surveyContents && surveyContents.length">
                <template v-for="(survey, index) in surveyContents">
                  <tr v-if="survey.is_publish == 1 || permission == 1" v-bind:key="index">
                    <td>{{index + 1}}</td>
                    <td style="text-align: left">{{survey.name}}</td>
                    <td style="text-align: center;">
                      <div class="toggle-switch" style="margin: auto;" v-if="survey.is_publish">
                        <input v-bind:id="survey.id" class="toggle-input" type="checkbox"
                               v-model="survey.status" true-value="enable"
                               false-value="disable"
                               @change="updateStatus(survey)">
                        <label v-bind:for="survey.id" class="toggle-label"/>
                        <span></span>
                      </div>
                      <span v-else>下書き</span>

                    </td>

                    <td class="row-btn" style="text-align: left; display: flex">
                      <div class="btn-edit01" v-if="!survey.is_publish && permission == 1" v-tooltip="'編集'">
                        <a class="btn-more btn-more-linebot btn-block" :href="`${route}/${survey.id}/edit`">
                          <i class="fas fa-edit"></i>
                        </a>
                      </div>
                      <div class="btn-edit01 btn-info-linebot" v-if="survey.is_publish" v-tooltip="'回答一覧'">
                        <a class="btn-more btn-more-linebot btn-block" :href="`${route}/${survey.id}/info`">
                          回答一覧
                        </a>
                      </div>
                      <div class="btn-edit01" @click="modalCopy(survey)" v-tooltip="'複製'" v-if="permission == 1">
                        <a class="btn-more btn-more-linebot btn-block">
                          <i class="fas fa-copy"></i>
                        </a>
                      </div>
                      <div class="btn-edit01" @click="modalDelete(survey)" v-tooltip="'削除'" v-if="permission == 1">
                        <a class="btn-more btn-more-linebot btn-block">
                          <i class="fas fa-trash"></i>
                        </a>
                      </div>
                    </td>
                  </tr>
                </template>
                </tbody>
                <tbody v-else>
                <tr>
                  <td colspan="3">
                    データなし
                  </td>
                  <td></td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm v-bind:title="'コピーしますか？'" type='confirm' @input="copySurvey"></modal-confirm>
    <modal-confirm title="こちらのアンケートを削除しますか？" id="modal-delete-confirm" type='confirm' @input="deleteSurvey"></modal-confirm>
    <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteTag"/>
  </section>
</template>

<script>
export default {
  props: ['data', 'route', 'permission', 'plan'],
  data() {
    return {
      isBlink: false,
      surveys: [],
      surveysData: [],
      selectedFolder: 0,
      scenarioIndex: 0,
      surveyContents: 0,
      isPc: true,
      survey: null,
      textSearch: null

    };
  },
  beforeMount() {
    if (this.plan && this.plan.level === '3') {
      this.getSurveys();
    } else {
      window.location.href = '/';
    }
  },
  created() {
    this.selectedFolder = location.href.getParameterByName('folder_index') || 0;
  },

  watch: {
    textSearch(val) {
      console.log(val);
      if (!val) {
        this.surveys = this.surveyData;
      } else {
        if (this.surveys.length > 0) {
          const flatMap = [];
          for (const surveyFolder of this.surveyData) {
            for (const survey of surveyFolder.surveys) {
              flatMap.push(survey);
            }
          }

          const data = flatMap.findWhere(function(survey) {
            // console.log(survey);
            return survey.name.includes(val);
          });

          this.surveys = [{
            name: '名称',
            surveys: data
          }].concat(this.surveyData);

          this.changeSelectedFolder(0);
        } else {
          this.surveys = [];
        }
      }
    }
  },
  methods: {
    blink() {
      this.isBlink = true;
      this.$nextTick(() => {
        this.isBlink = false;
      });
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

    getSurveys() {
      this.$store.dispatch('survey/list', {}).done((res) => {
        console.log(res);
        this.surveys = res;
        this.surveyData = JSON.parse(JSON.stringify(res));
        if (this.surveys.length > this.selectedFolder) {
          this.surveyContents = this.surveys[this.selectedFolder].surveys;
        }
      }).fail(() => {
      });
    },
    changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.surveyContents = this.surveys[index].surveys;
      this.blink();
    },
    submitEditFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.surveys[this.selectedFolder].name = res.name;
        }).fail(e => {
        });
    },
    submitAddNewFolder(value) {
      this.$store
        .dispatch('global/createFolder', value)
        .done(res => {
          this.getSurveys();
        }).fail(e => {
        });
    },
    updateStatus(survey) {
      this.$store.dispatch('survey/updateStatus', {
        id: survey.id,
        status: survey.status
      }).done((res) => {
        this.$toastr.s('ステータスが変更されました');
      }).fail(() => {
        this.$toastr.e('ステータスの変更はエラーになりました');
      });
    },
    modalCopy(survey) {
      this.survey = survey;
      $('#modal-confirm').modal('show');
      $('#modal-confirm').on('hidden.bs.modal', function() {
        this.survey = null;
        $('#modal-confirm').off();
      });
    },
    copySurvey() {
      if (this.survey) {
        this.$store.dispatch('survey/copy', {
          id: this.survey.id
        }).done(() => {
          this.getSurveys();
        }).fail(() => {
          this.$toastr.e('コピーエラー');
        });
      }
    },
    modalDelete(survey) {
      this.survey = survey;
      $('#modal-delete-confirm').modal('show');
      $('#modal-delete-confirm').on('hidden.bs.modal', function() {
        this.survey = null;
        $('#modal-delete-confirm').off();
      });
    },
    deleteSurvey() {
      if (this.survey) {
        this.$store.dispatch('survey/destroy', {
          id: this.survey.id
        }).done(() => {
          this.getSurveys();
        }).fail(() => {
          this.$toastr.e('削除エラー');
        });
      }
    },

    submitDeleteTag() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.surveys[this.selectedFolder].id, type: 'survey' })
        .done(res => {
          this.surveys.splice(this.selectedFolder, 1);
          this.selectedFolder -= 1;
          this.surveyContents = this.surveys[this.selectedFolder].surveys;
        }).fail(e => {
        });
    }

  }
};
</script>
<style lang="scss" scoped>
  .table-responsive > .table > thead > tr > th {
    white-space: nowrap !important;
    height: 42px;
  }

  .btn-action {
    white-space: nowrap;
    width: auto !important;
  }

  .tag-header {
    height: 40px;
    color: white;
    .col-r {
      display: inline-flex;
      float: right;
    }
    button {
      color: black !important;
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
    margin-bottom: 0px !important;
  }

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

  .table-scenario {
    min-width: 580px;
  }

  .table-responsive {
    overflow: auto;
    height: 100%;
    margin-bottom: 0px !important;
    thead {
      border-bottom: none !important;
      th {
        padding: 8px !important;
        border-bottom: none !important;
        position: sticky;
        top: 0;
        z-index: 20;
        background: #e0e0e0;
        border-radius: 0px !important;
      }
    }
  }

  .btn-copy {
    border: 1px solid #00B900 !important;
    color: #00B900 !important;
    background: transparent !important;
  }

  .btn-more,
  .btn-edit01 {
    margin-right: 5px;
    margin-bottom: 5px;
    width: 40px !important;
  }

  .btn-edit01.btn-info-linebot,
  .btn-info-linebot .btn-more {
    max-width: 100px !important;
    width: 100px !important;
  }

  ::v-deep {
    .modal-dialog {
      margin: auto !important;
    }
    @media(max-width: 991px) {
      .btn-copy {
        min-width: 80px;
        margin-bottom: 10px;
      }
    }
  }
</style>
