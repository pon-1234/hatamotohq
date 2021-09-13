<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-header d-flex align-items-center">
        <a :href="`${MIX_ROOT_PATH}/user/templates`" class="text-info">
          <i class="fa fa-arrow-left"></i> テンプレート一覧
        </a>
        <h5 class="m-auto font-weight-bold">新規テンプレート登録</h5>
      </div>
      <div class="card-body">
        <div class="form-border">
          <div class="form-group">
            <label>タイトル<required-mark/></label>
            <input type="text" class="form-control"  name="template-title" placeholder="タイトルを入力してください" v-model="templateData.title" v-validate="'required'" data-vv-as="タイトル"/>
            <error-message :message="errors.first('template-title')"></error-message>
          </div>
        </div>
        <div class="form-border">
          <div v-if="refresh_content">
            <message-editor
              :isDisplayTemplate="false"
              v-for="(item, index) in templateData.messages"
              :key="index"
              v-bind:data="item"
              v-bind:index="index"
              v-bind:countMessages="templateData.messages.length"
              @input="changeContent"
              @remove="removeContent"
              @moveTopMessage="moveTopMessage"
              @moveBottomMessage="moveBottomMessage"
            />
          </div>
        </div>

        <div class="btn btn-outline-success" v-if="templateData.messages.length < 3" @click="_addMessage()"><i class="fa fa-plus"></i><span > メッセージ追加</span></div>
      </div>
      <div class="card-footer">
        <button
          type="submit"
          class="btn btn-submit btn-success fw-120"
          @click="createMessage"
        >保存</button>
        <div v-if="template_id"><a class="btn btn-danger" data-toggle="modal" data-target="#modal-confirm">削除</a></div>
      </div>
    </div>
    <message-preview />
    <modal-confirm v-bind:title="'このメッセージを削除します。よろしいですか？'" type='delete' @input="deleteMessageTemplate"/>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ErrorMessage from '../../components/common/ErrorMessage.vue';

export default {
  components: { ErrorMessage },
  props: ['template_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      templateData: {
        title: '',
        messages: []
      },
      refresh_tag: true,
      refresh_content: true
    };
  },
  created() {
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
  },

  async beforeMount() {
    await this.fetchItem();
    await this.getTags();
    await this.listTagAssigned();
  },

  computed: {
    ...mapState('messageTemplate', {
      message: state => state.message
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
      'sendMessage',
      'updateMessage',
      'deleteMessage',
      'getMessageById',
      'setMessagePreview'
    ]),

    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    _addMessage() {
      this.templateData.messages.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    removeContent({ index }) {
      this.refresh_content = false;
      this.templateData.messages.splice(index, 1);
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.templateData.messages[index];
      this.templateData.messages[index] = this.templateData.messages.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.templateData.messages[index];
      this.templateData.messages[index] = this.templateData.messages.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    async fetchItem() {
      if (this.template_id) {
        this.refresh_tag = false;
        await this.getMessageById({ id: this.template_id });
        Object.assign(this.templateData, this.message);
        console.log(this.templateData);

        if (this.templateData.tags && this.templateData.tags.length === 0) {
          this.templateData.tags = null;
        }

        this.$nextTick(() => {
          this.refresh_tag = true;
        });
      }
    },

    changeContent({ index, content }) {
      this.templateData.messages.splice(index, 1, content);
    },

    async createMessage() {
      const result = await this.$validator.validateAll();
      this.setIsSubmitChange();

      if (!result) {
        $('input, textarea').each(
          function(index) {
            let input = $(this);
            if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
              if (input.is(':hidden')) {
                input = input.parent();
              }
              $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
              return false;
            }
          }
        );
        return;
      }

      const makeValue = {
        id: this.template_id,
        title: this.templateData.title,
        folder_id: Util.getQueryParamsUrl('folder_id'),
        messages: this.templateData.messages
      };

      if (!this.template_id) {
        await this.createTemplate(makeValue);
        window.location.href = process.env.MIX_ROOT_PATH + '/user/templates';
      } else {
        await this.updateMessage(makeValue);
      }
    },

    async deleteMessageTemplate() {
      await this.deleteMessage({ id: this.template_id });
      window.location.href = process.env.MIX_ROOT_PATH + '/template/streams';
    }
  }
};
</script>
