export default {
  question_list: () => {
    return window.$.ajax({
      url: `${process.env.MIX_ROOT_PATH}/review_questions`,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      cache: false
    });
  }
};