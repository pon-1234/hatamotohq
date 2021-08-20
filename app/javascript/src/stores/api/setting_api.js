export default {
  getSettingBasic: (query = {}) => {
    query._pid = btoa('/basicSetting');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  putEditSettingBasic: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/basicSetting'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
