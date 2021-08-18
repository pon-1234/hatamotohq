export default {
  editTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/tags/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getTags: (query = {}) => {
    query._pid = btoa('/tags');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  getFriendsTag: (query = {}) => {
    return window.$.get(process.env.MIX_API_URL + '?' + '_pid=' + btoa('/tags/' + query.id + '/listFriendWithTag'));
  },

  listTagAssigned: (query = {}) => {
    return window.$.get(process.env.MIX_API_URL + '?' + '_pid=' + btoa('/tags/listTagAssigned'));
  },

  deleteTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/tags/' + query.id + '/delete'),
      method: 'DELETE'
    });
  },

  createTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/tags/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
