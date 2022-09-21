import '../stylesheets/application'; // This file will contain your custom CSS
import Vue from 'vue';
import VeeValidate, { Validator, ValidationObserver, ValidationProvider } from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';
import Chartkick from 'vue-chartkick';
import { Datetime } from 'vue-datetime';
import { Settings } from 'luxon';
import 'vue-datetime/dist/vue-datetime.css';
import DateRangePicker from 'vue2-daterange-picker';
import 'vue2-daterange-picker/dist/vue2-daterange-picker';
import vSelect from 'vue-select';
import * as VueGoogleMaps from 'vue2-google-maps';
import Clipboard from 'v-clipboard';
import VTooltip from 'v-tooltip';
import CKEditor from '@ckeditor/ckeditor5-vue2';
import VueLazyload from 'vue-lazyload';
import 'bootstrap/js/dist/modal';
import Multiselect from 'vue-multiselect';
import VueQRCodeComponent from 'vue-qrcode-component';
import GAuth from 'vue-google-oauth2';

import {
  BootstrapVue,
  DropdownPlugin,
  TabsPlugin
} from 'bootstrap-vue';
// Import constant
import * as constant from '@/core/constant';
import 'vue-select/dist/vue-select.css';
import store from '../src/stores';
import '../src/filters';
import Rails from '@rails/ujs';

Rails.start();

const jQuery = require('jquery');
window.$ = jQuery;
window._ = require('lodash');
const toastr = require('toastr');
window.toastr = toastr;
window.emojione = require('../src/lib/emojione');
window.emojionearea = require('../src/lib/emojionearea');
Object.keys(constant).forEach((key) => {
  Vue.prototype[key] = constant[key];
});

require('@rails/activestorage').start();
require('chart.js');

Vue.config.devtools = true;
Vue.use(Chartkick);
Vue.use(Datetime);
Settings.defaultLocale = 'ja';
Vue.use(DateRangePicker);
Vue.component('v-select', vSelect);
Vue.use(VueGoogleMaps, {
  load: {
    key: process.env.MIX_GOOGLE_MAP_KEY,
    libraries: 'places'
  }
});
Vue.use(BootstrapVue);
Vue.use(DropdownPlugin);
Vue.use(TabsPlugin);
Vue.use(Clipboard);
Vue.use(VTooltip);
Vue.use(CKEditor);
Vue.component('multiselect', Multiselect);
// Lazy loading image
Vue.use(VueLazyload, {
  preLoad: 1.3,
  error: '/images/no-image.png',
  loading: '/images/loading.gif',
  attempt: 1
});
// START: vee-validation configuration
Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);
Vue.component('qr-code', VueQRCodeComponent);
Vue.use(VeeValidate, { fieldsBagName: 'veeFields', locale: 'ja' });

const gauthOption = {
  clientId: process.env.GOOGLE_OAUTH_CLIENT_ID || '',
  scope: 'email',
  plugin_name: 'lineCrm',
  prompt: 'consent',
  fetch_basic_profile: true
};
Vue.use(GAuth, gauthOption);

Validator.localize('ja', ja);
Validator.extend('email', value => {
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
jQuery(() => {
  new Vue({
    locale: 'ja',
    store
  }).$mount('#application');
});

toastr.options = {
  closeButton: true,
  debug: false,
  newestOnTop: true,
  progressBar: false,
  positionClass: 'toast-top-right',
  preventDuplicates: true,
  onclick: null,
  showDuration: '300',
  hideDuration: '500',
  timeOut: '2000',
  extendedTimeOut: '1000',
  showEasing: 'swing',
  hideEasing: 'linear',
  showMethod: 'fadeIn',
  hideMethod: 'fadeOut'
};

// Unauthenticated detection
$(document).ajaxError((e, xhr, settings) => {
  if (xhr.status === 401) {
    location.reload();
  }
});