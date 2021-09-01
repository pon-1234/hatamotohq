export default {
  getChannels: (query = {}) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  getListMessages: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/messages`,
      query: query,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  sendMedia: (query) => {
    const formData = new FormData();
    formData.append('key', query.key);
    formData.append('fileData', query.file);
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/messages/sendMedia`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  sendMediaFromManager: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/messages/sendMediaFromManager`,
      method: 'POST',
      data: JSON.stringify(query),
      processData: false,
      contentType: false
    });
  },

  unreadMessage: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/unreadMessage`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
