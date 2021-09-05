import ScenarioApi from '../api/scenario_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  setPreviewContent(context, message) {
    context.dispatch('preview/setMessages', message, { root: true });
  },
  async getScenarios(_) {
    return await ScenarioApi.listManual();
  },
  async createScenario(context, query) {
    let scenarioId = null;
    try {
      const response = await ScenarioApi.createScenario(query);
      if (response && response.id) {
        scenarioId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return scenarioId;
  },
  async updateScenario(context, query) {
    let scenarioId = null;
    try {
      const response = await ScenarioApi.scenarioEdit(query);
      if (response && response.id) {
        scenarioId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return scenarioId;
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
  async getScenario(_, id) {
    return await ScenarioApi.get(id);
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

  createScenarioMessageFromTemplate(_, body) {
    _.dispatch('system/setLoading', true, { root: true });
    return ScenarioApi.createScenarioMessageFromTemplate(body).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  async createScenarioMessage(_, data) {
    const response = await ScenarioApi.createScenarioMessage(data);
    console.log(response);
    return response.id;
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
