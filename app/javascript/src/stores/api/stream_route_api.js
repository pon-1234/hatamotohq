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
  }
};
