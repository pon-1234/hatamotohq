export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  channelMessages: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/messages`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  availableScenarios: (channelId) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${channelId}/scenarios`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  sendMessage: (channelId, payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${channelId}/messages`,
      method: 'POST',
      data: JSON.stringify(payload),
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  sendScenario: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${payload.channel_id}/messages/send_scenario`,
      method: 'POST',
      data: JSON.stringify(payload),
      dataType: 'jsonp',
      contentType: 'application/json'
    });
  },

  sendTemplate: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${payload.channel_id}/messages/send_template`,
      method: 'POST',
      data: JSON.stringify(payload),
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

  unreadMessage: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${query.channelId}/unreadMessage`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateLastSeen: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/channels/${id}/update_last_seen`,
      method: 'POST'
    });
  }
};
