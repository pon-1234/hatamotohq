export default {
  list: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

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

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${id}/copy`,
      method: 'POST',
      contentType: 'application/json'
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
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

  sendScenarioToTesters: (payload) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${payload.scenario_id}/send_to_testers`,
      method: 'POST',
      data: JSON.stringify(payload),
      contentType: 'application/json'
    });
  }
};
