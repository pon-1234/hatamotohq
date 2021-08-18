<template>
  <section v-if="liff_id">
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">アンケート</h3>
    </div>
    <div class="form-common01">
      <div class="form-border">
        <div class="form-group">
          <label>アンケート名<span class="label label-sm label-danger">必須</span></label>
          <input v-model.trim="surveyData.name" type="text" name="survey-name" class="form-control"
                 placeholder="" v-validate="'required'">
          <span v-if="errors.first('survey-name')" class="is-validate-label">アンケート名は必須です</span>
        </div>

        <div class="form-group">
          <label>フォルダ<span class="label label-sm label-danger">必須</span></label>
          <select class="form-control" name="survey-folder" v-model="surveyData.folder_id" v-validate="'required'">
            <option v-for="(folder, index) of folders" :key="index" :value="folder.id">{{folder.name}}</option>
          </select>
          <span v-if="errors.first('survey-folder')" class="is-validate-label">フォルダは必須です</span>
        </div>

        <input v-model.trim="surveyData.liff_id" type="hidden" name="liff_id" class="form-control"
                placeholder="" v-validate="'required'">

        <div class="form-group">
          <label>タイトル<span class="label label-sm label-danger">必須</span></label>
          <input v-model.trim="surveyData.title" type="text" name="survey-title" class="form-control"
                 placeholder="" v-validate="'required'">
          <span v-if="errors.first('survey-title')" class="is-validate-label">タイトルは必須です</span>
        </div>

        <div class="form-group">
          <label>説明<span class="label label-sm label-danger">必須</span></label>
          <textarea rows="5" v-model.trim="surveyData.description" type="text" name="survey-description"
                    class="form-control"
                    placeholder="" v-validate="'required'"></textarea>
          <span v-if="errors.first('survey-description')" class="is-validate-label">説明は必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label>複数回答</label>
          <div class="survey">
            <input type="checkbox" name="multiple_answers" id="multiple_answers" v-model.trim="surveyData.multiple_answers" value="true">
            <label for="multiple_answers">
              何度でも回答可能にする
            </label>
          </div>
        </div>
      </div>

      <div class="form-border">
        <survey-editor :data="surveyData.questions"
                       name="survey-editor"
                       @input="surveyData.questions = $event">
        </survey-editor>
      </div>

      <div class="form-border">
        <div class="form-group">
          <label>回答後の文章
            <span class="label label-sm label-danger">必須</span></label>
          <textarea v-model.trim="surveyData.success_message" type="text" name="survey-success-message"
                    class="form-control"
                    placeholder="" v-validate="'required'">
                    </textarea>
          <span v-if="errors.first('survey-success-message')" class="is-validate-label">回答後の文章は必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
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
  </section>
  <section v-else>
    <div class="liff_box">
      <p>LIFF IDが入力されていません</p>
      <p>入力をお願い致します</p>
      <a href="/information/edit" class="btn btn-link">LIFF IDを入力する</a>
    </div>
  </section>
</template>

<script>
import { mapActions } from 'vuex';

export default {
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
        multiple_answers: false
      }
    };
  },
  async beforeMount() {
    if (this.plan && this.plan.level === '3') {
      this.folders = await this.getFolders();
      await this.getTags({ low: true });
    } else {
      window.location.href = '/';
    }
  },
  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
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
            this.$toastr.s('成功');
            location.href = this.route + '?folder_index=' + folderIndex;
          }).catch(() => {
            this.$toastr.e('失敗');
            location.href = this.route + '?folder_index=' + folderIndex;
          });
        } else {
          this.update(this.surveyData).then((res) => {
            this.$toastr.s('成功');
            location.href = this.route + '?folder_index=' + folderIndex;
          }).catch(() => {
            this.$toastr.e('失敗');
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
