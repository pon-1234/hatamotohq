<template>
  <div class="card chat-panel">
    <div class="card-body d-flex flex-column">
      <ul
        ref="chatPanel"
        class="flex-grow-1 conversation-list overflow-auto"
        data-simplebar
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
          >
          </chat-item>
        </span>
      </ul>

      <reply-box
        @sendTextMessage="sendTextMessage"
        @sendStickerMessage="sendStickerMessage"
        @sendMediaMessage="sendMediaMessage"
        @sendTemplate="sendTemplate"
        @sendScenario="sendScenario"
      ></reply-box>
    </div>
    <loading-indicator></loading-indicator>
    <!-- <modal-select-flex-message-template name="modal-flex-message-template" @input="selectFlexMessageTemplate"/> -->
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      animation: false,
      currentScrollTop: 0,
      isLoadingPrevious: true,
      scrollTopBeforeLoad: null,
      heightBeforeLoad: null,
      latestMessageId: null
    };
  },

  mounted() {
    this.addScrollListener();
  },

  unmounted() {
    this.removeScrollListener();
  },

  watch: {
    messages: {
      handler(val) {
        const newestMessage = _.last(val);
        // Scroll to bottom if receive a new message
        if (newestMessage.id > this.latestMessageId) {
          setTimeout(() => {
            this.latestMessageId = newestMessage.id;
            this.scrollToBottom();
          }, 500);
        }
      },
      deep: true
    },
    activeChannel(newChannel, oldChannel) {
      if (oldChannel && newChannel.id === oldChannel.id) {
        return;
      }
      if (newChannel) {
        this.loadMoreMessages();
      }
    }
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      messages: state => state.messages,
      allMessagesLoaded: state => state.allMessagesLoaded,
      isLoadMoreMessage: state => state.isLoadMoreMessage
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

    addScrollListener() {
      this.setScrollParams();
      this.scrollToBottom();
      this.isLoadingPrevious = false;
    },

    setScrollParams() {
      this.heightBeforeLoad = this.$refs.chatPanel.scrollHeight;
      this.scrollTopBeforeLoad = this.$refs.chatPanel.scrollTop;
    },

    scrollToBottom() {
      this.$refs.chatPanel.scrollTop = this.$refs.chatPanel.scrollHeight;
      this.markMessagesRead();
    },

    scrollToMessage(id) {
      location.href = '#';
      location.href = `#chatItem${id}`;
    },

    async handleScroll(e) {
      this.setScrollParams();
      if (
        e.target.scrollTop < 100 &&
        !this.isLoadingPrevious &&
        !this.allMessagesLoaded
      ) {
        this.isLoadingPrevious = true;
        await this.loadMoreMessages();
        const heightDifference =
              this.$refs.chatPanel.scrollHeight - this.heightBeforeLoad;
        this.$refs.chatPanel.scrollTop =
              this.scrollTopBeforeLoad + heightDifference;
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

    selectFlexMessageTemplate(template) {
      const content = JSON.parse(template.json_message);
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.last_timetamp = new Date().getTime();
      this.setActiveChannel(channel);
      const message = {
        channel: channel,
        content: {
          key: new Date().getTime(),
          is_bot_sender: 0,
          attr: 'chat-reverse',
          content: { ...content, id: template.id }
        }
      };

      this.$emit('onSendMessage', message);
    }
  }
};
</script>
<style lang="scss" scoped>
  @keyframes kf-flash-message {
    from {
      background-color: #ffe2d5;
    }
    to {
      background-color: transparent;
    }
  }
</style>
