<template>
  <li>
    <chat-item-unread-mark v-if="shouldShowUnreadDiv"></chat-item-unread-mark>
    <div class="text-center text-sm font-weight-bold mb-2" v-if="shouldShowDate">{{ readableDate }}</div>
    <template v-if="isSystemMessage">
      <system-message :message="message"></system-message>
    </template>
    <template v-else>
      <div :class="alignBubble">
        <div class="chat-avatar">
          <img :src="sender.line_picture_url ? sender.line_picture_url :  '/img/no-image-profile.png'" class="rounded" alt="Shreyu N" />
          <i>{{ readableTime }}</i>
        </div>
        <div class="conversation-text">
          <div class="ctext-wrap">
            <i>{{ sender.name || 'システム' }}</i>
            <p>
              <message-content :data="message.content" :time="readableTime"></message-content>
            </p>
          </div>
        </div>
        <div class="conversation-actions dropdown" hidden>
          <button class="btn btn-sm btn-link" data-toggle="dropdown" aria-expanded="false"><i
              class='uil uil-ellipsis-v'></i></button>

          <div class="dropdown-menu dropdown-menu-right">
            <a class="dropdown-item" href="#">Copy Message</a>
            <a class="dropdown-item" href="#">Edit</a>
            <a class="dropdown-item" href="#">Delete</a>
          </div>
        </div>
      </div>
    </template>
  </li>
</template>
<script>
import moment from 'moment';

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
  computed: {
    isSystemMessage() {
      return this.message.from === 'system';
    },
    sender() {
      return this.message.sender || {};
    },
    readableTime() {
      return moment(this.message.timestamp).format('HH:mm');
    },
    readableDate() {
      return moment(this.message.timestamp).format('YYYY/MM/DD');
    },
    shouldShowDate() {
      const ts1 = this.message.timestamp;
      const ts2 = this.prevMessage ? this.prevMessage.timestamp : null;
      const date1 = moment(ts1).format('YYYY/MM/DD');
      const date2 = ts2 ? moment(ts2).format('YYYY/MM/DD') : null;
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
      return moment(message.timestamp).isAfter(moment(this.lastSeenAt));
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
    .more-option {
      display: none;
      margin:  0 5px;

      button {
        cursor: pointer;
        display: flex;
        flex-shrink: 0;
        height: 25px;
        justify-content: center;
        width: 20px;
        background: transparent!important;
        border: none!important;
      }

      button:active {
        box-shadow: none!important;
      }

      .dropdown-menu {
        width: 50px!important;
        min-width: 50px!important;
        a{
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
    .right .direct-chat-text::after, .right .direct-chat-text::before {
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
    .right .direct-chat-text::after, .right .direct-chat-text::before {
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
