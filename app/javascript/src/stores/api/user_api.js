export default {
  getValidate(data) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/admin/users/validate_unique',
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  updateUser: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/admin/users/' + query.id,
      method: 'PATCH',
      data: JSON.stringify(query),
      dataType: 'json',
      contentType: 'application/json'
    });
  }
};