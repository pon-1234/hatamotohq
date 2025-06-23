// Entry point for the build script in your package.json
import { createApp } from 'vue';
// VeeValidate v4
import './src/core/vee-validate';
// import ValidationProvider from './src/components/validation/ValidationProvider.vue'; // REMOVE THIS
// import ValidationObserver from './src/components/validation/ValidationObserver.vue'; // REMOVE THIS
import VueChartkick from 'vue-chartkick';
import 'chartkick';
// import { Datetime } from 'vue-datetime'; // Replaced with @vuepic/vue-datepicker
import { Settings } from 'luxon';
// import 'vue-datetime/dist/vue-datetime.css';
import Datetime from './src/components/datetime/Datetime.vue';
// import DateRangePicker from 'vue2-daterange-picker'; // TODO: Replace with Vue 3 compatible version
// import 'vue2-daterange-picker/dist/vue2-daterange-picker.css';
import vSelect from 'vue-select';
import VueGoogleMaps from '@fawmi/vue-google-maps';
// import Clipboard from 'v-clipboard'; // Replaced with vue-clipboard3
import ClipboardPlugin from './src/directives/clipboard';
import Directives from './src/directives';
import BaseComponents from './src/components/base';
import FloatingVue from 'floating-vue';
import 'floating-vue/dist/style.css';
import { CkeditorPlugin } from '@ckeditor/ckeditor5-vue';
import VueLazyload from 'vue3-lazyload';
// import Multiselect from 'vue-multiselect'; // Replaced with @vueform/multiselect
import Multiselect from './src/components/multiselect/Multiselect.vue';
import QrcodeVue from 'qrcode.vue';
import vue3GoogleOauth from 'vue3-google-oauth2';

// Bootstrap-Vue migration completed - all components replaced with custom base components
// Import constant
import * as constant from './src/core/constant';
import 'vue-select/dist/vue-select.css';
import store from './src/stores';
import filters from './src/filters';
import Rails from '@rails/ujs';

Rails.start();

import jQuery from 'jquery';
import _ from 'lodash';
import toastr from 'toastr';
// Emojione libraries will be loaded as UMD modules
import './src/lib/emojione';
import './src/lib/emojionearea';
import * as ActiveStorage from '@rails/activestorage';

window.$ = jQuery;
window.jQuery = jQuery;
window._ = _;
window.toastr = toastr;
// emojione and emojionearea are loaded as UMD modules and available globally

ActiveStorage.start();

// Vue 3 native mode - no compatibility needed
// window.Vue = Vue; // Removed - no longer needed for Vue 3 mode

Settings.defaultLocale = 'ja';

// VeeValidate v4 is configured in src/core/vee-validate.js

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
import DatetimeComponent from './src/components/datetime/Datetime.vue';

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

// Vueアプリケーションの初期化ロジック
console.log('Vue initialization: Checking for application element...');
const appElement = document.getElementById('application');
console.log('Application element found:', appElement);

if (appElement) {
  console.log('Creating Vue app...');
  const app = createApp({
    locale: 'ja'
  });
  
  // Configure app
  app.config.devtools = true;
  
  // Add global properties (replacing Vue.prototype)
  Object.keys(constant).forEach((key) => {
    app.config.globalProperties[key] = constant[key];
  });
  
  // Register filters as global properties (Vue 3 doesn't have filters)
  Object.keys(filters).forEach((key) => {
    app.config.globalProperties[`$${key}`] = filters[key];
  });
  
  // Register plugins
  app.use(store);
  app.use(VueChartkick);
  // Datetime is now a component, not a plugin
  // app.use(DateRangePicker); // TODO: Replace with Vue 3 compatible version
  // Bootstrap-Vue removed - using custom base components instead
  app.use(BaseComponents);
  app.use(ClipboardPlugin);
  app.use(Directives);
  app.use(FloatingVue);
  app.use(CkeditorPlugin);
  app.use(VueLazyload, {
    preLoad: 1.3,
    error: '/images/no-image.png',
    loading: '/images/loading.gif',
    attempt: 1
  });
  // VeeValidate v4 doesn't need app.use() - rules are registered globally
  
  // Register Google Maps if API key is available
  if (import.meta.env.VITE_GOOGLE_MAP_KEY) {
    app.use(VueGoogleMaps, {
      load: {
        key: import.meta.env.VITE_GOOGLE_MAP_KEY,
        libraries: 'places'
      }
    });
  }
  
  // Google OAuth configuration
  if (import.meta.env.VITE_GOOGLE_OAUTH_CLIENT_ID) {
    app.use(vue3GoogleOauth, {
      clientId: import.meta.env.VITE_GOOGLE_OAUTH_CLIENT_ID,
      scope: 'email https://www.googleapis.com/auth/spreadsheets',
      prompt: 'consent'
    });
  }
  
  // Register global components
  app.component('v-select', vSelect);
  app.component('multiselect', Multiselect);
  app.component('qrcode-vue', QrcodeVue);
  // app.component('ValidationProvider', ValidationProvider); // REMOVE THIS
  // app.component('ValidationObserver', ValidationObserver); // REMOVE THIS
  
  // Register all components that were previously globally registered
  app.component('user-session-new', UserSessionNew);
  app.component('admin-session-new', AdminSessionNew);
  app.component('agency-session-new', AgencySessionNew);
  app.component('input-password', InputPassword);
  app.component('error-message', ErrorMessage);
  app.component('hello-vue3', HelloVue3);
  app.component('datetime', Datetime);
  
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
  
  console.log('Mounting Vue app to #application...');
  app.mount('#application');
  console.log('Vue app mounted successfully!');
}

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
