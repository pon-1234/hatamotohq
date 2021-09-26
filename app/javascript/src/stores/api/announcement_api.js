export default {
  create(query) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  search: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/admin/announcements/search/?page=${query.page}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  }
};