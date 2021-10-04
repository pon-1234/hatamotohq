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
