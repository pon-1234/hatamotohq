
import Message from '../api/message_api';

export const state = {
  messages: [],
  total: 0,
  per_page: 0,
  params: {
    page: 1,
    status: 'all'
  },
  message: null,
  message_id: null,
  action_objects: []
};

export const mutations = {
  SET_MESSAGES_DATA(state, { messages, total, perPage }) {
    state.messages = messages;
    state.total = total;
    state.per_page = perPage;
  },

  SET_MESSAGE(state, message) {
    // eslint-disable-next-line no-undef
    state.message = _.cloneDeep(message);
  },

  SET_MESSAGE_ID(state, messageId) {
    state.message_id = messageId;
  },

  SET_PARAMS(state, params) {
    state.params = params;
  },

  REMOVE_MESSAGE_FROM_LIST_MESSAGE(state, index) {
    state.messages = state.messages.filter(item => item.id !== index);
  },

  SET_ACTION_OBJECTS(state, actionObjects) {
    state.action_objects = actionObjects;
  }

};
export const getters = {
};

export const actions = {
  setMessageDistributions(context, message) {
    context.commit('SET_MESSAGE', message);
    context.dispatch('preview/setMessages', message.broadcast_messages, { root: true });
  },

  async getBroadcast(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let messageData = null;
    try {
      messageData = await Message.getBroadcast(query);
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGE', messageData);
  },

  async createBroadcast(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let broadcastId = null;
    try {
      const response = await Message.createBroadcast(query);
      context.dispatch('system/setLoading', false, { root: true });

      if (response && response.id) {
        broadcastId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return broadcastId;
  },

  async updateBroadcast(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let broadcastId = null;
    try {
      const response = await Message.updateBroadcast(query);
      context.dispatch('system/setLoading', false, { root: true });

      if (response && response.id) {
        broadcastId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return broadcastId;
  },

  async fetchListMessageDelivers(context, query = {}) {
    context.dispatch('system/setLoading', true, { root: true });
    let messagesData = null;
    let total = 0;
    let perPage = 0;

    try {
      const response = await Message.getListMessageDelivers(query);

      if (response && response.data) {
        messagesData = response.data;
      }

      if (response && response.meta) {
        total = response.meta.total;
        perPage = response.meta.per_page;
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGES_DATA', { messages: messagesData, total, perPage });
  },

  setParams(context, params) {
    if (!params.page) {
      params.page = 1;
    }
    context.commit('SET_PARAMS', Object.assign({}, context.state.params, params));
  },

  async deleteMessageDelivers(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Message.deleteMessageDelivers(query);
      if (response && response.message === 'success') {
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
        context.commit('REMOVE_MESSAGE_FROM_LIST_MESSAGE', query.id);
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
  },

  async copyMessageDelivers(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Message.copyMessageDelivers(query);
      if (response && response.id) {
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
        context.dispatch('fetchListMessageDelivers');
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  }

};
