import FriendAPI from '../api/friend_api';

export const state = {
  friend: null,
  lineFriends: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: '',
    line_name_or_display_name_cont: null
  }
};

export const mutations = {
  setFriend(state, friend) {
    state.friend = friend;
  },

  setlineFriends(state, lineFriends) {
    state.lineFriends = lineFriends;
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
  async getlineFriends(context) {
    const params = {
      page: state.queryParams.page,
      q: _.omit(state.queryParams, 'page')
    };
    try {
      const response = await FriendAPI.list(params);
      context.commit('setlineFriends', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async getFriend(context, id) {
    let friend = null;
    try {
      friend = await FriendAPI.get(id);
      context.commit('setFriend', friend);
      return friend;
    } catch (error) {
      console.log(error);
      return error.responseJSON;
    }
  },

  async updateFriend(_, query) {
    try {
      return await FriendAPI.update(query);
    } catch (error) {
      return null;
    }
  },

  async toggleLocked(context, id) {
    try {
      return await FriendAPI.toggleLocked(id);
    } catch (error) {
      return null;
    }
  },

  async toggleVisible(context, id) {
    try {
      return await FriendAPI.toggleVisible(id);
    } catch (error) {
      return null;
    }
  }
};