export default {
  createUser(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/admin/users/',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  updateUser: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/admin/users/' + query.id,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  }
};