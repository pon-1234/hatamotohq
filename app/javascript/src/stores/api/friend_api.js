export default {
  //
  getList: (query) => {
    query._pid = btoa('/friends');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  fetchFriends: (query) => {
    query._pid = btoa('/friends/fetchFriends');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  getDetailFriend: (query) => {
    query._pid = btoa('/friends/' + query.id + '/detail');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  editTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/friends/' + query.id + '/editTag'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  editLineInfo: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/friends/' + query.id + '/editLineInfo'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateStatusFromBot: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/friends/' + query.id + '/updateStatusFromBot'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getFiles: (query) => {
    query._pid = btoa('/friends/getFiles');
    return window.$.get(process.env.MIX_API_URL, query);
  }
};
