import FriendApi from '../api/friend_api';

export const state = {
  friend: null
};

export const mutations = {
  SET_FRIEND(state, friend) {
    state.friend = friend;
  }
};

export const getters = {};

export const actions = {
  getList(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendApi.getList(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  editTag(_, query) {
    return FriendApi.editTag(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  editLineInfo(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendApi.editLineInfo(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  fetchFriends(_, query = {}) {
    _.dispatch('system/setLoading', true, { root: true });

    return FriendApi.fetchFriends(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  async getDetailFriend(context, query, showLoading = true) {
    if (showLoading) {
      context.dispatch('system/setLoading', true, { root: true });
    }

    let friendData = null;
    try {
      friendData = await FriendApi.getDetailFriend(query);
      context.dispatch('system/setLoading', false, { root: true });
      context.commit('SET_FRIEND', friendData);
      return friendData;
    } catch (error) {
      console.log(error);
      return error;
    }
  },

  updateStatusFromBot(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendApi.updateStatusFromBot(query).done((res) => {
      _.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      _.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  getFiles(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendApi.getFiles(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  }
};
