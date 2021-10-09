export default {
  list: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reminders/${id}/episodes`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  }
};
