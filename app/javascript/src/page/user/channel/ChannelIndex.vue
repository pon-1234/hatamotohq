<template>
  <div class="row">
    <!-- start chat users-->
    <div class="col-xl-3 col-lg-6 order-lg-1 order-xl-1">
      <channel-list @switchChannel="switchChannel" :class="getLeftItem()" />
    </div>
    <!-- end chat users-->

    <!-- chat area -->
    <div class="col-xl-6 col-lg-12 order-lg-2 order-xl-1">
      <chat-box
        :class="getRightItem()"
        @showFriendDetail="showFriendDetail"
      ></chat-box>
    </div>
    <!-- end chat area-->

    <!-- start user detail -->
    <div class="col-xl-3 col-lg-6 order-lg-1 order-xl-2">
      <channel-friend-detail></channel-friend-detail>
    </div>
    <!-- end user detail -->

    <talk-modal-search
      :id="'TalkModalSearch'"
      @input="fetchItem"
    ></talk-modal-search>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import consumer from '@channels/consumer';
import * as ActionCable from '@rails/actioncable';
ActionCable.logger.enabled = true;

export default {
  props: {
    activeChannel: Number
  },
  async beforeMount() {
    this.connectToWebsocket();
    await this.getChannels();
    await this.getTags();
    this.activateFirstChannel();
  },

  data() {
    return {
      ws: null,
      isPc: true,
      isShowTalkChannel: false,
      rerender: true
    };
  },

  created() {
    $(window).on('scroll', function() {
      const scrollHeight = $(document).height();
      const scrollPosition = $(window).height() + $(window).scrollTop();
      if (scrollHeight - scrollPosition <= 77) {
        $('div.talk').css(
          'top',
          scrollHeight - $('div.talk').height() - 185 - 77 - 30
        );
        $('div.talk').addClass('bottom');
      } else {
        $('div.talk').css('top', '185px');
        $('div.talk').removeClass('bottom');
      }
    });
  },

  computed: {
    ...mapState('channel', {
      activeChannel: (state) => state.activeChannel,
      channels: (state) => state.channels,
      messages: (state) => state.messages,
      unreadChannelId: (state) => state.unreadChannelId
    }),
    ...mapState('friend', {
      friend: (state) => state.friend
    })
  },

  watch: {
    activeChannel: {
      handler(val) {
        this.rerender = false;
        this.$nextTick(() => {
          this.rerender = true;
        });
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('channel', [
      'getChannels',
      'onReceiveWebsocketEvent',
      'pushMessage',
      'setActiveChannel'
    ]),
    ...mapActions('tag', ['getTags']),

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

    async activateFirstChannel() {
      this.setActiveChannel(this.channels[0]);
    },

    switchChannel(isRefresh) {
      this.isPc = !this.isPc;
      // if (isRefresh) { this.activeChannel(0); }
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
    },

    changeTilteActiveChannel(title) {
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.title = title;
      this.setActiveChannel(channel);
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
