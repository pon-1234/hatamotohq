
import FolderAPI from '../api/folder_api';

export const state = {
  folders: []
};

export const mutations = {
  setFolders(state, folders) {
    state.folders = folders;
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
  }
};
