import ReviewAPI from '../api/review_api';

export const state = {
  questions: [],
};

export const mutations = {
  setQuestions(state, questions) {
    state.questions = questions;
  }  
};

export const actions = {
  async getQuestions(context) {    
    try {
      const response = await ReviewAPI.question_list();
      context.commit('setQuestions', response.data);
      console.log(response.data);
      return response;
    } catch (error) {
      console.log(error);
      return null;
    }
  }  
};