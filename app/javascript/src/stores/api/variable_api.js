export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/variables`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/variables/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/variables`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/variables/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/variables/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/variables/${id}/copy`,
      method: 'POST'
    });
  }
};
