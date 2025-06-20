export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/variables`,
      method: 'GET',
      dataType: 'json',
      data: query,
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/variables/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/variables`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  update: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/variables/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/variables/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/variables/${id}/copy`,
      method: 'POST'
    });
  }
};
