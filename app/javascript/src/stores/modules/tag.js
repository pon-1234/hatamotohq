import Tag from '../api/tag_api';
import FolderAPI from '../api/folder_api';

export const state = {
  folders: [],
  tagsAssigned: [],
  friendsTag: []
};

// TODO need refactor
export const mutations = {
  editFolder(state, folder) {
    const old = state.folders.find(_ => _.id === folder.id);
    old.tags_count = folder.tags_count;
    old.tags = folder.tags;
  },

  EDIT_TAG(state, tag) {
    state.tags.forEach(element => {
      if (element.id === tag.folder_id) {
        element.tags.forEach((el, index) => {
          if (el.id === tag.id) {
            el.name = tag.name;
          }
        });
      }
    });
  },

  DELETE_FOLDER(state, id) {
    state.tags.forEach((element, index) => {
      if (element.id === id) {
        state.tags.splice(index, 1);
      }
    });
  },

  DELETE_TAG(state, { id, folderId }) {
    state.tags.forEach((element, index) => {
      if (element.id === folderId) {
        element.tags_count -= 1;
        element.tags.forEach((el, index) => {
          if (el.id === id) {
            element.tags.splice(index, 1);
          }
        });
      }
    });
  },

  SET_FRIENDS_TAG(state, friendsTag) {
    state.friendsTag = friendsTag;
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

  pushTag(state, tag) {
    const folder = state.folders.find(_ => _.id === tag.folder_id);
    folder.tags.push(tag);
  }
};

export const getters = {
};

export const actions = {
  async getTags(context) {
    try {
      const folders = await Tag.getTags();
      context.commit('setFolders', folders);
      return folders;
    } catch (error) {
      console.log(error);
    }
  },

  async getFriendsByTag(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let data = null;
    try {
      data = await Tag.getFriendsByTag(query);
      context.commit('SET_FRIENDS_TAG', data);
    } catch (error) {
      console.log(error);
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async editTag(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Tag.editTag(query);
      if (response.type === 'folder') {
        context.commit('editFolder', response);
        context.dispatch('system/setSuccess', { status: true, message: 'フォルダの変更は完成しました' }, { root: true });
      } else {
        context.commit('EDIT_TAG', response);
        context.dispatch('system/setSuccess', { status: true, message: 'タグの変更は完成しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async deleteTag(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Tag.deleteTag(query);
      console.log(response);
      if (query.type === 'folder') {
        context.commit('DELETE_FOLDER', query.id);
      } else {
        context.commit('DELETE_TAG', { id: query.id, folderId: query.folder_id });
      }
    } catch (error) {
      console.log(error);
    }
    context.dispatch('system/setLoading', false, { root: true });
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

  async createTag(context, payload) {
    try {
      const response = await Tag.createTag(payload);
      context.commit('pushTag', response);
    } catch (error) {
      return null;
    }
  },

  async updateTag(context, payload) {
    try {
      const response = await Tag.updateTag(payload);
      context.commit('updateTag', response);
    } catch (error) {
      return null;
    }
  }
};
