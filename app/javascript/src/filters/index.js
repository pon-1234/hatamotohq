import moment from 'moment-timezone';
import _ from 'lodash';

// Custom filter functions for Vue 3
// In Vue 3, filters are removed. Use global properties or methods instead.

export const formatted_time = (value) => {
  if (!value) return '';
  value = value.toString();
  return moment(value).tz('Asia/Tokyo').format('YYYY年MM月DD日 HH:mm');
};

export const formatted_date = (value) => {
  if (!value) return '';
  value = value.toString();
  return moment(value).tz('Asia/Tokyo').format('YYYY年MM月DD日');
};

export const truncate = (value, length) => {
  if (!value) return '';
  return _.truncate(value, {
    length: length
  });
};

export const number_to_percent = (value) => {
  value = _.isFinite(value) ? _.round(value * 100, 2) : 0;
  return `${value.toString()} %`;
};

// Export all filters as an object for easy registration
export default {
  formatted_time,
  formatted_date,
  truncate,
  number_to_percent
};
