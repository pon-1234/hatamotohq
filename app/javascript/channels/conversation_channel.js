import consumer from './consumer';
import * as ActionCable from '@rails/actioncable';
import moment from 'moment-timezone';
ActionCable.logger.enabled = true;

consumer.subscriptions.create(
  {
    channel: 'ConversationChannel'
  },
  {
    received(data) {
      this.appendNewMessage(data);
    },

    appendNewMessage(data) {
      console.log('----------- received --------', data);
      // const html = this.createLine(data);
      // const element = document.querySelector('.direct-chat-messages');
      // element.insertAdjacentHTML('beforeend', html);
      // $('.direct-chat-messages').stop().animate({ scrollTop: $('.direct-chat-messages')[0].scrollHeight }, 1000);
    },

    createLine(data) {
      const event = data.event;
      if (event === 'message.created') {
        const message = data.data;
        return `
        <div class="direct-chat-msg">
          <div class="direct-chat-infos clearfix">
            <span class="direct-chat-name float-left">${message.sender.nick_name}</span>
            <span class="direct-chat-timestamp float-right">${moment(message.created_at).format('YYYY年MM月DD日 HH:mm')}</span>
          </div>
          <img class="direct-chat-img" src="${message.sender.avatar_url}">
          <div class="direct-chat-text">${message.content}</div>
        </div>
      `;
      }
    }
  });
