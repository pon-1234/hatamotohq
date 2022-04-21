export default {
  //
  latestMessages: (query) => {
    query._pid = btoa('/notices/latestMessages');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  },
  notices: (query) => {
    query._pid = btoa('/notices');
    return window.$.get(process.env.MIX_ROOT_PATH, query);
  }

};
