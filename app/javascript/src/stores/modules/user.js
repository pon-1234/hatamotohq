import UserApi from '../api/user_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  validateUnique(_, data) {
    return UserApi.getValidate(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  updateUser(_, query) {
    return UserApi.updateUser(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};