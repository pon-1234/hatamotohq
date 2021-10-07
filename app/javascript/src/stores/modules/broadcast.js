import BroadcastAPI from '../api/broadcast_api';

export const state = {
  broadcasts: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: '',
    name_or_company_name_or_email_cont: null
  }
};

export const mutations = {
  setBroadcasts(state, broadcasts) {
    state.broadcasts = broadcasts;
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  },

  setQueryParams(state, params) {
    Object.assign(state.queryParams, params);
  },

  setQueryParam(state, param) {
    Object.assign(state.queryParams, param);
  }
};

export const getters = {
  getQueryParams(state) {
    return state.queryParams;
  }
};

export const actions = {
  setPreviewContent(context, broadcast) {
    context.dispatch('preview/setMessages', broadcast.messages, { root: true });
  },

  async getBroadcast(context, id) {
    return await BroadcastAPI.get(id);
  },

  async getBroadcasts(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await BroadcastAPI.list(params);
      context.commit('setBroadcasts', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async createBroadcast(context, query) {
    let broadcastId = null;
    try {
      const response = await BroadcastAPI.create(query);
      if (response && response.id) {
        broadcastId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return broadcastId;
  },

  async updateBroadcast(context, query) {
    let broadcastId = null;
    try {
      const response = await BroadcastAPI.update(query);
      if (response && response.id) {
        broadcastId = response.id;
      }
    } catch (error) {
      console.log(error);
    }
    return broadcastId;
  },

  async copyBroadcast(context, id) {
    try {
      return await BroadcastAPI.copy(id);
    } catch (error) {
      return null;
    }
  },

  async deleteBroadcast(context, id) {
    try {
      return await BroadcastAPI.delete(id);
    } catch (error) {
      return null;
    }
  }
};