import ChannelAPI from '../api/channel_api';

export const state = {
  channels: [],
  activeChannel: null,
  messages: [],
  channelParams: {
    before: null,
    keyword: ''
  },
  limitChannel: 30,
  limitMessage: 20,
  isLoadMoreMessage: false,
  unreadChannelId: null,
  allChannelLoaded: false,
  allMessagesLoaded: false
};

export const mutations = {
  setChannelParams(state, params) {
    Object.assign(state.channelParams, params);
  },

  setChannelParam(state, param) {
    Object.assign(state.channelParams, param);
  },

  pushChannels(state, channels) {
    if (channels.length < state.limitChannel) {
      state.allChannelLoaded = true;
    }
    state.channels = state.channels.concat(channels);
    state.channels = _.uniqBy(state.channels, (channel) => {
      return channel.id;
    });
  },

  setActiveChannel(state, activeChannel) {
    state.activeChannel = activeChannel;
    state.allMessagesLoaded = false;
    const index = state.channels.findIndex(item => parseInt(item.id) === parseInt(activeChannel.id));
    if (index >= 0) {
      state.channels.splice(index, 1, activeChannel);
    }
  },

  resetChannels(state) {
    state.channels = [];
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

  setAllChannelLoaded(state, status) {
    state.allChannelLoaded = status;
  },

  setAllMessageLoaded(state, status) {
    state.allMessagesLoaded = status;
  },

  pushMessage(state, message) {
    if (state.messages.find(item => item.key && parseInt(item.key) === parseInt(message.key))) {
      return;
    }
    state.messages.push(message);

    if (message.from === 'friend') {
      state.activeChannel.unread_count += 1;
    }
  },

  setUnreadCount(state, { channel, count }) {
    channel.unread_count = count;
  },

  updateChannels(state, { event, channel }) {
    const channelIndex = state.channels.findIndex(item => item.id === channel.id);
    if (channelIndex >= 0) {
      if (state.activeChannel && state.activeChannel.id === channel.id) {
        channel.unread_count = 0;
        // Update active channel with latest data
        state.activeChannel = channel;
      }
      if (event.action === 'new_message') {
        const message = event.content;
        if (message.from === 'friend') {
          if (_.isEmpty(state.channelParams.keyword)) {
            state.channels.splice(channelIndex, 1);
            state.channels.unshift(channel);
          }
        }
      } else if (event.action === 'read_message' || event.action === 'line_follow') {
        state.channels.splice(channelIndex, 1, channel);
      }
    } else {
      state.channels.unshift(channel);
    }
  }
};

export const getters = {
};

export const actions = {
  async getChannels(context) {
    try {
      const params = {
        before: state.channelParams.before,
        q: { line_friend_display_name_or_line_friend_line_name_or_line_friend_tags_name_cont: state.channelParams.keyword }
      };
      const res = await ChannelAPI.list(params);
      if (res) {
        context.commit('pushChannels', res.data);
      }
    } catch (error) {
      console.log(error);
    }
  },

  async getMessages(context, query) {
    context.commit('setLoadMoreMessage', true);
    try {
      const response = await ChannelAPI.channelMessages(query);
      const messages = response.data;
      if (messages && (context.state.activeChannel && query.channelId === context.state.activeChannel.id)) {
        context.commit('setMessages', messages);
        if (messages.length < state.limitMessage) {
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
      context.commit('updateChannels', { event: event, channel: event.channel });
      break;

    case 'line_follow':
      context.commit('updateChannels', { event: event, channel: event.channel });
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
      const response = await ChannelAPI.updateLastSeen(state.activeChannel.id);
      context.commit('setUnreadCount', { channel: state.activeChannel, count: 0 });
      return response;
    } catch (error) {
      return null;
    }
  },

  async sendMedia(context, query) {
    try {
      const response = await ChannelAPI.sendMedia(query);
      return response;
    } catch (error) {
      console.log(error);
    }
  }
};
