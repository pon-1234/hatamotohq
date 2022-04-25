export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  detail: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites/${query.id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/sites/' + id,
      method: 'DELETE'
    });
  }
};