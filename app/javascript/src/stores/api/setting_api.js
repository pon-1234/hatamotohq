export default {
  getSettingBasic: (query = {}) => {
    query._pid = btoa('/basicSetting');
    return window.$.get(process.env.MIX_API_URL, query);
  },
  putEditSettingBasic: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/basicSetting'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
