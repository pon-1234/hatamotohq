export default {
  createRichmenu: (data) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/richmenus/add'),
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  editRichmenu: (data) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/richmenus/' + data.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  getList: (query) => {
    query._pid = btoa('/richmenus');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  getDetail: (richMenuId) => {
    const query = {
      _pid: btoa('/richmenus/' + richMenuId)
    };
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  destroyRichmenu: (data) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/richmenus/' + data.richMenuId + '/destroy'),
      method: 'DELETE',
      contentType: 'application/json'
    });
  },

  uploadImage: (data) => {
    const formData = new FormData();
    formData.append('fileData', data.file);

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/richmenus/uploadImage'),
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  }
};
