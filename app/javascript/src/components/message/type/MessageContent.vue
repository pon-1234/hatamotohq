<template>
  <div>
    <text-message v-if="content.type === 'text'" :data="content.text"></text-message>

    <sticker-message v-if="content.type === 'sticker'" :data="content.stickerId"></sticker-message>

    <media-message v-if="['image', 'video', 'audio'].includes(content.type)" :data="content"></media-message>

    <buttons-message
      v-if="
        content.type === MessageType.Template &&
        content.template &&
        content.template.type === TemplateMessageType.Buttons
      "
      :data="content.template"
    ></buttons-message>

    <confirm-message
      v-if="
        content.type === MessageType.Template &&
        content.template &&
        content.template.type === TemplateMessageType.Confirm
      "
      :data="content.template"
    ></confirm-message>

    <carousel-message
      v-if="
        content.type === MessageType.Template &&
        content.template &&
        content.template.type === TemplateMessageType.Carousel
      "
      :data="content.template.columns"
    ></carousel-message>

    <image-carousel-message
      v-if="
        content.type === MessageType.Template &&
        content.template &&
        content.template.type === TemplateMessageType.ImageCarousel
      "
      :data="content.template.columns"
    ></image-carousel-message>

    <imagemap-message v-if="content.type === MessageType.Imagemap" :baseUrl="content.baseUrl"></imagemap-message>

    <location-message v-if="content.type === MessageType.Location" :data="content"></location-message>

    <flex-message v-if="content.type === MessageType.Flex" :html="htmlContent"></flex-message>
  </div>
</template>
<script>
export default {
  props: {
    data: Object
  },

  computed: {
    content() {
      return this.data.content;
    },

    htmlContent() {
      return this.data.html_content;
    }
  }
};
</script>
