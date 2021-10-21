export default {
  listMessages: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${query.scenario_id}/messages`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json'
    });
  },
  deleteMessage: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/scenarios/${query.scenario_id}/messages/${query.id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};