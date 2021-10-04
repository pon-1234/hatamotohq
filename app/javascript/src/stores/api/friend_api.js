export default {
  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/friends/' + query.id,
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  toggleLocked: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}/toggle_locked`,
      method: 'POST'
    });
  },

  toggleVisible: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}/toggle_visible`,
      method: 'POST'
    });
  },

};
