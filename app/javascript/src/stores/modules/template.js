
import TemplateAPI from '../api/template_api';
import FolderAPI from '../api/folder_api';
import Global from '../api/global_api';

export const state = {
  folders: [],
  messages: [],
  total: 0,
  per_page: 0,
  params: {
    page: 1
  },
  message: null,
  message_id: null
};

export const mutations = {
  pushFolder(state, folder) {
    folder.templates = [];
    state.folders.push(folder);
  },

  setFolders(state, { folders, total, perPage }) {
    state.folders = folders;
    state.total = total;
    state.perPage = perPage;
  },

  SET_MESSAGES_DATA(state, { messages, total, perPage }) {
    state.messages = messages;
    state.total = total;
    state.per_page = perPage;
  },

  SET_MESSAGE(state, message) {
    // eslint-disable-next-line no-undef
    state.message = _.cloneDeep(message);
  },

  SET_MESSAGE_ID(state, messageId) {
    state.message_id = messageId;
  },

  SET_PARAMS(state, params) {
    state.params = params;
  },

  REMOVE_MESSAGE_FROM_LIST_MESSAGE(state, index) {
    state.messages = state.messages.filter(item => item.id !== index);
  },

  COPY_MESSAGE(state, params) {
    state.messages.find(item => item.id === params.message.folder_id).message_templates.splice(0, 0, params.message);
  },

  DELETE_MESSAGE(state, params) {
    state.messages.find(item => item.id === params.folder_id).message_templates.splice(params.index, 1);
  },

  UPDATE_NEW_MESSAGE(state, params) {
    const item = state.messages.find(item => item.id === params.id);
    if (item) {
      item.name = params.name;
    }
  }
};
export const getters = {
};

export const actions = {
  setMessagePreview(context, message) {
    context.commit('SET_MESSAGE', message);
    context.dispatch('preview/setMessages', message.message_content_distribution_templates, { root: true });
  },

  async getTemplates(context, query) {
    let templates = null;
    const total = 1;
    const perPage = 1;
    try {
      const res = await TemplateAPI.list(query);
      templates = res;
    } catch (error) {
      console.log(error);
    }
    context.commit('setFolders', { folders: templates, total, perPage });
  },

  async getMessageById(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let messageData = null;
    try {
      const res = await TemplateAPI.getMessageById(query);
      if (res) {
        messageData = {
          id: res.id,
          title: res.title,
          message_content_distribution_templates: res.contents
        };
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGE', messageData);
  },

  async createTemplate(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let messageIdData = null;
    try {
      const response = await TemplateAPI.sendMessage(query);

      if (response && response.id) {
        messageIdData = response.id;
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      }

      if (!messageIdData) {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGE_ID', messageIdData);
  },

  async updateMessage(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    let messageIdData = null;
    try {
      const response = await TemplateAPI.updateMessage(query);

      if (response && response.id) {
        messageIdData = response.id;
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
      }

      if (!messageIdData) {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGE_ID', messageIdData.id);
  },

  async fetchListMessageTemplate(context, query = {}) {
    context.dispatch('system/setLoading', true, { root: true });
    let messagesData = null;
    let total = 0;
    let perPage = 0;

    try {
      const response = await TemplateAPI.getListMessage(query);

      if (response) {
        messagesData = response;
      }

      if (response && response.meta) {
        total = response.meta.total;
        perPage = response.meta.per_page;
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
    context.commit('SET_MESSAGES_DATA', { messages: messagesData, total, perPage });
  },

  getListMessageTemplate(context, query = {}) {
    return TemplateAPI.getListMessage(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  setParams(context, params) {
    if (!params.page) {
      params.page = 1;
    }
    context.commit('SET_PARAMS', Object.assign({}, context.state.params, params));
  },

  async  deleteMessage(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await TemplateAPI.deleteMessage(query);
      if (response && response.message === 'success') {
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
        context.commit('DELETE_MESSAGE', { index: query.index, folder_id: query.folder_id });
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
    }

    context.dispatch('system/setLoading', false, { root: true });
  },

  async copyMessage(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await TemplateAPI.copyMessage(query);
      if (response) {
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
        context.commit('COPY_MESSAGE', { index: query.index, message: response });
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async createFolder(context, query) {
    try {
      const response = await FolderAPI.createFolder(query);
      context.commit('pushFolder', response);
    } catch (error) {
      return null;
    }
  },

  async editFolder(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Global.editFolder(query);
      if (response) {
        context.dispatch('system/setSuccess', { status: true, message: 'フォルダの変更は完成しました' }, { root: true });
        context.commit('UPDATE_NEW_MESSAGE', response);
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  },

  async deleteFolder(context, query) {
    context.dispatch('system/setLoading', true, { root: true });
    try {
      const response = await Global.deleteFolder(query);
      if (response) {
        context.dispatch('system/setSuccess', { status: true, message: '成功しました' }, { root: true });
        context.commit('REMOVE_MESSAGE_FROM_LIST_MESSAGE', query.id);
      } else {
        context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
      }
    } catch (error) {
      console.log(error);
      context.dispatch('system/setSuccess', { status: false, message: 'エラーを発生しました' }, { root: true });
    }
    context.dispatch('system/setLoading', false, { root: true });
  }

};
