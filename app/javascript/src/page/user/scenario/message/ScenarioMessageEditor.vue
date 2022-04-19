<template>
  <div class="mxw-1200">
    <div :key="componentKey">
      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">基本設定</h3>
        </div>
        <div class="card-body">
          <div class="form-group d-flex">
            <label class="fw-250">メッセージ名（管理用)</label>
            <div class="flex-grow-1">
              <input
                type="text"
                name="message-name"
                class="form-control"
                placeholder="メッセージ名を入力してください"
                v-model.trim="scenarioMessageData.name"
                v-validate="'max:255'"
                data-vv-as="メッセージ名"
              />
              <error-message :message="errors.first('message-name')"></error-message>
            </div>
          </div>
          <div class="fmt-2 d-flex">
            <label class="fw-250">配信する</label>
            <div class="flex-grow-1">
              <input
                type="checkbox"
                id="messageOnoff"
                checked
                data-switch="success"
                v-model="scenarioMessageData.status"
                true-value="enabled"
                false-value="disabled"
                ref="status"
              />
              <label for="messageOnoff" data-on-label="オン" data-off-label="オフ"></label>
            </div>
          </div>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>

      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">配信タイミング設定</h3>
        </div>
        <div class="card-body">
          <scenario-message-time-editor
            :mode="scenario.mode"
            :is_initial.sync="scenarioMessageData.is_initial"
            :date.sync="scenarioMessageData.date"
            :time.sync="scenarioMessageData.time"
            :order.sync="scenarioMessageData.order"
          >
          </scenario-message-time-editor>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>

      <div class="card">
        <div class="card-header left-border">
          <h3 class="card-title">メッセージ本文</h3>
        </div>
        <div class="card-body py-0">
          <message-editor
            :allowCreateFromTemplate="true"
            v-for="(item, index) in scenarioMessageData.messages"
            :key="index"
            v-bind:data="item"
            v-bind:index="index"
            v-bind:showUrlClickConfig="true"
            v-bind:siteMeasurements="scenarioMessageData.site_measurements"
            @selectTemplate="selectTemplate"
            @input="onMessageContentChanged"
            @configUrl="configUrl"
          ></message-editor>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
      <div>
        <div class="btn btn-success mw-120" @click="submit()">
          {{ message_id ? "保存" : "メッセージ登録" }}
        </div>
      </div>
    </div>
    <message-preview></message-preview>
  </div>
</template>
<script>
import { MessageTypeIds, MessageType } from '@/core/constant';
import { mapActions } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';

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
        mode: 'time',
        is_initial: false,
        date: 1,
        time: '00:00',
        order: 1,
        status: 'enabled', // or 'disabled'
        messages: [
          // Each scenario message contains only one message, but we use array to reuse component
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
          this.scenarioMessageData.messages = [
            {
              message_type_id: messageData.message_type_id,
              content: messageData.content
            }
          ];
        }
      }
    },

    onMessageContentChanged({ index, content }) {
      this.scenarioMessageData.messages[index] = content;
      this.setPreviewContent(this.scenarioMessageData.messages);
    },

    configUrl({ index, content }) {
      this.scenarioMessageData.messages[index].site_measurements_attributes = [content];
    },

    async submit() {
      if (this.loading) return;
      this.loading = true;
      const result = await this.$validator.validateAll();
      if (!result) {
        this.loading = false;
        return ViewHelper.scrollToRequiredField(false);
      }

      const payload = _.omit(this.scenarioMessageData, ['messages']);
      const messageContent = this.scenarioMessageData.messages[0];
      payload.message_type_id = messageContent.message_type_id;
      payload.content = messageContent.content;
      payload.site_measurements_attributes = messageContent.site_measurements_attributes;

      let response = null;
      if (this.message_id) {
        response = await this.updateMessage(payload);
      } else {
        response = await this.createMessage(payload);
      }

      if (response) {
        Util.showSuccessThenRedirect(
          'シナリオにメッセージを保存しました。',
          `${process.env.MIX_ROOT_PATH}/user/scenarios/${this.scenario_id}/messages`
        );
      } else {
        window.toastr.error('シナリオにメッセージの保存は失敗しました。');
        this.loading = false;
      }
    }
  }
};
</script>
