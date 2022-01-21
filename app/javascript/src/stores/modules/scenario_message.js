import ScenarioMessageApi from '../api/scenario_message_api';
import ScenarioApi from '../api/scenario_api';

export const state = {
  totalRows: 0,
  perPage: 0,
  curPage: 1,
  messages: []
};

export const mutations = {
  setCurPage(state, curPage) {
    state.curPage = curPage;
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  },

  setMessages(state, messages) {
    state.messages = messages;
  }
};

export const getters = {};

export const actions = {
  async getMessages(context, query) {
    const params = {
      page: context.state.curPage,
      scenario_id: query
    };
    try {
      const response = await ScenarioMessageApi.list(params);
      context.commit('setMessages', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async deleteMessage(_, query) {
    try {
      return await ScenarioMessageApi.delete(query);
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
