import MediaApi from '../api/media_api';

export const state = {
  medias: [],
  totalRows: 0,
  perPage: 0,
  curPage: 1,
  filterTypes: ['image', 'video', 'audio', 'richmenu']
};

export const mutations = {
  setMedias(state, medias) {
    state.medias = medias;
  },

  setCurPage(state, curPage) {
    state.curPage = curPage;
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  },

  setFilter(state, types) {
    state.filterTypes = types;
  },

  resetFilter(state) {
    state.filterTypes = ['image', 'video', 'audio', 'richmenu'];
  }
};

export const getters = {};

export const actions = {
  async getMedias(context) {
    const params = {
      page: context.state.curPage,
      q: {
        type_in: context.state.filterTypes
      }
    };
    try {
      const response = await MediaApi.list(params);
      context.commit('setMedias', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async uploadMedia(_, payload) {
    try {
      return await MediaApi.uploadMedia({ file: payload.file, duration: payload.duration });
    } catch (error) {
      return null;
    }
  },

  async uploadRichMenu(_, file) {
    try {
      return await MediaApi.uploadRichMenu(file);
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async uploadImageMap(_, file) {
    try {
      return await MediaApi.uploadImageMap(file);
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async deleteMedias(_, ids) {
    try {
      return await MediaApi.bulkDelete(ids);
    } catch (error) {
      console.log(error);
      return null;
    }
  }
};