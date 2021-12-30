export default {
  //
  getLineSetting: (query = {}) => {
    query._pid = btoa('/account');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },

  editAccount: (query) => {
    return window.$.ajax({
      headers: {
        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
      },
      url: process.env.MIX_ROOT_PATH + '/information/edit',
      method: 'PUT',
      data: JSON.stringify(query),
      contentType: 'application/json'
    });
  }

};
