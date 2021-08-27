export default {

  getUserDetails: (query = {}) => {
    // return window.$.get(process.env.MIX_ROOT_PATH + '/information/profile', query);
  },

  sendMedia: (query) => {
    const formData = new FormData();
    formData.append('file', query.file);
    if (query.duration) {
      formData.append('duration', query.duration);
    }

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/medias',
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  getStickers: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/emojis/' + query.packageId,
      method: 'GET',
      dataType: "json",
      contentType: 'application/json'
    });
  },

  getGenTokenMedias: (query = {}) => {
    query._pid = btoa('/medias/genToken');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  getActionObjects: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/action_objects',
      method: 'GET',
      dataType: "json",
      contentType: 'application/json'
    });
  },

  getBadge: () => {
    const qr = {
      _pid: btoa('/channels/badge')
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  },

  createFolder(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/folders/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  editFolder(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/folders/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  deleteFolder: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/folders/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }

};
