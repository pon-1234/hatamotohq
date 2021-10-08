export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/reminders/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/reminders/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${id}/copy`,
      method: 'POST'
    });
  }
};
