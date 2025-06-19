<template>
  <li :id="`chatItem${message.id}`">
    <chat-item-unread-mark v-if="showUnreadMarkDiv" :key="componentKey"></chat-item-unread-mark>
    <div class="d-flex align-items-center mb-2" v-if="shouldShowDate">
      <div class="fh-2 bg-light flex-grow-1"></div>
      <span class="font-12 font-weight-bold border border-light py-1 px-2 date-title">{{ readableDate }}</span>
      <div class="fh-2 bg-light flex-grow-1"></div>
    </div>
    <template v-if="isSystemMessage">
      <system-message :message="message"></system-message>
    </template>
    <template v-else>
      <div :class="alignBubble">
        <div class="chat-avatar">
          <img v-lazy="avatarImgObj" class="rounded" alt="友達" />
          <i>{{ readableTime }}</i>
        </div>
        <div class="conversation-text d-flex flex-end">
          <div v-if="!isFriendMessage" class="d-flex ml-auto">
            <span class="mt-auto mr-1"><chat-item-send-status :status="message.status"></chat-item-send-status></span>
          </div>
          <div class="ctext-wrap">
            <i>{{ sender.name || "システム" }}</i>
            <p>
              <message-content :data="message" :time="readableTime"></message-content>
            </p>
          </div>
        </div>
      </div>
    </template>
  </li>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import moment from 'moment'
import Util from '@/core/util'

const props = defineProps({
  message: {
    type: Object,
    required: true
  },
  prevMessage: {
    type: Object,
    required: false,
    default: () => {}
  },
  lastSeenAt: {
    type: String,
    required: false,
    default: moment().format()
  },
  showUnreadMarkDiv: {
    type: Boolean,
    required: false,
    default: null
  }
})

const componentKey = ref(0)
const avatarImgObj = ref({
  src: '',
  error: '/img/no-image-profile.png',
  loading: '/images/loading.gif'
})

const isSystemMessage = computed(() => props.message.from === 'system')
const isFriendMessage = computed(() => props.message.from === 'friend')
const sender = computed(() => props.message.sender || {})
const readableTime = computed(() => Util.formattedTime(props.message.timestamp))
const readableDate = computed(() => Util.formattedDate(props.message.timestamp))
const shouldShowDate = computed(() => {
  const ts1 = props.message.timestamp
  const ts2 = props.prevMessage ? props.prevMessage.timestamp : null
  const date1 = Util.formattedDate(ts1)
  const date2 = ts2 ? Util.formattedDate(ts2) : null
  return date1 !== date2
})
const alignBubble = computed(() => props.message.from === 'friend' ? 'clearfix' : 'clearfix odd')

onMounted(() => {
  avatarImgObj.value.src = sender.value.avatar_url || '/img/no-image-profile.png'
})

const forceRerender = () => {
  componentKey.value++
}
</script>
<style lang="scss" scoped>
  .date-title {
    border-radius: 15px;
  }

  .border-light {
    border-color: #ccc;
  }

  .bg-light {
    background: #ccc;
  }

  :deep() {
    .more-option {
      display: none;
      margin: 0 5px;

      button {
        cursor: pointer;
        display: flex;
        flex-shrink: 0;
        height: 25px;
        justify-content: center;
        width: 20px;
        background: transparent !important;
        border: none !important;
      }

      button:active {
        box-shadow: none !important;
      }

      .dropdown-menu {
        width: 50px !important;
        min-width: 50px !important;
        a {
          padding: 3px 10px !important;
        }
      }
    }
  }

  .direct-chat-text {
    border-radius: 10px;
  }

  .user {
    .right .direct-chat-text {
      background-color: #b8ebb8;
      border: 1px solid #b8ebb8 !important;
      color: #000 !important;
      left: auto;
      right: 0;
      border-left-color: #b8ebb8 !important;
      border-right: 0;
      border-top: 0;
      margin-right: -0.375rem;
    }
    .right .direct-chat-text::after,
    .right .direct-chat-text::before {
      border-left-color: #88d69a !important;
      border-right-color: transparent;
      left: 100%;
      right: auto;
    }
  }

  .bot {
    .right .direct-chat-text {
      background-color: #d8d8d8;
      border: 1px solid #d8d8d8 !important;
      color: #000 !important;
    }
    .right .direct-chat-text::after,
    .right .direct-chat-text::before {
      border-left-color: #d8d8d8 !important;
      border-right-color: transparent;
      left: 100%;
      right: auto;
    }
  }

  .chat:hover {
    .more-option {
      display: block;
    }
  }

  .created-message {
    margin-top: auto;
    margin-left: 5px;
    margin-right: 5px;
  }
</style>
