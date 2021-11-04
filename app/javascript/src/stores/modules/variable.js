
import VariableAPI from '../api/variable_api';
import FolderAPI from '../api/folder_api';

export const state = {
  folders: []
};

export const mutations = {
  pushFolder(state, folder) {
    folder.variables = [];
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
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
  },

  deleteVariable(state, id) {
    const folder = state.folders.find(folder => folder.variables.some(_ => _.id === id));
    const index = folder.variables.find(_ => _.id === id);
    folder.variables.splice(index, 1);
  }
};

export const getters = {
};

export const actions = {
  async getFolders(context, query) {
    try {
      const folders = await VariableAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      console.log(error);
    }
  },

  async getVariable(_, id) {
    try {
      return await VariableAPI.get(id);
    } catch (error) {
      return null;
    }
  },

  async updateVariable(context, query) {
    try {
      const response = await VariableAPI.update(query);
      return response;
    } catch (error) {
      return null;
    }
  },

  async createVariable(context, payload) {
    try {
      const response = await VariableAPI.create(payload);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteVariable(context, id) {
    try {
      const response = await VariableAPI.delete(id);
      context.commit('deleteVariable', id);
      return response;
    } catch (error) {
      return null;
    }
  },

  async copyVariable(context, id) {
    try {
      return await VariableAPI.copy(id);
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
