export default {
  list: (params) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/precheckins`,
      method: 'GET',
      dataType: 'json',
      data: params,
      contentType: 'application/json',
      cache: false
    });
  }
};
