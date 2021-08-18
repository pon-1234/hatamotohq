<template>
  <div class="form-common01 create-content">
    <div class="form-border">
      <div class="form-group">
        <label>タイトル<span class="label label-sm label-danger">必須</span></label>
        <input type="text" class="form-control"  name="template-title" placeholder="タイトルを入力してください" v-model="message_data.title" v-validate="'required'" />
        <span v-if="errors.first('template-title')" class="is-validate-label">タイトルは必須です</span>
      </div>
    </div>
    <div class="form-border">
      <div v-if="refresh_content">
        <message-content-distribution
          :isDisplayTemplate="false"
          v-for="(item, index) in message_data.message_content_distribution_templates"
          :key="index"
          v-bind:data="item"
          v-bind:index="index"
          v-bind:countMessages="message_data.message_content_distribution_templates.length"
          @input="changeContent"
          @remove="removeContent"
          @moveTopMessage="moveTopMessage"
          @moveBottomMessage="moveBottomMessage"
        />
      </div>
    </div>

    <div class="btn-common02 btn-form01 text-center fz14 mb20" v-if="message_data.message_content_distribution_templates.length < 3"><a class="btn-add-form01" @click="_addMessage()"><span >追加</span></a></div>

    <div class="row-form-btn flex start" >
      <button
        type="submit"
        class="btn btn-submit btn-block"
        @click="createMessage"
      >保存</button>
      <div v-if="stream_id"><a class="btn btn-delete btn-block" data-toggle="modal" data-target="#modal-confirm">削除</a></div>
    </div>
    <message-preview />
    <modal-confirm v-bind:title="'このメッセージを削除します。よろしいですか？'" type='delete' @input="deleteMessageTemplate"/>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['stream_id'],
  provide() {
    return { parentValidator: this.$validator };
  },
  data() {
    return {
      message_data: {
        title: '',
        message_content_distribution_templates: []
      },
      refresh_tag: true,
      refresh_content: true

    };
  },
  created() {
    if (this.stream_id) {
      this.message_data.id = this.stream_id;
    } else {
      this.message_data.message_content_distribution_templates.push({
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
    message_data: {
      handler(val) {
        console.log('handler watch change message', val);
        this.setMessage(val);
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('messageTemplate', [
      'sendMessage',
      'updateMessage',
      'deleteMessage',
      'getMessageById',
      'setMessage'
    ]),

    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    ...mapActions('system', [
      'setIsSubmitChange'
    ]),

    _addMessage() {
      this.message_data.message_content_distribution_templates.push({
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      });
    },

    removeContent({ index }) {
      this.refresh_content = false;
      this.message_data.message_content_distribution_templates.splice(index, 1);
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    moveTopMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.message_content_distribution_templates[index];
      this.message_data.message_content_distribution_templates[index] = this.message_data.message_content_distribution_templates.splice(index - 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },
    moveBottomMessage(index) {
      this.refresh_content = false;
      const option = this.message_data.message_content_distribution_templates[index];
      this.message_data.message_content_distribution_templates[index] = this.message_data.message_content_distribution_templates.splice(index + 1, 1, option)[0];
      this.$nextTick(() => {
        this.refresh_content = true;
      });
    },

    async fetchItem() {
      if (this.stream_id) {
        this.refresh_tag = false;
        await this.getMessageById({ id: this.stream_id });
        Object.assign(this.message_data, this.message);
        console.log(this.message_data);

        if (this.message_data.tags && this.message_data.tags.length === 0) {
          this.message_data.tags = null;
        }

        this.$nextTick(() => {
          this.refresh_tag = true;
        });
      }
    },

    changeContent({ index, content }) {
      this.message_data.message_content_distribution_templates.splice(index, 1, content);
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
        id: this.stream_id,
        title: this.message.title,
        folder_id: Util.getQueryParamsUrl('folder_id'),
        messages: this.message.message_content_distribution_templates
      };

      if (!this.stream_id) {
        await this.sendMessage(makeValue);
        window.location.href = process.env.MIX_ROOT_PATH + '/template/streams?is_created=true';
      } else {
        await this.updateMessage(makeValue);
        window.location.href = process.env.MIX_ROOT_PATH + '/template/streams?is_updated=true';
      }
    },

    async deleteMessageTemplate() {
      await this.deleteMessage({ id: this.stream_id });
      window.location.href = process.env.MIX_ROOT_PATH + '/template/streams';
    }
  }
};
</script>
