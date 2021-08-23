<template>
  <div class="bot-edit create-content">
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">新規自動応答メッセージ</h3>
    </div>

    <div class="form-common01" v-if="message_data">
      <div class="form-border">
        <div class="form-group">
          <label>タイトル<span class="label label-sm label-danger">必須</span></label>
          <input type="text" class="form-control" v-model="message_data.title" placeholder="タイトルを入力してください"  v-validate="'required'">
        </div>
      </div>
      <div class="form-border">
        <div class="form-group">
          <label class="mb10">設定</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-keyword01">
              <input id="keyword-onoff-setting01" class="toggle-input" type="checkbox"
                     v-model="message_data.status" true-value="enable" false-value="disable" >
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
          <label class="mb10">キーワード</label>
          <!-- <div class="flex start ai_center mb10">
            <div class="toggle-switch btn-keyword02">
              <input id="keyword-onoff-setting02" class="toggle-input" type="checkbox"
                     v-model="message_data.keyword_status" true-value="enable"
                     false-value="disable">
              <label for="keyword-onoff-setting02" class="toggle-label">
                <span></span>
              </label>
            </div>
            <p class="keyword-status no-mgn"  v-if="message_data.keyword_status =='enable'">キーワードを有効にする<span class="label label-sm label-danger">必須</span></p>
            <p class="keyword-status no-mgn"  v-else>キーワードを無効にする</p>
          </div> -->
          <b-form-tags class="bot-tag" input-id="tags-basic" v-model="message_data.keywords" :class="errors.first('bot-tag') ? 'is-validate' : ''"
            placeholder="キーワードを入力してください" separator=" ,;" :disabled="(message_data.keyword_status !=='enable')" :add-button-text="'追加'">
          </b-form-tags>
          <input type='hidden' name="bot-tag" v-model="message_data.keywords" v-validate="{required: message_data.keyword_status =='enable'}"/>
          <p class="no-mgn">
            <small>キーワードはコンマ(半角)区切りで複数設定可能です。【例】キーワード01,キーワード02,キーワード03</small>
          </p>
          <span class="is-validate-label"  v-if="error"><b>{{ error.keyword}}</b>のキーワードが<b>{{error.title}}</b>で設定されているため設定できません。</span>
          <span v-else-if="errors.first('bot-tag')" class="is-validate-label">キーワードは必須です</span>        </div>
      </div>
      <div class="form-border">
        <div class="form-group"  v-if="refresh_content">
          <label>メッセージ本文</label>
          <div class="btn-template mb20 fz14">
            <a class="btn-block" data-toggle="modal" data-target="#modal-template">テンプレートから作成</a>
            <modal-select-message-template @setTemplate="selectTemplate" id="modal-template"/>
          </div>

          <message-content-distribution
            :isDisplayTemplate="true"
            v-for="(item, index) in message_data.auto_broadcast_messages"
            :key="index"
            v-bind:data="item"
            v-bind:index="index"
            v-bind:countMessages="message_data.auto_broadcast_messages.length"
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
              v-if="message_data.auto_broadcast_messages.length < 3"
            >
              <span>追加</span>
            </a>
          </div>
        </div>
      </div>
      <div class="form-bottom">
        <div class="row-form-btn flex start">
          <button type="submit" class="btn btn-submit btn-block" @click="botEditMessage()" >保存</button>
        </div>
      </div>
    </div>
    <message-preview />
  </div>

</template>
<script>
import { mapState, mapActions } from 'vuex';

export default {
  props: ['route', 'message_id'],
  data() {
    return {
      error: null,
      refresh_content: true,
      message_data: null
    };
  },

  async beforeMount() {
    await this.fetchItem();
    await this.getTags();
    await this.listTagAssigned();
  },

  computed: {
    ...mapState('bot', {
      message: state => state.message
    })
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  watch: {
    message_data: {
      handler(val) {
        this.updateContentMessageDistributions(this.message_data);
      },
      deep: true
    },
    'message_data.keywords': {
      handler: function(after, before) {
        this.error = null;
        if (after && before) {
          if (after.length > 0 && after.length > before.length) {
            const keyword = after.last();
            this.botWithKeyword({
              keyword: keyword
            }).then((res) => {
              if (res) {
                console.log(this.message_id);
                if (parseInt(this.message_id) !== res.id) {
                  this.message_data.keywords.splice(this.message_data.keywords.length - 1, 1);
                  this.$nextTick(() => {
                    this.error = {
                      keyword: keyword,
                      title: res.title
                    };
                  });
                }
              }
            });
          }
        }
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('bot', [
      'botDetail',
      'botEdit',
      'botWithKeyword',
      'updateContentMessageDistributions'
    ]),

    ...mapActions('global', [
      'getActionObject'
    ]),

    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    async fetchItem() {
      await this.getActionObject();
      await this.botDetail({ id: this.message_id });
      // eslint-disable-next-line no-undef
      this.message_data = _.cloneDeep(this.message);
    },

    async botEditMessage() {
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
      await this.botEdit({ message: this.message_data, isLoad: true });
      window.location.href = process.env.MIX_ROOT_PATH + '/bots?is_updated=true';
    },

    changeContent({ index, content }) {
      this.message_data.auto_broadcast_messages.splice(index, 1, content);
    },

    addMoreMessageContentDistribution() {
      this.message_data.auto_broadcast_messages.push({
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

      Object.assign(this.message_data, {
        title: template.title,
        auto_broadcast_messages: template.contents
      });

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    removeContent({ index }) {
      this.message_data.auto_broadcast_messages.splice(index, 1);
      this.refresh_content = false;
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.auto_broadcast_messages[index];
      this.message_data.auto_broadcast_messages[index] = this.message_data.auto_broadcast_messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.auto_broadcast_messages[index];
      this.message_data.auto_broadcast_messages[index] = this.message_data.auto_broadcast_messages.splice(index + 1, 1, option)[0];
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
