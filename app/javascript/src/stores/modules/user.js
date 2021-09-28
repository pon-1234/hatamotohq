import UserApi from '../api/user_api';

export const state = {
  users: [],
  totalRows: 0,
  perPage: 0,
  curPage: 1
};

export const mutations = {
  setUsers(state, users) {
    state.users = users;
  },

  setCurPage(state, curPage) {
    state.curPage = curPage;
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  }
};

export const getters = {};

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
    const params = {
      page: context.state.curPage
    };
    try {
      const response = await UserApi.list(params);
      context.commit('setUsers', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async searchUsers(context, query) {
    try {
      const response = await UserApi.search(query);
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