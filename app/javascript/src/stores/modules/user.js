import UserApi from '../api/user_api';

export const state = {
  users: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: null,
    status_eq: '',
    name_or_company_name_or_email_cont: null
  }
};

export const mutations = {
  setUsers(state, users) {
    state.users = users;
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
    Object.assign(state.queryParams, { param });
  }
};

export const getters = {
  getQueryParams(state) {
    return state.queryParams;
  }
};

export const actions = {
  createUser(_, query) {
    return UserApi.create(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateUser(_, query) {
    return UserApi.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  async getUsers(context) {
    try {
      const response = await UserApi.list(state.queryParams);
      context.commit('setUsers', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async deleteUser(context, id) {
    try {
      return await UserApi.delete(id);
    } catch (error) {
      return null;
    }
  }
};