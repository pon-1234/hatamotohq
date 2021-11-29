export default {
  list: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${id}/episodes`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${payload.reminder_id}/episodes`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  delete: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${payload.reminder_id}/episodes/${payload.id}`,
      method: 'DELETE'
    });
  }
};
