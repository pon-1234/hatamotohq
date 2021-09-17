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

  createRichmenu(_, data) {
    _.dispatch('system/setLoading', true, { root: true });
    return RichMenuAPI.createRichmenu(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  editRichmenu(_, data) {
    _.dispatch('system/setLoading', true, { root: true });

    return RichMenuAPI.editRichmenu(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getDetail(_, rickMenuId) {
    return RichMenuAPI.getDetail(rickMenuId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  destroyRichmenu(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return RichMenuAPI.destroyRichmenu(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  }

};
