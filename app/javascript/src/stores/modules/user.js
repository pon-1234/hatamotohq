import UserApi from '../api/user_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  createUser(_, query) {
    return UserApi.create(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  updateUser(_, query) {
    return UserApi.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};