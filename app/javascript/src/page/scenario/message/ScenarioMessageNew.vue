<template>
  <div class="mw-1200">
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${userRootUrl}/user/scenarios/${scenario_id}/messages`" class="text-info" v-if="!loading">
          <i class="fa fa-arrow-left"></i> メッセージ一覧
        </a>
        <h5 class="m-auto font-weight-bold">新規登録</h5>
      </div>
      <div class="card-body">
        <scenario-message-time-define
          v-if="!loading"
          :mode="scenario.mode"
          :is_initial.sync="scenarioMessageData.is_initial"
          :date.sync="scenarioMessageData.date"
          :time.sync="scenarioMessageData.time"
          :order.sync="scenarioMessageData.order"
          >
        </scenario-message-time-define>
        <div class="form-common01">
          <div class="form-border">
            <div class="form-group">
              <label>タイトル<required-mark/></label>
              <input type="text" name="talk-title" class="form-control" placeholder="タイトルを入力してください" v-model="scenarioMessageData.name" v-validate="'required'">
              <span v-if="errors.first('talk-title')" class="is-validate-label">タイトルは必須です</span>
            </div>
          </div>
          <div class="form-border">
            <div class="form-group" v-if="refresh_content">
              <label>メッセージ本文</label>
                <message-editor
                :isDisplayTemplate="true"
                  v-for="(item, index) in scenarioMessageData.messages"
                  :key="index"
                  v-bind:data="item"
                  v-bind:index="index"
                  @setTemplate="selectTemplate"
                  @input="changeContent"
                />
            </div>
          </div>
          <div class="form-border">
            <div class="form-group">
              <label class="mb10">配信</label>
              <div class="flex start ai_center">
                <div class="toggle-switch btn-scenario01">
                  <input id="scenario-onoff" class="toggle-input" type="checkbox"
                    v-model="scenarioMessageData.status" true-value="enabled"
                    false-value="disabled">
                  <label for="scenario-onoff" class="toggle-label">
                    <span></span>
                  </label>
                </div>
                <p class="scenario-status no-mgn">配信する</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="card-footer">
        <button type="submit" class="btn btn-success" @click="submit()" >保存</button>
      </div>
      <loading-indicator :loading="loading"/>
    </div>
    <message-preview />
  </div>
</template>
<script>
import {
  MessageTypeIds,
  MessageType
} from '@/core/constant';
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['scenario_id'],
  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      scenarioMessageData: {
        scenario_id: this.scenario_id,
        name: '',
        is_initial: false,
        date: 1,
        time: '00:00',
        order: 1,
        status: 'enabled', // or 'disabled'
        // Each scenario message contains only one message, but we use array to reuse component
        messages: [
          {
            message_type_id: MessageTypeIds.Text,
            content: {
              type: MessageType.Text,
              text: ''
            }
          }
        ]
      },
      current_page_template: 1,
      refresh_content: true,
      scenario: null
    };
  },

  computed: {
    ...mapState('messageTemplate', {
      message_templates: state => state.messages,
      total_templates: state => state.total,
      per_page_template: state =>
        state.per_page,
      param_template: state =>
        state.params
    })
  },

  async beforeMount() {
    await this.getScenario();
    await this.getTags();
    await this.listTagAssigned();
    this.loading = false;
  },

  methods: {
    ...mapActions('scenario', [
      'createScenarioMessage',
      'setPreviewContent'
    ]),
    ...mapActions('messageTemplate', [
      'fetchListMessageTemplate',
      'setParams'
    ]),
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),
    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    getScenario() {
      this.$store.dispatch('scenario/getScenario', this.scenario_id).then((res) => {
        this.scenario = res;
      }).catch((err) => {
        console.log(err);
      });
    },

    changeContent({ index, content }) {
      this.scenarioMessageData.messages[index] = content;
      this.setPreviewContent(this.scenarioMessageData.messages);
      // this.validate(this.talk);
    },
    async submit() {
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

      const payload = _.omit(this.scenarioMessageData, ['messages']);
      const messageContent = this.scenarioMessageData.messages[0];
      payload.message_type_id = messageContent.message_type_id;
      payload.content = messageContent.content;
      const messageId = await this.createScenarioMessage(payload);
      if (messageId) {
        Util.showSuccessThenRedirect('シナリオにメッセージを追加しました。', `${process.env.MIX_ROOT_PATH}/user/scenarios/${this.scenario_id}/messages`);
      } else {
        Util.showErrorThenRedirect('シナリオにメッセージの追加は失敗しました。', `${process.env.MIX_ROOT_PATH}/user/scenarios/${this.scenario_id}/messages`);
      }
    },

    selectTemplate({ index, template }) {
      // eslint-disable-next-line no-undef
      this.refresh_content = false;

      this.scenarioMessageData.messages.splice(0, 1, template);

      this.setPreviewContent(this.scenarioMessageData.messages);

      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    getListMessageTemplate() {
      this.fetchListMessageTemplate(this.param_template);
    },

    changeListTemplate(page) {
      this.setParams({ page: page });
      this.fetchListMessageTemplate(this.param_template);
    }
  }
};
</script>
<style lang="scss" scoped>
.talk-priority {
  .hdg3 {
    flex: none!important;
  }
  input {
    width: 60px;
  }
}

::v-deep {
  .date-time-picker {
    display: inline-block;
  }

  #time-select-wrapper {
    max-width: 150px!important;
  }
}

.priority-input {
  width: 50px!important;
}

.delivery-timing-input {
  font-size: 17px;
  padding: 4px 12px!important;
}
</style>
