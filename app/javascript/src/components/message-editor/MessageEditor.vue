<template>
  <div>
    <div class="card border-primary border mt-4">
      <div class="card-header d-flex align-items-center">
        <span>メッセージ{{ index ? index + 1 : "" }}設定</span>
        <div class="ml-auto btn btn-tool" data-card-widget="collapse">
          <i class="fas fa-minus"></i>
        </div>
      </div>
      <div class="card-body">
        <div class="d-flex align-items-center">
          <message-type-selection v-model="messageData.message_type_id" @input="changeSelectedMessage" />
          <div class="group-action d-flex" v-if="messagesCount && messagesCount > 0">
            <div role="button" class="d-flex btn btn-light btn-sm mr-1" @click="moveUp" v-if="index >= 1">
              <i class="dripicons-chevron-up"></i>
            </div>
            <div
              role="button"
              class="d-flex btn btn-light btn-sm mr-1"
              @click="moveDown"
              v-if="index < messagesCount - 1"
            >
              <i class="dripicons-chevron-down"></i>
            </div>
            <div role="button" class="d-flex btn btn-light btn-sm" @click="removeMessage" v-if="messagesCount != 1">
              <i class="dripicons-minus"></i>
            </div>
          </div>
        </div>
        <message-content-editor
          class="mt-2"
          v-if="rerender"
          :index="index"
          :data="messageData.content"
          @changeContent="changeContentMessage"
        />
        <url-config @configured="configUrl" :index="index" :messageContent="messageData.content" v-if="messageData.message_type_id === MessageTypeIds.Text"></url-config>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data', 'index', 'messagesCount', 'allowCreateFromTemplate'],
  data() {
    return {
      messageData: {
        message_type_id: this.MessageTypeIds.Text,
        content: {
          type: this.MessageType.Text,
          text: ''
        }
      },
      rerender: true
    };
  },

  created() {
    if (this.data) {
      Object.assign(this.messageData, this.data);
    }
  },

  methods: {
    changeSelectedMessage() {
      switch (this.messageData.message_type_id) {
      case this.MessageTypeIds.Text:
        this.messageData.content = {
          type: this.MessageType.Text,
          text: ''
        };
        break;
      case this.MessageTypeIds.Sticker:
        this.messageData.content = {
          type: this.MessageType.Sticker,
          packageId: '',
          stickerId: ''
        };
        break;
      case this.MessageTypeIds.Image:
        this.messageData.content = {
          type: this.MessageType.Image,
          originalContentUrl: '',
          previewImageUrl: ''
        };
        break;
      case this.MessageTypeIds.Video:
        this.messageData.content = {
          type: this.MessageType.Video,
          originalContentUrl: '',
          previewImageUrl: ''
        };
        break;
      case this.MessageTypeIds.Audio:
        this.messageData.content = {
          type: this.MessageType.Audio,
          originalContentUrl: '',
          duration: ''
        };
        break;
      case this.MessageTypeIds.TemplateButtons:
        this.messageData.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Buttons
          }
        };
        break;
      case this.MessageTypeIds.TemplateConfirm:
        this.messageData.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Confirm
          }
        };
        break;
      case this.MessageTypeIds.TemplateCarousel:
        this.messageData.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Carousel
          }
        };
        break;
      case this.MessageTypeIds.TemplateImageCarousel:
        this.messageData.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.ImageCarousel
          }
        };
        break;
      case this.MessageTypeIds.Imagemap:
        this.messageData.content = {
          type: this.MessageType.Imagemap,
          templateId: 201,
          templateValue: 6,
          baseUrl: null,
          baseSize: {
            width: 1040,
            height: 1040
          },
          actions: []
        };
        break;
      case this.MessageTypeIds.Location:
        this.messageData.content = {
          type: 'location',
          title: '',
          address: '',
          latitude: '',
          longitude: ''
        };
        break;
      case this.MessageTypeIds.Flex:
        this.messageData.content = {
          type: this.MessageType.Flex,
          contents: null
        };
        break;
      }
      this.rerender = false;

      setTimeout(() => {
        this.rerender = true;
      }, 100);

      this.$emit('input', { index: this.index, content: this.messageData });
    },
    changeContentMessage(content) {
      this.messageData.content = content;
      this.$emit('input', { index: this.index, content: this.messageData });
    },

    removeMessage() {
      this.$emit('remove', this.index);
    },

    moveUp() {
      this.$emit('moveUp', this.index);
    },

    moveDown() {
      this.$emit('moveDown', this.index);
    },

    configUrl({ index, content }) {
      this.$emit('configUrl', { index: index, content: content });
    }
  }
};
</script>

<style  lang="scss" scoped>
  ::v-deep {
    .group-action {
      margin-left: auto;
    }

    .dashed {
      height: 1px;
      margin: 10px 0;
      border: thin dashed #ededed;
    }
  }
</style>
