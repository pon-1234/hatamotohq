export default {
  createNew(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/create'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  update(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  delete(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  list(query) {
    query._pid = btoa('/surveys');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  folders(query) {
    query._pid = btoa('/folders');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  updateStatus(data) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + data.id + '/status'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  getCustomers(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + query.id + '/customers')
    });
  },

  answersOfCustomer(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + query.id + '/answersOfCustomer')
    });
  },
  copy(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + query.id + '/copy'),
      method: 'POST',
      contentType: 'application/json'
    });
  },

  addSurveyProfile(data) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/addProfileTemplate'),
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  getSurveyProfiles(query) {
    query._pid = btoa('/surveys/getProfileTemplates');
    return window.$.get(process.env.MIX_API_URL, query);
  },

  updateSurveyProfile(data) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/' + data.id + '/updateSurveyProfile'),
      method: 'PUT',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },

  friendAnswers(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/surveys/friendAnswers/' + query.id)
    });
  }
};
