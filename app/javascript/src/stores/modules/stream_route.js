import FolderAPI from '../api/folder_api';
import StreamRouteApi from '../api/stream_route_api';

export const state = {
  friendList: [],
  foldersIncludeStreamRoutes: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    streamRouteId: null
  }
};

export const mutations = {
  setFriendList(state, friends) {
    state.friendList = friends;
  },

  setFoldersIncludeStreamRoutes(state, foldersIncludeStreamRoutes) {
    state.foldersIncludeStreamRoutes = foldersIncludeStreamRoutes;
  },

  pushFolder(state, folder) {
    state.foldersIncludeStreamRoutes.push(folder);
  },

  updateFolder(state, newItem) {
    const item = state.foldersIncludeStreamRoutes.find(item => item.id === newItem.id);
    if (item) {
      item.name = newItem.name;
    }
  },

  deleteFolder(state, id) {
    const index = state.foldersIncludeStreamRoutes.findIndex(_ => _.id === id);
    state.foldersIncludeStreamRoutes.splice(index, 1);
  },

  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  },
  setQueryParams(state, params) {
    Object.assign(state.queryParams, params);
  },

  setQueryParam(state, param) {
    Object.assign(state.queryParams, param);
  }
};

export const actions = {
  async createStreamRoute(_, query) {
    try {
      return await StreamRouteApi.create(query);
    } catch (error) {
      return error;
    }
  },

  async updateStreamRoute(_, query) {
    try {
      return await StreamRouteApi.update(query);
    } catch (error) {
      return error;
    }
  },

  async deleteStreamRoute(context, id) {
    try {
      return await StreamRouteApi.delete(id);
    } catch (error) {
      return null;
    }
  },

  async copyStreamRoute(context, id) {
    try {
      return await StreamRouteApi.copy(id);
    } catch (error) {
      return null;
    }
  },

  async getStreamRouteDetail(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await StreamRouteApi.getDetail(params);
      context.commit('setFriendList', response.data);
      context.commit('setMeta', response.meta);
    } catch (error) {
      console.log(error);
    }
  },

  async getStreamRoutes(context) {
    try {
      // const params = {
      //   page: state.queryParams.page,
      //   q: _.omit(state.queryParams, 'page')
      // };
      const response = await StreamRouteApi.getStreamRoutes();
      console.log(response);
      context.commit('setFoldersIncludeStreamRoutes', response);
    } catch (error) {
      console.log(error);
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
  }
};
