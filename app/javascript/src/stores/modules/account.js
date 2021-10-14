import AccountApi from '../api/account_api';

export const state = {
  accounts: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: '',
    name_or_email_cont: null
  }
};

export const mutations = {
  setAccounts(state, accounts) {
    state.accounts = accounts;
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
  createAccount(_, query) {
    return AccountApi.create(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateAccount(_, query) {
    return AccountApi.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  async getAccounts(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await AccountApi.list(params);
      context.commit('setAccounts', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async deleteAccount(context, id) {
    try {
      return await AccountApi.delete(id);
    } catch (error) {
      return null;
    }
  }
};