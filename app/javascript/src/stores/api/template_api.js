export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/templates`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  getMessageById: (query) => {
    const qr = {
      _pid: btoa('/messageTemplates/' + query.id)
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  },

  sendMessage: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/messageTemplates/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateMessage: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/messageTemplates/' + query.id + '/edit'),
      method: 'PUT',
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
