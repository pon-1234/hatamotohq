<template>
  <li :id="`chatItem${message.id}`">
    <chat-item-unread-mark v-if="shouldShowUnreadDiv"></chat-item-unread-mark>
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
<script>
import moment from 'moment';
import Util from '@/core/util';

export default {
  props: {
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
      default: moment()
    }
  },
  data() {
    return {
      avatarImgObj: {
        src: '',
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      }
    };
  },

  created() {
    this.avatarImgObj.src = this.sender.avatar_url || '/img/no-image-profile.png';
  },

  computed: {
    isSystemMessage() {
      return this.message.from === 'system';
    },
    isFriendMessage() {
      return this.message.from === 'friend';
    },
    sender() {
      return this.message.sender || {};
    },
    readableTime() {
      return Util.formattedTime(this.message.timestamp);
    },
    readableDate() {
      return Util.formattedDate(this.message.timestamp);
    },
    shouldShowDate() {
      const ts1 = this.message.timestamp;
      const ts2 = this.prevMessage ? this.prevMessage.timestamp : null;
      const date1 = Util.formattedDate(ts1);
      const date2 = ts2 ? Util.formattedDate(ts2) : null;
      return date1 !== date2;
    },
    shouldShowUnreadDiv() {
      if (!this.prevMessage) return this.isUnread(this.message);
      return this.isUnread(this.prevMessage) ? false : this.isUnread(this.message);
    },
    alignBubble() {
      return this.message.from === 'friend' ? 'clearfix' : 'clearfix odd';
    }
  },

  methods: {
    isUnread(message) {
      return message.from === 'friend' && moment(message.timestamp).isAfter(moment(this.lastSeenAt));
    }
  }
};
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

  ::v-deep {
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
