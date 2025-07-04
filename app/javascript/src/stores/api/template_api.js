export default {
  list: () => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/templates`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/templates/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/templates`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/templates/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/templates/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/templates/${id}/copy`,
      method: 'POST'
    });
  }
};
