export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/folders`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/folders`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/folders/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/folders/${id}`,
      method: 'DELETE'
    });
  }
};
