export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/staffs`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: true
    });
  },
  search: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/staffs/search`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  create(query) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/staffs`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/staffs/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/staffs/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};