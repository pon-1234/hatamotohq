<template>
  <div class="row">
    <!-- start chat users-->
    <div class="col-xl-3 col-lg-6 order-lg-1 order-xl-1">
      <channel-list :class="getLeftItem()" />
    </div>
    <!-- end chat users-->

    <!-- chat area -->
    <div class="col-xl-6 col-lg-12 order-lg-2 order-xl-1">
      <chat-box :class="getRightItem()"></chat-box>
    </div>
    <!-- end chat area-->

    <!-- start user detail -->
    <div class="col-xl-3 col-lg-6 order-lg-1 order-xl-2">
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
      activeChannel: state => state.activeChannel,
      channels: state => state.channels,
      messages: state => state.messages,
      unreadChannelId: state => state.unreadChannelId
    }),
    ...mapState('friend', {
      friend: state => state.friend
    })
  },

  methods: {
    ...mapActions('channel', ['getChannels', 'onReceiveWebsocketEvent', 'pushMessage', 'setActiveChannel']),

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
  @media (max-width: 991px) {
    .item-pc {
      display: none !important;
    }
    .item-hidden {
      display: none !important;
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
