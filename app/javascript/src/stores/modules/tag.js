import Tag from '../api/tag_api';
import Folder from '../api/folder_api';

export const state = {
  tags: [],
  tagsAssigned: [],
  friendsTag: []
};

export const mutations = {
  EDIT_FOLDER(state, folder) {
    state.tags.forEach((element, index) => {
      if (element.id === folder.id) {
        folder.tags_count = element.tags_count;
        folder.tags = element.tags;
        state.tags.splice(index, 1, folder);
      }
    });
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

  SET_TAGS_ASSIGNED(state, tagsAssigned) {
    state.tagsAssigned = tagsAssigned;
  },

  SET_TAGS(state, value) {
    state.tags = value;
  },

  ADD_NEW_FOLDER(state, value) {
    if (value && !value.tags_count) {
      value.tags_count = 0;
    }
    state.tags.push(value);
  },

  ADD_NEW_TAG(state, value) {
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
  async getTags(context, query = {}) {
    context.dispatch('system/setLoading', true, { root: true });

    let data = null;
    try {
      if (query.low === undefined) {
        query.low = true;
      }
      data = await Tag.getTags(query);
      context.commit('SET_TAGS', data);
    } catch (error) {
      console.log(error);
    }
    context.dispatch('system/setLoading', false, { root: true });
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
      context.commit('SET_TAGS_ASSIGNED', data);
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
        context.commit('EDIT_FOLDER', response);
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
    context.commit('ADD_NEW_FOLDER', payload);
  },

  addNewTag(context, payload) {
    context.commit('ADD_NEW_TAG', payload);
  },

  async createTag(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      if (query.type === 'folder') {
        const formData = { name: query.name, type: 'tag' };
        const response = await Folder.createFolder(formData);
        response.tags_count = 0;
        response.tags = [];
        context.commit('ADD_NEW_FOLDER', response);
        context.dispatch('system/setSuccess', { status: true, message: 'フォルダを登録しました' }, { root: true });
      } else {
        const response = await Tag.createTag(query);
        context.commit('ADD_NEW_TAG', response);
        context.dispatch('system/setSuccess', { status: true, message: 'タグを登録しました' }, { root: true });
      }
    } catch (error) {
      if (error.responseText) {
        context.dispatch('system/setSuccess', { status: false, message: JSON.parse(error.responseText).name }, { root: true });
      }
    }
    context.dispatch('system/setLoading', false, { root: true });
  }

};
