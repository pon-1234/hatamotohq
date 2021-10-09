
import ReminderAPI from '../api/reminder_api';
import FolderAPI from '../api/folder_api';
import EpisodeAPI from '../api/episode_api';

export const state = {
  folders: []
};

export const mutations = {
  pushFolder(state, folder) {
    folder.reminders = [];
    state.folders.push(folder);
  },

  setFolders(state, folders) {
    state.folders = folders;
  },

  updateFolder(state, folder) {
    folder.reminders = [];
    folder.reminders_count = 0;
    const index = state.folders.findIndex(_ => _.id === folder.id);
    state.folders.splice(index, 1, folder);
  },

  deleteFolder(state, id) {
    const index = state.folders.findIndex(_ => _.id === id);
    state.folders.splice(index, 1);
  },

  deleteReminder(state, id) {
    const folder = state.folders.find(folder => folder.reminders.some(_ => _.id === id));
    const index = folder.reminders.find(_ => _.id === id);
    folder.reminders.splice(index, 1);
  }
};

export const getters = {
};

export const actions = {
  setMessagePreview(context, template) {
    context.dispatch('preview/setMessages', template.messages, { root: true });
  },

  async getFolders(context, query) {
    try {
      const folders = await FolderAPI.list({ type: 'reminder' });
      context.commit('setFolders', folders);
      return folders;
    } catch (error) {
      return null;
    }
  },

  // Template is belong to a folder, get all folders of current account
  async getReminders(context, query) {
    try {
      const folders = await ReminderAPI.list(query);
      context.commit('setFolders', folders);
    } catch (error) {
      console.log(error);
    }
  },

  async getReminder(context, id) {
    try {
      return await ReminderAPI.get(id);
    } catch (error) {
      return null;
    }
  },

  async updateReminder(context, query) {
    try {
      const response = await ReminderAPI.update(query);
      return response;
    } catch (error) {
      return null;
    }
  },

  async createReminder(context, payload) {
    try {
      const response = await ReminderAPI.create(payload);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteReminder(context, id) {
    try {
      const response = await ReminderAPI.delete(id);
      context.commit('deleteReminder', id);
      return response;
    } catch (error) {
      return null;
    }
  },

  async copyReminder(context, id) {
    try {
      return await ReminderAPI.copy(id);
    } catch (error) {
      return null;
    }
  },

  async createFolder(context, payload) {
    try {
      const folder = await FolderAPI.create(payload);
      context.commit('pushFolder', folder);
      return folder;
    } catch (error) {
      return null;
    }
  },

  async updateFolder(context, payload) {
    try {
      const response = await FolderAPI.update(payload);
      context.commit('updateFolder', response);
      return response;
    } catch (error) {
      return null;
    }
  },

  async deleteFolder(context, id) {
    try {
      const response = await FolderAPI.delete(id);
      context.commit('deleteFolder', id);
      return response;
    } catch (error) {
      return null;
    }
  },

  async getEpisodes(context, reminderId) {
    try {
      return await EpisodeAPI.list(reminderId);
    } catch (error) {
      return null;
    }
  },

  async createEpisode(context, payload) {
    try {
      return await EpisodeAPI.create(payload);
    } catch (error) {
      return null;
    }
  }
};
