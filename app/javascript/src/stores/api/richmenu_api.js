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

  update: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus/${payload.id}`,
      method: 'PUT',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
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
