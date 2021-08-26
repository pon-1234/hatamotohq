import ScenarioApi from '../api/scenario_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  updateContentMessageDistributions(context, message) {
    context.dispatch('preview/setMessages', message, { root: true });
  },
  getList(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.getList(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  async createScenario(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let scenarioId = null;
    try {
      const response = await ScenarioApi.createScenario(query);
      context.dispatch('system/setLoading', false, { root: true });

      if (response && response.id) {
        scenarioId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return scenarioId;
  },
  scenarioEdit(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.scenarioEdit(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  scenarioDelete(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.scenarioDelete(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  scenarioCopy(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.scenarioCopy(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  scenarioDetail(_, query) {
    return ScenarioApi.scenarioDetail(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
    });
  },
  getTalks(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.getTalks(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  getTalk(_, query) {
    return ScenarioApi.getTalk(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  talkAddFromTemplate(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.talkAddFromTemplate(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  talkAdd(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.talkAdd(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  talkDelete(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.talkDelete(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  talkEdit(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.talkEdit(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },
  talksEdit(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.talksEdit(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getListScenarioTemplate(_, query) {
    query.type = 'template';
    return ScenarioApi.getList(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  copyMessageScenario(context, query) {
    context.dispatch('system/setLoading', true, { root: true });

    return ScenarioApi.copyMessageScenario(query).done((res) => {
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      context.dispatch('system/setLoading', false, { root: true });
    });
  }
};
