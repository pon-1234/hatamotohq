
export function omitDeep(input, props) {
  function omitDeepOnOwnProps(obj) {
    if (typeof input === 'undefined') {
      return input;
    }

    if (!Array.isArray(obj) && !isObject(obj)) {
      return obj;
    }

    if (Array.isArray(obj)) {
      return omitDeep(obj, props);
    }

    const o = {};
    for (const [key, value] of Object.entries(obj)) {
      o[key] = !isNil(value) ? omitDeep(value, props) : value;
    }

    return window._.omit(o, props);
  }

  if (arguments.length > 2) {
    props = Array.prototype.slice.call(arguments).slice(1);
  }

  if (Array.isArray(input)) {
    return input.map(omitDeepOnOwnProps);
  }

  return omitDeepOnOwnProps(input);
};

function isNil(value) {
  return value === null || value === undefined;
}

function isObject(obj) {
  return Object.prototype.toString.call(obj) === '[object Object]';
}
