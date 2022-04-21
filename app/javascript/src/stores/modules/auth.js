import AuthApi from '../api/auth_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  getAccount(_) {
    return AuthApi.getLineSetting().done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  editAccount(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    return AuthApi.editAccount(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      context.dispatch('system/setLoading', false, { root: true });
    });
  }

};
