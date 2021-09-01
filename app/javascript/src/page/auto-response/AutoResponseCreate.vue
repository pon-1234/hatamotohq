<template>
  <div class="mw-1200" >
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${MIX_ROOT_PATH}/user/broadcasts`" class="text-info">
          <i class="fa fa-arrow-left"></i> 自動応答一覧
        </a>
        <h5 class="m-auto font-weight-bold">新規自動応答メッセージ</h5>
      </div>

      <div class="card-body">
        <div class="form-group">
          <label>自動応答名<required-mark/></label>
          <input type="text" name="name" class="form-control" v-model="autoResponseData.name" placeholder="自動応答名を入力してください" v-validate="'required'" data-vv-as="自動応答名">
          <error-message :message="errors.first('name')"></error-message>
        </div>
        <div class="form-group">
          <label class="mb10">設定</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-keyword01">
              <input id="keyword-onoff-setting01" class="toggle-input" type="checkbox"
                    v-model="autoResponseData.status" true-value="enable"
                    false-value="disable">
              <label for="keyword-onoff-setting01" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="keyword-status keyword-status01 no-mgn">オン</p>
          </div>
        </div>

        <div class="card">
          <div class="card-header left-border">
            <h3>反応するキーワードを設定する</h3>
          </div>
          <div class="card-body">
            <div class="form-group d-flex flex-column">
              <label class="mb10">キーワード<required-mark/></label>
              <b-form-tags class="bot-tag" input-id="tags-basic" v-model="autoResponseData.keywords" :class="errors.first('bot-tag') ? 'is-validate' : ''"
                placeholder="キーワードを入力してください" separator=" ,;" :disabled="(autoResponseData.keyword_status !=='enable')" :add-button-text="'追加'" >
              </b-form-tags>
              <input type='hidden' name="keywords" data-vv-as="キーワード" v-model="autoResponseData.keywords" v-validate="{required: autoResponseData.keyword_status =='enable'}"/>
              <div>
                <small>キーワードはコンマ(半角)区切りで複数設定可能です。【例】キーワード01,キーワード02,キーワード03</small>
              </div>
              <span class="is-validate-label"  v-if="error"><b>{{ error.keyword}}</b>のキーワードが<b>{{error.name}}</b>で設定されているため設定できません。</span>
              <error-message class="w-100" :message="errors.first('keywords')"></error-message>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-header left-border">
            <h3>反応時のアクションを設定する</h3>
          </div>
          <div class="card-body">
            <div class="form-border">
              <div class="form-group" v-if="refresh_content">
                <label>メッセージ本文</label>
                <div>
                  <div class="btn btn-primary" data-toggle="modal" data-target="#modal-template">テンプレートから作成</div>
                </div>
                <!-- <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/> -->

                <message-editor
                  :isDisplayTemplate="true"
                  v-for="(item, index) in autoResponseData.messages"
                  :key="index"
                  v-bind:data="item"
                  v-bind:index="index"
                  v-bind:countMessages="autoResponseData.messages.length"
                  @input="onMessageContentChanged"
                  @setTemplate="selectTemplate"
                  @remove="removeContent"
                  @moveTopMessage="moveTopMessage"
                  @moveBottomMessage="moveBottomMessage"
                />

                <div>
                  <div class="btn btn-outline-success" @click="addMoreMessageContentDistribution" v-if="autoResponseData.messages.length < MAX_AUTO_RESPONSE_MESSAGE">
                    <i class="fa fa-plus"></i><span> メッセージ追加</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="card-footer">
        <button type="submit" class="btn btn-success fw-120" @click="submitCreate()">保存</button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
      <message-preview />
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: {
    autoResponseId: Number
  },
  data() {
    return {
      MAX_AUTO_RESPONSE_MESSAGE: 3,
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      loading: true,
      error: null,
      refresh_content: true,
      autoResponseData: {
        name: '',
        status: 'enable',
        keywords: [],
        keyword_status: 'enable',
        messages: [
          {
            message_type_id: this.MessageTypeIds.Text,
            content: {
              type: this.MessageType.Text,
              text: ''
            }
          }
        ]
      }
    };
  },
  provide() {
    return { parentValidator: this.$validator };
  },

  async beforeMount() {
    if (this.autoResponseId) {
      await this.getAutoResponse(this.autoResponseId);
    }
    await this.getTags();
    this.loading = false;
  },

  watch: {
    autoResponseData: {
      handler(val) {
        this.updateContentMessageDistributions(this.autoResponseData);
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),

    ...mapActions('autoResponse', [
      'getAutoResponse',
      'createAutoResponse',
      'updateContentMessageDistributions'
    ]),

    async submitCreate() {
      const result = await this.$validator.validateAll();

      if (!result) {
        $('input, textarea').each(
          function(index) {
            var input = $(this);
            if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
              $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
              return false;
            }
          }
        );
        return;
      };
      const data = {
        folder_id: Util.getQueryParamsUrl('folder_id'),
        ...this.autoResponseData
      };
      await this.createAutoResponse(data);
    },

    onMessageContentChanged({ index, content }) {
      this.autoResponseData.messages.splice(index, 1, content);
    },

    addMoreMessageContentDistribution() {
      this.autoResponseData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    selectTemplate(template) {
      // eslint-disable-next-line no-undef
      this.refresh_content = false;

      Object.assign(this.autoResponseData, {
        name: template.name,
        messages: template.contents
      });

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    removeContent(index) {
      this.autoResponseData.messages.splice(index, 1);
      console.log('aaaa');
      this.refresh_content = false;
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    }
  }
};
</script>
<style lang="scss"  scoped>
  ::v-deep {
    #tags-basic {
      border: none;
      background-color: rgba(255, 255, 255, 0)!important;
    }
    .bot-tag.disabled {
      background-color: #ccc !important;
    }
  }
</style>
