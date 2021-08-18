import RichMenuApi from '../api/richmenu_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  getList(_, query) {
    return RichMenuApi.getList(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  createRichmenu(_, data) {
    _.dispatch('system/setLoading', true, { root: true });
    return RichMenuApi.createRichmenu(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  editRichmenu(_, data) {
    _.dispatch('system/setLoading', true, { root: true });

    return RichMenuApi.editRichmenu(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getDetail(_, rickMenuId) {
    return RichMenuApi.getDetail(rickMenuId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  destroyRichmenu(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return RichMenuApi.destroyRichmenu(query).done((res) => {
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
