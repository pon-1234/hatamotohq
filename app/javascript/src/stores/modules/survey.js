import SurveyAPI from '../api/survey_api';

export const state = {
  folders: []
};

export const mutations = {
  pushFolder(state, folder) {
    folder.surveys = [];
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  updateFolder(state, folder) {
    folder.surveys = [];
    folder.surveys_count = 0;
    const index = state.folders.findIndex(_ => _.id === folder.id);
    state.folders.splice(index, 1, folder);
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  }
};

export const getters = {};

export const actions = {
  createNew(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyAPI.createNew(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  update(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyAPI.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  list(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return SurveyAPI.list(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  /**
   * Survey is belong to a folder, get all folders of current account
   * @param {*} context store context
   * @param {*} query query params
   * @returns surveys in folders
   */
  async getSurveys(context, query) {
    try {
      const folders = await SurveyAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      return null;
    }
  },

  /**
   * Create a new survey
   * @param {Context} context store context
   * @param {Object} payload payload
   * @returns survey or null
   */
  async createSurvey(context, payload) {
    try {
      return await SurveyAPI.create(payload);
    } catch (error) {
      return null;
    }
  },

  updateStatus(_, data) {
    return SurveyAPI.updateStatus(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  getCustomers(_, query) {
    return SurveyAPI.getCustomers(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  answersOfCustomer(_, query) {
    return SurveyAPI.answersOfCustomer(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  copy(_, query) {
    return SurveyAPI.copy(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  destroy(_, query) {
    return SurveyAPI.delete(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  addSurveyProfile(_, data) {
    _.dispatch('system/setLoading', true, { root: true });

    return SurveyAPI.addSurveyProfile(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getSurveyProfiles(_, query = {}) {
    return SurveyAPI.getSurveyProfiles(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateSurveyProfile(_, data) {
    return SurveyAPI.updateSurveyProfile(data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  friendAnswers(_, query) {
    return SurveyAPI.friendAnswers(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};
