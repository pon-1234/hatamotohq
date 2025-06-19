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
        <url-config
          @configured="configUrl"
          @changeShortenUrlUsage="changeShortenUrlUsage"
          :index="index"
          :messageContent="messageData.content"
          :siteMeasurements="siteMeasurements"
          v-if="showUrlClickConfig && messageData.message_type_id === MessageTypeIds.Text"
        />
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { MessageType, MessageTypeIds, TemplateMessageType } from '@/core/constant'

const props = defineProps({
  data: Object,
  index: Number,
  messagesCount: Number,
  allowCreateFromTemplate: Boolean,
  showUrlClickConfig: Boolean,
  siteMeasurements: Array
})

const emit = defineEmits(['input', 'remove', 'moveUp', 'moveDown', 'configUrl', 'changeShortenUrlUsage'])

const messageData = ref({
  message_type_id: MessageTypeIds.Text,
  content: {
    type: MessageType.Text,
    text: ''
  }
})
const rerender = ref(true)

onMounted(() => {
  if (props.data) {
    Object.assign(messageData.value, props.data)
  }
})

const changeSelectedMessage = () => {
  switch (messageData.value.message_type_id) {
  case MessageTypeIds.Text:
    messageData.value.content = {
      type: MessageType.Text,
      text: ''
    }
    break
  case MessageTypeIds.Sticker:
    messageData.value.content = {
      type: MessageType.Sticker,
      packageId: '',
      stickerId: ''
    }
    break
  case MessageTypeIds.Image:
    messageData.value.content = {
      type: MessageType.Image,
      originalContentUrl: '',
      previewImageUrl: ''
    }
    break
  case MessageTypeIds.Video:
    messageData.value.content = {
      type: MessageType.Video,
      originalContentUrl: '',
      previewImageUrl: ''
    }
    break
  case MessageTypeIds.Audio:
    messageData.value.content = {
      type: MessageType.Audio,
      originalContentUrl: '',
      duration: ''
    }
    break
  case MessageTypeIds.TemplateButtons:
    messageData.value.content = {
      type: 'template',
      template: {
        type: TemplateMessageType.Buttons
      }
    }
    break
  case MessageTypeIds.TemplateConfirm:
    messageData.value.content = {
      type: 'template',
      template: {
        type: TemplateMessageType.Confirm
      }
    }
    break
  case MessageTypeIds.TemplateCarousel:
    messageData.value.content = {
      type: 'template',
      template: {
        type: TemplateMessageType.Carousel
      }
    }
    break
  case MessageTypeIds.TemplateImageCarousel:
    messageData.value.content = {
      type: 'template',
      template: {
        type: TemplateMessageType.ImageCarousel
      }
    }
    break
  case MessageTypeIds.Imagemap:
    messageData.value.content = {
      type: MessageType.Imagemap,
      templateId: 201,
      templateValue: 6,
      baseUrl: null,
      baseSize: {
        width: 1040,
        height: 1040
      },
      actions: []
    }
    break
  case MessageTypeIds.Location:
    messageData.value.content = {
      type: 'location',
      title: '',
      address: '',
      latitude: '',
      longitude: ''
    }
    break
  case MessageTypeIds.Flex:
    messageData.value.content = {
      type: MessageType.Flex,
      contents: null
    }
    break
  }
  rerender.value = false

  setTimeout(() => {
    rerender.value = true
  }, 100)

  emit('input', { index: props.index, content: messageData.value })
}

const changeContentMessage = (content) => {
  messageData.value.content = content
  emit('input', { index: props.index, content: messageData.value })
}

const removeMessage = () => {
  emit('remove', props.index)
}

const moveUp = () => {
  emit('moveUp', props.index)
}

const moveDown = () => {
  emit('moveDown', props.index)
}

const configUrl = ({ index, content }) => {
  emit('configUrl', { index: index, content: content })
}

const changeShortenUrlUsage = ({ index, notUseShorternUrl }) => {
  emit('changeShortenUrlUsage', { index: index, notUseShorternUrl: notUseShorternUrl })
}
</script>

<style  lang="scss" scoped>
  :deep() {
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
