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
            :href="`${rootPath}/user/surveys/new?folder_id=${curFolder ? curFolder.id : null}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規作成
          </a>
          <div class="mt-2">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th>公開化</th>
                  <th>フォーム名</th>
                  <th>回答状態</th>
                  <th></th>
                </tr>
              </thead>
              <tbody v-if="curFolder">
                <tr v-for="(survey, index) in curFolder.surveys" v-bind:key="index">
                  <td>
                    <div v-if="survey.status !== 'draft'">
                      <input
                        type="checkbox"
                        :id="`switchStatus${index}`"
                        checked
                        data-switch="success"
                        v-model="survey.status"
                        true-value="published"
                        false-value="unpublished"
                        @change="updateStatus(survey)"
                      />
                      <label class="m-0" :for="`switchStatus${index}`"></label>
                    </div>
                    <span v-else class="text-danger">下書き</span>
                  </td>
                  <td>{{ survey.name }}</td>
                  <td class="mw-200">
                    <template v-if="survey.responses_count === 0"> 未回答 </template>
                    <template v-else>
                      {{ survey.responses_count }}回答／<span class="font-12">{{ survey.users_count }}人</span>
                      <a :href="`${rootPath}/user/surveys/${survey.id}`" class="btn btn-sm btn-light ml-2">表示</a>
                    </template>
                  </td>
                  <td>
                    <div class="btn-group">
                      <button
                        type="button"
                        class="btn btn-light btn-sm dropdown-toggle"
                        data-toggle="dropdown"
                        aria-expanded="false"
                      >
                        操作 <span class="caret"></span>
                      </button>
                      <div class="dropdown-menu">
                        <a
                          role="button"
                          class="dropdown-item"
                          :href="`${rootPath}/user/surveys/${survey.id}/edit`"
                          v-if="survey.status !== 'published'"
                          >回答フォームを編集</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalCopySurvey"
                          @click="curSurveyIndex = index"
                          >回答フォームをコピー</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteSurvey"
                          @click="curSurveyIndex = index"
                          >回答フォームを削除</a
                        >
                      </div>
                    </div>
                    <div class="btn-edit01 btn-info-linebot" v-if="survey.is_publish" v-tooltip="'回答一覧'">
                      <a
                        class="btn-more btn-more-linebot btn-block"
                        :href="`${rootPath}/user/surveys/${survey.id}/info`"
                      >
                        回答一覧
                      </a>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="!curFolder || curFolder.surveys.length === 0">
              <b>回答フォームはありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal-confirm
      title="この回答フォームをコピーしてもよろしいですか？"
      id="modalCopySurvey"
      type="confirm"
      @confirm="submitCopySurvey"
    >
      <template v-slot:content v-if="curSurvey">
        <span>回答フォーム名：{{ curSurvey.name }}</span>
      </template>
    </modal-confirm>
    <modal-confirm
      title="この回答フォームを削除してもよろしいですか？"
      id="modalDeleteSurvey"
      type="delete"
      @confirm="submitDeleteSurvey"
    >
      <template v-slot:content v-if="curSurvey">
        <span>回答フォーム名：{{ curSurvey.name }}</span>
      </template>
    </modal-confirm>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      surveysData: [],
      selectedFolderIndex: 0,
      curSurveyIndex: 0,
      surveyContents: 0,
      isPc: true,
      survey: null,
      textSearch: null
    };
  },
  async beforeMount() {
    await this.getSurveys();
    const folderId = Util.getParamFromUrl('folder_id');
    setTimeout(() => {
      if (folderId) {
        const index = _.findIndex(this.folders, _ => _.id === Number.parseInt(folderId));
        if (index >= 0) {
          this.changeSelectedFolder(index);
        }
      }
    }, 0);
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
      return this.curFolder ? this.curFolder.surveys[this.curSurveyIndex] : null;
    }
  },

  methods: {
    ...mapActions('survey', ['createFolder', 'updateFolder', 'getSurveys', 'copySurvey']),
    forceRerender() {
      this.contentKey++;
    },

    changeSelectedFolder(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
    },

    async submitUpdateFolder(folder) {
      const response = await this.updateFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの変更は完了しました。');
      } else {
        window.toastr.error('フォルダーの変更は失敗しました。');
      }
    },

    async submitCreateFolder(folder) {
      const response = await this.createFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの作成は完了しました。');
      } else {
        window.toastr.error('フォルダーの作成は失敗しました。');
      }
    },

    updateStatus(survey) {
      this.$store
        .dispatch('survey/updateStatus', {
          id: survey.id,
          status: survey.status
        })
        .done(res => {
          window.toastr.success('ステータスが変更されました');
        })
        .fail(() => {
          window.toastr.error('ステータスの変更はエラーになりました');
        });
    },

    async submitCopySurvey() {
      const response = await this.copySurvey(this.curSurvey.id);
      if (response) {
        Util.showSuccessThenRedirect('回答フォームのコピーは完成しました。', location.href);
      } else {
        window.toastr.error('回答フォームのコピーは失敗しました。');
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
    submitDeleteSurvey() {
      if (this.survey) {
        this.$store
          .dispatch('survey/destroy', {
            id: this.survey.id
          })
          .done(() => {
            this.getSurveys();
          })
          .fail(() => {
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
        })
        .fail(e => {});
    }
  }
};
</script>
