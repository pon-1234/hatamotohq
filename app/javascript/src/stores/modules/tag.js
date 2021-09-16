import Tag from '../api/tag_api';
import Folder from '../api/folder_api';

export const state = {
  folders: [],
  tagsAssigned: [],
  friendsTag: []
};

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

  pushFolder(state, value) {
    if (value && !value.tags_count) {
      value.tags_count = 0;
    }
    state.tags.push(value);
  },

  pushTag(state, value) {
    state.tags.forEach(element => {
      if (element.id === value.folder_id) {
        element.tags_count += 1;
        value.line_friend_count = 0;
        element.tags.splice(0, 0, value);
      }
    });
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

  async listTagAssigned(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let data = null;
    try {
      data = await Tag.getTags(query);
      context.commit('setTags_ASSIGNED', data);
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

  addNewFolder(context, payload) {
    context.commit('pushFolder', payload);
  },

  addNewTag(context, payload) {
    context.commit('pushTag', payload);
  },

  async createTag(context, query) {
    let response = null;
    try {
      if (query.type === 'folder') {
        const formData = { name: query.name, type: 'tag' };
        response = await Folder.createFolder(formData);
        response.tags = [];
        response.tags_count = 0;
        context.commit('pushFolder', response);
      } else {
        response = await Tag.createTag(query);
        context.commit('pushTag', response);
      }
      return response;
    } catch (error) {
      return error.responseJSON;
    }
  }

};
