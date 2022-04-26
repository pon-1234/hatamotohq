export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/agency/clients`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  search: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/agency/clients/search`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  create(query) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/agency/clients`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/agency/clients/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },
  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/agency/clients/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};