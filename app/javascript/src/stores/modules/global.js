import Global from '../api/global_api';
import RichMenuApi from '../api/richmenu_api';
import MediaApi from '../api/media_api';

export const state = {
  stickers: [],
  stickersHistories: [],
  user: null,
  media_url: null,
  media_preview_url: null,
  key: '',
  action_objects: null,
  action_objects_expired: null,
  badge: true
};

export const mutations = {
  SET_USER(state, user) {
    state.user = user;
  },

  SET_STICKERS(state, stickers) {
    state.stickers = stickers;
  },

  SET_STICKERS_HISTORIES(state, stickers) {
    state.stickersHistories = state.stickersHistories.concat(stickers);
  },

  SET_MEDIA_URL(state, url) {
    state.media_url = url;
  },

  SET_MEDIA_PREVIEW_URL(state, url) {
    state.media_preview_url = url;
  },

  SET_KEY(state, key) {
    state.key = key;
  },

  SET_ACTION_OBJECTS(state, actionObjects) {
    state.action_objects = actionObjects;
  },

  SET_ACTION_OBJECTS_EXPIRED(state, actionObjects) {
    state.action_objects_expired = actionObjects;
  },

  SET_BADGE(state, val) {
    state.badge = val;
  }
};

export const getters = {
  ACTION_OBJECTS: state => state.action_objects,
  BADGE: state => state.badge
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
    context.commit('SET_USER', userData);
  },

  async sendMedia(context, query) {
    context.dispatch('system/setLoading', true, { root: true });

    const response = await Global.sendMedia({ file: query.file, duration: query.duration });

    context.dispatch('system/setLoading', false, { root: true });

    if (response && !response.id) {
      window.toastr.error('Could not upload media');
    }
    const media_url = response.url;
    const media_preview_url = response.preview_url;
    context.commit('SET_MEDIA_URL', media_url);
    context.commit('SET_MEDIA_PREVIEW_URL', media_preview_url);
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
          context.commit('SET_STICKERS', stickersData);
        }
      } catch (error) {
        console.log(error);
      }
      // TODO fixme
      context.commit('SET_STICKERS_HISTORIES', stickersData);
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
    context.commit('SET_ACTION_OBJECTS', data);
  },

  getBadge(context) {
    Global.getBadge().then((res) => {
      // save
      context.commit('SET_BADGE', res.badge);
    }).catch(() => {
      context.commit('SET_BADGE', false);
    });
  },

  createFolder(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    return Global.createFolder(query).done((res) => {
      context.dispatch('system/setSuccess', { status: true, message: 'フォルダを登録しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      context.dispatch('system/setLoading', false, { root: true });
    });
  },

  editFolder(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    return Global.editFolder(query).done((res) => {
      context.dispatch('system/setSuccess', { status: true, message: 'フォルダの変更は完成しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      context.dispatch('system/setLoading', false, { root: true });
    });
  },

  deleteFolder(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    return Global.deleteFolder(query).done((res) => {
      context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      return Promise.resolve(res);
    }).fail((err) => {
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      return Promise.reject(err);
    }).always(function() {
      context.dispatch('system/setLoading', false, { root: true });
    });
  },

  async uploadImageForRichMenu(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let keyData = '';
    try {
      const response = await RichMenuApi.uploadImage({ file: query.file });
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

  async uploadImagemap(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let keyData = '';
    try {
      const response = await MediaApi.uploadImagemap({ file: query.file });

      if (response && response.id) {
        keyData = response.id;
        context.dispatch('system/setLoading', false, { root: true });
        context.commit('SET_KEY', keyData);
        return Promise.resolve(keyData);
      }
    } catch (error) {
      context.dispatch('system/setLoading', false, { root: true });
      console.log(error);
      return Promise.reject(error);
    }
  }
};
