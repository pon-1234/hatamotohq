class ViewHelper {
  static scrollTopIfInvalidInput(input, parent) {
    input.each(
      function(index) {
        var input = $(this);
        if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
          if (parent && input.is(':hidden')) {
            input = input.parent();
          }
          $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
          return false;
        }
      }
    );
  }
}

export default ViewHelper;