<template>
  <div class="card chat-panel">
    <div class="card-header d-flex">
      <a class="icon-fs d-sm-block d-lg-none" @click="hiddenChatBox()"><i class="dripicons-arrow-thin-left"></i></a>
      <a class="flex-grow-1"></a>
      <a class="icon-fs d-sm-block d-xl-none" @click="showUserDetailBox()"><i class="mdi mdi-account-details"></i></a>
    </div>
    <div class="card-body d-flex flex-column">
      <ul
        ref="chatPanel"
        class="flex-grow-1 conversation-list overflow-auto"
        @scroll="handleScroll"
        @drop="onDropMessage"
        @dragover="allowDrop"
      >
        <transition name="slide-up">
          <div class="d-flex justify-content-center">
            <div class="spinner-border" role="status" v-show="shouldShowSpinner"></div>
          </div>
        </transition>
        <span v-for="(message, index) in messages" :key="index" :id="'message_content_' + message.id">
          <chat-item
            :message="message"
            :prevMessage="index > 0 ? messages[index - 1] : null"
            :lastSeenAt="activeChannel.last_seen_at"
            :showUnreadMarkDiv="message.shouldShowUnreadDiv"
            :key="componentKey"
          >
          </chat-item>
        </span>
      </ul>

      <reply-box ref="replyBox" @sendTextMessage="sendTextMessage" @resetModalSticker="resetModalSticker"></reply-box>
    </div>
    <loading-indicator></loading-indicator>
  </div>
</template>
<script setup>
import { ref, computed, watch, onMounted, onUpdated, onUnmounted } from 'vue'
import { useStore } from 'vuex'
import Util from '@/core/util'
import moment from 'moment'

const emit = defineEmits(['onResetModalSticker'])

const store = useStore()

const chatPanel = ref(null)
const replyBox = ref(null)
const animation = ref(false)
const currentScrollTop = ref(0)
const isLoadingPrevious = ref(true)
const scrollTopBeforeLoad = ref(null)
const heightBeforeLoad = ref(null)
const latestMessageId = ref(null)
const unreadDivWasShown = ref(false)
const componentKey = ref(0)

const activeChannel = computed(() => store.state.channel.activeChannel)
const messages = computed(() => store.state.channel.messages)
const allMessagesLoaded = computed(() => store.state.channel.allMessagesLoaded)
const isLoadMoreMessage = computed(() => store.state.channel.isLoadMoreMessage)
const showChatBox = computed(() => store.state.channel.showChatBox)
const showUserDetail = computed(() => store.state.channel.showUserDetail)
const latestMessage = computed(() => messages.value[messages.value.length - 1])
const isMobile = computed(() => Util.isMobile())
const shouldShowSpinner = computed(() => !allMessagesLoaded.value && isLoadingPrevious.value)

onMounted(() => {
  addScrollListener()
})

onUpdated(() => {
  Util.addMediaPlayListeners()
})

onUnmounted(() => {
  removeScrollListener()
})

watch(messages, (val) => {
  const newestMessage = val[val.length - 1]
  // Scroll to bottom if receive a new message
  if (newestMessage && newestMessage.id > latestMessageId.value) {
    setTimeout(() => {
      latestMessageId.value = newestMessage.id
      scrollToBottom()
    }, 500)
  }
}, { deep: true })

watch(activeChannel, (newChannel, oldChannel) => {
  unreadDivWasShown.value = false
  if (oldChannel && newChannel.id === oldChannel.id) {
    return
  }
  if (newChannel) {
    loadMoreMessages()
    replyBox.value?.clearInput()
  }
})

const forceRerender = () => {
  componentKey.value++
}

const removeScrollListener = () => {
  // Implementation needed if scroll listener was added
}

const addScrollListener = () => {
  setScrollParams()
  scrollToBottom()
  isLoadingPrevious.value = false
}

const setScrollParams = () => {
  heightBeforeLoad.value = chatPanel.value?.scrollHeight
  scrollTopBeforeLoad.value = chatPanel.value?.scrollTop
}

const scrollToBottom = async () => {
  if (messages.value.length === 0) return
  latestMessageId.value = messages.value[messages.value.length - 1].id
  if (!document.getElementById(`message_content_${latestMessageId.value}`)) return
  chatPanel.value.scrollTop = chatPanel.value.scrollHeight
  store.dispatch('channel/markMessagesRead')
}

const scrollToMessage = (id) => {
  location.href = '#'
  location.href = `#chatItem${id}`
}

