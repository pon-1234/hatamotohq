export default {
  list: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/scenarios/${query.scenario_id}/messages`,
      method: 'GET',
      data: query,
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  delete: (query) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/scenarios/${query.scenario_id}/messages/${query.id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  }
};