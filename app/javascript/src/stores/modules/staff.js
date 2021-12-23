import StaffAPI from '../api/staff_api';

export const state = {
  staffs: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    status_eq: '',
    name_or_company_name_or_email_cont: null
  }
};

export const mutations = {
  setStaffs(state, staffs) {
    state.staffs = staffs;
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

export const getters = {
  getQueryParams(state) {
    return state.queryParams;
  }
};

export const actions = {
  createStaff(_, query) {
    return StaffAPI.create(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  updateStaff(_, query) {
    return StaffAPI.update(query).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },

  async getStaffs(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await StaffAPI.list(params);
      context.commit('setStaffs', response.data);
      context.commit('setMeta', response.meta);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  },

  async getAllStaffs(context) {
    try {
      return await StaffAPI.all();
    } catch (error) {
      return null;
    }
  },

  async deleteStaff(context, id) {
    try {
      return await StaffAPI.delete(id);
    } catch (error) {
      return null;
    }
  }
};