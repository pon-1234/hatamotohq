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
      :index="index"
    />

    <!-- image/video/audio -->
    <template v-if="['image', 'video', 'audio'].includes(data.type)">
      <media-message-editor :data="data" @input="onMediaChanged" :index="index"/>
    </template>

    <!-- location -->
    <location-editor v-if="data.type === MessageType.Location" :data="data"  @input="onLocationChanged" :indexParent="index"/>

    <!-- <div class="form-group" v-if="[MessageType.Template, MessageType.Imagemap, MessageType.Flex].includes(data.type)" hidden>
      <label>代替テキスト</label>
      <input type="text" :name="`${altText}${index}`" class="form-control" placeholder="代替テキストを入力してください" v-model="defaults.altText" v-validate="'max:400'" data-vv-as="代替テキスト"/>
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
    onTextChanged(value) {
      this.defaults = {
        type: 'text',
        text: value
      };
      this.$emit('changeContent', this.defaults);
    },
    onStickerChanged(value) {
      this.defaults = {
        type: 'sticker',
        packageId: value.packageId,
        stickerId: value.stickerId
      };
      this.$emit('changeContent', this.defaults);
    },
    onMediaChanged(value) {
      this.defaults = value;
      this.$emit('changeContent', this.defaults);
    },

    onTemplateContentChanged(value) {
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

    onImagemapChanged(value) {
      this.defaults = value;
      this.$emit('changeContent', this.defaults);
    },

    onLocationChanged(value) {
      this.defaults = value;
      this.$emit('changeContent', this.defaults);
    },

    onFlexChanged(value) {
      this.defaults = value;
      if (!this.defaults.altText) {
        this.defaults.altText = 'Flexメッセージ';
      }
      this.$emit('changeContent', this.defaults);
    }
  }
};
</script>
