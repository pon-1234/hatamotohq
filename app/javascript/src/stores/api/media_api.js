export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias?page=${query.page}&q[type_in]=${query.types}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  uploadMedia: (payload) => {
    const formData = new FormData();
    formData.append('file', payload.file);
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
    formData.append('type', 'image_map');
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
    formData.append('type', 'menu');
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/medias`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  mediasDelete: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/medias/delete'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  download: (query) => {
    query._pid = btoa('/medias/download');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  }
};
