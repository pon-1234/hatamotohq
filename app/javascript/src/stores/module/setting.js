import SettingApi from '../api/setting_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  getSettingBasic(_) {
    return SettingApi.getSettingBasic().done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  putEditSettingBasic(_, query) {
    return SettingApi.putEditSettingBasic(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};
