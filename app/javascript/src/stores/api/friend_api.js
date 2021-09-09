export default {
  //
  getList: (query) => {
    query._pid = btoa('/friends');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  fetchFriends: (query) => {
    query._pid = btoa('/friends/fetchFriends');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/friends/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  editTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/friends/' + query.id + '/editTag'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  editLineInfo: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/friends/' + query.id,
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateStatusFromBot: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/friends/' + query.id + '/updateStatusFromBot'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getFiles: (query) => {
    query._pid = btoa('/friends/getFiles');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  }
};
