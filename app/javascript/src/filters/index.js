import Vue from 'vue';
import moment from 'moment-timezone';

// Custom filters
Vue.filter('formatted_time', (value) => {
  if (!value) return '';
  value = value.toString();
  return moment(value).tz('Asia/Tokyo').format('YYYY年MM月DD日 HH:mm');
});

Vue.filter('formatted_date', (value) => {
  if (!value) return '';
  value = value.toString();
  return moment(value).tz('Asia/Tokyo').format('YYYY年MM月DD日');
});

Vue.filter('formatted_time_without_minute', (value) => {
  if (!value) return '';
  value = value.toString();
  return moment(value).tz('Asia/Tokyo').format('YYYY.MM.DD HH時');
});

Vue.filter('truncate', (value, length) => {
  if (!value) return '';
  return _.truncate(value, {
    length: length
  });
});

Vue.filter('numberToPercent', (value) => {
  value = value.toFixed(2) * 100;
  return `${value.toString()} %`;
});