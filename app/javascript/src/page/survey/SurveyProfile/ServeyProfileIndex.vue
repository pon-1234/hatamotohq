<template>
  <section>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">友だち情報名</h3>
    </div>
    <div>
      <folder-left
        type="survey_profile"
        :data="surveyProfiles"
        :isPc="isPc"
        :selectedFolder="selectedFolder"
        @changeSelectedFolder="changeSelectedFolder"
        @submitUpdateFolder="submitUpdateFolder"
        @submitCreateFolder="submitCreateFolder"
      ></folder-left>
      <div :class="getClassRightTag()">
        <div class="tag-header">
          <div class="col-r">
            <div class="btn-common02 fz14">
              <a @click="addProfile()"
                 v-if="surveyProfiles && surveyProfiles.length > selectedFolder && surveyProfiles[selectedFolder]"><span>新規作成</span></a>
            </div>
          </div>
        </div>
        <div class="tag-content">
          <div class="x-tag-header">
            <div class="x-btn-back">
              <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
            <div class="x-title"
                 v-if="surveyProfiles[selectedFolder]">{{surveyProfiles[selectedFolder].name}}
            </div>
          </div>

          <div class="tag-scroll" v-if="!isBlink">
            <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center"
                 style="overflow-x: scroll; width: 100%">
              <table class="table table-hover table-scenario">
                <thead>
                <tr>
                  <th class="w20">友だち情報名</th>
                  <th class="" style="width: 25%">形式</th>
                  <th class="w20" style="min-width: 83px; width: 20%">ステータス</th>
                  <th class="w20" style="min-width: 83px;  width: 10%">操作</th>
                </tr>
                </thead>
                <tbody v-if="surveyContents && surveyContents.length">
                <tr v-for="(survey, index) in surveyContents" v-bind:key="index">
                  <td style="text-align: left">{{survey.field_name}}</td>
                  <td>{{survey.type}}</td>
                  <td>
                    <div class="toggle-switch" style="margin: auto;">
                      <input class="toggle-input" type="checkbox"
                             v-model="survey.status"
                             true-value="enable"
                             false-value="disable"
                             @change="updateStatus(survey)">
                      <label v-bind:for="survey.id" class="toggle-label"/>
                      <span></span>
                    </div>
                  </td>
                  <td>
                    <div data-toggle="tooltip" title="編集" class="btn-edit01">
                      <a class="btn-more btn-more-linebot btn-block" @click="showProfileEditor(index, survey)"> <i class="fas fa-edit"></i> </a>
                    </div>
                  </td>
                </tr>
                </tbody>
                <tbody v-else>
                <tr>
                  <td colspan="3">
                    データなし
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
    <survey-profile-editor :model="currentModel" :folderId="currentFolderId"
                           id="survey-profile-editor" @submited="onSubmit()"></survey-profile-editor>
    <!--<modal-confirm v-bind:title="'コピーしますか？'" type='confirm' @input="copySurvey"></modal-confirm>-->
    <!--<modal-confirm title="こちらのアンケートをご確認ください。" id="modal-delete-confirm" type='confirm'-->
    <!--@input="deleteSurvey"></modal-confirm>-->
    <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modalDeleteFolder' type='delete' @input="submitDeleteTag"/>
  </section>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: ['route'],
  data() {
    return {
      isBlink: false,
      surveyProfiles: [],
      surveyContents: [],
      currentModel: null,
      isPc: true,
      selectProfileIndex: -1,
      selectedFolder: location.href.getParameterByName('folder_index') || 0
    };
  },
  created() {
    this.getSurveyProfiles().then((res) => {
      this.surveyProfiles = res;
      this.changeSelectedFolder(this.selectedFolder);
    });
  },

  computed: {
    currentFolderId() {
      if (this.surveyProfiles.length > 0) {
        return this.surveyProfiles[this.selectedFolder].id;
      }
      return null;
    }
  },
  methods: {
    ...mapActions('survey', ['getSurveyProfiles', 'updateSurveyProfile']),
    backToFolder() {
      this.isPc = false;
    },
    addProfile() {
      this.currentModel = null;
      $('#survey-profile-editor').modal('show');
    },
    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },
    blink() {
      this.isBlink = true;
      this.$nextTick(() => {
        this.isBlink = false;
      });
    },

    changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.surveyContents = this.surveyProfiles[index].survey_profile_templates;
      this.blink();
    },
    submitCreateFolder(value) {
      this.$store
        .dispatch('global/createFolder', value)
        .done(res => {
          this.getSurveyProfiles().then((res) => {
            this.surveyProfiles = res;
          });
        }).fail(e => {
        });
    },

    submitUpdateFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.surveyProfiles[this.selectedFolder].name = res.name;
        }).fail(e => {
        });
    },

    showProfileEditor(index, value) {
      $('#survey-profile-editor').modal('show');
      this.currentModel = value;
    },

    onSubmit() {
      $('#survey-profile-editor').modal('hide');
      this.getSurveyProfiles().then((res) => {
        this.surveyProfiles = res;
        this.changeSelectedFolder(this.selectedFolder);
      }).always(() => {
        this.currentModel = null;
      });
    },

    updateStatus(survey) {
      this.updateSurveyProfile({ status: survey.status, id: survey.id });
    },

    submitDeleteTag() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.surveyProfiles[this.selectedFolder].id, type: 'survey_profile' })
        .done(res => {
          this.surveyProfiles.splice(this.selectedFolder, 1);
          this.selectedFolder -= 1;
          this.surveyContents = this.surveyProfiles[this.selectedFolder].surveys;
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
