<template>
  <div class="container" v-if="activeChannel">
    <div class="nav-element" hidden>
      <!-- left -->
      <div class="left">
          <div class="avatar">
              <img :src="activeChannel.avatar ? activeChannel.avatar : '/img/no-image-profile.png'">
          </div>
          <div class="name">
              {{activeChannel.title}}
          </div>
          <div  id="btn-detail" class="btn-detail fz14 btn-deatil-friend" @click="showFriendDetail(activeChannel.line_friend_id)"><a >友だち詳細</a></div>
      </div>
      <div class="right">
      </div>
    </div>
    <div class="messages">
      <div class="content direct-chat-messages" ref='messageDisplay' @scroll="loadMoreMessages" @click="clickMessagesContent" @drop="onDropMessage" @dragover="allowDrop">
        <img id="message_loading" src="/img/giphy.gif" style="width: 100px;height: 70px; margin: auto; display: flex; object-fit:cover;"  v-if="isLoadMoreMessage">
        <div v-for="(message, index) in messages" :key="index" :id="'message_content_' + message.id">
          <div v-if="isDateTimeMessage(message, messages[index-1]) || index == 0 " class="chatsys">
            <div class="chatsys-content">
              {{getDateTimeMessage(message)}}
            </div>
          </div>
          <div class="unread-message-divider w-100" v-show="totalUnreadMessage && messages.length - totalUnreadMessage == index" id="unreadMessageIndex">
            <div class="unread-message-content w-100">
              <div class="unread-message-text">
                未読
              </div>
            </div>
          </div>
          <chat-item  :message="message" @unread="setUnreadMessage"></chat-item>
        </div>
      </div>
      <div class="box-input" style="position: relative">
        <div  class="emoji" v-if="openedStickerPane">
          <div class="tool">
            <select-package-sticker @input="changePackageId" />
          </div>
          <div class="content">
            <sticker
              v-for="(sticker, index) in stickers"
              v-bind:sticker="sticker"
              v-bind:animation="animation"
              :key="index"
              @input="onSendStickerMessage"
            />
          </div>
        </div>
        <div class="tool d-flex align-items-center" v-if="activeChannel.status !== 'blocked'">
          <ul class="left list-action">
            <li class="text-sticker" @click="openSticker">
              <i class="fas fa-smile "></i>
            </li>
            <li data-toggle="modal" data-target="#imageModalCenter">
              <i class="fas fa-paperclip "></i>
            </li>
            <li data-toggle="modal">
              <b-dropdown id="dropdown-dropup" dropup class="m-2 action-template">
                 <template v-slot:button-content>
                    <i class="fas fa-plus"></i>
                  </template>
                <b-dropdown-item  data-toggle="modal" data-target="#modal-template">テンプレート配信</b-dropdown-item>
                <b-dropdown-item data-toggle="modal" data-target="#modalSelectScenario">シナリオ配信</b-dropdown-item>
                <b-dropdown-item data-toggle="modal" data-target="#modal-flex-message-template">Flexメッセージ配信</b-dropdown-item>
              </b-dropdown>
            </li>
          </ul>
          <div class="btn-send" @click="sendTextMessage"><i class="fas fa-paper-plane"></i></div>
        </div>
        <div class="text"  v-if="activeChannel.status !== 'blocked'">
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
          v-if="activeChannel.status === 'blocked'"
          style="padding: 30px;background-color: #ededed;display: flex;">
            <div style="font-size: 12px; text-align: center; user-select: none; height: 100%; overflow: hidden"> このユーザーはLINEアカウントを削除したか、あなたのアカウントをブロックしたか、あなたをチャットルームから退出させたため、このユーザーにメッセージを送信できません。
            </div>
        </div>
      </div>
    </div>
    <modal-select-media :types="['image','audio','video']" @select="onSendMedia($event)"></modal-select-media>
    <modal-send-template @selectTemplate="onSelectTemplate"></modal-send-template>
    <modal-send-scenario @selectScenario="onSelectScenario" type="normal" id="modalSelectScenario"></modal-send-scenario>
    <!-- <modal-select-flex-message-template name="modal-flex-message-template" @input="selectFlexMessageTemplate"/> -->
  </div>
  <div v-else class="container" >
    <div class="empty" ></div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';
import moment from 'moment';

