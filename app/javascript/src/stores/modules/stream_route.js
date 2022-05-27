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
  }
};
