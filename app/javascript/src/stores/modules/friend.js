import FriendAPI from '../api/friend_api';

export const state = {
  friend: null,
  friends: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: 'active',
    line_name_or_display_name_cont: null,
    tags_id_in: null,
    created_at_gteq: null,
    created_at_lteq: null,
    visible_eq: true,
    locked_eq: false
  },
  clearQueryParams: false
};

export const mutations = {
  setFriend(state, friend) {
    state.friend = friend;
  },

  setFriends(state, friends) {
    state.friends = friends;
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
  },

  resetQueryParams(state) {
    state.queryParams = {
      page: 1,
      status_eq: 'active',
      line_name_or_display_name_cont: null,
      tags_id_in: null,
      created_at_gteq: null,
      created_at_lteq: null,
      visible_eq: true,
      locked_eq: false
    };
  },

  resetFriends(state) {
    state.friends = [];
  },

  setClearQueryParams(state, clearQueryParams) {
    state.clearQueryParams = clearQueryParams;
  }
};

export const getters = {
  getQueryParams(state) {
    return state.queryParams;
  }
};

export const actions = {
  async getFriends(context) {
    const params = {
      page: state.queryParams.page,
      q: _.omit(state.queryParams, 'page')
    };
    try {
      const response = await FriendAPI.list(params);
      context.commit('setFriends', response.data);
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
  },

  async getReminders(context, id) {
    try {
      return await FriendAPI.getReminders(id);
    } catch (error) {
      return null;
    }
  },

  async setReminder(context, payload) {
    try {
      return await FriendAPI.setReminder(payload);
    } catch (error) {
      return null;
    }
  }
};