export default {
  list: () => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/reminders/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '/user/reminders/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${id}/copy`,
      method: 'POST'
    });
  }
};
