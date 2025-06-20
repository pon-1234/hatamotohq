export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  getByCode: (code) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/surveys/${code}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  update: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${id}`,
      method: 'DELETE'
    });
  },

  postAnswer(payload) {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/surveys/${payload.code}/${payload.friend_id}`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${id}/copy`,
      method: 'POST',
      contentType: 'application/json'
    });
  },

  toggleStatus: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${id}/toggle_status`,
      method: 'POST',
      contentType: 'application/json'
    });
  },

  answeredUsers: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${query.id}/answered_users`,
      method: 'GET',
      dataType: 'json',
      data: query,
      contentType: 'application/json',
      cache: false
    });
  },

  responses: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${query.id}/responses`,
      method: 'GET',
      dataType: 'json',
      data: query,
      contentType: 'application/json',
      cache: false
    });
  },

  friendResponses: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/surveys/${query.survey_id}/${query.friend_id}/responses`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  }
};
