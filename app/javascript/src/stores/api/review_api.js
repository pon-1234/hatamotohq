export default {
  question_list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/review_questions`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  },
  review_list: (params) => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/user/reviews`,
      method: 'GET',
      dataType: 'json',
      data: params,
      contentType: 'application/json',
      cache: false
    });
  }
};