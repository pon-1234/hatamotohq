export default {
  getTags: () => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags',
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  getFriendsByTag: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/tags/${query.id}/friends`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/tags/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags/' + id,
      method: 'DELETE'
    });
  }
};