<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">配信日時</h3>
      </div>
      <div class="card-body"></div>
      <loading-indicator :loading="loading" />
    </div>

    <!-- アクション設定 -->
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">アクション設定</h3>
      </div>
      <div class="card-body"></div>
      <loading-indicator :loading="loading" />
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
        <button class="btn btn-success fw-120 mr-1" @click="createBroadcast()" :disabled="invalid">配信登録</button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';

export default {
  props: ['broadcast_id'],
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      loading: false,
      contentKey: 0,
      episodeData: {
        actions: [],
        messages: []
      }
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  methods: {
    ...mapActions('template', ['getTemplate']),

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
      this.episodeData.messages = templateData.messages;
      this.forceRerender();
    }
  }
};
</script>