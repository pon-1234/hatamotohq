export default {
  getTags: () => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/tags',
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: true
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/tags',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/tags/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/tags/' + id,
      method: 'DELETE'
    });
  }
};