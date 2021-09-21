import Global from '../api/global_api';
import RichMenuAPI from '../api/richmenu_api';
import MediaAPI from '../api/media_api';

export const state = {
  stickers: [],
  logs: [],
  user: null,
  mediaUrl: null,
  mediaPreviewUrl: null,
  key: '',
  action_objects: null,
  action_objects_expired: null,
  badge: true
};

export const mutations = {
  setUser(state, user) {
    state.user = user;
  },

  setStickers(state, stickers) {
    state.stickers = stickers;
  },

  addLog(state, sticker) {
    const MAX_LOGS = 30;
    if (state.logs.length > MAX_LOGS) state.logs.splice(MAX_LOGS - 1, 1);
    const oldLogIndex = state.logs.findIndex(_ => _.line_emoji_id === sticker.line_emoji_id);
    state.logs.splice(oldLogIndex, 1);
    state.logs.unshift(sticker);
  },

  setMediaUrl(state, url) {
    state.mediaUrl = url;
  },

  setMediaPreviewUrl(state, url) {
    state.mediaPreviewUrl = url;
  },

  SET_KEY(state, key) {
    state.key = key;
  },

  setActionObjects(state, actionObjects) {
    state.action_objects = actionObjects;
  },

  setActionObjects_EXPIRED(state, actionObjects) {
    state.action_objects_expired = actionObjects;
  },

  setBadge(state, val) {
    state.badge = val;
  }
};

export const getters = {
  actionObjects: state => state.action_objects,
  badge: state => state.badge
};

export const actions = {
  async fetchUserData(context, query) {
    if (context.state.user) {
      return;
    }

    let userData = null;
    context.dispatch('system/setLoading', true, { root: true });

    try {
      userData = await Global.getUserDetails(query);
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('setUser', userData);
  },

  async sendMedia(_, query) {
    try {
      return await Global.sendMedia({ file: query.file, duration: query.duration });
    } catch (error) {
      return null;
    }
  },

  async getStickers(context, query) {
    let stickersData = [];
    if (!query.packageId) context.commit('setStickers', context.state.logs);
    if (query.packageId) {
      try {
        stickersData = await Global.getStickers(query);
        context.commit('setStickers', stickersData);
      } catch (error) {
        console.log(error);
      }
    }
  },

  async getActionObjectConfigs(context, query = {}) {
    // Loaded from cache, no need to load new one
    if (context.state.action_objects && context.state.action_objects.length > 0) {
      return;
    }
    let data = null;
    try {
      data = await Global.getActionObjectConfigs(query);
    } catch (error) {
      console.log(error);
    }
    context.commit('setActionObjects', data);
  },

  getBadge(context) {
    Global.getBadge().then((res) => {
      // save
      context.commit('setBadge', res.badge);
    }).catch(() => {
      context.commit('setBadge', false);
    });
  },

  async uploadRichMenu(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let keyData = '';
    try {
      const response = await RichMenuAPI.uploadImage({ file: query.file });
      context.dispatch('system/setLoading', false, { root: true });

      if (response && response.id) {
        keyData = response.id;
        context.commit('SET_KEY', keyData);
        return Promise.resolve(keyData);
      }
    } catch (error) {
      context.dispatch('system/setLoading', false, { root: true });
      console.log(error);
      return Promise.reject(error);
    }
  },

  async uploadImageMap(_, payload) {
    try {
      return await MediaAPI.uploadImageMap(payload.file);
    } catch (error) {
      console.log(error);
      return Promise.reject(error);
    }
  },

  async uploadRichMenu(_, payload) {
    try {
      return await MediaAPI.uploadRichMenu(payload.file);
    } catch (error) {
      console.log(error);
      return Promise.reject(error);
    }
  }
};