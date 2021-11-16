export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  uploadMedia: (payload) => {
    const formData = new FormData();
    formData.append('file', payload.file);
    formData.append('type', payload.type);
    if (payload.duration) {
      formData.append('duration', payload.duration);
    }

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/medias',
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  uploadImageMap: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', 'imagemap');
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  uploadRichMenu: (file) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', 'richmenu');
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  bulkDelete: (ids) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias/bulk_delete`,
      method: 'POST',
      data: JSON.stringify({ ids: ids }),
      dataType: 'json',
      contentType: 'application/json'
    });
  }
};
