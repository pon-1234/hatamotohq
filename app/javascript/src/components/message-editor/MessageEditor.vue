<template>
  <div>
    <div class="card border-primary border mt-4">
      <div class="card-header d-flex align-items-center">
        <span>メッセージ{{index ? index + 1 : '' }}設定</span>
        <div class="ml-auto btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i></div>
      </div>
      <div class="card-body">
        <div class="d-flex align-items-center">
          <message-type-selection
            v-model="defaults.message_type_id"
            @input="changeSelectedMessage"
          />
          <div class="group-action d-flex" v-if="messagesCount && messagesCount > 0">
            <button type="button" class="d-flex btn btn-light action-item" @click="moveMessageToTop" v-if="index >= 1">
              <i class="fas fa-chevron-up"></i>
            </button>
            <button type="button" class="d-flex btn btn-light action-item" @click="moveMessageToBottom" v-if="index < messagesCount - 1">
              <i class="fas fa-chevron-down"></i>
            </button>
            <button type="button" class="d-flex btn btn-light action-item" @click="removeMessage" v-if="messagesCount !=1">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
        <message-content-editor
          class="mt-2"
          v-if="rerender"
          :index="index"
          :data="defaults.content"
          @changeContent="changeContentMessage"
        />
      </div>
    </div>

  </div>
</template>
<script>
export default {
  props: ['data', 'index', 'messagesCount', 'isDisplayTemplate'],
  data() {
    return {
      defaults: {
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
      Object.assign(this.defaults, this.data);
    }
  },

  methods: {
    changeSelectedMessage() {
      switch (this.defaults.message_type_id) {
      case this.MessageTypeIds.Text:
        this.defaults.content = {
          type: this.MessageType.Text,
          text: ''
        };
        break;
      case this.MessageTypeIds.Sticker:
        this.defaults.content = {
          type: this.MessageType.Sticker,
          packageId: '',
          stickerId: ''
        };
        break;
      case this.MessageTypeIds.Image:
        this.defaults.content = {
          type: this.MessageType.Image,
          originalContentUrl: '',
          previewImageUrl: ''
        };
        break;
      case this.MessageTypeIds.Video:
        this.defaults.content = {
          type: this.MessageType.Video,
          originalContentUrl: '',
          previewImageUrl: ''
        };
        break;
      case this.MessageTypeIds.Audio:
        this.defaults.content = {
          type: this.MessageType.Audio,
          originalContentUrl: '',
          duration: ''
        };
        break;
      case this.MessageTypeIds.TemplateButtons:
        this.defaults.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Buttons
          }
        };
        break;
      case this.MessageTypeIds.TemplateConfirm:
        this.defaults.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Confirm
          }
        };
        break;
      case this.MessageTypeIds.TemplateCarousel:
        this.defaults.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.Carousel
          }
        };
        break;
      case this.MessageTypeIds.TemplateImageCarousel:
        this.defaults.content = {
          type: 'template',
          template: {
            type: this.TemplateMessageType.ImageCarousel
          }
        };
        break;
      case this.MessageTypeIds.Imagemap:
        this.defaults.content = {
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
        this.defaults.content = {
          type: 'location',
          title: '',
          address: '',
          latitude: '',
          longitude: ''
        };
        break;
      case this.MessageTypeIds.Flex:
        this.defaults.content = {
          type: this.MessageType.Flex,
          contents: null
        };
        break;
      }
      this.rerender = false;

      setTimeout(() => {
        this.rerender = true;
      }, 100);

      this.$emit('input', { index: this.index, content: this.defaults });
    },
    changeContentMessage(content) {
      this.defaults.content = content;
      this.$emit('input', { index: this.index, content: this.defaults });
    },

    removeMessage() {
      this.$emit('remove', { index: this.index });
    },

    moveMessageToTop() {
      this.$emit('moveMessageToTop', this.index);
    },

    moveMessageToBottom() {
      this.$emit('moveMessageToBottom', this.index);
    }
  }
};
</script>

<style  lang="scss" scoped>
::v-deep {
  .group-action {
    margin-left: auto;
  }

  .action-item {
    margin-left: 10px;
    background: transparent;
  }

  .action-item:hover {
    color: #212529;
    background-color: #e2e6ea;
    border-color: #dae0e5;
  }
  .dashed{
    height: 1px;
    margin: 10px 0;
    border: thin dashed #ededed;
  }
}

</style>
