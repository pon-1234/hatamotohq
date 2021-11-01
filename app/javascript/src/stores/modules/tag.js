import TagAPI from '../api/tag_api';
import FolderAPI from '../api/folder_api';

export const state = {
  folders: [],
  tagIds: []
};

// TODO need refactor
export const mutations = {
  editFolder(state, folder) {
    const old = state.folders.find(_ => _.id === folder.id);
    old.tags_count = folder.tags_count;
    old.tags = folder.tags;
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  pushFolder(state, folder) {
    folder.tags_count = 0;
    folder.tags = [];
    state.folders.push(folder);
  },

  updateFolder(state, folder) {
    folder.tags = [];
    folder.tags_count = 0;
    const index = state.folders.findIndex(_ => _.id === folder.id);
    state.folders.splice(index, 1, folder);
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  },

  pushTag(state, tag) {
    tag.friends_count = 0;
    const folder = state.folders.find(_ => _.id === tag.folder_id);
    folder.tags.push(tag);
  },

  updateTag(state, tag) {
    const folder = state.folders.find(_ => _.id === tag.folder_id);
    const oldIndex = folder.tags.findIndex(_ => _.id === tag.id);
    folder.tags.splice(oldIndex, 1, tag);
  },

  setTagIds(state, tagIds) {
    state.tagIds = [...tagIds];
  }
};

export const getters = {};

export const actions = {
  async getTags(context) {
    try {
      const folders = await TagAPI.getTags();
      context.commit('setFolders', folders);
      return folders;
    } catch (error) {
      console.log(error);
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
      const folder = await FolderAPI.update(payload);
      context.commit('updateFolder', folder);
      return folder;
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

  async createTag(context, payload) {
    try {
      const response = await TagAPI.create(payload);
      context.commit('pushTag', response);
      return response;
    } catch (error) {
      return null;
    }
  },

  async updateTag(context, payload) {
    try {
      const response = await TagAPI.update(payload);
      context.commit('updateTag', response);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteTag(context, id) {
    try {
      return await TagAPI.delete(id);
    } catch (error) {
      return null;
    }
  }
};