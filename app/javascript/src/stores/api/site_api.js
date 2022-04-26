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

  getScenarios: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites/${query.id}/scenarios`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  getBroadcasts: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites/${query.id}/broadcasts`,
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