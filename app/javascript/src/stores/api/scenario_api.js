export default {
  manual: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/manual`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  get: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    });
  },

  create: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/scenarios',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  update: (scenarioData) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${scenarioData.id}`,
      method: 'PATCH',
      data: JSON.stringify(scenarioData),
      contentType: 'application/json'
    });
  },

  delete: (query = {}) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/delete'),
      method: 'DELETE',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  copy: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/talks/scenarios/' + query.id + '/copy'),
      method: 'POST',
      data: JSON.stringify(query),
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

  createMessage: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${payload.scenario_id}/messages`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  updateMessage: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${payload.scenario_id}/messages/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  createMessagesFromTemplate: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${payload.scenario_id}/messages/import`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  },

  getScenarioMessage: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${query.scenario_id}/messages/${query.id}`,
      method: 'GET',
      dataType: 'json',
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
