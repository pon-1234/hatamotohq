export default {
  getFolders: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/folders',
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  deleteFolder: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/folders/${id}`,
      method: 'DELETE'
    });
  },

  createFolder: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/folders',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  editFolder: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/folders/' + query.id,
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
