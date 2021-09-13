export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/templates`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/templates/' + id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/templates`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/templates/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getListMessage: (query) => {
    query._pid = btoa('/messageTemplates');

    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  deleteMessage: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/messageTemplates/' + query.id + '/delete'),
      method: 'DELETE'
    });
  },

  copyMessage: (query) => {
    const qr = {
      _pid: btoa('/messageTemplates/' + query.id + '/copy')
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  }
};
