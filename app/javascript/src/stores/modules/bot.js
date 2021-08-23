import BotApi from '../api/bot_api';

export const state = {
  tags: [],
  messages: [],
  total: 1,
  perPage: 1,
  message: null
};

export const mutations = {
  SET_MESSAGES_DATA(state, { messages, total, perPage }) {
    state.messages = messages;
    state.total = total;
    state.perPage = perPage;
  },

  SET_MESSAGE(state, message) {
    message.keywords = message.keyword && message.keyword.length > 0 ? message.keyword.split(',') : [];
    state.message = message;
  },

  SET_MESSAGES_DELETE(state, params) {
    state.messages.find(item => item.id === params.folder_id).auto_messages = state.messages.find(item => item.id === params.folder_id).auto_messages.filter(item => item.id !== params.id);
  },

  ADD_NEW_MESSAGE(state, params) {
    params.auto_messages = [];
    state.messages.push(params);
  },

  EDIT_MESSAGE(state, params) {
    const item = state.messages.find(item => item.id === params.id);
    if (item) {
      item.name = params.name;
    }
  },

  DELETE_MESSAGE(state, index) {
    state.messages = state.messages.filter(item => item.id !== index);
  }
};

export const getters = {};

export const actions = {

  updateContentMessageDistributions(context, message) {
    context.dispatch('preview/setMessages', message.auto_broadcast_messages, { root: true });
  },

  async getList(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let messages = null;
    const total = 1;
    const perPage = 1;
    try {
      const res = await BotApi.getList(query);
      messages = res;
    } catch (error) {

    }
    context.commit('SET_MESSAGES_DATA', { messages: messages, total, perPage });
    context.dispatch('system/setLoading', false, { root: true });
  },

  async botDetail(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const res = await BotApi.getDetail(query);
      context.commit('SET_MESSAGE', res);
    } catch (error) {

    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async botAdd(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      await BotApi.botAdd(query);
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
    } catch (e) {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async botWithKeyword(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const res = await BotApi.botWithKeyword(query);
      context.dispatch('system/setLoading', false, { root: true });
      return res;
    } catch (e) {
    }
    context.dispatch('system/setLoading', false, { root: true });
    return null;
  },

  async botEdit(context, query) {
    if (query.isLoad === true) context.dispatch('system/setLoading', true, { root: true });
    try {
      await BotApi.botEdit(query.message);
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
    } catch (e) {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    if (query.isLoad === true) context.dispatch('system/setLoading', false, { root: true });
  },

  async botDelete(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      await BotApi.botDelete(query);
      context.commit('SET_MESSAGES_DELETE', query);
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
    } catch (error) {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  createFolder(context, payload) {
    context.commit('ADD_NEW_MESSAGE', payload);
  },

  editFolder(context, payload) {
    context.commit('EDIT_MESSAGE', payload);
  },

  deleteFolder(context, payload) {
    context.commit('DELETE_MESSAGE', payload);
  }
};
