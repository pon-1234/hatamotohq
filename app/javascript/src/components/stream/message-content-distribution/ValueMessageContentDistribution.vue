<template>
  <div class="area-type mb20">

    <!-- text message -->
    <text-message-editor v-if="data.type === 'text'" :value="data.text" @input="valueMessageChange" :index="index" />

    <!-- sticker -->
    <sticker-message-editor
      v-if="data.type === 'sticker'"
      :packageId="data.packageId"
      :stickerId="data.stickerId"
      @input="changeSticker"
      :index="index"
    />

    <!-- image -->
    <media-message-editor v-if="data.type === 'image'" :data="data" @input="changeMedia" :index="index"/>

    <!-- video -->
    <media-message-editor v-if="data.type === 'video'" :data="data" @input="changeMedia" :index="index"/>

    <!-- audio -->
    <media-message-editor v-if="data.type === 'audio'" :data="data" @input="changeMedia" :index="index"/>

    <div class="form-group" v-if="data.type == MessageType.Template || data.type == 'imagemap' || data.type == MessageType.Flex">
      <label>メッセージ通知文</label>
      <input type="text" class="form-control" placeholder="プレビューを入力してください" v-model="defaults.altText"/>
    </div>

    <!-- template button -->
    <template-button-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Buttons" :data="data.template"
      @input="changeTemplateMessageContent"
      :indexParent="index"
      />

    <!-- template confirm -->
    <template-confirm-editor
    v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Confirm" :data="data.template"
    @input="changeTemplateMessageContent"
    :indexParent="index"
    />

    <!-- template carousel -->
    <template-carousel-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Carousel" :data="data.template"
      @input="changeTemplateMessageContent"
      :indexParent="index"
      />

    <!-- template image caroutsel -->
    <template-image-carousel-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.ImageCarousel" :data="data.template"
      @input="changeTemplateMessageContent"
      :indexParent="index"
      />

    <!-- imagemap -->
    <imagemap-editor v-if="data.type === 'imagemap'" :data="data" :index="index" @input="changeImagemap" :indexParent="index"/>

    <!-- location -->
    <location-editor v-if="data.type === 'location'" :data="data"  @input="changeGooglegmap" :indexParent="index"/>

    <!-- flex message -->
    <flex-message-editor v-if="data.type === MessageType.Flex" :data="data" :index="index"  @input="changeFlexmessage" :indexParent="index"/>
  </div>
</template>
<script>

export default {
  props: ['data', 'index'],
  data() {
    return {
      defaults: {
        type: 'text',
        text: ''
      }
    };
  },
  created() {
    if (this.data) {
      // eslint-disable-next-line no-undef
      this.defaults = _.cloneDeep(this.data);
    }
  },
  methods: {
    valueMessageChange(value) {
      this.defaults = {
        type: 'text',
        text: value
      };
      this.$emit('changeContent', this.defaults);
    },
    changeSticker(value) {
      this.defaults = {
        type: 'sticker',
        packageId: value.packageId,
        stickerId: value.stickerId
      };
      this.$emit('changeContent', this.defaults);
    },
    changeMedia(value) {
      this.defaults = value;
      this.$emit('changeContent', this.defaults);
    },

    changeTemplateMessageContent(value) {
      this.defaults.template = value;

      if (!this.defaults.altText) {
        if (this.defaults.template.type === 'buttons') {
          this.defaults.altText = 'ボタンメッセージ';
        }
        if (this.defaults.template.type === 'confirm') {
          this.defaults.altText = '確認メッセージ';
        }
        if (this.defaults.template.type === 'carousel') {
          this.defaults.altText = 'カルーセルメッセージ';
        }
        if (this.defaults.template.type === 'image_carousel') {
          this.defaults.altText = '画像カルーセルメッセージ';
        }
      }
      this.$emit('changeContent', this.defaults);
    },

    changeImagemap(value) {
      this.defaults = value;
      if (!this.defaults.altText) {
        this.defaults.altText = 'イメージマップメッセージ';
      }
      this.$emit('changeContent', this.defaults);
    },

    changeGooglegmap(value) {
      this.defaults = value;
      this.$emit('changeContent', this.defaults);
    },

    changeFlexmessage(value) {
      this.defaults = value;
      if (!this.defaults.altText) {
        this.defaults.altText = 'Flexメッセージ';
      }
      this.$emit('changeContent', this.defaults);
    }
  }
};
</script>
