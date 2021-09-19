import MediaApi from '../api/media_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  async getMedias(_, query) {
    try {
      return await MediaApi.list(query);
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  mediasDelete(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return MediaApi.mediasDelete(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  download(_, query) {
    return MediaApi.download(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {});
  }
};
