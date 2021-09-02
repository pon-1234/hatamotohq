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
  isLoadmoreMessage: false,
  isLoadMoreChannel: false,
  unreadChannelId: null
};

export const mutations = {
  SET_CHANNELS(state, channels) {
    state.channel_LastPage = parseInt(channels.meta.last_page);
    state.channel_CurrentPage = parseInt(channels.meta.current_page);
    if (state.channel_CurrentPage === 1) {
      state.channels = channels.data;
    } else {
      // kiểm tra channel có chưa
      for (const channel of channels.data) {
        const index = state.channels.findIndex(item => item.alias === channel.alias);
        if (index === -1) {
          state.channels.push(channel);
        }
      }
    }
  },

  SET_UNREAD_CHANNEL_ID(state, unreadChannelId) {
    state.unreadChannelId = unreadChannelId;
    if (unreadChannelId) {
      state.activeChannel.un_read = true;
    }
  },

  SET_ACTIVE_CHANNEL(state, activeChannel) {
    state.activeChannel = activeChannel;
    if (state.unreadChannelId !== state.activeChannel.id) {
      state.activeChannel.un_read = false;
    }
    const index = state.channels.findIndex(item => parseInt(item.id) === parseInt(activeChannel.id));
    if (index >= 0) {
      state.channels.splice(index, 1, activeChannel);
    }
  },

  RESET_MESSAGES(state, messages = []) {
    state.messages = messages;
  },

  SET_MESSAGES(state, messages) {
    state.totalPages = parseInt(messages.meta.total_pages);
    state.currentPage = parseInt(messages.meta.current_page);

    if (messages.meta.current_page > 1) {
      state.messages = messages.data.reverse().concat(state.messages);
    } else {
      state.messages = messages.data.reverse();
    }
  },

  SET_MESSAGE_PARAMS(state, messageParams) {
    state.messageParams = messageParams;
    state.currentPage = messageParams.page;
  },

  SET_LOAD_MORE_MESSAGE(state, status) {
    state.isLoadmoreMessage = status;
  },

  SET_LOAD_MORE_CHANNEL(state, status) {
    state.isLoadMoreChannel = status;
  },

  PUSH_MESSAGE(state, message) {
    if (state.messages.find(item => item.key && parseInt(item.key) === parseInt(message.key))) {
      return;
    }
    state.messages.push(message);

    if (state.unreadChannelId) {
      state.activeChannel.total_unread_messages += 1;
    } else {
      state.activeChannel.total_unread_messages = 0;
    }
  },

  UPDATE_CHANNELS(state, { status, channel }) {
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
        console.log('-----channels-----', state.channels);
        console.log('-----new channel-----', channel);
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
    context.dispatch('system/setLoading', true, { root: true });
    context.commit('SET_LOAD_MORE_CHANNEL', true);

    try {
      const res = await ChannelAPI.list();
      if (res) {
        context.commit('SET_CHANNELS', res);
      }
    } catch (error) {
      console.log(error);
    }
    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_LOAD_MORE_CHANNEL', false);
  },

  async getMessages(context, query) {
    context.commit('SET_LOAD_MORE_MESSAGE', true);
    try {
      const res = await ChannelAPI.getListMessages(query);
      if (res && res.data && (context.state.activeChannel && query.channelId === context.state.activeChannel.id)) {
        context.commit('SET_MESSAGES', res);
      }
    } catch (error) {
      console.log(error);
    }
    context.commit('SET_LOAD_MORE_MESSAGE', false);
  },

  setActiveChannel(context, payload) {
    context.commit('SET_ACTIVE_CHANNEL', payload);
  },

  setMessageParams(context, params) {
    if (!params.page) {
      params.page = 1;
    }
    context.commit('SET_MESSAGE_PARAMS', Object.assign({}, context.state.messageParams, params));
  },

  onReceiveWebsocketEvent(context, event) {
    const eventType = event.action;
    switch (eventType) {
    case 'new_message':
      if (context.state.activeChannel && context.state.activeChannel.id && event.channel.id === context.state.activeChannel.id) {
        console.log('----1-----');
        context.commit('PUSH_MESSAGE', event.content);
      }
      context.commit('UPDATE_CHANNELS', { status: 'new_message', channel: event.channel });
      break;

    case 'message_read':
      context.commit('UPDATE_CHANNELS', { status: 'read_message', channel: event });
      break;

    case 'line_follow':
      context.commit('UPDATE_CHANNELS', { status: 'line_follow', channel: event.channel });
      break;
    default:
    }
  },

  pushMessage(context, message) {
    context.commit('PUSH_MESSAGE', message);
  },

  updateChannels(context, { status, channel }) {
    context.commit('UPDATE_CHANNELS', { status, channel });
  },

  resetMessages(context, payload) {
    context.commit('RESET_MESSAGES', payload);
  },

  setUnreadChannelId(context, payload) {
    context.commit('SET_UNREAD_CHANNEL_ID', payload);
  },

  async sendMedia(context, query) {
    try {
      const response = await ChannelAPI.sendMedia(query);
      console.log(response);
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
  },

  async unreadMessage(context, query) {
    try {
      const res = await ChannelAPI.unreadMessage(query);
      if (res && res.total) {
        context.commit('SET_ACTIVE_CHANNEL', Object.assign({}, context.state.activeChannel, { total_unread_messages: res.total }));
      }
    } catch (error) {
      console.log(error);
    }
  }
};
