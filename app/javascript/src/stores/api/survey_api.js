export default {
  list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/surveys`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/surveys/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/surveys`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  update(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  delete(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateStatus(data) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + data.id + '/status'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  getCustomers(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + query.id + '/customers')
    });
  },

  answersOfCustomer(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + query.id + '/answersOfCustomer')
    });
  },
  copy(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + query.id + '/copy'),
      method: 'POST',
      contentType: 'application/json'
    });
  },

  addSurveyProfile(data) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/addProfileTemplate'),
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  getSurveyProfiles(query) {
    query._pid = btoa('/surveys/getProfileTemplates');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  updateSurveyProfile(data) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/' + data.id + '/updateSurveyProfile'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  friendAnswers(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/surveys/friendAnswers/' + query.id)
    });
  }
};
