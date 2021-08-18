/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */
import Vue from 'vue';
import VueToastr from 'vue-toastr';

import store from './state/store';
import * as VeeValidate from 'vee-validate';
import VueSimpleAlert from 'vue-simple-alert';
import VueCtkDateTimePicker from 'vue-ctk-date-time-picker';
import 'vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css';
import * as VueGoogleMaps from 'vue2-google-maps';
import 'bootstrap-vue/dist/bootstrap-vue.css';
import VeeValidateLocaleJA from 'vee-validate-locale-ja';
import 'vue-datetime/dist/vue-datetime.css';
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';
import { Settings } from 'luxon';
import Clipboard from 'v-clipboard';
import VTooltip from 'v-tooltip';

import {
  BootstrapVue,
  DropdownPlugin,
  TabsPlugin
} from 'bootstrap-vue';

import * as constant from '@/core/constant';

moment.tz.setDefault('Asia/Tokyo');
Settings.defaultLocale = 'ja';
require('./bootstrap');
/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

window._ = require('lodash');

window.emojione = require('./lib/emojione');
window.emojionearea = require('./lib/emojionearea');
Object.keys(constant).forEach((key) => {
  Vue.prototype[key] = constant[key];
});

Vue.use(VueGoogleMaps, {
  load: {
    key: process.env.MIX_GOOGLE_MAP_KEY,
    libraries: 'places'
  }
});
VeeValidate.Validator.localize('ja', VeeValidateLocaleJA);

Vue.use(VueToastr, {});
Vue.use(VeeValidate, { fieldsBagName: 'veeFields', locale: 'ja' });
Vue.component('VueCtkDateTimePicker', VueCtkDateTimePicker);
Vue.component('datetime', Datetime);

Vue.use(BootstrapVue);
Vue.use(DropdownPlugin);
Vue.use(VueSimpleAlert);
Vue.use(TabsPlugin);
Vue.use(Clipboard);
Vue.use(VTooltip);

// Automatically register components
const files = require.context('./', true, /\.vue$/i);
files.keys().map(key => Vue.component(key.split('/').pop().split('.')[0], files(key).default));
/* eslint-disable no-unused-vars */
const app = new Vue({
  el: '#app',
  store
});
