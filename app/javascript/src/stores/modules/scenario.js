import ScenarioApi from '../api/scenario_api';

export const state = {
  scenarios: [],
  totalRows: 0,
  perPage: 0,
  curPage: 1,
  queryParams: {
    page: 1,
    status_eq: ''
  }
};

export const mutations = {
  setScenarios(state, scenarios) {
    state.scenarios = scenarios;
  },

  setCurPage(state, curPage) {
    state.curPage = curPage;
  },

  setQueryParams(state, params) {
    Object.assign(state.queryParams, params);
  },

  setQueryParam(state, param) {
    Object.assign(state.queryParams, param);
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  }
};

export const getters = {
  getQueryParams(state) {
    return state.queryParams;
  }
};

export const actions = {
  setPreviewContent(context, message) {
    context.dispatch('preview/setMessages', message, { root: true });
  },

  async getScenarios(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await ScenarioApi.list(params);
      context.commit('setScenarios', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async getManualScenarios(_) {
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

  async copyScenario(context, id) {
    try {
      return await ScenarioApi.copy(id);
    } catch (error) {
      return null;
    }
  },

  async deleteScenario(context, id) {
    try {
      return await ScenarioApi.delete(id);
    } catch (error) {
      return null;
    }
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

  async sendScenarioToTesters(_, payload) {
    try {
      return await ScenarioApi.sendScenarioToTesters(payload);
    } catch (error) {
      return null;
    }
  }
};
