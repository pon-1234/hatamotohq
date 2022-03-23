
import ReservationAPI from '../api/reservation_api';

export const state = {
  reservations: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: '',
    line_friend_line_name_or_line_friend_display_name_cont: null
  }
};

export const mutations = {
  setMeta(state, meta) {
    state.totalRows = meta.total_count;
    state.perPage = meta.limit_value;
    state.curPage = meta.current_page;
  },

  setReservations(state, reservations) {
    state.reservations = reservations;
  },

  setQueryParams(state, params) {
    Object.assign(state.queryParams, params);
  },

  setQueryParam(state, param) {
    Object.assign(state.queryParams, param);
  }
};

export const getters = {
};

export const actions = {
  async getReservations(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await ReservationAPI.list(params);
      context.commit('setReservations', response.data);
      context.commit('setMeta', response.meta);
    } catch (error) {
      console.log(error);
    }
  }
};
