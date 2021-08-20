export default {
  getMedias: (query) => {
    query._pid = btoa('/medias');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
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
  },
  uploadImagemap: (data) => {
    const formData = new FormData();
    formData.append('fileData', data.file);

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/medias/uploadImagemap'),
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  }
};
