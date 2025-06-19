<template>
  <div class="area-type mb20">
    <!-- text message -->
    <message-editor-text v-if="data.type === 'text'" :value="data.text" @input="onTextChanged" :index="index" />

    <!-- sticker -->
    <sticker-message-editor
      v-if="data.type === 'sticker'"
      :packageId="data.packageId"
      :stickerId="data.stickerId"
      @input="onStickerChanged"
      :index="index"
    >
    </sticker-message-editor>

    <!-- image/video/audio -->
    <template v-if="['image', 'video', 'audio'].includes(data.type)">
      <message-editor-media :data="data" @input="onMediaChanged" :index="index"></message-editor-media>
    </template>

    <!-- location -->
    <message-editor-location
      v-if="data.type === MessageType.Location"
      :data="data"
      @input="onLocationChanged"
      :indexParent="index"
    ></message-editor-location>

    <!-- <div class="form-group" v-if="[MessageType.Template, MessageType.Imagemap, MessageType.Flex].includes(data.type)" hidden>
      <label>代替テキスト</label>
      <input type="text" :name="`${altText}${index}`" class="form-control" placeholder="代替テキストを入力してください" v-model="messageData.altText" v-validate="'max:400'" data-vv-as="代替テキスト"/>
      <error-message :message="errors.first(`${altText}${index}`)"></error-message>
    </div> -->

    <!-- template button -->
    <message-editor-buttons
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Buttons"
      :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
    ></message-editor-buttons>

    <!-- template confirm -->
    <message-editor-confirm
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Confirm"
      :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
    ></message-editor-confirm>

    <!-- template carousel -->
    <message-editor-carousel
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.Carousel"
      :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
    ></message-editor-carousel>

    <!-- template image caroutsel -->
    <message-editor-carousel-image
      v-if="data.type === MessageType.Template && data.template.type === TemplateMessageType.ImageCarousel"
      :data="data.template"
      @input="onTemplateContentChanged"
      :indexParent="index"
    ></message-editor-carousel-image>

    <!-- imagemap -->
    <message-editor-imagemap
      v-if="data.type === MessageType.Imagemap"
      :data="data"
      :index="index"
      @input="onImagemapChanged"
      :indexParent="index"
    >
    </message-editor-imagemap>

    <!-- flex message -->
    <flex-message-editor
      v-if="data.type === MessageType.Flex"
      :data="data"
      :index="index"
      @input="onFlexChanged"
      :indexParent="index"
    />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { MessageType, TemplateMessageType } from '@/core/constant'

const props = defineProps({
  data: {
    type: Object,
    required: true
  },
  index: {
    type: Number,
    required: true
  }
})

const emit = defineEmits(['changeContent'])

const messageData = ref({
  type: 'text',
  text: ''
})

onMounted(() => {
  if (props.data) {
    messageData.value = JSON.parse(JSON.stringify(props.data))
  }
})

const onTextChanged = (value) => {
  messageData.value = {
    type: 'text',
    text: value
  }
  emit('changeContent', messageData.value)
}

const onStickerChanged = (value) => {
  messageData.value = {
    type: 'sticker',
    packageId: value.packageId,
    stickerId: value.stickerId
  }
  emit('changeContent', messageData.value)
}

const onMediaChanged = (value) => {
  messageData.value = value
  emit('changeContent', messageData.value)
}

const onTemplateContentChanged = (value) => {
  messageData.value.template = value

  if (!messageData.value.altText) {
    if (messageData.value.template.type === 'buttons') {
      messageData.value.altText = 'ボタンメッセージ'
    }
    if (messageData.value.template.type === 'confirm') {
      messageData.value.altText = '質問メッセージ'
    }
    if (messageData.value.template.type === 'carousel') {
      messageData.value.altText = 'カルーセルメッセージ'
    }
    if (messageData.value.template.type === 'image_carousel') {
      messageData.value.altText = '画像カルーセルメッセージ'
    }
  }
  emit('changeContent', messageData.value)
}

const onImagemapChanged = (value) => {
  messageData.value = value
  emit('changeContent', messageData.value)
}

const onLocationChanged = (value) => {
  messageData.value = value
  emit('changeContent', messageData.value)
}

const onFlexChanged = (value) => {
  messageData.value = value
  if (!messageData.value.altText) {
    messageData.value.altText = 'Flexメッセージ'
  }
  emit('changeContent', messageData.value)
}
</script>
