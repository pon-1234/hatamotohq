export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
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

  getReminders: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}/reminders`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  setReminder: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${payload.friend_id}/set_reminder`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  }
};