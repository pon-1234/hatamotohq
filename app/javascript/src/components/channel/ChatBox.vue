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
<script>
import { mapState, mapMutations, mapActions } from 'vuex';
import Util from '@/core/util';
import moment from 'moment';

export default {
  data() {
    return {
      animation: false,
      currentScrollTop: 0,
      isLoadingPrevious: true,
      scrollTopBeforeLoad: null,
      heightBeforeLoad: null,
      latestMessageId: null,
      unreadDivWasShown: false,
      componentKey: 0
    };
  },

  mounted() {
    this.addScrollListener();
  },

  updated() {
    Util.addMediaPlayListeners();
  },

  unmounted() {
    this.removeScrollListener();
  },

  watch: {
    messages: {
      handler(val) {
        const newestMessage = _.last(val);
        // Scroll to bottom if receive a new message
        if (newestMessage && newestMessage.id > this.latestMessageId) {
          setTimeout(() => {
            this.latestMessageId = newestMessage.id;
            this.scrollToBottom();
          }, 500);
        }
      },
      deep: true
    },
    activeChannel(newChannel, oldChannel) {
      this.unreadDivWasShown = false;
      if (oldChannel && newChannel.id === oldChannel.id) {
        return;
      }
      if (newChannel) {
        this.loadMoreMessages();
        this.$refs.replyBox.clearInput();
      }
    }
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      messages: state => state.messages,
      allMessagesLoaded: state => state.allMessagesLoaded,
      isLoadMoreMessage: state => state.isLoadMoreMessage,
      showChatBox: state => state.showChatBox,
      showUserDetail: state => state.showUserDetail
    }),

    latestMessage() {
      return _.last(this.messages);
    },

    isMobile() {
      return Util.isMobile();
    },

    shouldShowSpinner() {
      return !this.allMessagesLoaded && this.isLoadingPrevious;
    }
  },

  methods: {
    ...mapActions('channel', [
      'getMessages',
      'setActiveChannel',
      'sendMessage',
      'sendMedia',
      'sendTemplate',
      'sendScenario',
      'unreadMessage',
      'markMessagesRead'
    ]),
    ...mapMutations('channel', ['setShowChatBox', 'setShowUserDetail']),
    forceRerender() {
      this.componentKey++;
    },

    addScrollListener() {
      this.setScrollParams();
      this.scrollToBottom();
      this.isLoadingPrevious = false;
    },

    setScrollParams() {
      this.heightBeforeLoad = this.$refs.chatPanel.scrollHeight;
      this.scrollTopBeforeLoad = this.$refs.chatPanel.scrollTop;
    },

    async scrollToBottom() {
      if (this.messages.length === 0) return;
      this.latestMessageId = _.last(this.messages).id;
      if (!document.getElementById(`message_content_${this.latestMessageId}`)) return;
      this.$refs.chatPanel.scrollTop = this.$refs.chatPanel.scrollHeight;
      this.markMessagesRead();
    },

    scrollToMessage(id) {
      location.href = '#';
      location.href = `#chatItem${id}`;
    },

    hiddenChatBox() {
      if (this.showChatBox) this.setShowChatBox(false);
      if (this.showUserDetail) this.setShowUserDetail(false);
    },

    showUserDetailBox() {
      if (!this.showUserDetail) this.setShowUserDetail(true);
    },

    async handleScroll(e) {
      this.setScrollParams();
      if (e.target.scrollTop < 100 && !this.isLoadingPrevious && !this.allMessagesLoaded && !_.isEmpty(this.messages)) {
        this.isLoadingPrevious = true;
        await this.loadMoreMessages();
        const heightDifference = this.$refs.chatPanel.scrollHeight - this.heightBeforeLoad;
        this.$refs.chatPanel.scrollTop = this.scrollTopBeforeLoad + heightDifference;
        this.isLoadingPrevious = false;
      }
    },

    shouldLoadMoreChats() {
      return !this.allMessagesLoaded && !this.isLoadingPrevious;
    },

    async loadMoreMessages() {
      const before = this.messages && this.messages.length > 0 ? this.messages[0].id : null;
      await this.getMessages({ channelId: this.activeChannel.id, before: before });
      this.scrollToBottom();
      this.calcShowingUnreadDiv();
    },

    // Send a text message from input
    sendTextMessage(message) {
      if (message.trim()) {
        const payload = {
          channel_id: this.activeChannel.id,
          message: {
            type: 'text',
            text: message
          }
        };
        this.sendMessage(payload);
      }
    },

    // Send a sticker message
    sendStickerMessage(sticker) {
      // close stickers pane
      this.openedStickerPane = false;

      const payload = {
        channel_id: this.activeChannel.id,
        message: {
          type: 'sticker',
          packageId: sticker.packageId,
          stickerId: sticker.stickerId,
          stickerResourceType: 'STATIC'
        }
      };
      this.sendMessage(payload);
    },

    sendMediaMessage(media) {
      let message = null;
      switch (media.type) {
      case 'image':
        message = this.buildImageMessage(media);
        break;
      case 'video':
        message = this.buildVideoMessage(media);
        break;
      case 'audio':
        message = this.buildAudioMessage(media);
        break;
      }
      this.sendMessage(message);
    },

    buildImageMessage(media) {
      return {
        channel_id: this.activeChannel.id,
        message: {
          type: 'image',
          originalContentUrl: media.url,
          previewImageUrl: media.preview_url
        }
      };
    },

    buildVideoMessage(media) {
      return {
        channel_id: this.activeChannel.id,
        message: {
          type: 'video',
          originalContentUrl: media.url,
          previewImageUrl: media.preview_url
        }
      };
    },

    buildAudioMessage(media) {
      return {
        channel_id: this.activeChannel.id,
        message: {
          type: 'audio',
          originalContentUrl: media.url,
          duration: media.duration || 0
        }
      };
    },

    onDropMessage(event) {
      event.preventDefault();
      this.sendMediaToTalk(event.dataTransfer.files);
    },

    allowDrop(event) {
      event.preventDefault();
    },

    resetModalSticker(event) {
      this.$emit('onResetModalSticker', event);
    },

    calcShowingUnreadDiv() {
      this.unreadDivWasShown = false;
      for (let index = 0; index < this.messages.length; index++) {
        const message = this.messages[index];
        const prevMessage = index === 0 ? null : this.messages[index - 1];
        if (this.unreadDivWasShown) {
          // only show one unread mark at the same time
          message.shouldShowUnreadDiv = false;
        } else {
          message.shouldShowUnreadDiv = prevMessage && this.isUnread(prevMessage) ? false : this.isUnread(message);
          if (message.shouldShowUnreadDiv) {
            this.unreadDivWasShown = true;
          }
        }
      }
      this.forceRerender();
    },

    isUnread(message) {
      return message.from === 'friend' && moment(message.timestamp).isAfter(moment(this.activeChannel.last_seen_at));
    }
  }
};
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
