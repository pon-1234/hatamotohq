<template>
  <div :class="'direct-chat-msg ' + message.from">
    <template v-if="message.from === 'friend'">
      <div class="direct-chat-infos clearfix">
        <span class="direct-chat-name float-left">{{ message.sender.name }}</span>
      </div>
      <div class="d-flex">
        <img class="direct-chat-img" alt="friend avatar" :src="message.sender.line_picture_url ? message.sender.line_picture_url :  '/img/no-image-profile.png'">
        <div class="ml-2">
          <message-content :data="message.line_content" :time="getTimeMessage(message)" :source="message.source || 'sended'"></message-content>
        </div>
        <span class="direct-chat-timestamp float-right mt-auto ml-2">{{getTimeMessage(message)}}</span>
      </div>
    </template>

    <template v-if="['bot', 'user'].includes(message.from)">
      <div>
        <div class="direct-chat-msg right">
          <div class="direct-chat-infos clearfix" v-if="message.sender">
            <span class="direct-chat-name float-right">{{ message.sender.name }}</span>
          </div>
          <div class="d-flex float-right">
            <span class="direct-chat-timestamp float-left mt-auto mr-2">{{getTimeMessage(message)}}</span>
            <div class="chat-item mr-0">
              <message-content :data="message.line_content" :time="getTimeMessage(message)" :source="message.source || 'sended'"></message-content>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- <div class="d-flex align-items-center" hidden>
      <div class="avatar" v-if="message.from === 'friend'">
        <img :src="message.sender.line_picture_url ? message.sender.line_picture_url :  '/img/no-image-profile.png'">
      </div>
      <div class="chat-content">
        <div class="chat-body">
          <div class="chat-main" :class="message.from === 'bot' ? ' is_bot' : ''">
            <message-content :data="message.line_content" :time="getTimeMessage(data)" :source="message.source || 'sended'"></message-content>
          </div>
        </div>
      </div>
      <div class="created-message" v-if="message.attr !== 'chat-log'">
        {{getTimeMessage(data)}}
      </div>
      <div :class="'more-option option-'+ message.attr" v-if="message.attr !== 'chat-log'">
        <b-dropdown>
          <template v-slot:button-content>
            <i class="fas fa-ellipsis-h"></i>
          </template>
          <b-dropdown-item @click="setUnreadMessage">未読</b-dropdown-item>
        </b-dropdown>
      </div>
    </div> -->
  </div>
</template>
<script>
import moment from 'moment';

export default {
  props: ['message'],
  methods: {
    setUnreadMessage() {
      this.$emit('unread', this.message.id);
    },

    getTimeMessage(value) {
      return moment(parseInt(value.timestamp)).format('HH:mm');
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
