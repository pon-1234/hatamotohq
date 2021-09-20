import RichMenuAPI from '../api/richmenu_api';
import FolderAPI from '../api/folder_api';

export const state = {
  folders: []
};

export const mutations = {
  pushFolder(state, folder) {
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  updateFolder(state, folder) {
    const index = state.folders.findIndex(_ => _.id === folder.id);
    state.folders.splice(index, 1, folder);
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  }
};

export const getters = {};

export const actions = {
  async getRichMenus(context, query) {
    try {
      const folders = await RichMenuAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      return null;
    }
  },

  async createFolder(context, payload) {
    try {
      const folder = await FolderAPI.create(payload);
      folder.rich_menus = [];
      context.commit('pushFolder', folder);
    } catch (error) {
      return null;
    }
  },

  async updateFolder(context, payload) {
    try {
      const folder = await FolderAPI.update(payload);
      folder.rich_menus = [];
      context.commit('updateFolder', folder);
    } catch (error) {
      return null;
    }
  },

  async deleteFolder(context, id) {
    try {
      const response = await FolderAPI.delete(id);
      context.commit('deleteFolder', id);
      return response;
    } catch (error) {
      return null;
    }
  },

  async getRichMenu(_, id) {
    try {
      return await RichMenuAPI.get(id);
    } catch (error) {
      return null;
    }
  },

  async createRichMenu(_, payload) {
    try {
      return await RichMenuAPI.create(payload);
    } catch (error) {
      return null;
    }
  },

  async updateRichMenu(_, payload) {
    try {
      return await RichMenuAPI.update(payload);
    } catch (error) {
      return null;
    }
  },

  async deleteRichMenu(context, id) {
    try {
      return await RichMenuAPI.delete(id);
    } catch (error) {
      return null;
    }
  }
};
