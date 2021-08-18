export const state = {
  messages: []
};

export const mutations = {
  SET_MESSAGES(state, messages) {
    // eslint-disable-next-line no-undef
    state.messages = _.cloneDeep(messages);
  }
};

export const getters = {
};

export const actions = {
  setMessages(context, messages) {
    context.commit('SET_MESSAGES', messages);
  }
};