const hiddenChatBox = () => {
  if (showChatBox.value) store.commit('channel/setShowChatBox', false)
  if (showUserDetail.value) store.commit('channel/setShowUserDetail', false)
}

const showUserDetailBox = () => {
  if (!showUserDetail.value) store.commit('channel/setShowUserDetail', true)
}

const handleScroll = async (e) => {
  setScrollParams()
  if (e.target.scrollTop < 100 && !isLoadingPrevious.value && !allMessagesLoaded.value && messages.value.length > 0) {
    isLoadingPrevious.value = true
    await loadMoreMessages()
    const heightDifference = chatPanel.value.scrollHeight - heightBeforeLoad.value
    chatPanel.value.scrollTop = scrollTopBeforeLoad.value + heightDifference
    isLoadingPrevious.value = false
  }
}

const shouldLoadMoreChats = () => {
  return !allMessagesLoaded.value && !isLoadingPrevious.value
}

const loadMoreMessages = async () => {
  const before = messages.value && messages.value.length > 0 ? messages.value[0].id : null
  await store.dispatch('channel/getMessages', { channelId: activeChannel.value.id, before: before })
  scrollToBottom()
  calcShowingUnreadDiv()
}

const sendTextMessage = (message) => {
  if (message.trim()) {
    const payload = {
      channel_id: activeChannel.value.id,
      message: {
        type: 'text',
        text: message
      }
    }
    store.dispatch('channel/sendMessage', payload)
  }
}

const sendStickerMessage = (sticker) => {
  const payload = {
    channel_id: activeChannel.value.id,
    message: {
      type: 'sticker',
      packageId: sticker.packageId,
      stickerId: sticker.stickerId,
      stickerResourceType: 'STATIC'
    }
  }
  store.dispatch('channel/sendMessage', payload)
}

const sendMediaMessage = (media) => {
  let message = null
  switch (media.type) {
  case 'image':
    message = buildImageMessage(media)
    break
  case 'video':
    message = buildVideoMessage(media)
    break
  case 'audio':
    message = buildAudioMessage(media)
    break
  }
  store.dispatch('channel/sendMessage', message)
}

const buildImageMessage = (media) => {
  return {
    channel_id: activeChannel.value.id,
    message: {
      type: 'image',
      originalContentUrl: media.url,
      previewImageUrl: media.preview_url
    }
  }
}

const buildVideoMessage = (media) => {
  return {
    channel_id: activeChannel.value.id,
    message: {
      type: 'video',
      originalContentUrl: media.url,
      previewImageUrl: media.preview_url
    }
  }
}

const buildAudioMessage = (media) => {
  return {
    channel_id: activeChannel.value.id,
    message: {
      type: 'audio',
      originalContentUrl: media.url,
      duration: media.duration || 0
    }
  }
}

const onDropMessage = (event) => {
  event.preventDefault()
  // sendMediaToTalk is not defined in original component
  // This would need to be implemented based on actual requirements
}

const allowDrop = (event) => {
  event.preventDefault()
}

const resetModalSticker = (event) => {
  emit('onResetModalSticker', event)
}

const calcShowingUnreadDiv = () => {
  unreadDivWasShown.value = false
  for (let index = 0; index < messages.value.length; index++) {
    const message = messages.value[index]
    const prevMessage = index === 0 ? null : messages.value[index - 1]
    if (unreadDivWasShown.value) {
      // only show one unread mark at the same time
      message.shouldShowUnreadDiv = false
    } else {
      message.shouldShowUnreadDiv = prevMessage && isUnread(prevMessage) ? false : isUnread(message)
      if (message.shouldShowUnreadDiv) {
        unreadDivWasShown.value = true
      }
    }
  }
  forceRerender()
}

const isUnread = (message) => {
  return message.from === 'friend' && moment(message.timestamp).isAfter(moment(activeChannel.value.last_seen_at))
}
</script>
<style lang="scss" scoped>
  .icon-fs {
    font-size: 1.5rem;
    cursor: pointer;
  }

  .conversation-list {
    z-index: 1;
  }

  @media (max-width: 768px) {
    .chat-panel {
      height: calc(100vh - 50px);
    }
  }

  @media (max-width: 767px) {
    .chat-panel {
      height: calc(100vh - 25px);
    }
  }

  @keyframes kf-flash-message {
    from {
      background-color: #ffe2d5;
    }
    to {
      background-color: transparent;
    }
  }

  @media screen and (min-color-index: 0) and(-webkit-min-device-pixel-ratio:0) {
    @media (max-width: 767px) {
      .chat-panel {
        .card-body {
          padding-bottom: 3.5rem;
        }
      }
    }
  }
</style>
