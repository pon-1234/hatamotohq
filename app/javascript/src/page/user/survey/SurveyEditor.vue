<template>
  <div>
    <div class="mxw-1200" :key="contentKey">
      <div class="card">
        <div class="card-header left-border"><h3 class="card-title">基本設定</h3></div>
        <div class="card-body">
          <div class="form-group d-flex">
            <label class="fw-300">フォルダー</label>
            <div class="flex-grow-1">
              <select v-model="surveyData.folder_id" class="form-control fw-300">
                <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                  {{ folder.name }}
                </option>
              </select>
            </div>
          </div>
          <div class="form-group d-flex">
            <label class="fw-300">フォーム名(管理用)<required-mark /></label>
            <div class="flex-grow-1">
              <input
                v-model.trim="surveyData.name"
                type="text"
                name="survey_name"
                class="form-control"
                placeholder="フォーム名(管理用)を入力してください"
                v-validate="'required|max:255'"
                maxlength="256"
                data-vv-as="フォーム名(管理用)"
              />
              <error-message :message="errors.first('survey_name')"></error-message>
            </div>
          </div>
          <div class="form-group d-flex">
            <label class="fw-300">タイトル<required-mark /></label>
            <input
              v-model.trim="surveyData.title"
              type="text"
              name="survey_title"
              class="form-control flex-grow-1"
              placeholder="タイトルを入力してください"
              v-validate="'required|max:255'"
              data-vv-as="タイトル"
            />
            <error-message :message="errors.first('survey_title')"></error-message>
          </div>

          <div class="form-group d-flex">
            <label class="fw-300">説明<required-mark /></label>
            <textarea
              rows="3"
              v-model="surveyData.description"
              type="text"
              name="survey_description"
              class="form-control flex-grow-1"
              placeholder="説明を入力してください"
              maxlength="1001"
              v-validate="'required|max:1000'"
              data-vv-as="説明"
            >
            </textarea>
            <error-message :message="errors.first('survey_description')"></error-message>
          </div>
          <div class="form-group d-flex">
            <label class="fw-300">回答後の文章</label>
            <textarea
              rows="2"
              v-model="surveyData.success_message"
              type="text"
              name="survey_success_message"
              class="form-control flex-grow-1"
              placeholder="回答後の文章を入力してください"
              data-vv-as="回答後の文章"
              maxlength="1001"
              v-validate="'max:1000'"
            >
            </textarea>
            <error-message :message="errors.first('survey_success_message')"></error-message>
          </div>

          <div class="custom-control custom-checkbox">
            <input
              type="checkbox"
              class="custom-control-input"
              id="repeatAnswerCheck"
              v-model.trim="surveyData.re_answer"
            />
            <label class="custom-control-label" for="repeatAnswerCheck">何度でも回答可能にする</label>
          </div>
        </div>
        <loading-indicator :loading="this.loading"></loading-indicator>
      </div>

      <div class="card">
        <div class="card-header left-border"><h3 class="card-title">質問一覧</h3></div>
        <div class="card-body">
          <survey-question-editor
            :data="surveyData.questions"
            name="survey-question-editor"
            @input="onQuestionsChanged($event)"
          >
          </survey-question-editor>
        </div>
        <loading-indicator :loading="this.loading"></loading-indicator>
      </div>

      <div class="card">
        <div class="card-header left-border"><h3 class="card-title">回答後のアクション</h3></div>
        <div class="card-body">
          <action-editor-custom
            name="survey-action"
            :value="surveyData.after_action"
            :labelRequired="false"
            :showTitle="false"
            :showLaunchMesasge="false"
            @input="surveyData.after_action = $event"
          ></action-editor-custom>
        </div>
        <loading-indicator :loading="this.loading"></loading-indicator>
      </div>

      <div class="card">
        <div class="card-body">
          <div class="btn btn-success mr-2" @click="submit()">保存＆公開</div>
          <div class="btn btn-outline-success mw-120" @click="submit(false)">下書き保存</div>
        </div>
      </div>
    </div>

    <survey-preview :survey="surveyData"></survey-preview>

    <modal-confirm
      title="公開後、編集できませんがよろしいでしょうか。"
      id="modal-publish"
      type="confirm"
      @input="submit(true)"
    />
  </div>
</template>

<script>
import Util from '@/core/util';
import { mapActions, mapState } from 'vuex';

export default {
  props: ['survey_id', 'plan'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      contentKey: 0,
      loading: true,
      surveyData: {
        id: null,
        folder_id: Util.getParamFromUrl('folder_id'),
        name: null,
        title: null,
        description: null,
        questions: null,
        after_action: null,
        success_message: null,
        re_answer: true
      }
    };
  },
  async beforeMount() {
    await this.getTags({ low: true });
    if (this.survey_id) {
      const response = await this.getSurvey(this.survey_id);
      this.parseSurvey(response);
      this.forceRerender();
    }
    await this.getSurveys();
    this.loading = false;
  },

  computed: {
    ...mapState('survey', {
      folders: state => state.folders
    })
  },

  methods: {
    ...mapActions('tag', ['getTags']),
    ...mapActions('survey', ['getSurvey', 'createSurvey', 'updateSurvey', 'delete', 'getSurveys']),

    forceRerender() {
      this.contentKey++;
    },

    parseSurvey(survey) {
      this.surveyData = _.cloneDeep(survey);
    },

    async validateForm() {
      const result = await this.$validator.validateAll();
      if (!result) {
        const $input = $('input, textarea');
        for (const ele of $input) {
          let input = $(ele);
          if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
            if (input.is(':hidden')) {
              input = input.parent();
            }
            $('html,body').animate({ scrollTop: input.offset().top - 250 }, 'fast');
            break;
          }
        }
        return false;
      }
      return true;
    },

    async submit(published = true) {
      if (published) {
        const valid = await this.validateForm();
        if (!valid) return;
      }
      const payload = _.pick(this.surveyData, [
        'id',
        'folder_id',
        'name',
        'title',
        'description',
        'success_message',
        're_answer',
        'after_action'
      ]);
      payload.status = published ? 'published' : 'draft';
      payload.survey_questions_attributes = this.surveyData.questions;
      let response = null;
      if (this.survey_id) {
        response = await this.updateSurvey(payload);
      } else {
        response = await this.createSurvey(payload);
      }
      if (response) {
        Util.showSuccessThenRedirect('回答フォームの保存は完了しました。', `${process.env.MIX_ROOT_PATH}/user/surveys`);
      } else {
        window.toastr.error('回答フォームの保存は失敗しました。');
      }
    },

    onQuestionsChanged(questions) {
      this.surveyData.questions = questions;
      // this.forceRerender();
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
    .liff_box {
      margin-top: 200px;
      text-align: center;
      font-size: 16pt;
    }
    .liff_box p {
      font-weight: bold;
      margin: 20px;
    }

    .btn-link {
      text-transform: uppercase;
      background: #00b900;
      border: 1px solid #00b900;
      color: #ffffff;
      font-weight: bold;
      font-size: 16pt;
      padding-left: 30px;
      padding-right: 30px;
    }
    .btn-submit {
      text-transform: uppercase;
      width: initial;
      min-width: 100px;
    }
    .btn-confirm {
      text-transform: uppercase;
      background: white;
      border: 1px solid #00b900;
      color: #00b900;
    }
    .survey {
      border: 1px solid #dedede;
      border-radius: 4px;
      padding: 10px;
    }
  }
</style>
