export default {
  sendMedia: (query) => {
    const formData = new FormData();
    formData.append('file', query.file);
    if (query.duration) {
      formData.append('duration', query.duration);
    }

    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/medias',
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false
    });
  },

  getStickers: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/emojis/' + query.packageId,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  getActionObjectConfigs: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/action_objects',
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  }
};
