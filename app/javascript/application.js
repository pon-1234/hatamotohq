// Entry point for the build script in your package.json
import { createApp } from 'vue';
import * as Vue from 'vue';
import VeeValidate, { Validator, ValidationObserver, ValidationProvider } from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';
import Chartkick from 'vue-chartkick';
import { Datetime } from 'vue-datetime';
import { Settings } from 'luxon';
import 'vue-datetime/dist/vue-datetime.css';
import DateRangePicker from 'vue2-daterange-picker';
import 'vue2-daterange-picker/dist/vue2-daterange-picker.css';
import vSelect from 'vue-select';
// import * as VueGoogleMaps from 'vue2-google-maps';
const VueGoogleMaps = null;
import Clipboard from 'v-clipboard';
import VTooltip from 'v-tooltip';
import CKEditor from '@ckeditor/ckeditor5-vue2';
import VueLazyload from 'vue-lazyload';
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

require('@rails/activestorage').start();
require('chart.js');

Vue.configureCompat({
  MODE: 2,
  GLOBAL_MOUNT: true,
  GLOBAL_EXTEND: true,
  GLOBAL_PROTOTYPE: true,
  RENDER_FUNCTION: true,
  INSTANCE_DESTROY: true,
  INSTANCE_EVENT_EMITTER: true,
  COMPONENT_V_MODEL: true,
  COMPONENT_ASYNC: true,
  TRANSITION_GROUP_ROOT: true,
  ATTR_FALSE_VALUE: true,
  CUSTOM_DIR: true,
  V_FOR_REF: true,
  FILTER: true
});

Settings.defaultLocale = 'ja';

// VeeValidate configuration
Validator.localize('ja', ja);
Validator.extend('email', value => {
  var pattern = new RegExp('^\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$');
  return !!pattern.test(value);
});

// Import all Vue components
// Note: With esbuild, we need to explicitly import components instead of using require.context
// Import session components
import UserSessionNew from './src/page/user/session/UserSessionNew.vue';
import AdminSessionNew from './src/page/admin/session/AdminSessionNew.vue';
import AgencySessionNew from './src/page/agency/session/AgencySessionNew.vue';

// Import common components
import InputPassword from './src/components/input/InputPassword.vue';
import ErrorMessage from './src/components/common/ErrorMessage.vue';
import HelloVue3 from './src/components/common/HelloVue3.vue';

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


// TODO: Import other components as needed

// We have to re-create vue app when change the page url
jQuery(() => {
  const appElement = document.getElementById('application');
  if (appElement) {
    const app = createApp({
      locale: 'ja'
    });
    
    // Configure app
    app.config.devtools = true;
    
    // Add global properties (replacing Vue.prototype)
    Object.keys(constant).forEach((key) => {
      app.config.globalProperties[key] = constant[key];
    });
    
    // Register plugins
    app.use(store);
    app.use(Chartkick);
    app.use(Datetime);
    app.use(DateRangePicker);
    app.use(BootstrapVue);
    app.use(DropdownPlugin);
    app.use(TabsPlugin);
    app.use(Clipboard);
    app.use(VTooltip);
    app.use(CKEditor);
    app.use(VueLazyload, {
      preLoad: 1.3,
      error: '/images/no-image.png',
      loading: '/images/loading.gif',
      attempt: 1
    });
    app.use(VeeValidate, { fieldsBagName: 'veeFields', locale: 'ja' });
    
    // Register Google Maps if API key is available
    if (process.env.MIX_GOOGLE_MAP_KEY) {
      app.use(VueGoogleMaps, {
        load: {
          key: process.env.MIX_GOOGLE_MAP_KEY,
          libraries: 'places'
        }
      });
    }
    
    // Temporarily disable Google Auth until client ID is configured
    // if (process.env.GOOGLE_OAUTH_CLIENT_ID) {
    //   app.use(GAuth, {
    //     clientId: process.env.GOOGLE_OAUTH_CLIENT_ID,
    //     scope: 'email https://www.googleapis.com/auth/spreadsheets',
    //     prompt: 'consent'
    //   });
    // }
    
    // Register global components
    app.component('v-select', vSelect);
    app.component('multiselect', Multiselect);
    // app.component('qr-code', VueQRCodeComponent); // TODO: Fix Vue component loading
    app.component('ValidationProvider', ValidationProvider);
    app.component('ValidationObserver', ValidationObserver);
    
    // Register all components that were previously globally registered
    app.component('user-session-new', UserSessionNew);
    app.component('admin-session-new', AdminSessionNew);
    app.component('agency-session-new', AgencySessionNew);
    app.component('input-password', InputPassword);
    app.component('error-message', ErrorMessage);
    app.component('hello-vue3', HelloVue3);
    
    // Register user components
    app.component('scenario-index', ScenarioIndex);
    app.component('channel-index', ChannelIndex);
    app.component('friend-index', FriendIndex);
    app.component('broadcast-index', BroadcastIndex);
    app.component('auto-response-index', AutoResponseIndex);
    app.component('template-index', TemplateIndex);
    app.component('rich-menu-index', RichMenuIndex);
    app.component('survey-index', SurveyIndex);
    app.component('reminder-index', ReminderIndex);
    app.component('tag-index', TagIndex);
    app.component('staff-index', StaffIndex);
    app.component('variable-index', VariableIndex);
    
    // Register admin components
    app.component('admin-account-index', AdminAccountIndex);
    app.component('admin-user-index', AdminUserIndex);
    app.component('agency-index', AgencyIndex);
    app.component('announcement-index', AnnouncementIndex);
    
    // Register agency components
    app.component('client-index', ClientIndex);
    
    app.mount('#application');
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