export default {
  data() {
    return {
      textMessage: '',
      openedStickerPane: false,
      animation: false,
      doneFetchingChannelAcitveId: null,
      totalUnreadMessage: null,
      currentScrollTop: 0
    };
  },

  watch: {
    messages: {
      handler(val) {
        if (this.currentPage === 1 && val.length > 0) {
          this.$nextTick(function() {
            if (this.totalUnreadMessage && this.totalUnreadMessage > 0 && val.length >= this.totalUnreadMessage) {
              // đi đến unread
              const message = val[val.length - this.totalUnreadMessage];
              const obj = $('#message_content_' + message.id);
              const childPos = obj.offset();
              const parentPos = obj.parent().offset();
              this.$refs.messageDisplay.scrollTop = childPos.top - parentPos.top - 20;// ($('#message_content_' + message.id).offset().top - 30);
              // flash message
              obj.find('.chat').addClass('flash-message');
            } else {
              this.scrollToBottom();
            }
            this.totalUnreadMessage = 0;
          });
        }
      },
      deep: true
    },

    activeChannel: {
      handler(val) {
        if (!val) return;
        this.$nextTick(() => {
          if (this.doneFetchingChannelAcitveId !== val.id) {
            this.totalUnreadMessage = val.total_unread_messages;
            this.doneFetchingChannelAcitveId = val.id;
          } else {
            if (this.unreadChannelId) {
              this.totalUnreadMessage = val.total_unread_messages;
            }
          }
        });
      },
      deep: true
    }
  },
  computed: {
    ...mapState('channel', {
      activeChannel: state => state.activeChannel,
      messages: state => state.messages,
      isLoadMoreMessage: state => state.isLoadMoreMessage,
      messageParams: state => state.messageParams,
      totalPages: state => state.totalPages,
      currentPage: state => state.currentPage,
      unreadChannelId: state => state.unreadChannelId
    }),
    ...mapState('global', {
      stickers: state => state.stickers
    }),

    isMobile() {
      return Util.isMobile();
    }
  },

  methods: {
    ...mapActions('channel', [
      'getMessages',
      'setMessageParams',
      'setActiveChannel',
      'sendMedia',
      'unreadMessage',
      'setUnreadChannelId'
    ]),
    ...mapActions('global', [
      'getStickers'
    ]),

    scrollToBottom() {
      setTimeout(() => {
        const messageDisplay = this.$refs.messageDisplay;
        messageDisplay.scrollTop = messageDisplay.scrollHeight;
      }, 1);
    },

    async loadMoreMessages() {
      const messageDisplay = this.$refs.messageDisplay;
      if (messageDisplay.scrollTop < 10 && !this.isLoadMoreMessage) {
        const lastElement = messageDisplay.firstElementChild.id;
        const page = this.messageParams.page + 1;
        this.currentScrollTop = messageDisplay.scrollHeight;
        if (page > this.totalPages) return;
        this.setMessageParams({ page: page });
        await this.getMessages({ page: page });
        this.$nextTick(() => {
          document.getElementById(lastElement).scrollIntoView();
        });
      }
    },

    openSticker() {
      this.openedStickerPane = !this.openedStickerPane;
      this.getStickers({ packageId: null });
    },

    clickMessagesContent() {
      this.openedStickerPane = false;
      this.getStickers({ packageId: null });
    },

    changePackageId(option) {
      this.animation = option.animation;
      this.getStickers({ packageId: option.packageId });
    },

    // Send a text message from input
    sendTextMessage() {
      if (this.textMessage.trim()) {
        const message = {
          channel_id: this.activeChannel.id,
          message: {
            type: 'text',
            text: this.textMessage
          },
          timestamp: new Date().getTime()
        };

        this.$emit('onSendMessage', message);
      }

      this.textMessage = '';
    },
    // Send a sticker message
    onSendStickerMessage(sticker) {
      // close stickers pane
      this.openedStickerPane = false;

      const message = {
        channel_id: this.activeChannel.id,
        message: {
          type: 'sticker',
          packageId: sticker.package_id,
          stickerId: sticker.line_emoji_id,
          stickerResourceType: 'STATIC'
        },
        timestamp: new Date().getTime()
      };

      this.$emit('onSendMessage', message);
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
      this.$emit('onSendMessage', message);
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

    showFriendDetail(id) {
      this.$emit('showFriendDetail', { id: id });
    },

    setUnreadMessage(messageId) {
      this.setUnreadChannelId(this.activeChannel.id);
      this.unreadMessage({ message_id: messageId, channel_id: this.activeChannel.id });
    },

    isDateTimeMessage(currentMessage, lastMessage) {
      if (currentMessage && currentMessage.created_at && lastMessage && lastMessage.created_at) {
        const currentTime = moment(moment(parseInt(currentMessage.timestamp)).format('YYYY-MM-DD'));
        const lastTime = moment(moment(parseInt(lastMessage.timestamp)).format('YYYY-MM-DD'));
        const dif = currentTime.diff(lastTime, 'days');
        if (dif >= 1) {
          return true;
        }
      }
      return false;
    },

    getDateTimeMessage(value) {
      return moment(parseInt(value.timestamp)).format('YYYY年MM月DD日');
    },

    onSelectTemplate(template) {
      const payload = {
        channel_id: this.activeChannel.id,
        template_id: template.id
      };

      this.$emit('onSendTemplate', payload);
    },

    onSelectScenario(scenario) {
      const payload = {
        channel_id: this.activeChannel.id,
        scenario_id: scenario.id
      };

      this.$emit('onSendScenario', payload);
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
          line_content: { ...content, id: template.id },
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
