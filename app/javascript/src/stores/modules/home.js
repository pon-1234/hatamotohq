import HomeApi from '../api/home_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  latestMessages(_, query) {
    return HomeApi.latestMessages(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  notices(_, query) {
    return HomeApi.notices(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};
