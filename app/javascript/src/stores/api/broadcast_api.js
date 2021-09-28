export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/broadcasts`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (data) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts',
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  update: (data) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts/' + data.id,
      method: 'PATCH',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/broadcasts/${id}/copy`,
      method: 'POST',
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/broadcasts/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};
