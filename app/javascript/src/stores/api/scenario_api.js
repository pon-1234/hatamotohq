export default {
  getList: (query = {}) => {
    query._pid = btoa('/talks/scenarios');
    return window.$.get(process.env.MIX_API_URL, query);
  },
  scenarioAdd: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/' + query.folderId + '/scenarios/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioDelete: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioCopy: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/copy'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioDetail: (query) => {
    query._pid = btoa('/talks/scenarios');
    return window.$.get(process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id));
  },
  getTalks: (query) => {
    query._pid = btoa('/talks/scenarios/' + query.id + '/messages');
    return window.$.get(process.env.MIX_API_URL, query);
  },
  getTalk: (query) => {
    query._pid = btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id);
    return window.$.get(process.env.MIX_API_URL, query);
  },
  talkAdd: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/add'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talkAddFromTemplate: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/addFromTemplate'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talkDelete: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talkEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talksEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/updateListMessage'),
      method: 'PUT',
      data: JSON.stringify(query.data),
      contentType: 'application/json'
    });
  },

  copyMessageScenario(query) {
    return window.$.ajax({
      url: process.env.MIX_API_URL + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/copy'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
