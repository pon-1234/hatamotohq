<template>
  <div class="area-type mb20">

    <!-- text message -->
    <text-message-editor v-if="data.type === 'text'" :value="data.text" @input="onTextChanged" :index="index" />

    <!-- sticker -->
    <sticker-message-editor
      v-if="data.type === 'sticker'"
      :packageId="data.packageId"
      :stickerId="data.stickerId"
      @input="onStickerChanged"
      :index="index">
    </sticker-message-editor>

    <!-- image/video/audio -->
    <template v-if="['image', 'video', 'audio'].includes(data.type)">
      <media-message-editor :data="data" @input="onMediaChanged" :index="index"></media-message-editor>
    </template>

    <!-- location -->
    <location-editor v-if="data.type === MessageType.Location" :data="data"  @input="onLocationChanged" :indexParent="index"/>

    <!-- <div class="form-group" v-if="[MessageType.Template, MessageType.Imagemap, MessageType.Flex].includes(data.type)" hidden>
      <label>代替テキスト</label>
      <input type="text" :name="`${altText}${index}`" class="form-control" placeholder="代替テキストを入力してください" v-model="messageData.altText" v-validate="'max:400'" data-vv-as="代替テキスト"/>
      <error-message :message="errors.first(`${altText}${index}`)"></error-message>
    </div> -->

    <!-- template button -->
    <template-button-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Buttons" :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
      />

    <!-- template confirm -->
    <template-confirm-editor
    v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Confirm" :data="data.template"
    @input="onTemplateContentChanged"
    :indexParent="index"
    />

    <!-- template carousel -->
    <template-carousel-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Carousel" :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
      />

    <!-- template image caroutsel -->
    <template-image-carousel-editor
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.ImageCarousel" :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
      />

    <!-- imagemap -->
    <imagemap-editor v-if="data.type === MessageType.Imagemap" :data="data" :index="index" @input="onImagemapChanged" :indexParent="index"/>

    <!-- flex message -->
    <flex-message-editor v-if="data.type === MessageType.Flex" :data="data" :index="index"  @input="onFlexChanged" :indexParent="index"/>
  </div>
</template>
<script>

export default {
  props: ['data', 'index'],
  data() {
    return {
      messageData: {
        type: 'text',
        text: ''
      }
    };
  },
  created() {
    if (this.data) {
      // eslint-disable-next-line no-undef
      this.messageData = _.cloneDeep(this.data);
    }
  },
  methods: {
    onTextChanged(value) {
      this.messageData = {
        type: 'text',
        text: value
      };
      this.$emit('changeContent', this.messageData);
    },
    onStickerChanged(value) {
      this.messageData = {
        type: 'sticker',
        packageId: value.packageId,
        stickerId: value.stickerId
      };
      this.$emit('changeContent', this.messageData);
    },
    onMediaChanged(value) {
      console.log('----on media changed----', value);
      this.messageData = value;
      this.$emit('changeContent', this.messageData);
    },

    onTemplateContentChanged(value) {
      this.messageData.template = value;

      if (!this.messageData.altText) {
        if (this.messageData.template.type === 'buttons') {
          this.messageData.altText = 'ボタンメッセージ';
        }
        if (this.messageData.template.type === 'confirm') {
          this.messageData.altText = '確認メッセージ';
        }
        if (this.messageData.template.type === 'carousel') {
          this.messageData.altText = 'カルーセルメッセージ';
        }
        if (this.messageData.template.type === 'image_carousel') {
          this.messageData.altText = '画像カルーセルメッセージ';
        }
      }
      this.$emit('changeContent', this.messageData);
    },

    onImagemapChanged(value) {
      this.messageData = value;
      this.$emit('changeContent', this.messageData);
    },

    onLocationChanged(value) {
      this.messageData = value;
      this.$emit('changeContent', this.messageData);
    },

    onFlexChanged(value) {
      this.messageData = value;
      if (!this.messageData.altText) {
        this.messageData.altText = 'Flexメッセージ';
      }
      this.$emit('changeContent', this.messageData);
    }
  }
};
</script>
