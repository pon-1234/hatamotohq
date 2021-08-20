export default {
  editTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/tags/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getTags: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags',
      method: 'GET',
      dataType: "json",
      contentType: 'application/json'
    });
  },

  getFriendsTag: (query = {}) => {
    return window.$.get(process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/tags/' + query.id + '/listFriendWithTag'));
  },

  listTagAssigned: (query = {}) => {
    return window.$.get(process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/tags/listTagAssigned'));
  },

  deleteTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/tags/' + query.id + '/delete'),
      method: 'DELETE'
    });
  },

  createTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/tags/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
