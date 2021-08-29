<template>
  <div  class="container" v-if="activeChannel">
    <div class="nav-element">
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
      <div class="content" style="padding: 10px 0;" ref='messageDisplay' @scroll="loadMoreMessages" @click="clickMessagesContent" @drop="onDropMessage" @dragover="allowDrop">
        <img id="message_loading" src="/img/giphy.gif" style="width: 100px;height: 70px; margin: auto; display: flex; object-fit:cover;"  v-if="isLoadmoreMessage">
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
          <talk-view-message-content  :data="message" @unread="setUnreadMessage"/>
        </div>
      </div>
      <div class="box-input" style="position: relative">
        <div  class="emoji" v-if="isOpenStickers">
          <div class="tool">
            <select-package-sticker @input="changePackageId" />
          </div>
          <div class="content">
            <sticker
              v-for="(sticker, index) in stickers"
              v-bind:sticker="sticker"
              v-bind:animation="animation"
              :key="index"
              @input="selectSticker"
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
                <b-dropdown-item data-toggle="modal" data-target="#modal-scenario-template">ステップ配信</b-dropdown-item>
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
    <talk-select-media-modal @sendFile="sendFile" @sendMedia="sendMediaFromManager"/>
    <modal-select-message-template @setTemplate="selectMessageTemplate"/>
    <modal-select-scenario-template @changeSelectedTemplate="selectScenarioTemplate" type="normal" id="modal-scenario-template"/>
    <modal-select-flex-message-template name="modal-flex-message-template" @input="selectFlexMessageTemplate"/>
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
      isOpenStickers: false,
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
    ...mapState('talk', {
      activeChannel: state => state.activeChannel,
      messages: state => state.messages,
      isLoadmoreMessage: state => state.isLoadmoreMessage,
      messageParams: state => state.messageParams,
      lastPage: state => state.lastPage,
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
    ...mapActions('talk', ['getMessages', 'setMessageParams', 'setActiveChannel', 'sendMedia', 'unreadMessage', 'setUnreadChannelId']),
    ...mapActions('global', ['getStickers']),

    scrollToBottom() {
      setTimeout(() => {
        const messageDisplay = this.$refs.messageDisplay;
        messageDisplay.scrollTop = messageDisplay.scrollHeight;
      }, 1);
    },

    async loadMoreMessages() {
      const messageDisplay = this.$refs.messageDisplay;
      if (messageDisplay.scrollTop < 10 && !this.isLoadmoreMessage) {
        const page = this.messageParams.page + 1;
        this.currentScrollTop = messageDisplay.scrollHeight;
        if (page > this.lastPage) return;
        this.setMessageParams({ page: page });
        await this.getMessages(this.messageParams);
        this.$nextTick(() => {
          messageDisplay.scrollTop = this.currentScrollTop;
        });
      }
    },

    sendTextMessage() {
      if (this.textMessage.trim()) {
        // eslint-disable-next-line no-undef
        const channel = _.cloneDeep(this.activeChannel);
        channel.last_message = this.textMessage;
        channel.last_timetamp = new Date().getTime();

        this.setActiveChannel(channel);
        const message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'text',
              text: this.textMessage
            },
            line_timestamp: new Date().getTime()
          }
        };

        this.$emit('sendMessage', message);
      }

      this.textMessage = '';
    },

    openSticker() {
      this.isOpenStickers = !this.isOpenStickers;
      this.getStickers({ packageId: null });
    },
    clickMessagesContent() {
      this.isOpenStickers = false;
      this.getStickers({ packageId: null });
    },

    changePackageId(option) {
      this.animation = option.animation;
      this.getStickers({ packageId: option.packageId });
    },

    selectSticker(sticker) {
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.last_message = 'スタンプメッセージ';
      channel.last_timetamp = new Date().getTime();
      this.setActiveChannel(channel);
      const message = {
        channel: channel,
        content: {
          key: new Date().getTime(),
          is_bot_sender: 0,
          attr: 'chat-reverse',
          line_content: {
            type: 'sticker',
            packageId: sticker.package_id,
            stickerId: sticker.line_emoji_id,
            stickerResourceType: 'STATIC'
          },
          line_timestamp: new Date().getTime()
        }
      };

      this.$emit('sendMessage', message);
    },

    onDropMessage(event) {
      event.preventDefault();
      this.sendMediaToTalk(event.dataTransfer.files);
    },

    allowDrop(event) {
      event.preventDefault();
    },

    sendFile(file) {
      let message = null;
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.last_message = '';
      channel.last_timetamp = new Date().getTime();
      if (this.ImageType.indexOf(file.type) !== -1) {
        channel.last_message = '画像メッセージ';
        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'image',
              contentProvider: {
                type: 'external',
                originalContentUrl: URL.createObjectURL(file),
                previewImageUrl: URL.createObjectURL(file)
              }
            },
            line_timestamp: new Date().getTime()
          }
        };
      } else if (this.VideoType.indexOf(file.type) !== -1) {
        channel.last_message = '動画メッセージ';
        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'video',
              contentProvider: {
                type: 'external',
                originalContentUrl: URL.createObjectURL(file),
                previewImageUrl: URL.createObjectURL(file)
              },
              duration: 0
            },
            line_timestamp: new Date().getTime()
          }
        };
      } else if (this.AudioType.indexOf(file.type) !== -1) {
        channel.last_message = '音声メッセージ';

        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'audio',
              duration: 0,
              contentProvider: {
                type: 'external',
                originalContentUrl: URL.createObjectURL(file)
              }
            },
            line_timestamp: new Date().getTime()
          }
        };
      }
      if (message) {
        this.$emit('sendMessage', message);
        this.sendMedia({ key: message.content.key, file: file, channelId: channel.id });
      }
    },

    sendMediaFromManager(media) {
      let message = null;
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.last_message = '';
      channel.last_timetamp = new Date().getTime();
      if (this.ImageType.indexOf(media.mine_type) >= 0) {
        channel.last_message = '画像メッセージ';
        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'image',
              originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl,
              previewImageUrl: Util.makeUrlfromKey(media.alias).previewImageUrl,
              contentProvider: {
                type: 'external',
                originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl,
                previewImageUrl: Util.makeUrlfromKey(media.alias).previewImageUrl
              }
            },
            line_timestamp: new Date().getTime()
          }
        };
      }
      if (this.VideoType.indexOf(media.mine_type) >= 0) {
        channel.last_message = '動画メッセージ';
        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'video',
              originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl,
              previewImageUrl: Util.makeUrlfromKey(media.alias).previewImageUrl,
              contentProvider: {
                type: 'external',
                originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl,
                previewImageUrl: Util.makeUrlfromKey(media.alias).previewImageUrl
              },
              duration: 0
            },
            line_timestamp: new Date().getTime()
          }
        };
      }
      if (this.AudioType.indexOf(media.mine_type) >= 0) {
        channel.last_message = '音声メッセージ';

        message = {
          channel: channel,
          content: {
            key: new Date().getTime(),
            statusText: '送信中...',
            is_bot_sender: 0,
            attr: 'chat-reverse',
            line_content: {
              type: 'audio',
              duration: media.duration,
              originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl,
              contentProvider: {
                type: 'external',
                originalContentUrl: Util.makeUrlfromKey(media.alias).originalContentUrl
              }
            },
            line_timestamp: new Date().getTime()
          }
        };
      }

      this.$emit('sendMediaMessage', message);
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
        const currentTime = moment(moment(parseInt(currentMessage.line_timestamp)).format('YYYY-MM-DD'));
        const lastTime = moment(moment(parseInt(lastMessage.line_timestamp)).format('YYYY-MM-DD'));
        const dif = currentTime.diff(lastTime, 'days');
        if (dif >= 1) {
          return true;
        }
      }
      return false;
    },

    getDateTimeMessage(value) {
      return moment(parseInt(value.line_timestamp)).format('YYYY年MM月DD日');
    },

    selectMessageTemplate(template) {
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      channel.last_timetamp = new Date().getTime();
      this.setActiveChannel(channel);

      const message = {
        channel: channel,
        content: {
          type: 'template',
          templateId: template.id
        }
      };

      this.$emit('sendMessage', message);
    },

    selectScenarioTemplate(template) {
      // eslint-disable-next-line no-undef
      const channel = _.cloneDeep(this.activeChannel);
      const message = {
        channel: channel,
        content: {
          type: 'scenario',
          scenario_id: template.id
        }
      };

      this.$emit('sendMessage', message);
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
          line_timestamp: new Date().getTime()
        }
      };

      this.$emit('sendMessage', message);
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
