import ChannelAPI from '../api/channel_api';

export const state = {
  channels: [],
  activeChannel: null,
  messages: [],
  messageParams: {
    page: 1,
    channelId: null
  },
  totalPages: 1,
  currentPage: null,
  channel_LastPage: 1,
  channel_CurrentPage: null,
  isLoadMoreMessage: false,
  isLoadMoreChannel: false,
  unreadChannelId: null,
  allMessagesLoaded: false
};

export const mutations = {
  setChannels(state, channels) {
    state.channels = channels;
  },

  setUnreadChannelId(state, unreadChannelId) {
    state.unreadChannelId = unreadChannelId;
    if (unreadChannelId) {
      state.activeChannel.un_read = true;
    }
  },

  setActiveChannel(state, activeChannel) {
    state.activeChannel = activeChannel;
    state.allMessagesLoaded = false;
    if (state.unreadChannelId !== state.activeChannel.id) {
      state.activeChannel.un_read = false;
    }
    const index = state.channels.findIndex(item => parseInt(item.id) === parseInt(activeChannel.id));
    if (index >= 0) {
      state.channels.splice(index, 1, activeChannel);
    }
  },

  resetMessages(state) {
    state.messages = [];
  },

  setMessages(state, messages) {
    state.messages = messages.concat(state.messages);
  },

  setLoadMoreMessage(state, status) {
    state.isLoadMoreMessage = status;
  },

  setAllMessageLoaded(state, status) {
    state.allMessagesLoaded = status;
  },

  setLoadMoreChannel(state, status) {
    state.isLoadMoreChannel = status;
  },

  pushMessage(state, message) {
    if (state.messages.find(item => item.key && parseInt(item.key) === parseInt(message.key))) {
      return;
    }
    state.messages.push(message);

    if (state.unreadChannelId) {
      state.activeChannel.unread_count += 1;
    } else {
      state.activeChannel.unread_count = 0;
    }
  },

  updateChannels(state, { status, channel }) {
    const index = state.channels.findIndex(item => item.id === channel.id);
    if (index >= 0) {
      if (state.activeChannel && state.activeChannel.id === channel.id) {
        channel.un_read = false;
        if (!state.unreadChannelId) {
          channel.total_unread_messages = 0;
        }
        state.activeChannel = channel;
      }

      if (status === 'new_message') {
        // move channel to top
        state.channels.splice(index, 1);
        state.channels.unshift(channel);
      } else if (status === 'read_message' || status === 'line_follow') {
        state.channels.splice(index, 1, channel);
      }
    } else {
      state.channels.unshift(channel);
    }
  }
};

export const getters = {
};

export const actions = {
  async getChannels(context, query = {}) {
    context.commit('setLoadMoreChannel', true);
    try {
      const res = await ChannelAPI.list();
      if (res) {
        context.commit('setChannels', res.data);
      }
    } catch (error) {
      console.log(error);
    }
    context.commit('setLoadMoreChannel', false);
  },

  async getMessages(context, query) {
    context.commit('setLoadMoreMessage', true);
    try {
      const response = await ChannelAPI.channelMessages(query);
      const messages = response.data;
      if (messages && (context.state.activeChannel && query.channelId === context.state.activeChannel.id)) {
        context.commit('setMessages', messages);
        if (messages.length < 20) {
          context.commit('setAllMessageLoaded', true);
        }
      }
    } catch (error) {
      console.log(error);
    }
    context.commit('setLoadMoreMessage', false);
  },

  setActiveChannel(context, payload) {
    context.commit('setActiveChannel', payload);
  },

  onReceiveWebsocketEvent(context, event) {
    const eventType = event.action;
    switch (eventType) {
    case 'new_message':
      if (context.state.activeChannel && context.state.activeChannel.id && event.channel.id === context.state.activeChannel.id) {
        context.commit('pushMessage', event.content);
      }
      context.commit('updateChannels', { status: 'new_message', channel: event.channel });
      break;

    case 'message_read':
      context.commit('updateChannels', { status: 'read_message', channel: event });
      break;

    case 'line_follow':
      context.commit('updateChannels', { status: 'line_follow', channel: event.channel });
      break;
    default:
    }
  },

  // Get available scenario of the channel
  async getAvailableScenarios(context, channelId) {
    return await ChannelAPI.availableScenarios(channelId);
  },

  // Send a text message to the active channel
  async sendMessage(context, payload) {
    try {
      return await ChannelAPI.sendMessage(context.state.activeChannel.id, payload);
    } catch (error) {
      console.log(error);
    }
  },

  // Send a scenario to the active channel
  async sendScenario(_, payload) {
    try {
      return await ChannelAPI.sendScenario(payload);
    } catch (error) {
      console.log(error);
    }
  },

  async sendTemplate(_, payload) {
    try {
      return await ChannelAPI.sendTemplate(payload);
    } catch (error) {
      console.log(error);
    }
  },

  async updateLastSeen(context, payload) {
    try {
      return await ChannelAPI.updateLastSeen(payload);
    } catch (error) {
      return null;
    }
  },

  /**
   * Mark all messages in the channel as read
   * @param {Context} context state context
   * @returns response
   */
  async markMessagesRead(context) {
    try {
      return await ChannelAPI.updateLastSeen(state.activeChannel.id);
    } catch (error) {
      return null;
    }
  },

  pushMessage(context, message) {
    context.commit('pushMessage', message);
  },

  updateChannels(context, { status, channel }) {
    context.commit('updateChannels', { status, channel });
  },

  resetMessages(context) {
    context.commit('resetMessages');
  },

  setUnreadChannelId(context, payload) {
    context.commit('setUnreadChannelId', payload);
  },

  async sendMedia(context, query) {
    try {
      const response = await ChannelAPI.sendMedia(query);
      return response;
    } catch (error) {
      console.log(error);
    }
  },

  async sendMediaFromManager(context, query) {
    try {
      const response = await ChannelAPI.sendMediaFromManager(query);
      console.log(response);
    } catch (error) {
      console.log(error);
    }
  }
};
