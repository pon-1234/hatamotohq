<template>
  <div>
    <div class="dashed" v-if="index !== 0"></div>
    <div class="card card-outline card-success mt-4">
      <div class="card-header">
        <span class="card-title">メッセージ{{index + 1}}設定</span>
        <div class="card-tools">
          <button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i>
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="d-flex align-items-center mb10">
          <select-message-content-distribution
            v-model="defaults.message_type_id"
            @input="changeSelectedMessage"
          />
          <div class="group-action d-flex" v-if="countMessages && countMessages > 0">
            <button type="button" class="d-flex btn btn-light action-item" @click="moveTopMessage" v-if="index >= 1">
              <i class="fas fa-chevron-up"></i>
            </button>
            <button type="button" class="d-flex btn btn-light action-item" @click="moveBottomMessage" v-if="index < countMessages - 1">
              <i class="fas fa-chevron-down"></i>
            </button>
            <button type="button" class="d-flex btn btn-light action-item" @click="removeContent" v-if="countMessages !=1">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
    <value-message-content-distribution
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
  props: ['data', 'index', 'countMessages', 'isDisplayTemplate'],
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
      console.log('changeContentMessage', this.defaults);
      this.$emit('input', { index: this.index, content: this.defaults });
    },

    removeContent() {
      this.$emit('remove', { index: this.index });
    },

    // selectTemplate(template) {
    //   // eslint-disable-next-line no-undef
    //   const data = _.cloneDeep(template);
    //   this.$emit('setTemplate', {
    //     index: this.index,
    //     template: {
    //       message_type_id: data.message_type_id,
    //       content: data.content
    //     }
    //   });
    // },

    moveTopMessage() {
      this.$emit('moveTopMessage', this.index);
    },

    moveBottomMessage() {
      this.$emit('moveBottomMessage', this.index);
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
