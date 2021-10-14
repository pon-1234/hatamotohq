import ScenarioMessageApi from '../api/scenariomessage_api';

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
      const response = await ScenarioMessageApi.listMessages(params);
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
      return await ScenarioMessageApi.deleteMessage(query);
    } catch (error) {
      return null;
    }
  }
};