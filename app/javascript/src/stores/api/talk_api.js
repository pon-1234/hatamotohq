export default {
  getChannels: (query = {}) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels`,
      method: 'GET',
      dataType: "json",
      contentType: 'application/json'
    });
  },

  getListMessages: (query) => {
    const qr = {
      _pid: btoa('/channels/' + query.channelId + '/messages')
    };
    Object.assign(qr, query);
    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  },

  sendMedia: (query) => {
    const formData = new FormData();
    formData.append('key', query.key);
    formData.append('fileData', query.file);

    const qr = '_pid=' + btoa('/channels/' + query.channelId + '/sendFile');

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + qr,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  sendMediaFromManager: (query) => {
    const qr = '_pid=' + btoa('/channels/' + query.channelId + '/sendMediaFromManager');

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + qr,
      method: 'POST',
      data: JSON.stringify(query),
      processData: false,
      contentType: false
    });
  },

  unreadMessage: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/channels/unreadMessage'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
