
import TemplateAPI from '../api/template_api';
import FolderAPI from '../api/folder_api';

export const state = {
  folders: []
};

export const mutations = {
  pushFolder(state, folder) {
    folder.templates = [];
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  updateFolder(state, folder) {
    // folder.templates = [];
    // folder.templates_count = 0;
    const index = state.folders.findIndex(_ => _.id === folder.id);
    state.folders.splice(index, 1, folder);
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  },

  deleteTemplate(state, id) {
    const folder = state.folders.find(folder => folder.templates.some(_ => _.id === id));
    const index = folder.templates.find(_ => _.id === id);
    folder.templates.splice(index, 1);
  }
};

export const getters = {
};

export const actions = {
  setMessagePreview(context, template) {
    context.dispatch('preview/setMessages', template.messages, { root: true });
  },

  // Template is belong to a folder, get all folders of current account
  async getTemplates(context, query) {
    try {
      const folders = await TemplateAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      console.log(error);
    }
  },

  async getTemplate(_, id) {
    try {
      return await TemplateAPI.get(id);
    } catch (error) {
      return null;
    }
  },

  async updateTemplate(context, query) {
    try {
      const response = await TemplateAPI.update(query);
      return response;
    } catch (error) {
      return null;
    }
  },

  async createTemplate(context, payload) {
    try {
      const response = await TemplateAPI.create(payload);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteTemplate(context, id) {
    try {
      const response = await TemplateAPI.delete(id);
      context.commit('deleteTemplate', id);
      return response;
    } catch (error) {
      return null;
    }
  },

  async copyTemplate(context, id) {
    try {
      return await TemplateAPI.copy(id);
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
