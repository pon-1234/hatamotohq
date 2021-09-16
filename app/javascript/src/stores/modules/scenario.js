import ScenarioApi from '../api/scenario_api';

export const state = {};

export const mutations = {};

export const getters = {};

export const actions = {
  setPreviewContent(context, message) {
    context.dispatch('preview/setMessages', message, { root: true });
  },

  async getScenarios(_) {
    try {
      return await ScenarioApi.manual();
    } catch (error) {
      return null;
    }
  },

  async getScenario(_, id) {
    try {
      return await ScenarioApi.get(id);
    } catch (error) {
      return null;
    }
  },

  async createScenario(context, query) {
    try {
      return await ScenarioApi.create(query);
    } catch (error) {
      return null;
    }
  },

  async updateScenario(context, query) {
    try {
      return await ScenarioApi.update(query);
    } catch (error) {
      return null;
    }
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

  async createMessage(_, data) {
    try {
      return await ScenarioApi.createMessage(data);
    } catch (error) {
      return null;
    }
  },

  async updateMessage(_, payload) {
    try {
      return await ScenarioApi.updateMessage(payload);
    } catch (error) {
      return null;
    }
  },

  async getScenarioMessage(_, query) {
    try {
      return await ScenarioApi.getScenarioMessage(query);
    } catch (error) {
      return null;
    }
  },

  async createMessagesFromTemplate(_, payload) {
    try {
      return await ScenarioApi.createMessagesFromTemplate(payload);
    } catch (error) {
      return null;
    }
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
