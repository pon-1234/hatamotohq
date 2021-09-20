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

  async uploadMedia(_, payload) {
    try {
      return await MediaApi.uploadMedia({ file: payload.file, duration: payload.duration });
    } catch (error) {
      return null;
    }
  },

  async uploadRichMenu(_, file) {
    try {
      return await MediaApi.uploadRichMenu(file);
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async uploadImageMap(_, query) {
    try {
      return await MediaApi.uploadImageMap({ file: query.file });
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
