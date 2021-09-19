export default {
  getTags: () => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags',
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  getFriendsByTag: (query = {}) => {
    return window.$.get(process.env.MIX_ROOT_PATH + '/user/tags/' + query.id + '/friends');
  },

  deleteTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags/' + query.id,
      method: 'DELETE'
    });
  },

  createTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateTag: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/tags/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  editTag: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/tags/' + query.id,
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }

};
