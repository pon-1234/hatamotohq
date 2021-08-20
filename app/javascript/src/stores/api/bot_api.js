export default {
  getList: (query = {}) => {
    query._pid = btoa('/automessage');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  getDetail: (query = {}) => {
    query._pid = btoa('/automessage/' + query.id);
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  botWithKeyword: (query = {}) => {
    query._pid = btoa('/automessage/autoMessageWithKeyword');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  botAdd: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/automessage/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  botEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/automessage/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  botDelete: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/automessage/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
