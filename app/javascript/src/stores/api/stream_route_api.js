export default {
  create(query) {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/stream_routes/`,
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  update: (query) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/stream_routes/${query.id}`,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json',
      dataType: 'json'
    });
  },

  getDetail: (params) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/stream_routes/${params.q.streamRouteId}`,
      method: 'GET',
      dataType: 'json',
      data: params,
      contentType: 'application/json',
      cache: false
    });
  },

  getStreamRoutes: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/stream_routes`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },

  delete: (id) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/stream_routes/' + id,
      method: 'DELETE'
    });
  },

  copy: (id) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/stream_routes/${id}/copy`,
      method: 'POST',
      contentType: 'application/json',
      dataType: 'json'
    });
  }
};
