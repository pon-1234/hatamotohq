<template>
  <div class="mxw-1200" ref="myComponent">
    <div class="card">
      <div class="card-body">
        <div class="form-border">
          <div class="form-group">
            <label class="fw-300">フォルダー</label>
            <div class="flex-grow-1">
              <select v-model="templateData.folder_id" class="form-control fw-300">
                <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                  {{ folder.name }}
                </option>
              </select>
            </div>
          </div>
        </div>
        <div class="form-border">
          <div class="form-group">
            <label>テンプレート名<required-mark /></label>
            <input
              type="text"
              class="form-control"
              name="template_name"
              placeholder="テンプレート名を入力してください"
              v-model.trim="templateData.name"
              maxlength="65"
              v-validate="'required|max:64'"
              data-vv-as="テンプレート名"
            />
            <error-message :message="errors.first('template_name')"></error-message>
          </div>
        </div>
        <div class="form-border">
          <div :key="componentKey">
            <message-editor
              :allowCreateFromTemplate="false"
              v-for="(item, index) in templateData.messages"
              :key="item.id"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:messagesCount="templateData.messages.length"
              @input="changeContent"
              @remove="removeContent"
              @moveUp="moveUp"
              @moveDown="moveDown"
            />
          </div>
        </div>

        <div class="btn btn-primary" v-if="templateData.messages.length < 3" @click="addMessageBlock()">
          <i class="uil-plus"></i><span> メッセージ追加</span>
        </div>
      </div>
      <div class="card-footer d-flex">
        <button type="submit" class="btn btn-success fw-120" @click="submitSaveTemplate">保存</button>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>
    <message-preview></message-preview>
    <modal-confirm
      v-bind:title="'このメッセージを削除してもよろしいですか？'"
      type="delete"
      @input="deleteTemplateTemplate"
    />
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';

export default {
  props: ['template_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      templateData: {
        name: '',
        messages: [],
        folder_id: null
      },
      loading: true,
      componentKey: 0
    };
  },
  async created() {
    if (this.template_id) {
      this.templateData.id = this.template_id;
    } else {
      this.templateData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    }
    this.templateData.folder_id = Util.getParamFromUrl('folder_id');
    await this.getTemplates();
  },

  async beforeMount() {
    await this.fetchItem();
    this.loading = false;
  },

  computed: {
    ...mapState('template', {
      folders: state => state.folders
    })
  },

  watch: {
    templateData: {
      handler(val) {
        this.setMessagePreview(val);
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('template', [
      'getTemplate',
      'createTemplate',
      'updateTemplate',
      'deleteTemplate',
      'setMessagePreview',
      'getTemplates'
    ]),

    ...mapActions('system', ['setIsSubmitChange']),

    forceRerender() {
      this.componentKey += 1;
    },

    addMessageBlock() {
      this.templateData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    removeContent({ index }) {
      this.templateData.messages.splice(index, 1);
    },

    moveUp(index) {
      const temp1 = this.templateData.messages[index - 1];
      const temp2 = this.templateData.messages[index];
      this.$set(this.templateData.messages, index - 1, temp2);
      this.$set(this.templateData.messages, index, temp1);
      this.forceRerender();
    },
    moveDown(index) {
      const temp1 = this.templateData.messages[index + 1];
      const temp2 = this.templateData.messages[index];
      this.$set(this.templateData.messages, index + 1, temp2);
      this.$set(this.templateData.messages, index, temp1);
      this.forceRerender();
    },

    async fetchItem() {
      if (this.template_id) {
        const response = await this.getTemplate(this.template_id);
        Object.assign(this.templateData, response);

        if (this.templateData.tags && this.templateData.tags.length === 0) {
          this.templateData.tags = null;
        }
      }
    },

    changeContent({ index, content }) {
      this.templateData.messages.splice(index, 1, content);
    },

    async submitSaveTemplate() {
      const result = await this.$validator.validateAll();
      this.setIsSubmitChange();

      if (!result) {
        return ViewHelper.scrollToRequiredField(true);
      }

      const orderedMessages = this.templateData.messages.map((message, index) => {
        message.order = index;
        return message;
      });
      const payload = {
        id: this.template_id,
        folder_id: Util.getParamFromUrl('folder_id'),
        name: this.templateData.name,
        template_messages_attributes: orderedMessages
      };

      if (!this.template_id) {
        const response = await this.createTemplate(payload);
        if (response) {
          Util.showSuccessThenRedirect(
            'テンプレートの作成は完了しました。',
            `${process.env.MIX_ROOT_PATH}/user/templates`
          );
        } else {
          window.toastr.error('エラーを発生しました。');
        }
      } else {
        const response = await this.updateTemplate(payload);
        if (response) {
          Util.showSuccessThenRedirect(
            'テンプレートの変更は完了しました。',
            `${process.env.MIX_ROOT_PATH}/user/templates`
          );
        } else {
          window.toastr.error('エラーを発生しました。');
        }
      }
    },

    async deleteTemplateTemplate() {
      await this.deleteTemplate({ id: this.template_id });
      window.location.href = process.env.MIX_ROOT_PATH + '/template/streams';
    }
  }
};
</script>
