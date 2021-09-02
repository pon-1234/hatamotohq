export default {
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
  }
};
