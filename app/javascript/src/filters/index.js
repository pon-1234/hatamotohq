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

Vue.filter('truncate', (value, length) => {
  if (!value) return '';
  return _.truncate(value, {
    length: length
  });
});

Vue.filter('number_to_percent', (value) => {
  value = _.isFinite(value) ? _.round(value * 100, 2) : 0;
  return `${value.toString()} %`;
});
