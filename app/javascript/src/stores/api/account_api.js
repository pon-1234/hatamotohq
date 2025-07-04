export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/accounts`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  create(query) {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/accounts/`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/accounts/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  updateProfile: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/profile`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  delete: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/admin/accounts/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};