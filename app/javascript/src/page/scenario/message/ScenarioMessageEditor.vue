<template>
  <div class="mxw-1200">
    <div class="card" :key="componentKey">
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
              <label>メッセージ名<required-mark/></label>
              <input type="text" name="message-name" class="form-control" placeholder="メッセージ名を入力してください" v-model="scenarioMessageData.name" v-validate="'required'" data-vv-as="メッセージ名">
              <error-message :message="errors.first('message-name')"></error-message>
            </div>
          </div>
          <div class="form-border">
            <div class="form-group">
              <label>メッセージ本文</label>
                <message-editor
                :isDisplayTemplate="true"
                  v-for="(item, index) in scenarioMessageData.messages"
                  :key="index"
                  v-bind:data="item"
                  v-bind:index="index"
                  @selectTemplate="selectTemplate"
                  @input="onMessageContentChanged"
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
        <button type="submit" class="btn btn-success fw-120" @click="submit()" >保存</button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>
    <message-preview />
  </div>
</template>
<script>
import {
  MessageTypeIds,
  MessageType
} from '@/core/constant';
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: {
    scenario_id: {
      type: Number,
      required: true
    },

    message_id: {
      type: Number,
      required: false
    }
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: true,
      componentKey: 0,
      scenarioMessageData: {
        id: null,
        scenario_id: this.scenario_id,
        name: '',
        is_initial: false,
        date: 1,
        time: '00:00',
        order: 1,
        status: 'enabled', // or 'disabled'
        messages: [ // Each scenario message contains only one message, but we use array to reuse component
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
      scenario: null
    };
  },

  async beforeMount() {
    await this.fetchItem();
    await this.getTags();
    this.loading = false;
    this.forceRerender();
  },

  methods: {
    ...mapActions('scenario', [
      'getScenario',
      'getScenarioMessage',
      'createMessage',
      'updateMessage',
      'setPreviewContent'
    ]),
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    forceRerender() {
      this.componentKey++;
    },

    async fetchItem() {
      this.scenario = await this.getScenario(this.scenario_id);
      if (this.message_id) {
        const query = {
          scenario_id: this.scenario_id,
          id: this.message_id
        };
        const messageData = await this.getScenarioMessage(query);
        if (messageData) {
          this.scenarioMessageData = _.omit(messageData, ['message_type_id', 'content']);
          this.scenarioMessageData.messages = [{
            message_type_id: messageData.message_type_id,
            content: messageData.content
          }];
        }
      }
    },

    onMessageContentChanged({ index, content }) {
      this.scenarioMessageData.messages[index] = content;
      this.setPreviewContent(this.scenarioMessageData.messages);
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

      let response = null;
      if (this.message_id) {
        response = await this.updateMessage(payload);
      } else {
        response = await this.createMessage(payload);
      }

      if (response) {
        Util.showSuccessThenRedirect('シナリオにメッセージを保存しました。', `${process.env.MIX_ROOT_PATH}/user/scenarios/${this.scenario_id}/messages`);
      } else {
        Util.showErrorThenRedirect('シナリオにメッセージの保存は失敗しました。', `${process.env.MIX_ROOT_PATH}/user/scenarios/${this.scenario_id}/messages`);
      }
    }
  }
};
</script>
