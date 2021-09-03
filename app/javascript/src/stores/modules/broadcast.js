
import BroadcastAPI from '../api/broadcast_api';

export const state = {
  broadcasts: [],
  total: 0,
  per_page: 0,
  params: {
    page: 1,
    status: 'all'
  },
  broadcast: null,
  broadcast_id: null,
  action_objects: []
};

export const mutations = {
  SET_BROADCASTS_DATA(state, { broadcasts, total, perPage }) {
    state.broadcasts = broadcasts;
    state.total = total;
    state.per_page = perPage;
  },

  SET_BROADCAST(state, broadcast) {
    // eslint-disable-next-line no-undef
    state.broadcast = _.cloneDeep(broadcast);
  },

  SET_BROADCAST_ID(state, broadcastId) {
    state.broadcast_id = broadcastId;
  },

  SET_PARAMS(state, params) {
    state.params = params;
  },

  REMOVE_BROADCAST_FROM_LIST_BROADCAST(state, index) {
    state.broadcasts = state.broadcasts.filter(item => item.id !== index);
  },

  SET_ACTION_OBJECTS(state, actionObjects) {
    state.action_objects = actionObjects;
  }

};
export const getters = {
};

export const actions = {
  setPreviewContent(context, broadcast) {
    context.commit('SET_BROADCAST', broadcast);
    context.dispatch('preview/setMessages', broadcast.broadcasts, { root: true });
  },

  async getBroadcast(context, id) {
    return await BroadcastAPI.get(id);
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

  setParams(context, params) {
    if (!params.page) {
      params.page = 1;
    }
    context.commit('SET_PARAMS', Object.assign({}, context.state.params, params));
  }
};
