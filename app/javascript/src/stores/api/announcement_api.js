export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
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

  create(payload) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  update: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
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