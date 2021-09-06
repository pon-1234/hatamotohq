export default {
  getList: (query = {}) => {
    query._pid = btoa('/talks/scenarios');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  createScenario: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/scenarios',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioEdit: (scenarioData) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${scenarioData.id}`,
      method: 'PATCH',
      data: JSON.stringify(scenarioData),
      contentType: 'application/json'
    });
  },
  scenarioDelete: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  scenarioCopy: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/copy'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  getScenario: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/scenarios/' + query.id,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  getTalks: (query) => {
    query._pid = btoa('/talks/scenarios/' + query.id + '/messages');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  getTalk: (query) => {
    query._pid = btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id);
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  createScenarioMessage: (data) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${data.scenario_id}/messages`,
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  createScenarioMessageFromTemplate: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/addFromTemplate'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talkDelete: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talkEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },
  talksEdit: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/updateListMessage'),
      method: 'PUT',
      data: JSON.stringify(query.data),
      contentType: 'application/json'
    });
  },

  copyMessageScenario(query) {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/messages/' + query.talk_id + '/copy'),
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }
};
