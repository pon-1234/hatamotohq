import FriendAPI from '../api/friend_api';

export const state = {
  friend: null
};

export const mutations = {
  setFriend(state, friend) {
    state.friend = friend;
  }
};

export const getters = {};

export const actions = {
  getList(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendAPI.getList(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  editTag(_, query) {
    return FriendAPI.editTag(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  editLineInfo(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendAPI.editLineInfo(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  },

  fetchFriends(_, query = {}) {
    _.dispatch('system/setLoading', true, { root: true });

    return FriendAPI.fetchFriends(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
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

  updateStatusFromBot(_, query) {
    _.dispatch('system/setLoading', true, { root: true });
    return FriendAPI.updateStatusFromBot(query).done((res) => {
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
    return FriendAPI.getFiles(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(function() {
      _.dispatch('system/setLoading', false, { root: true });
    });
  }
};
