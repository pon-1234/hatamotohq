import '../stylesheets/application'; // This file will contain your custom CSS
import Vue from 'vue';
import { ValidationProvider, ValidationObserver, localize, extend } from 'vee-validate';
import ja from '../strings/validator/ja.json';
import 'bootstrap';
import * as rules from 'vee-validate/dist/rules';
import Chartkick from 'vue-chartkick';
import { Datetime } from 'vue-datetime';
import 'vue-datetime/dist/vue-datetime.css';
import DateRangePicker from 'vue2-daterange-picker';
import 'vue2-daterange-picker/dist/vue2-daterange-picker';
import vSelect from 'vue-select';
import 'vue-select/dist/vue-select.css';
import store from '../src/stores';

// Action cable
// import '../channels/conversation_channel';

const jQuery = require('jquery');
window.$ = jQuery;
window._ = require('lodash');
const toastr = require('toastr');
window.toastr = toastr;
require('@rails/ujs').start();
require('turbolinks').start();
require('@rails/activestorage').start();
require('admin-lte');
require('chart.js');

// Plugin configurations
Vue.config.devtools = true;
Vue.use(Chartkick);
Vue.use(Datetime);
Vue.use(DateRangePicker);
Vue.component('v-select', vSelect);

// START: vee-validation configuration
Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);
localize('ja', ja);

Object.keys(rules).forEach(rule => {
  extend(rule, rules[rule]);
});

extend('url', value => {
  var pattern = new RegExp('^(https?:\\/\\/)?' + // protocol
    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|' + // domain name
    '((\\d{1,3}\\.){3}\\d{1,3}))' + // OR ip (v4) address
    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + // port and path
    '(\\?[;&a-z\\d%_.~+=-]*)?' + // query string
    '(\\#[-a-z\\d_]*)?$', 'i'); // fragment locator
  return !!pattern.test(value);
});

extend('email', value => {
  var pattern = new RegExp('^\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$');
  return !!pattern.test(value);
});
// END: vee-validation configuration

// Automatically import components
const files = require.context('../src', true, /\.vue$/i);
files.keys().map((key) => {
  const component = key
    .split('/')
    .pop()
    .split('.')[0];
  Vue.component(component, files(key).default);
});

// We have to re-create vue app when change the page url
document.addEventListener('turbolinks:load', () => {
  new Vue({
    locale: 'ja',
    store
  }).$mount('#application');
});

toastr.options = {
  closeButton: false,
  positionClass: 'toast-top-right',
  preventDuplicates: true,
  onclick: null,
  showDuration: '500',
  hideDuration: '500',
  timeOut: '5000',
  extendedTimeOut: '1000',
  showEasing: 'swing',
  hideEasing: 'linear',
  showMethod: 'fadeIn',
  hideMethod: 'fadeOut'
};
