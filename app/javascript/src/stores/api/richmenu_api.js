export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
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
      method: 'PATCH',
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

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus/${id}/copy`,
      method: 'POST'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/rich_menus/${id}`,
      method: 'DELETE'
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
