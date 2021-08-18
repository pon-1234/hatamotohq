import Talk from '../api/talk_api';

export const state = {
  channels: [],
  channelActive: null,
  messages: [],
  messageParams: {
    page: 1,
    channelId: null
  },
  lastPage: 1,
  currentPage: null,
  channel_LastPage: 1,
  channel_CurrentPage: null,
  isLoadmoreMessage: false,
  isLoadMoreChannel: false,
  unreadChannelId: null
};

export const mutations = {
  SET_CHANELS(state, channels) {
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
      state.channelActive.un_read = true;
    }
  },

  SET_CHANEL_ACTIVE(state, channelActive) {
    state.channelActive = channelActive;
    if (state.unreadChannelId !== state.channelActive.id) {
      state.channelActive.un_read = false;
    }
    const index = state.channels.findIndex(item => parseInt(item.id) === parseInt(channelActive.id));
    if (index >= 0) {
      state.channels.splice(index, 1, channelActive);
    }
  },

  RESET_MESSAGES(state, messages = []) {
    state.messages = messages;
  },

  SET_MESSAGES(state, messages) {
    state.lastPage = parseInt(messages.meta.last_page);
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
      state.channelActive.total_unread_messages += 1;
    } else {
      state.channelActive.total_unread_messages = 0;
    }
  },

  UPDATE_CHANNELS(state, { status, channel }) {
    const index = state.channels.findIndex(item => item.id === channel.id);
    if (index >= 0) {
      if (state.channelActive && state.channelActive.id === channel.id) {
        channel.un_read = false;
        if (!state.unreadChannelId) {
          channel.total_unread_messages = 0;
        }
        state.channelActive = channel;
      }

      if (status === 'add_message') {
        state.channels.splice(index, 1);
        state.channels.unshift(channel);
      } else if (status === 'read_message' || status === 'line_follow') {
        state.channels.splice(index, 1, channel);
      }
    } else {
      // theem channel mới
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
      const res = await Talk.getChannels(query);
      if (res) {
        context.commit('SET_CHANELS', res);
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
      const res = await Talk.getListMessages(query);
      if (res && res.data && (context.state.channelActive && query.channelId === context.state.channelActive.id)) {
        context.commit('SET_MESSAGES', res);
      }
    } catch (error) {
      console.log(error);
    }
    context.commit('SET_LOAD_MORE_MESSAGE', false);
  },

  setChangeActive(context, payload) {
    context.commit('SET_CHANEL_ACTIVE', payload);
  },

  setMessageParams(context, params) {
    if (!params.page) {
      params.page = 1;
    }
    context.commit('SET_MESSAGE_PARAMS', Object.assign({}, context.state.messageParams, params));
  },

  getMessageFromWs(context, mess) {
    if (mess.action === 'message_sent' || mess.action === 'message_receive') {
      if (context.state.channelActive && context.state.channelActive.id && mess.payload.channel.id === context.state.channelActive.id) {
        context.commit('PUSH_MESSAGE', mess.payload.content);
      }
      context.commit('UPDATE_CHANNELS', { status: 'add_message', channel: mess.payload.channel });
    } else if (mess.action === 'message_read') {
      context.commit('UPDATE_CHANNELS', { status: 'read_message', channel: mess.payload });
    } else if (mess.action === 'line_follow') {
      context.commit('UPDATE_CHANNELS', { status: 'line_follow', channel: mess.payload.channel });
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
      const response = await Talk.sendMedia(query);
      console.log(response);
    } catch (error) {
      console.log(error);
    }
  },

  async sendMediaFromManager(context, query) {
    try {
      const response = await Talk.sendMediaFromManager(query);
      console.log(response);
    } catch (error) {
      console.log(error);
    }
  },

  async unreadMessage(context, query) {
    try {
      const res = await Talk.unreadMessage(query);
      if (res && res.total) {
        context.commit('SET_CHANEL_ACTIVE', Object.assign({}, context.state.channelActive, { total_unread_messages: res.total }));
      }
    } catch (error) {
      console.log(error);
    }
  }
};
