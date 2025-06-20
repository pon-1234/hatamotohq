export default {
  list: () => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  get: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses/${id}`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  create: (data) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses/`,
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    });
  },
  update: (payload) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses/${payload.id}`,
      method: 'PATCH',
      data: JSON.stringify(payload),
      contentType: 'application/json',
      cache: false
    });
  },
  delete: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses/${id}`,
      method: 'DELETE',
      contentType: 'application/json'
    });
  },
  copy: (id) => {
    return window.$.ajax({
      url: `${import.meta.env.VITE_ROOT_PATH}/user/auto_responses/${id}/copy`,
      method: 'POST',
      contentType: 'application/json',
      cache: false
    });
  }
};
