<template>
  <div>
    <div class="row">
      <!-- start chat users-->
      <div class="channel-list">
        <channel-list :class="getLeftItem()" />
        <!-- :class="getLeftItem()" -->
      </div>
      <!-- end chat users-->
      <!-- {{ showChatBox }} -->
      <!-- chat area -->
      <div class="channel-chat" :class="showChatBox ? 'channel-chat-visible' : ''">
        <chat-box></chat-box>
        <!-- :class="getRightItem()" -->
      </div>
      <!-- end chat area-->

      <!-- start user detail -->
      <div class="channel-friend" :class="showUserDetail ? 'channel-friend-visible' : ''">
        <channel-friend-detail></channel-friend-detail>
      </div>
      <!-- end user detail -->
    </div>
    <template v-if="activeChannel">
      <modal-select-media
        id="modalSendMedia"
        :types="['image', 'audio', 'video', 'richmenu']"
        @select="sendMediaMessage($event)"
      ></modal-select-media>
      <modal-send-template @sendTemplate="sendTemplate"></modal-send-template>
      <modal-send-scenario @selectScenario="sendScenario"></modal-send-scenario>
      <modal-select-sticker
        ref="modalSticker"
        id="modalSelectSticker"
        @input="sendStickerMessage"
      ></modal-select-sticker>
    </template>
  </div>
</template>
<script>
import { mapActions, mapState, mapMutations } from 'vuex';
import consumer from '@channels/consumer';
import * as ActionCable from '@rails/actioncable';
ActionCable.logger.enabled = true;

export default {
  props: {
    channel_id: Number
  },

  async beforeMount() {
    this.connectToWebsocket();
    await this.getChannels();
    this.activateChannel();
  },

  data() {
    return {
      ws: null,
      isPc: true,
      isShowTalkChannel: false,
      rerender: true
    };
  },

  mounted() {
    if (window.location.href.toString() !== `${process.env.MIX_ROOT_PATH}/user/channels`) {
      this.setShowChatBox(true);
    }
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      channels: state => state.channels,
      messages: state => state.messages,
      unreadChannelId: state => state.unreadChannelId,
      showChatBox: state => state.showChatBox,
      showUserDetail: state => state.showUserDetail
    }),
    ...mapState('friend', {
      friend: state => state.friend
    })
  },

  methods: {
    ...mapActions('channel', ['getChannels', 'onReceiveWebsocketEvent', 'pushMessage', 'setActiveChannel']),

    ...mapMutations('channel', ['setShowChatBox']),
    connectToWebsocket() {
      const _this = this;
      consumer.subscriptions.create(
        { channel: 'ConversationChannel' },
        {
          received(data) {
            _this.onReceiveWebsocketEvent(data);
          }
        }
      );
    },

    // Activate the first channel if no channel was specified. Otherwise, activate the specified one
    async activateChannel() {
      const channel = this.channels.find(_ => _.id === this.channel_id);
      this.setActiveChannel(channel || this.channels[0]);
    },

    showChannels() {
      this.isPc = true;
      this.isShowTalkChannel = false;
    },

    getLeftItem() {
      let className = '';
      if (!this.isPc) {
        className += ' item-pc';
      }
      if (this.isShowTalkChannel) {
        className += ' item-hidden';
      }

      return className;
    },

    getRightItem() {
      let className = '';
      if (this.isPc) {
        className += ' item-pc';
      }

      return className;
    }
  }
};
</script>
<style lang="scss" scoped>
  .channel-chat,
  .channel-friend {
    position: relative;
    width: 100%;
    padding-right: 12px;
    padding-left: 12px;
    -webkit-box-flex: 0;
  }

  .channel-list {
    -ms-flex: 0 0 25%;
    flex: 0 0 25%;
    max-width: 25%;
    order: 1;
  }

  .channel-chat {
    -ms-flex: 0 0 50%;
    flex: 0 0 50%;
    max-width: 50%;
    order: 2;
  }

  .channel-friend {
    -ms-flex: 0 0 25%;
    flex: 0 0 25%;
    max-width: 25%;
    order: 3;
  }

  @media (max-width: 1400px) {
    .channel-list {
      -ms-flex: 0 0 30%;
      flex: 0 0 30%;
      max-width: 30%;
    }

    .channel-chat {
      -ms-flex: 0 0 70%;
      flex: 0 0 70%;
      max-width: 70%;
    }

    .channel-friend {
      -ms-flex: 0 0 30%;
      flex: 0 0 30%;
      max-width: 30%;
    }

    .channel-friend-visible {
      visibility: visible !important;
      transform: translateX(0) !important;
    }

    .channel-friend {
      position: fixed;
      top: 155px;
      /* left: -35%; */
      right: 0%;
      bottom: 0;
      height: 100%;
      width: 65%;
      z-index: 1030;
      visibility: hidden;
      transform: translateX(100%);
      transition: transform 0.3s ease, visibility 0.3s ease;
      background: #fafbfd;
    }
  }

  @media (max-width: 1024px) {
    .item-pc {
      visibility: visible;
      transform: translateX(0);
    }
    .item-hidden {
      display: none !important;
    }

    .channel-list {
      -ms-flex: 0 0 100%;
      flex: 0 0 100%;
      max-width: 100%;
    }

    .channel-chat {
      -ms-flex: 0 0 100%;
      flex: 0 0 100%;
      max-width: 100%;
    }

    .channel-friend {
      -ms-flex: 0 0 100%;
      flex: 0 0 100%;
      max-width: 100%;
    }

    .channel-chat-visible {
      visibility: visible !important;
      transform: translateX(0) !important;
    }
    .channel-friend {
      top: 2vh;
      width: 35%;
    }

    .channel-chat {
      position: fixed;
      top: 2vh;
      left: 25%;
      bottom: 0;
      height: 100%;
      width: 75%;
      z-index: 1020;
      visibility: hidden;
      transform: translateX(100%);
      transition: transform 0.3s ease, visibility 0.3s ease;
      background: #fafbfd;
    }

    .chatbox {
      width: calc(100vw - 250px);
    }
    .item-hidden {
      display: block;
    }
    .bottom {
      right: 0px;
      left: 0px;
      position: relative;
      width: 100%;
      z-index: 0;
    }
  }

  @media only screen and (max-width: 780px) {
    .channel-chat {
      top: 2vh;
      left: 35%;
      width: 65%;
    }
    .channel-friend {
      top: 2vh;
    }
  }

  @media only screen and (max-width: 760px) {
    .channel-chat {
      top: 2vh;
      left: 0%;
      width: 100%;
    }
    .channel-friend {
      top: 2vh;
      width: 65%;
    }
  }

  .container {
    background: white;
  }
</style>
