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
  pushFolder(state, folder) {
    folder.auto_responses = [];
    state.folders.push(folder);
  },

  setFolders(state, { folders, total, perPage }) {
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

  setPreviewContent(context, autoResponse) {
    context.dispatch('preview/setMessages', autoResponse.messages, { root: true });
  },

  async getAutoResponses(context, query) {
    let autoResponses = null;
    const total = 1;
    const perPage = 1;
    try {
      const res = await AutoResponseAPI.list(query);
      autoResponses = res;
    } catch (error) {
      console.log(error);
    }
    context.commit('setFolders', { folders: autoResponses, total, perPage });
  },

  async getAutoResponse(context, id) {
    return await AutoResponseAPI.get(id);
  },

  async createAutoResponse(context, autoResponseData) {
    return await AutoResponseAPI.create(autoResponseData);
  },

  async updateAutoResponse(context, autoResponse) {
    await AutoResponseAPI.updateAutoResponse(autoResponse);
  },

  async deleteAutoResponse(context, query) {
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

  async pushFolder(context, payload) {
    try {
      const res = await FolderAPI.pushFolder(payload);
      context.commit('pushFolder', res);
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
