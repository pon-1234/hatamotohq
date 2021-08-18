<template>
  <div class="bot-create create-content">
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">新規自動応答メッセージ</h3>
    </div>

    <div class="form-common01">
      <div class="form-border">
        <div class="form-group">
          <label>タイトル<span class="label label-sm label-danger">必須</span></label>
          <input type="text" name="bot-title" class="form-control" v-model="message.title" placeholder="タイトルを入力してください" v-validate="'required'">
          <span v-if="errors.first('bot-title')" class="is-validate-label">タイトルは必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">設定</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-keyword01">
              <input id="keyword-onoff-setting01" class="toggle-input" type="checkbox"
                     v-model="message.status" true-value="enable"
                     false-value="disable">
              <label for="keyword-onoff-setting01" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="keyword-status keyword-status01 no-mgn">オン</p>
          </div>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">キーワード<span class="label label-sm label-danger">必須</span></label>
          <!-- <div class="flex start ai_center mb10">
            <div class="toggle-switch btn-keyword02">
              <input id="keyword-onoff-setting02" class="toggle-input" type="checkbox"
                     v-model="message.keyword_status" true-value="enable"
                     false-value="disable">
              <label for="keyword-onoff-setting02" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="keyword-status no-mgn"  v-if="message.keyword_status =='enable'">キーワードを有効にする<span class="label label-sm label-danger">必須</span></p>
            <p class="keyword-status no-mgn"  v-else>キーワードを無効にする</p>
          </div> -->
          <b-form-tags class="bot-tag" input-id="tags-basic" v-model="message.keywords" :class="errors.first('bot-tag') ? 'is-validate' : ''"
            placeholder="キーワードを入力してください" separator=" ,;" :disabled="(message.keyword_status !=='enable')" :add-button-text="'追加'" >
          </b-form-tags>
          <input type='hidden' name="bot-tag" v-model="message.keywords" v-validate="{required: message.keyword_status =='enable'}"/>
          <p class="no-mgn">
            <small>キーワードはコンマ(半角)区切りで複数設定可能です。【例】キーワード01,キーワード02,キーワード03</small>
          </p>
          <span class="is-validate-label"  v-if="error"><b>{{ error.keyword}}</b>のキーワードが<b>{{error.title}}</b>で設定されているため設定できません。</span>
          <span v-else-if="errors.first('bot-tag')" class="is-validate-label">キーワードは必須です</span>
        </div>
      </div>
      <div class="form-border">
        <div class="form-group" v-if="refresh_content">
          <label>メッセージ本文</label>
          <div class="btn-template mb20 fz14">
            <a class="btn-block" data-toggle="modal" data-target="#modal-template">テンプレートから作成</a>
            <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/>
          </div>

          <message-content-distribution
            :isDisplayTemplate="true"
            v-for="(item, index) in message.auto_message_content_distributions"
            :key="index"
            v-bind:data="item"
            v-bind:index="index"
            v-bind:countMessages="message.auto_message_content_distributions.length"
            @input="changeContent"
            @setTemplate="selectTemplate"
            @remove="removeContent"
            @moveTopMessage="moveTopMessage"
            @moveBottomMessage="moveBottomMessage"
          />

          <div class="btn-common02 btn-form01 text-center fz14">
            <a
              class="btn-add-form01"
              @click="addMoreMessageContentDistribution"
              v-if="message.auto_message_content_distributions.length < 3"
            >
              <span>追加</span>
            </a>
          </div>
        </div>
      </div>
      <div class="form-bottom">
        <div class="row-form-btn flex start">
          <button type="submit" class="btn btn-submit btn-block" @click="botCreateMessage()">保存</button>
        </div>
      </div>
    </div>
    <message-preview />
  </div>

</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      error: null,
      refresh_content: true,
      message: {
        title: '',
        status: 'enable',
        keywords: [],
        keyword_status: 'enable',
        auto_message_content_distributions: [
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
    await this.fetchItem();
    await this.getTags();
    await this.listTagAssigned();
  },

  watch: {
    message: {
      handler(val) {
        this.updateContentMessageDistributions(this.message);
      },
      deep: true
    },
    'message.keywords': {
      handler: function(after, before) {
        this.error = null;
        if (after.length > 0 && after.length > before.length) {
          const keyword = after.last();
          this.botWithKeyword({
            keyword: keyword
          }).then((res) => {
            if (res) {
              this.message.keywords.splice(this.message.keywords.length - 1, 1);
              this.$nextTick(() => {
                this.error = {
                  keyword: keyword,
                  title: res.title
                };
              });
            }
          });
        }
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    ...mapActions('bot', [
      'botAdd',
      'botWithKeyword',
      'updateContentMessageDistributions'
    ]),

    ...mapActions('global', [
      'fetchUserData',
      'getActionObject'
    ]),

    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    async fetchItem() {
      await this.fetchUserData();
      await this.getActionObject();
    },

    async botCreateMessage() {
      const result = await this.$validator.validateAll();
      this.setIsSubmitChange();

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
        ...this.message
      };
      await this.botAdd(data);
      window.location.href = process.env.MIX_ROOT_PATH + '/bots?is_created=true';
    },

    changeContent({ index, content }) {
      this.message.auto_message_content_distributions.splice(index, 1, content);
    },

    addMoreMessageContentDistribution() {
      this.message.auto_message_content_distributions.push({
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

      Object.assign(this.message, {
        title: template.title,
        auto_message_content_distributions: template.contents
      });

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    removeContent(index) {
      this.message.auto_message_content_distributions.splice(index, 1);
      console.log('aaaa');
      this.refresh_content = false;
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.message.auto_message_content_distributions[index];
      this.message.auto_message_content_distributions[index] = this.message.auto_message_content_distributions.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.message.auto_message_content_distributions[index];
      this.message.auto_message_content_distributions[index] = this.message.auto_message_content_distributions.splice(index + 1, 1, option)[0];
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
