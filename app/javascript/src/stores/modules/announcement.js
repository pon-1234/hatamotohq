import AnnouncementApi from '../api/announcement_api';

export const state = {};

export const mutations = {};

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
  searchAnnouncement(_, query) {
    return AnnouncementApi.search(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  }
};