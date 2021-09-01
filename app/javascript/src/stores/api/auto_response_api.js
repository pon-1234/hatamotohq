export default {
  getAutoResponses: (query = {}) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  getDetail: (query = {}) => {
    query._pid = btoa('/automessage/' + query.id);
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  createAutoResponse: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses/`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  updateAutoResponse: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses/${query.id}`,
      method: 'PATCH',
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
