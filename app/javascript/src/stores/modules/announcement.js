import AnnouncementApi from '../api/announcement_api';

export const state = {
  announcements: [],
  totalRows: 0,
  perPage: 0,
  curPage: 1
};

export const mutations = {
  setAnnouncements(state, announcements) {
    state.announcements = announcements;
  },

  setCurPage(state, curPage) {
    state.curPage = curPage;
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  }
};

export const getters = {};

export const actions = {
  createAnnouncement(_, query) {
    return AnnouncementApi.create(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateAnnouncement(_, query) {
    return AnnouncementApi.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  async getAnnouncements(context) {
    const params = {
      page: context.state.curPage
    };
    try {
      const response = await AnnouncementApi.list(params);
      context.commit('setAnnouncements', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async getPublishedAnnouncements(context) {
    const params = {
      page: context.state.curPage
    };
    try {
      const response = await AnnouncementApi.published(params);
      context.commit('setAnnouncements', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async deleteAnnouncement(context, id) {
    try {
      return await AnnouncementApi.delete(id);
    } catch (error) {
      return null;
    }
  }
};