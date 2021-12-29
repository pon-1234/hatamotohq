export const state = {
  loading: null,
  success: null,
  isSubmitChange: false
};

export const mutations = {
  SET_LOADING(state, loading) {
    state.loading = loading;
  },

  SET_SUCCESS(state, success) {
    state.success = success;
  },

  SET_IS_SUBMIT_CHANGE(state) {
    state.isSubmitChange = !state.isSubmitChange;
  }
};

export const getters = {
};

export const actions = {
  setLoading(context, loading) {
    context.commit('SET_LOADING', loading);
  },

  setSuccess(context, success) {
    context.commit('SET_SUCCESS', success);
  }
};
