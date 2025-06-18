// Entry point for the build script in your package.json
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
// Temporarily disable vue2-google-maps due to build issues
// import * as VueGoogleMaps from 'vue2-google-maps';
const VueGoogleMaps = null;
import Clipboard from 'v-clipboard';
import VTooltip from 'v-tooltip';
import CKEditor from '@ckeditor/ckeditor5-vue2';
import VueLazyload from 'vue-lazyload';
import * as bootstrap from "bootstrap";
import Multiselect from 'vue-multiselect';
// import VueQRCodeComponent from 'vue-qrcode-component'; // TODO: Fix Vue component loading
import GAuth from 'vue-google-oauth2';

import {
  BootstrapVue,
  DropdownPlugin,
  TabsPlugin
} from 'bootstrap-vue';
// Import constant
import * as constant from './src/core/constant';
import 'vue-select/dist/vue-select.css';
import store from './src/stores';
import './src/filters';
import Rails from '@rails/ujs';

Rails.start();

const jQuery = require('jquery');
window.$ = jQuery;
window._ = require('lodash');
const toastr = require('toastr');
window.toastr = toastr;
window.emojione = require('./src/lib/emojione');
window.emojionearea = require('./src/lib/emojionearea');
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
// Temporarily disable VueGoogleMaps
// Vue.use(VueGoogleMaps, {
//   load: {
//     key: process.env.MIX_GOOGLE_MAP_KEY,
//     libraries: 'places'
//   }
// });
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
// Vue.component('qr-code', VueQRCodeComponent); // TODO: Fix Vue component loading
Vue.use(VeeValidate, { fieldsBagName: 'veeFields', locale: 'ja' });

// Temporarily disable Google Auth until client ID is configured
// const gauthOption = {
//   clientId: process.env.GOOGLE_OAUTH_CLIENT_ID,
//   scope: 'email https://www.googleapis.com/auth/spreadsheets',
//   plugin_name: 'lineCrm',
//   prompt: 'consent',
//   fetch_basic_profile: false
// };
// Vue.use(GAuth, gauthOption);

Validator.localize('ja', ja);
Validator.extend('email', value => {
  var pattern = new RegExp('^\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$');
  return !!pattern.test(value);
});
// END: vee-validation configuration

// Import all Vue components
// Note: With esbuild, we need to explicitly import components instead of using require.context
// Import session components
import UserSessionNew from './src/page/user/session/UserSessionNew.vue';
import AdminSessionNew from './src/page/admin/session/AdminSessionNew.vue';
import AgencySessionNew from './src/page/agency/session/AgencySessionNew.vue';

// Import common components
import InputPassword from './src/components/input/InputPassword.vue';
import ErrorMessage from './src/components/common/ErrorMessage.vue';

// Import user page components
import ScenarioIndex from './src/page/user/scenario/ScenarioIndex.vue';
import ChannelIndex from './src/page/user/channel/ChannelIndex.vue';
import FriendIndex from './src/page/user/friend/FriendIndex.vue';
import BroadcastIndex from './src/page/user/broadcast/BroadcastIndex.vue';
import AutoResponseIndex from './src/page/user/auto-response/AutoResponseIndex.vue';
import TemplateIndex from './src/page/user/template/TemplateIndex.vue';
import RichMenuIndex from './src/page/user/richmenu/RichMenuIndex.vue';
import SurveyIndex from './src/page/user/survey/SurveyIndex.vue';
import ReminderIndex from './src/page/user/reminder/ReminderIndex.vue';
import TagIndex from './src/page/user/tag/TagIndex.vue';
import StaffIndex from './src/page/user/staff/StaffIndex.vue';
import VariableIndex from './src/page/user/variable/VariableIndex.vue';

// Import admin page components
import AdminAccountIndex from './src/page/admin/account/AdminAccountIndex.vue';
import AdminUserIndex from './src/page/admin/user/AdminUserIndex.vue';
import AgencyIndex from './src/page/admin/agency/AgencyIndex.vue';
import AnnouncementIndex from './src/page/admin/announcement/AnnouncementIndex.vue';

// Import agency page components
import ClientIndex from './src/page/agency/client/ClientIndex.vue';

// Register components
Vue.component('user-session-new', UserSessionNew);
Vue.component('admin-session-new', AdminSessionNew);
Vue.component('agency-session-new', AgencySessionNew);
Vue.component('input-password', InputPassword);
Vue.component('error-message', ErrorMessage);

// Register user components
Vue.component('scenario-index', ScenarioIndex);
Vue.component('channel-index', ChannelIndex);
Vue.component('friend-index', FriendIndex);
Vue.component('broadcast-index', BroadcastIndex);
Vue.component('auto-response-index', AutoResponseIndex);
Vue.component('template-index', TemplateIndex);
Vue.component('rich-menu-index', RichMenuIndex);
Vue.component('survey-index', SurveyIndex);
Vue.component('reminder-index', ReminderIndex);
Vue.component('tag-index', TagIndex);
Vue.component('staff-index', StaffIndex);
Vue.component('variable-index', VariableIndex);

// Register admin components
Vue.component('admin-account-index', AdminAccountIndex);
Vue.component('admin-user-index', AdminUserIndex);
Vue.component('agency-index', AgencyIndex);
Vue.component('announcement-index', AnnouncementIndex);

// Register agency components
Vue.component('client-index', ClientIndex);

// TODO: Import other components as needed

// We have to re-create vue app when change the page url
jQuery(() => {
  const app = document.getElementById('application');
  if (app) {
    new Vue({
      el: '#application',
      locale: 'ja',
      store
    });
  }
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
