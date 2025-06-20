export default {

  indexFolders: () => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders'),
      method: 'GET',
      contentType: 'application/json'
    });
  },
  editFolder: (data, folderId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/' + folderId + '/edit'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  createFolder: (data) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/create'),
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  deleteFolder: (folderId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/' + folderId + '/delete'),
      method: 'DELETE',
      contentType: 'application/json'
    });
  },
  folderFlexMessages: (folderId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/' + folderId + '/flex-message'),
      method: 'GET',
      contentType: 'application/json'
    });
  },
  detailFlexMessage: (folderId, flexMessageId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/' + folderId + '/flex-message/' + flexMessageId),
      method: 'GET',
      contentType: 'application/json'
    });
  },
  createFlexMessage: (data, folderId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/folders/' + folderId + '/flex-message/create'),
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  editFlexMessage: (data, folderId, flexMessageId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/' + flexMessageId + '/edit'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  deleteFlexMessage: (flexMessageId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/' + flexMessageId + '/delete'),
      method: 'DELETE',
      contentType: 'application/json'
    });
  },

  copyFlexMessage: (flexMessageId) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?' + '_pid=' + btoa('/flexMessages/' + flexMessageId + '/copy'),
      method: 'GET',
      contentType: 'application/json'
    });
  },
  renderFlexMesasege: (flexMessageId, source) => {
    return window.$.ajax({
      url: import.meta.env.VITE_ROOT_PATH + '?source=' + source + '&' + '_pid=' + btoa('/flexMessages/' + flexMessageId + '/render'),
      method: 'GET'
    });
  }
};
