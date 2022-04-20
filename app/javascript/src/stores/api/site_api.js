export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/sites`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  }
};