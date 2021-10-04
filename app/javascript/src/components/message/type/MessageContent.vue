<template>
  <div >
    <text-message
      v-if="data.type === 'text' "
      v-bind:data="data.text"
    />

    <log-message
      v-if="data.type === 'log' "
      v-bind:data="data.text"
      v-bind:time="time"
    />

    <sticker-message
      v-if="data.type === 'sticker' "
      v-bind:data="data.stickerId"
    />

    <media-message v-if="['image', 'video', 'audio'].includes(data.type)" v-bind:data="data" />
    <buttons-message v-if="data.type === MessageType.Template  && data.template && data.template.type ===  TemplateMessageType.Buttons" v-bind:data="data.template" />
    <confirm-message  v-if="data.type === MessageType.Template  && data.template && data.template.type ===  TemplateMessageType.Confirm" v-bind:data="data.template" />
    <carousel-message v-if="data.type === MessageType.Template  && data.template && data.template.type ===  TemplateMessageType.Carousel" :data="data.template.columns" />
    <image-carousel-message v-if="data.type === MessageType.Template  && data.template && data.template.type ===  TemplateMessageType.ImageCarousel"  :data="data.template.columns" />
    <imagemap-message v-if="data.type === MessageType.Imagemap"  :data="data.baseUrl"/>
    <location-message v-if="data.type === MessageType.Location"  :data="data"/>
    <!-- <flex-message v-if="data.type === MessageType.Flex"  :data="data" :source="source"/> -->
  </div>
</template>
<script>
export default {
  props: {
    data: Object,
    time: String
  }
};
</script>
