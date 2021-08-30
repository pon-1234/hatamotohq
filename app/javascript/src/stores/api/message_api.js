export default {

  getBroadcast: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts/' + query.id,
      method: 'GET',
      dataType: "json",
      contentType: 'application/json'
    });
  },

  createBroadcast: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts',
      method: 'POST',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  updateBroadcast: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '/user/broadcasts/' + query.id,
      method: 'PATCH',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getListMessageDelivers: (query) => {
    query._pid = btoa('/deliveries/distributions');

    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  copyMessageDelivers: (query) => {
    const qr = {
      _pid: btoa('/deliveries/distributions/' + query.id + '/copy')
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  }

};
