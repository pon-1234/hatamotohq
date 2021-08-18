/* eslint-disable */
window._ = require('lodash');

/**
 * We'll load jQuery and the Bootstrap jQuery plugin which provides support
 * for JavaScript based Bootstrap features such as modals and tabs. This
 * code may be modified to fit the specific needs of your application.
 */

try {
  window.$ = window.jQuery = require('jquery');

  require('bootstrap-sass');
} catch (e) {
}

/**
 * We'll load the axios HTTP library which allows us to easily issue requests
 * to our Laravel back-end. This library automatically handles sending the
 * CSRF token as a header based on the value of the "XSRF" token cookie.
 */

window.axios = require('axios');

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

/**
 * Next we will register the CSRF Token as a common header with Axios so that
 * all outgoing HTTP requests automatically have it attached. This is just
 * a simple convenience so we don't have to attach every token manually.
 */

const token = document.head.querySelector('meta[name="csrf-token"]');

if (token) {
  window.axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
} else {
  console.error('CSRF token not found: https://laravel.com/docs/csrf#csrf-x-csrf-token');
}

const wsToken = document.head.querySelector('meta[name="csrf-ws-token"]');

if (wsToken) {
  window.wsToken = wsToken.content;
}

/**
 * Echo exposes an expressive API for subscribing to channels and listening
 * for events that are broadcast by Laravel. Echo and event broadcasting
 * allows your team to easily build robust real-time web applications.
 */

// import Echo from 'laravel-echo'

// window.Pusher = require('pusher-js');

// window.Echo = new Echo({
//     broadcaster: 'pusher',
//     key: 'your-pusher-key'
// });

Array.prototype.firstWhere = function(cb) {
  for (const item of this) {
    if (cb(item)) { return item; }
  }
  return null;
};

Array.prototype.findWhere = function(cb) {
  const ret = [];
  for (const item of this) {
    if (cb(item)) { ret.push(item); }
  }
  return ret;
};

Array.prototype.deleteWhere = function(cb) {
  for (const [index, item] of this.entries()) {
    if (cb(item)) {
      this.splice(index, 1);
    }
  }
};

Array.prototype.last = function() {
    return this[this.length - 1];
};

String.prototype.getParameterByName = function(name) {
  name = name.replace(/[\[\]]/g, '\\$&');
  const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)');
  const results = regex.exec(this);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, ' '));
};

window.initShowPassword = () => {
  // lấy tất cả input password
  const passwordInputs = $('input[type="password"]');

  for (const passwordInput of passwordInputs) {
    const $button = $('<button type="button" style="position: absolute;width: 44px; font-size: 20px; color: #717171; right: 0;top: 0;bottom: 0;background: transparent;border: 0;border-bottom-right-radius: 10px;align-items: center;display: flex;"><i class="fa fa-eye" style="margin: auto" aria-hidden="true"></i></button>');

    $button.click((ev) => {
      if ($(passwordInput).prop('type') === 'text') {
        $(passwordInput).prop('type', 'password');
        $button.find('i').removeClass('fa-eye-slash');
        $button.find('i').addClass('fa-eye');
      } else {
        $(passwordInput).prop('type', 'text');
        $button.find('i').removeClass('fa-eye');
        $button.find('i').addClass('fa-eye-slash');
      }
    });

    const $div = $('<div style="position: relative"></div>');
    $(passwordInput).parent().append($div);
    $(passwordInput).appendTo($div);
    $(passwordInput).css('padding-right', '44px');
    $div.append($button);
  }
};
