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

  updateFolder(state, params) {
    const item = state.folders.find(item => item.id === params.id);
    if (item) {
      item.name = params.name;
    }
  },

  deleteFolder(state, id) {
    state.folders = state.folders.filter(item => item.id !== id);
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
    try {
      return await AutoResponseAPI.update(autoResponse);
    } catch (error) {
      return null;
    }
  },

  async copyAutoResponse(context, id) {
    try {
      return await AutoResponseAPI.copy(id);
    } catch (error) {
      return null;
    }
  },

  async deleteAutoResponse(context, id) {
    try {
      return await AutoResponseAPI.delete(id);
    } catch (error) {
      return null;
    }
  },

  async createFolder(context, payload) {
    try {
      const res = await FolderAPI.create(payload);
      context.commit('pushFolder', res);
      return res;
    } catch (error) {
      return null;
    }
  },

  updateFolder(context, payload) {
    context.commit('updateFolder', payload);
  },

  async deleteFolder(context, id) {
    try {
      const response = await FolderAPI.deleteFolder(id);
      context.commit('deleteFolder', id);
      return response;
    } catch (error) {
      return null;
    }
  }
};
