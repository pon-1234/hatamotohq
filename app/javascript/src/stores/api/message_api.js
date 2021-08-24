export default {

  getMessageDelivers: (query) => {
    const qr = {
      _pid: btoa('/deliveries/distributions/' + query.id)
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
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
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/deliveries/distributions/' + query.id + '/edit'),
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  },

  getListMessageDelivers: (query) => {
    query._pid = btoa('/deliveries/distributions');

    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  deleteMessageDelivers: (query) => {
    return window.$.ajax({
      url: process.env.MIX_ROOT_PATH + '?' + '_pid=' + btoa('/deliveries/distributions/' + query.id + '/delete'),
      method: 'DELETE'
    });
  },

  copyMessageDelivers: (query) => {
    const qr = {
      _pid: btoa('/deliveries/distributions/' + query.id + '/copy')
    };

    return window.$.get(process.env.MIX_ROOT_PATH, qr);
  }

};
