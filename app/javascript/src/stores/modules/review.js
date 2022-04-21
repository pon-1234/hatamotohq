import ReviewAPI from '../api/review_api';

export const state = {
  questions: [],
  reviews: [],
  totalRows: 0,
  perPage: 0,
  queryParams: {
    page: 1,
    line_friend_line_name_cont: null
  }
};

export const mutations = {
  setQuestions(state, questions) {
    state.questions = questions;
  },

  setReviews(state, reviews) {
    state.reviews = reviews;
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
  async getQuestions(context) {
    try {
      const response = await ReviewAPI.question_list();
      context.commit('setQuestions', response.data);
    } catch (error) {
      console.log(error);
    }
  },

  async getReviews(context) {
    try {
      const params = {
        page: state.queryParams.page,
        q: _.omit(state.queryParams, 'page')
      };
      const response = await ReviewAPI.review_list(params);
      context.commit('setReviews', response.data);
      context.commit('setMeta', response.meta);
    } catch (error) {
      console.log(error);
    }
  }
};
