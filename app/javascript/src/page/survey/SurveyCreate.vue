<template>
  <div>
    <div>
      <div class="card">
        <div class="card-body">
          <div class="row">
            <div class="col-xl-6">
              <div class="form-group">
                <label class="fw-300">フォーム名(管理用)<required-mark/></label>
                <div class="flex-grow-1">
                  <input v-model.trim="surveyData.name" type="text" name="survey-name" class="form-control" placeholder="" v-validate="'required'" data-vv-as="フォーム名(管理用)">
                  <error-message :message="errors.first('survey-name')"></error-message>
                </div>
              </div>
              <div class="form-group">
                <label>タイトル<required-mark/></label>
                <input v-model.trim="surveyData.title" type="text" name="survey-title" class="form-control" placeholder="" v-validate="'required'" data-vv-as="タイトル">
                <error-message :message="errors.first('survey-title')"></error-message>
              </div>

              <div class="custom-control custom-checkbox">
                <input type="checkbox" class="custom-control-input" id="" v-model.trim="surveyData.re_answer">
                <label class="custom-control-label" for="customCheck1">何度でも回答可能にする</label>
              </div>
            </div>

            <div class="col-xl-6">
              <div class="form-group">
                <label>説明<required-mark/></label>
                <textarea rows="6" v-model.trim="surveyData.description" type="text" name="survey-description"
                    class="form-control"
                    placeholder="" v-validate="'required'"
                    data-vv-as="説明">
                </textarea>
                <error-message :message="errors.first('survey-description')"></error-message>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- <input v-model.trim="surveyData.liff_id" type="hidden" name="liff_id" class="form-control"
              placeholder="" v-validate="'required'"> -->
      <div class="card">
        <div class="card-body">
          <survey-editor
            :data="surveyData.questions"
            name="survey-editor"
            @input="surveyData.questions = $event">
          </survey-editor>
        </div>
      </div>

      <div class="form-group mt-2">
        <label>回答後の文章<required-mark/></label>
        <textarea
          v-model.trim="surveyData.success_message" type="text" name="survey-success-message"
          class="form-control"
          placeholder=""
          v-validate="'required'"
          data-vv-as="回答後の文章">
        </textarea>
        <error-message :message="errors.first('survey-success-message')"></error-message>
      </div>

      <div class="form-group mt-2">
        <label>回答後のアクション</label>
        <message-action-type-default
          name="survey-action"
          :value="surveyData.action"
          :labelRequired="false"
          :showTitle="false"
          :showLaunchMesasge="false"
          @input="surveyData.action = $event"
        ></message-action-type-default>
      </div>

      <div class="flex">
        <form target="_blank" :action="`${route}/preview`" method="POST">
          <input type="hidden" name="data" :value="JSON.stringify(surveyData)">
          <button class="btn btn-submit btn-block" type="submit"><i class="fa fa-eye"></i>&nbsp;&nbsp;プレビュー
          </button>
        </form>
        <div style="width: 20px"></div>
        <button class="btn btn-submit btn-block" type="button" @click="submit()"><i class="fa fa-save"></i>&nbsp;&nbsp;保存
        </button>
        <div style="width: 20px"></div>
        <button class="btn btn-submit btn-confirm" type="button" @click="publish()"><i
          class="fa fa-upload"></i>&nbsp;&nbsp;保存＆公開
        </button>
      </div>
    </div>

    <modal-confirm title="公開後、編集できませんがよろしいでしょうか。" id='modal-publish' type='confirm'
                  @input="submit(true)"/>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import Divider from '../../components/common/Divider.vue';

export default {
  components: { Divider },
  props: ['data', 'route', 'plan', 'liff_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      isCreate: this.data == null,
      folders: [],
      surveyData: this.data || {
        name: null,
        liff_id: this.liff_id,
        title: null,
        folder_id: null,
        description: null,
        questions: null,
        action: null,
        success_message: null,
        re_answer: true
      }
    };
  },
  async beforeMount() {
    this.folders = await this.getFolders();
    await this.getTags({ low: true });
  },
  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('survey', [
      'update',
      'createNew',
      'delete',
      'getFolders'
    ]),

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

    async publish() {
      const passed = await this.validateForm();
      if (passed) {
        $('#modal-publish').modal('show');
      }
    },

    async submit(isPushlish = false) {
      const passed = await this.validateForm();
      // find indexFolder

      if (passed) {
        const folderIndex = this.folders.findIndex((folder) => {
          return folder.id === this.surveyData.folder_id;
        });

        this.surveyData.is_publish = isPushlish;
        if (isPushlish) {
          this.surveyData.status = 'enable';
        }
        if (this.isCreate) {
          this.createNew(this.surveyData).then(() => {
            window.toastr.success('成功');
            location.href = this.route + '?folder_index=' + folderIndex;
          }).catch(() => {
            window.toastr.error('失敗');
            location.href = this.route + '?folder_index=' + folderIndex;
          });
        } else {
          this.update(this.surveyData).then((res) => {
            window.toastr.success('成功');
            location.href = this.route + '?folder_index=' + folderIndex;
          }).catch(() => {
            window.toastr.error('失敗');
            location.href = this.route + '?folder_index=' + folderIndex;
          });
        }
      }
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
      background: #00B900;
      border: 1px solid #00B900;
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
      border: 1px solid #00B900;
      color: #00B900;
    }
    .survey {
      border: 1px solid #dedede;
      border-radius: 4px;
      padding: 10px;
    }
  }
</style>
