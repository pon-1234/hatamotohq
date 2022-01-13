
import ReservationAPI from '../api/reservation_api';

export const state = {
  reservations: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: 'wait',
    line_name_or_display_name_cont: null
  }
};

export const mutations = {
  setReservations(state, reservations) {
    state.reservations = reservations;
  }
};

export const getters = {
};

export const actions = {
  async getReservations(context, query) {
    try {
      const reservations = await ReservationAPI.list(query);
      context.commit('setReservations', reservations);
    } catch (error) {
      console.log(error);
    }
  }
};
