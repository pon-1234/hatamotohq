import AutoResponseAPI from '../api/auto_response_api';
import FolderAPI from '../api/folder_api';

export const state = {
  tags: [],
  folders: [],
  total: 1,
  perPage: 1,
  message: null
};

export const mutations = {
  CREATE_FOLDER(state, folder) {
    folder.auto_responses = [];
    state.folders.push(folder);
  },

  SET_FOLDERS(state, { folders, total, perPage }) {
    state.folders = folders;
    state.total = total;
    state.perPage = perPage;
  },

  SET_MESSAGE(state, message) {
    message.keywords = message.keyword && message.keyword.length > 0 ? message.keyword.split(',') : [];
    state.message = message;
  },

  SET_MESSAGES_DELETE(state, params) {
    state.folders.find(item => item.id === params.folder_id).auto_messages = state.folders.find(item => item.id === params.folder_id).auto_messages.filter(item => item.id !== params.id);
  },

  ADD_NEW_MESSAGE(state, params) {
    params.auto_messages = [];
    state.folders.push(params);
  },

  EDIT_MESSAGE(state, params) {
    const item = state.folders.find(item => item.id === params.id);
    if (item) {
      item.name = params.name;
    }
  },

  DELETE_MESSAGE(state, index) {
    state.folders = state.folders.filter(item => item.id !== index);
  }
};

export const getters = {};

export const actions = {

  updateContentMessageDistributions(context, message) {
    context.dispatch('preview/setMessages', message.auto_broadcast_messages, { root: true });
  },

  async getAutoResponses(context, query) {
    let autoResponses = null;
    const total = 1;
    const perPage = 1;
    try {
      const res = await AutoResponseAPI.getAutoResponses(query);
      autoResponses = res;
    } catch (error) {
      console.log(error);
    }
    context.commit('SET_FOLDERS', { folders: autoResponses, total, perPage });
  },

  async botDetail(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const res = await AutoResponseAPI.getDetail(query);
      context.commit('SET_MESSAGE', res);
    } catch (error) {

    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async createAutoResponse(context, query) {
    const res = await AutoResponseAPI.createAutoResponse(query);
  },

  async updateAutoResponse(context, auto_response) {
    await AutoResponseAPI.updateAutoResponse(auto_response);
  },

  async botDelete(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      await AutoResponseAPI.botDelete(query);
      context.commit('SET_MESSAGES_DELETE', query);
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
    } catch (error) {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async createFolder(context, payload) {
    try {
      const res = await FolderAPI.createFolder(payload);
      context.commit('CREATE_FOLDER', res);
      return res;
    } catch (error) {
      return null;
    }
  },

  editFolder(context, payload) {
    context.commit('EDIT_MESSAGE', payload);
  },

  deleteFolder(context, payload) {
    context.commit('DELETE_MESSAGE', payload);
  }
};
