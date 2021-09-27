export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  published: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/home/announcements`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create(query) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};