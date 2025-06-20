export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/agencies`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  search: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/agencies/search`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create(query) {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/agencies`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/agencies/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/agencies/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  },

  updateProfile: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/agency/profile`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  }
};