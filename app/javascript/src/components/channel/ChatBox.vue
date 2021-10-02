<template>
  <div class="card chat-panel">
    <div class="card-body d-flex flex-column">
      <ul ref="chatPanel" class="flex-grow-1 conversation-list overflow-auto" data-simplebar @scroll="handleScroll" @drop="onDropMessage" @dragover="allowDrop">
        <transition name="slide-up">
          <div class="d-flex justify-content-center">
            <div class="spinner-border" role="status" v-show="shouldShowSpinner"></div>
          </div>
        </transition>
        <span
          v-for="(message, index) in messages"
          :key="index"
          :id="'message_content_' + message.id"
        >
          <chat-item
            :message="message"
            :prevMessage="index > 0 ? messages[index -1] : null"
            @unread="setUnreadMessage">
          </chat-item>
        </span>
      </ul>

      <reply-box
        @sendTextMessage="sendTextMessage"
        @sendStickerMessage="sendStickerMessage"
        @sendTemplate="sendTemplate"
        @sendScenario="sendScenario"
      ></reply-box>

      <!-- <div hidden class="box-input" style="position: relative">
        <div  class="emoji" v-if="openedStickerPane">
          <div class="tool">
            <sticker-select-package @input="changePackageId" />
          </div>
          <div class="content">
            <sticker
              v-for="(sticker, index) in stickers"
              v-bind:sticker="sticker"
              v-bind:animation="animation"
              :key="index"
              @input="sendStickerMessage"
            />
          </div>
        </div>
        <div class="tool d-flex align-items-center" v-if="!activeChannel.locked">
          <ul class="left list-action">
            <li class="text-sticker" >
              <i class="fas fa-smile "></i>
            </li>
            <li data-toggle="modal" data-target="#modalSendMedia">
              <i class="fas fa-paperclip "></i>
            </li>
            <li data-toggle="modal">
              <b-dropdown id="dropdown-dropup" dropup class="m-2 action-template">
                 <template v-slot:button-content>
                    <i class="fas fa-plus"></i>
                  </template>
                <b-dropdown-item  data-toggle="modal" data-target="#modal-template">テンプレート配信</b-dropdown-item>
                <b-dropdown-item data-toggle="modal" data-target="#modalSelectScenario">シナリオ配信</b-dropdown-item>
              </b-dropdown>
            </li>
          </ul>
          <div class="btn-send" @click="sendTextMessage"><i class="fas fa-paper-plane"></i></div>
        </div>
        <div class="text"  v-if="!activeChannel.locked">
            <b-form-textarea
              v-model="textMessage"
              id='txtMessage'
              :placeholder="!isMobile? 'Enterで改行、Shift+Enterで送信': ''"
              rows="4"
              @compositionstart="composing=true"
              @compositionend="composing=false"
              @keydown.enter.shift.exact.prevent
              @keydown.enter.shift.exact="sendTextMessage"
              >
        </b-form-textarea>
        </div>
        <div class="blocked"
          v-if="activeChannel.locked"
          style="padding: 30px;background-color: #ededed;display: flex;">
            <div style="font-size: 12px; text-align: center; user-select: none; height: 100%; overflow: hidden"> このユーザーはLINEアカウントを削除したか、あなたのアカウントをブロックしたか、あなたをチャットルームから退出させたため、このユーザーにメッセージを送信できません。
            </div>
        </div>
      </div> -->
      <!-- <template v-if="activeChannel">
        <modal-select-media id="modalSendMedia" :types="['image','audio','video']" @select="onSendMedia($event)"></modal-select-media>
        <modal-send-template @selectTemplate="onSelectTemplate"></modal-send-template>
        <modal-send-scenario @selectScenario="onSelectScenario" type="normal" id="modalSelectScenario"></modal-send-scenario>
        <modal-select-sticker ref="modalSticker" name="modalSelectSticker" @input="sendStickerMessage"></modal-select-sticker>
      </template> -->
    </div>
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
      heightBeforeLoad: null
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
        this.$nextTick(function() {
          this.scrollToBottom();
        });
      },
      deep: true
    },
    activeChannel(newChannel, oldChannel) {
      if (oldChannel && newChannel.id === oldChannel.id) {
        return;
      }
      this.loadMoreMessages();
    }
  },

  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      messages: state => state.messages,
      allMessagesLoaded: state => state.allMessagesLoaded,
      isLoadMoreMessage: state => state.isLoadMoreMessage
    }),

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
        this.setScrollParams();
      }
    },

    shouldLoadMoreChats() {
      return !this.allMessagesLoaded && !this.isLoadingPrevious;
    },

    async loadMoreMessages() {
      const before = this.messages && this.messages.length > 0 ? this.messages[0].id : null;
      await this.getMessages({ channelId: this.activeChannel.id, before: before });
    },

    // Send a text message from input
    sendTextMessage(message) {
      if (message.trim()) {
        const payload = {
          channel_id: this.activeChannel.id,
          message: {
            type: 'text',
            text: message
          },
          timestamp: new Date().getTime()
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
        },
        timestamp: new Date().getTime()
      };
      this.sendMessage(payload);
    },

    onSendMedia(media) {
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
        },
        timestamp: new Date().getTime()
      };
    },

    buildVideoMessage(media) {
      return {
        channel_id: this.activeChannel.id,
        message: {
          type: 'video',
          originalContentUrl: media.url,
          previewImageUrl: media.preview_url
        },
        timestamp: new Date().getTime()
      };
    },

    buildAudioMessage(media) {
      return {
        channel_id: this.activeChannel.id,
        message: {
          type: 'audio',
          originalContentUrl: media.url,
          duration: media.duration || 0
        },
        timestamp: new Date().getTime()
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
          content: { ...content, id: template.id },
          timestamp: new Date().getTime()
        }
      };

      this.$emit('onSendMessage', message);
    }
  }
};
</script>
<style lang="scss" scoped>

::v-deep{
  .action-template {
    .dropdown-menu {
      bottom: auto!important;
      min-width: 180px!important;
    }

    button{
      background: transparent!important;
      border: none!important;
      i {
        color: #666f86!important;
      }
    }

    .btn:focus, .btn:active, .btn:hover{
        box-shadow: none!important;
        outline: 0;
    }
  }
}

.flash-message {
  background: transparent;
  animation: kf-flash-message 2s normal;
}

@keyframes kf-flash-message {
  from {background-color: #ffe2d5;}
  to {background-color: transparent;}
}

#txtMessage:focus{
  box-shadow: none!important;
}

.btn-send {
    margin-left: auto;
    margin-right: 10px;
    cursor: pointer;
    font-size: 16px;
}

.btn-deatil-friend {
  white-space: nowrap;
  margin-left: 10px;
  cursor: pointer;
}
.chatsys {
  width: 100%;
  text-align: center;
  .chatsys-content {
    background: rgba(0,0,0,0.2);
    color: #fff;
    font-size: 80%;
    border-radius: 0.75rem;
    display: inline-block;
    padding: 0.25rem 0.75rem;
    line-height: 1.5;
    padding-top: 3px;
  }
}

.unread-message-divider  {
  position: relative;
  height: 1px;
  background-color: rgb(196, 39, 96);
  margin: 9px 0px;
  .unread-message-content{
    position: absolute;
    top: -9px;
    width: 100%;
    text-align: center;
    .unread-message-text{
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: calc(19px);
      line-height: calc(19px);
      background-color: white;
      font-size: 11px;
      font-weight: 700;
      color: rgb(196, 39, 96);
      padding: 0px 8px;
    }
  }
}
</style>
