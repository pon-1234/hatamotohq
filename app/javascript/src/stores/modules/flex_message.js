import FlexMessageAPI from '../api/flexmessage_api';

export const actions = {
  indexFolders: (ctx) => {
    return FlexMessageAPI.indexFolders().done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  editFolder: (ctx, params) => {
    return FlexMessageAPI.editFolder(params.data, params.folderId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  createFolder: (ctx, params) => {
    return FlexMessageAPI.createFolder(params.data).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  deleteFolder: (ctx, params) => {
    return FlexMessageAPI.deleteFolder(params.folderId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  folderFlexMessages: (ctx, params) => {
    return FlexMessageAPI.folderFlexMessages(params.folderId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  detailFlexMessage: (ctx, params) => {
    ctx.dispatch('system/setLoading', true, { root: true });

    return FlexMessageAPI.detailFlexMessage(params.folderId, params.flexMessageId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      ctx.dispatch('system/setLoading', false, { root: true });
    });
  },
  createFlexMessage: (ctx, params) => {
    ctx.dispatch('system/setLoading', true, { root: true });
    return FlexMessageAPI.createFlexMessage(params.data, params.folderId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      ctx.dispatch('system/setLoading', false, { root: true });
    });
  },
  editFlexMessage: (ctx, params) => {
    ctx.dispatch('system/setLoading', true, { root: true });
    return FlexMessageAPI.editFlexMessage(params.data, params.folderId, params.flexMessageId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      ctx.dispatch('system/setLoading', false, { root: true });
    });
  },

  renderFlexMessage: (_, params) => {
    return FlexMessageAPI.renderFlexMesasege(params.flexMessageId, params.source).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    });
  },
  deleteFlexMessage: (ctx, params) => {
    ctx.dispatch('system/setLoading', true, { root: true });

    return FlexMessageAPI.deleteFlexMessage(params.flexMessageId).done((res) => {
      return Promise.resolve(res);
    }).fail((err) => {
      return Promise.reject(err);
    }).always(() => {
      ctx.dispatch('system/setLoading', false, { root: true });
    });
  },
  copyFlexMessage: (ctx, params) => {
    ctx.dispatch('system/setLoading', true, { root: true });
    return FlexMessageAPI.copyFlexMessage(params.flexMessageId)
      .done((res) => {
        return Promise.resolve(res);
      }).fail((err) => {
        return Promise.reject(err);
      }).always(() => {
        ctx.dispatch('system/setLoading', false, { root: true });
      });
  }

};
