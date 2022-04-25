
import FolderAPI from '../api/folder_api';
import SiteAPI from '../api/site_api';

export const state = {
  folders: [],
  siteDetail: {}
};

export const mutations = {
  pushFolder(state, folder) {
    folder.templates = [];
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  setSiteDetail(state, siteDetail) {
    state.siteDetail = siteDetail;
  },

  updateFolder(state, newItem) {
    const item = state.folders.find(item => item.id === newItem.id);
    if (item) {
      item.name = newItem.name;
    }
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  }
};

export const getters = {
};

export const actions = {
  async getFolders(context, query) {
    try {
      const folders = await FolderAPI.list({ type: 'site' });
      context.commit('setFolders', folders);
      return folders;
    } catch (error) {
      return null;
    }
  },

  async getSites(context, query) {
    try {
      const folders = await SiteAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      console.log(error);
    }
  },

  async getSiteDetail(context, query) {
    try {
      const result = await SiteAPI.detail(query);
      context.commit('setSiteDetail', result);
    } catch (error) {
      console.log(error);
    }
  },

  async updateSite(context, payload) {
    try {
      const response = await SiteAPI.update(payload);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteSite(context, id) {
    try {
      return await SiteAPI.delete(id);
    } catch (error) {
      return null;
    }
  },

  async createFolder(context, payload) {
    try {
      const folder = await FolderAPI.create(payload);
      context.commit('pushFolder', folder);
      return folder;
    } catch (error) {
      return null;
    }
  },

  async updateFolder(context, payload) {
    try {
      const response = await FolderAPI.update(payload);
      context.commit('updateFolder', response);
      return response;
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
  }
};
