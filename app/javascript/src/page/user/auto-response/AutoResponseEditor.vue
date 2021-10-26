<template>
  <div class="fw-1200">
    <div class="card">
      <div class="card-header left-border">
        <h3 class="card-title">基本設定</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex align-items-center">
          <label class="fw-200">フォルダー</label>
          <div class="flex-grow-1">
            <select v-model="autoResponseData.folder_id" class="form-control fw-300">
              <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                {{ folder.name }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-group d-flex">
          <label class="fw-200">自動応答名<required-mark /></label>
          <div class="flex-grow-1">
            <input
              type="text"
              name="name"
              class="form-control"
              v-model="autoResponseData.name"
              placeholder="自動応答名を入力してください"
              v-validate="'required|max:64'"
              maxlength="65"
              data-vv-as="自動応答名"
            />
            <error-message :message="errors.first('name')"></error-message>
          </div>
        </div>

        <div class="form-group d-flex">
          <label class="fw-200">自動応答 ON/OFF</label>
          <div class="flex-grow-1 d-flex">
            <input
              type="checkbox"
              id="scenario-onoff"
              checked
              data-switch="success"
              v-model="autoResponseData.status"
              true-value="enabled"
              false-value="disabled"
              ref="status"
            />
            <label for="scenario-onoff" data-on-label="オン" data-off-label="オフ"></label>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header left-border">
        <h3>反応するキーワードを設定する</h3>
      </div>
      <div class="card-body">
        <div class="form-group d-flex flex-column m-0">
          <label class="mb10">キーワード<required-mark /></label>
          <b-form-tags
            size="md"
            :limit="10"
            class="bot-tag"
            input-id="tags-limit"
            v-model="autoResponseData.keywords"
            :class="errors.first('bot-tag') ? 'invalid-box' : ''"
            placeholder="キーワードを入力してください"
            separator=",;"
            :tag-validator="tagValidator"
            invalid-tag-text="無効なタグ"
            duplicateTagText="タグはすでに存在します"
            add-on-change
            :add-button-text="'追加'"
          >
          </b-form-tags>
          <input
            type="hidden"
            name="keywords"
            data-vv-as="キーワード"
            v-model="autoResponseData.keywords"
            v-validate="'required'"
          />
          <div class="mt-1">
            <small class="text-muted font-12"
              >キーワードはコンマ(半角)区切りで複数設定可能です。【例】キーワード01,キーワード02,キーワード03<br />
              タグの長さは1〜20文字です</small
            >
          </div>
          <span class="invalid-box-label" v-if="error"
            ><b>{{ error.keyword }}</b
            >のキーワードが<b>{{ error.name }}</b
            >で設定されているため設定できません。</span
          >
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
          <div class="form-group" :key="msgContentKey">
            <label>メッセージ本文</label>
            <div>
              <div class="btn btn-primary" data-toggle="modal" data-target="#modal-template">テンプレートから作成</div>
            </div>
            <modal-select-template @selectTemplate="onSelectTemplate" id="modal-template" />
            <message-editor
              :allowCreateFromTemplate="true"
              v-for="(item, index) in autoResponseData.messages"
              :key="index"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:messagesCount="autoResponseData.messages.length"
              @input="onMessageContentChanged"
              @selectTemplate="selectTemplate"
              @remove="removeContent"
              @moveUp="moveUp"
              @moveDown="moveDown"
            />
            <div>
              <div
                class="btn btn-primary"
                @click="addMoreMessageContentDistribution"
                v-if="autoResponseData.messages.length < MAX_AUTO_RESPONSE_MESSAGE"
              >
                <i class="uil-plus"></i><span> メッセージ追加</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="card-footer">
        <button type="submit" class="btn btn-success fw-120" @click="submitCreate()">
          {{ !auto_response_id ? "登録" : "保存" }}
        </button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
      <message-preview />
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';

export default {
  props: {
    auto_response_id: Number
  },
  data() {
    return {
      MAX_AUTO_RESPONSE_MESSAGE: 3,
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      loading: true,
      msgContentKey: 0,
      error: null,
      autoResponseData: {
        folder_id: null,
        name: '',
        status: 'enabled',
        keywords: [],
        messages: []
      }
    };
  },
  provide() {
    return { parentValidator: this.$validator };
  },

  async created() {
    this.autoResponseData.folder_id = Util.getParamFromUrl('folder_id');
    await this.getAutoResponses();
  },

  async beforeMount() {
    if (this.auto_response_id) {
      const autoResponse = await this.getAutoResponse(this.auto_response_id);
      Object.assign(this.autoResponseData, autoResponse);
    } else {
      this.setDefaultMessage();
    }
    this.loading = false;
  },

  watch: {
    autoResponseData: {
      handler(val) {
        this.setPreviewContent(this.autoResponseData);
      },
      deep: true
    }
  },

  computed: {
    ...mapState('autoResponse', {
      folders: state => state.folders
    })
  },

  methods: {
    ...mapActions('autoResponse', [
      'getAutoResponse',
      'createAutoResponse',
      'updateAutoResponse',
      'setPreviewContent',
      'getAutoResponses'
    ]),

    ...mapActions('template', ['getTemplate']),

    forceRerender() {
      this.msgContentKey++;
    },

    tagValidator(tag) {
      // Individual tag validator function
      return tag === tag.toLowerCase() && tag.length < 20;
    },

    async submitCreate() {
      const result = await this.$validator.validateAll();
      if (!result) {
        return ViewHelper.scrollToRequiredField(false);
      }
      const data = {
        folder_id: Util.getParamFromUrl('folder_id'),
        ...this.autoResponseData
      };
      if (this.auto_response_id) {
        const response = await this.updateAutoResponse(data);
        if (response) {
          Util.showSuccessThenRedirect(
            '自動応答の変更は完了しました。',
            `${process.env.MIX_ROOT_PATH}/user/auto_responses?folder_id=${this.autoResponseData.folder_id}`
          );
        } else {
          window.toastr.error('自動応答の変更は失敗しました。');
        }
      } else {
        const response = await this.createAutoResponse(data);
        if (response) {
          Util.showSuccessThenRedirect(
            '自動応答の作成は完了しました。',
            `${process.env.MIX_ROOT_PATH}/user/auto_responses?folder_id=${this.autoResponseData.folder_id}`
          );
        } else {
          window.toastr.error('自動応答の作成は失敗しました。');
        }
      }
    },

    setDefaultMessage() {
      this.autoResponseData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
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

    async onSelectTemplate(template) {
      const templateData = await this.getTemplate(template.id);
      this.autoResponseData.messages = this.autoResponseData.messages.concat(templateData.messages);
      this.forceRerender();
    },

    removeContent(index) {
      this.autoResponseData.messages.splice(index, 1);
      this.forceRerender();
    },

    moveUp(index) {
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index - 1, 1, option)[0];
      this.forceRerender();
    },
    moveDown(index) {
      const option = this.autoResponseData.messages[index];
      this.autoResponseData.messages[index] = this.autoResponseData.messages.splice(index + 1, 1, option)[0];
      this.forceRerender();
    }
  }
};
</script>
<style lang="scss"  scoped>
  ::v-deep {
    #tags-limit {
      border: none;
      background-color: rgba(255, 255, 255, 0) !important;
    }
    .bot-tag.disabled {
      background-color: #ccc !important;
    }
  }
</style>
