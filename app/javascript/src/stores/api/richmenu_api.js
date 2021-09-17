export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus`,
      method: 'POST',
      data: JSON.stringify(payload),
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
