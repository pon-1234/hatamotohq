<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="survey"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="changeSelectedFolder"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        ></folder-left>
        <div class="flex-grow-1" :key="contentKey">
          <a
            :href="`${MIX_ROOT_PATH}/user/surveys/new?folder_id=${curFolder ? curFolder.id : null}`" class="btn btn-primary">
            <i class="fa fa-plus"></i> 新規作成
          </a>
          <div class="mt-2">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>未公開／公開</th>
                  <th>フォーム名</th>
                  <th>回答状態</th>
                  <th>無効化</th>
                  <th></th>
                </tr>
              </thead>
              <tbody v-if="curFolder">
                <tr v-for="(survey, index) in curFolder.surveys" v-bind:key="index">
                  <td>
                    <div v-if="survey.status !== 'draft'">
                      <input type="checkbox" :id="`switchStatus${index}`" checked data-switch="success"
                        v-model="survey.status" true-value="published" false-value="unpublished"
                        @change="updateStatus(survey)"/>
                      <label :for="`switchStatus${index}`"></label>
                    </div>
                    <span v-else class="text-danger">下書き</span>
                  </td>
                  <td>{{survey.name}}</td>
                  <td class="row-btn" style="text-align: left; display: flex">
                    <div class="btn-edit01" v-if="survey.status !== 'published'" v-tooltip="'編集'">
                      <a class="btn-more btn-more-linebot btn-block" :href="`${MIX_ROOT_PATH}/user/surveys/${survey.id}/edit`">
                        <i class="fas fa-edit"></i>
                      </a>
                    </div>
                    <div class="btn-edit01 btn-info-linebot" v-if="survey.is_publish" v-tooltip="'回答一覧'">
                      <a class="btn-more btn-more-linebot btn-block" :href="`${MIX_ROOT_PATH}/user/surveys/${survey.id}/info`">
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
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="!curFolder || curFolder.surveys.length === 0"><b>回答フォームはありません。</b></div>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm v-bind:title="'コピーしますか？'" type='confirm' @input="copySurvey"></modal-confirm>
    <modal-confirm title="こちらのアンケートを削除しますか？" id="modal-delete-confirm" type='confirm' @input="deleteSurvey"></modal-confirm>
    <modal-confirm title="こちらのフォルダを削除してもよろしいですか？" id='modalDeleteFolder' type='delete' @input="submitDeleteTag"/>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
export default {
  props: ['permission'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      surveysData: [],
      selectedFolderIndex: 0,
      scenarioIndex: 0,
      surveyContents: 0,
      isPc: true,
      survey: null,
      textSearch: null
    };
  },
  async beforeMount() {
    await this.getSurveys();
    this.loading = false;
  },

  computed: {
    ...mapState('survey', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curSurvey() {
      return this.curFolder ? this.curFolder.surveys[this.selectedFolderIndex] : null;
    }
  },

  methods: {
    ...mapActions('survey', [
      'getSurveys'
    ]),
    forceRerender() {
      this.contentKey++;
    },

    changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
      this.blink();
    },
    submitUpdateFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.curFolder.name = res.name;
        }).fail(e => {
        });
    },
    submitCreateFolder(value) {
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
        window.toastr.success('ステータスが変更されました');
      }).fail(() => {
        window.toastr.error('ステータスの変更はエラーになりました');
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
          window.toastr.error('コピーエラー');
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
          window.toastr.error('削除エラー');
        });
      }
    },

    submitDeleteTag() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.surveys[this.selectedFolderIndex].id, type: 'survey' })
        .done(res => {
          this.surveys.splice(this.selectedFolderIndex, 1);
          this.selectedFolderIndex -= 1;
          this.surveyContents = this.surveys[this.selectedFolderIndex].surveys;
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
