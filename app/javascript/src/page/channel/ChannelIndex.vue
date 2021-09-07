<template>
  <div class="card">
    <div class="card-body talk">
      <talk-menu-bar @input="showChannels"/>
      <div class="container">
        <div id="chatbox" class="chatbox active">
          <channel-list @switchChannel="switchChannel" :class="getLeftItem()" />
          <chat-box @onSendMessage="sendMessage" @onSendScenario="sendScenario" @sendMediaMessage="sendMediaMessage" :class="getRightItem()" @showFriendDetail="showFriendDetail"/>
        </div>
      </div>
    </div>
    <talk-modal-search :id="'TalkModalSearch'" @input="fetchItem"></talk-modal-search>
    <modal-friend-detail :data="friend" :talk="true" @changeTilteChannel="changeTilteActiveChannel" v-if="rerender"/>
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
        $('div.talk').css('top', scrollHeight - $('div.talk').height() - 185 - 77 - 30);
        $('div.talk').addClass('bottom');
      } else {
        $('div.talk').css('top', '185px');
        $('div.talk').removeClass('bottom');
      }
    });
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      channels: state => state.channels,
      messages: state => state.messages,
      messageParams: state => state.messageParams,
      unreadChannelId: state => state.unreadChannelId
    }),
    ...mapState('friend', {
      friend: state => state.friend
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
      'sendMessage',
      'sendScenario',
      'pushMessage',
      'updateChannels',
      'setActiveChannel',
      'setMessageParams',
      'getMessages',
      'setUnreadChannelId',
      'resetMessages']),
    ...mapActions('friend', ['getFriendDetail']),
    ...mapActions('tag', [
      'getTags'
    ]),

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

    async activateFirstChannel() {
      this.setActiveChannel(this.channels[0]);
      await this.setMessageParams({ channelId: this.activeChannel.id });
      await this.getMessages(this.messageParams);
    },

    sendMediaMessage(message) {
      this.pushMessage(message.content);
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

    async showFriendDetail(query) {
      await this.getFriendDetail(query);
      $('#modal-detail-friend').modal('show');
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
    display: none!important;
  }
  .item-hidden {
    display: none!important;
  }
}

@media (min-width: 992px) {

  .item-hidden {
    display: block;
  }
  .bottom{
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
