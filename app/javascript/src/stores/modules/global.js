import Global from '../api/global_api';
import RichMenuAPI from '../api/richmenu_api';
import MediaAPI from '../api/media_api';
import FolderAPI from '../api/folder_api';

export const state = {
  stickers: [],
  stickersHistories: [],
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

  setStickerLogs(state, stickers) {
    state.stickersHistories = state.stickersHistories.concat(stickers);
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

  async sendMedia(context, query) {
    context.dispatch('system/setLoading', true, { root: true });

    const response = await Global.sendMedia({ file: query.file, duration: query.duration });

    context.dispatch('system/setLoading', false, { root: true });

    if (response && !response.id) {
      window.toastr.error('Could not upload media');
    }
    const mediaUrl = response.url;
    const mediaPreviewUrl = response.preview_url;
    context.commit('setMediaUrl', mediaUrl);
    context.commit('setMediaPreviewUrl', mediaPreviewUrl);
    return response;
  },

  async getStickers(context, query) {
    let stickersData = [];
    if (query.packageId && context.state.stickersHistories.find(item => parseInt(item.package_id) === query.packageId)) {
      stickersData = context.state.stickersHistories.filter(item => parseInt(item.package_id) === query.packageId);
    } else if (query.packageId) {
      try {
        if (context.state.stickers && context.state.stickers.length > 0) {
          // Load from cache
          stickersData = context.state.stickers;
        } else {
          // Call api to load stickers
          stickersData = await Global.getStickers(query);
          context.commit('setStickers', stickersData);
        }
      } catch (error) {
        console.log(error);
      }
      // TODO fixme
      context.commit('setStickerLogs', stickersData);
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

  async uploadImageForRichMenu(context, query) {
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

  async uploadImageMap(context, payload) {
    try {
      const response = await MediaAPI.uploadImageMap(payload.file);
      if (response && response.id) {
        return response;
      }
    } catch (error) {
      console.log(error);
      return Promise.reject(error);
    }
  }
};
