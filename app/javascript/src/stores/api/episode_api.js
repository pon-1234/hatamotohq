export default {
  list: (reminderId) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${reminderId}/episodes`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  get: (params) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${params.reminder_id}/episodes/${params.id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${payload.reminder_id}/episodes`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  update: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${payload.reminder_id}/episodes/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  delete: (params) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/reminders/${params.reminder_id}/episodes/${params.id}`,
      method: 'DELETE'
    });
  }
};
