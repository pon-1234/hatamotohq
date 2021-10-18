<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信日時</h3>
      </div>
      <div class="card-body">
        <episode-time-editor
          :is_initial.sync="episodeData.is_initial"
          :date.sync="episodeData.date"
          :time.sync="episodeData.time"
        >
        </episode-time-editor>
      </div>
      <loading-indicator :loading="loading" />
    </div>

    <!-- アクション設定 -->
    <div class="card">
      <div class="card-header left-border"><h3 class="card-title">アクション設定</h3></div>
      <div class="card-body">
        <action-editor-custom
          name="after_action"
          :value="episodeData.actions"
          :labelRequired="false"
          :showTitle="false"
          :limit="10"
          :showLaunchMesasge="false"
          @input="updateAction"
        ></action-editor-custom>
      </div>
    </div>

    <!-- メッセージ設定 -->
    <div class="card" :key="contentKey">
      <div class="card-header left-border">
        <h3 class="card-title">メッセージ設定</h3>
      </div>
      <div class="card-body">
        <div>
          <div v-for="(item, index) in episodeData.messages" :key="index">
            <message-editor
              :allowCreateFromTemplate="true"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:messagesCount="episodeData.messages.length"
              @input="onMessageDataChanged"
              @remove="removeMessage"
              @moveUp="moveUp"
              @moveDown="moveDown"
            />
          </div>

          <div>
            <div class="btn btn-primary" @click="addMessage" v-if="episodeData.messages.length < 5">
              <i class="uil-plus"></i> <span>メッセージ追加</span>
            </div>
            <div class="btn btn-secondary" data-toggle="modal" data-target="#modalSelectTemplate">
              テンプレートから作成
            </div>
            <modal-select-template @selectTemplate="onSelectTemplate" id="modalSelectTemplate"></modal-select-template>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading" />
    </div>
    <div>
      <div class="row-form-btn d-flex">
        <button class="btn btn-success fw-120 mr-1" @click="submit()" :disabled="invalid">配信登録</button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: {
    reminder_id: {
      type: Number,
      required: true
    },
    episode_id: {
      type: Number,
      required: false
    }
  },
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: false,
      contentKey: 0,
      episodeData: {
        id: this.episode_id,
        reminder_id: this.reminder_id,
        date: 0,
        time: '00:00',
        is_initial: false,
        actions: this.ActionMessage.default,
        messages: []
      }
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  methods: {
    ...mapActions('template', ['getTemplate']),
    ...mapActions('reminder', [
      'createEpisode'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    addMessage() {
      this.episodeData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    onMessageDataChanged({ index, content }) {
      this.episodeData.messages.splice(index, 1, content);
    },

    async onSelectTemplate(template) {
      const templateData = await this.getTemplate(template.id);
      this.episodeData.messages = templateData.messages.map(message => _.omit(message, ['id', 'order']));
      this.forceRerender();
    },

    async submit() {
      const valid = await this.$validator.validateAll();
      if (!valid) {
        return;
      }
      const response = await this.createEpisode(this.episodeData);
      if (response) {
        Util.showSuccessThenRedirect('リマインダ配信タイミングの作成は完了しました。', `${process.env.MIX_ROOT_PATH}/user/reminders/${this.reminder_id}/episodes`);
      } else {
        window.toastr.error('リマインダ配信タイミングの作成は失敗しました。');
      }
    }
  }
};
</script>