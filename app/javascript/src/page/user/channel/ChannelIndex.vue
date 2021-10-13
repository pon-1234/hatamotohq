<template>
  <div class="row">
    <!-- start chat users-->
    <div class="col-xl-3 col-md-12 order-lg-1 order-xl-1">
      <channel-list :class="getLeftItem()"/>
      <!-- :class="getLeftItem()" -->
    </div>
    <!-- end chat users-->
    <!-- {{ showChatBox }} -->
    <!-- chat area -->
    <div class="col-xl-6 col-md-12 order-lg-2 order-xl-2 main " :class="showChatBox ? 'main-visible' : ''">
      <chat-box></chat-box>
      <!-- :class="getRightItem()" -->
    </div>
    <!-- end chat area-->

    <!-- start user detail -->
    <div class="col-xl-3 col-md-12 order-lg-1 order-xl-3 main-user" :class="showUserDetail ? 'main-user-visible' : ''">
      <channel-friend-detail></channel-friend-detail>
    </div>
    <!-- end user detail -->
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
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

  computed: {
    ...mapState('channel', {
      activeChannel: (state) => state.activeChannel,
      channels: (state) => state.channels,
      messages: (state) => state.messages,
      unreadChannelId: (state) => state.unreadChannelId,
      showChatBox: (state) => state.showChatBox,
      showUserDetail: state => state.showUserDetail
    }),
    ...mapState('friend', {
      friend: (state) => state.friend
    })
  },

  methods: {
    ...mapActions('channel', [
      'getChannels',
      'onReceiveWebsocketEvent',
      'pushMessage',
      'setActiveChannel'
    ]),

    connectToWebsocket() {
      const _this = this;
      if (consumer.subscriptions.subscriptions.length > 0) {
        // Already connected, keep only one connection at the same time
        return;
      }
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
@media (max-width: 1370px) {
  .item-pc {
    visibility: visible;
    transform: translateX(0);
  }
  .item-hidden {
    display: none !important;
  }

  .main-visible, .main-user-visible {
    visibility: visible !important;
    transform: translateX(0) !important;
  }

  .main, .main-user {
    position: fixed;
    top: 2vh;
    left: 0;
    bottom: 0;
    height: 100%;
    width: 100%;
    z-index: 1020;
    visibility: hidden;
    transform: translateX(100%);
    transition: transform .3s ease,visibility .3s ease;
    background: #fafbfd;
  }
}

@media (min-width: 992px) {
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

.container {
  background: white;
}
</style>
