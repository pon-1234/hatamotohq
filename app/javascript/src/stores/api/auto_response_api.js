export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  create: (data) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses/`,
      method: 'POST',
      data: JSON.stringify(data),
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
  },
  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/auto_responses/${id}/copy`,
      method: 'POST',
      contentType: 'application/json'
    });
  }
};
