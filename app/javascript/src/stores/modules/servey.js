import SurveyApi from '../api/survey_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  createNew(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyApi.createNew(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  update(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyApi.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  list(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyApi.list(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  getFolders(ctx) {
    return SurveyApi.folders({ type: 'survey' }).done((res) => {
      return Promise.resolve(res);
    }).fail((_) => {
      return Promise.resolve([]);
    });
  },

  updateStatus(_, data) {
    return SurveyApi.updateStatus(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  getCustomers(_, query) {
    return SurveyApi.getCustomers(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  answersOfCustomer(_, query) {
    return SurveyApi.answersOfCustomer(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  copy(_, query) {
    return SurveyApi.copy(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  destroy(_, query) {
    return SurveyApi.delete(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  addSurveyProfile(_, data) {
    _.dispatch('system/setLoading', true, { root: true });

    return SurveyApi.addSurveyProfile(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getSurveyProfiles(_, query = {}) {
    return SurveyApi.getSurveyProfiles(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateSurveyProfile(_, data) {
    return SurveyApi.updateSurveyProfile(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  friendAnswers(_, query) {
    return SurveyApi.friendAnswers(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};
