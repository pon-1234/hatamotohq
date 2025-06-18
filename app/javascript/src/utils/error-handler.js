/**
 * Global Error Handler Utility
 */

import axios from 'axios';
import store from '../stores';

// Error types
export const ErrorTypes = {
  NETWORK: 'NETWORK_ERROR',
  VALIDATION: 'VALIDATION_ERROR',
  AUTHENTICATION: 'AUTHENTICATION_ERROR',
  AUTHORIZATION: 'AUTHORIZATION_ERROR',
  NOT_FOUND: 'NOT_FOUND_ERROR',
  SERVER: 'SERVER_ERROR',
  UNKNOWN: 'UNKNOWN_ERROR'
};

// Error messages (Japanese)
const ErrorMessages = {
  [ErrorTypes.NETWORK]: 'ネットワークエラーが発生しました。接続を確認してください。',
  [ErrorTypes.VALIDATION]: '入力内容に誤りがあります。',
  [ErrorTypes.AUTHENTICATION]: 'ログインが必要です。',
  [ErrorTypes.AUTHORIZATION]: 'この操作を実行する権限がありません。',
  [ErrorTypes.NOT_FOUND]: 'リソースが見つかりません。',
  [ErrorTypes.SERVER]: 'サーバーエラーが発生しました。しばらく後に再試行してください。',
  [ErrorTypes.UNKNOWN]: '予期しないエラーが発生しました。'
};

/**
 * Determine error type from response
 * @param {Error|Object} error 
 * @returns {string} Error type
 */
export function getErrorType(error) {
  if (!error.response) {
    return ErrorTypes.NETWORK;
  }

  const status = error.response.status;
  
  switch (status) {
    case 400:
    case 422:
      return ErrorTypes.VALIDATION;
    case 401:
      return ErrorTypes.AUTHENTICATION;
    case 403:
      return ErrorTypes.AUTHORIZATION;
    case 404:
      return ErrorTypes.NOT_FOUND;
    case 500:
    case 502:
    case 503:
    case 504:
      return ErrorTypes.SERVER;
    default:
      return ErrorTypes.UNKNOWN;
  }
}

/**
 * Extract error message from response
 * @param {Error|Object} error 
 * @returns {string} Error message
 */
export function getErrorMessage(error) {
  // Custom error message from response
  if (error.response?.data?.message) {
    return error.response.data.message;
  }
  
  if (error.response?.data?.error) {
    return error.response.data.error;
  }
  
  if (error.response?.data?.errors) {
    const errors = error.response.data.errors;
    if (typeof errors === 'object') {
      // Rails-style errors
      const firstKey = Object.keys(errors)[0];
      if (Array.isArray(errors[firstKey])) {
        return errors[firstKey][0];
      }
      return errors[firstKey];
    }
    return errors;
  }

  // Default message based on error type
  const errorType = getErrorType(error);
  return ErrorMessages[errorType] || ErrorMessages[ErrorTypes.UNKNOWN];
}

/**
 * Extract validation errors from response
 * @param {Error|Object} error 
 * @returns {Object} Validation errors
 */
export function getValidationErrors(error) {
  if (!error.response?.data?.errors) {
    return {};
  }

  const errors = error.response.data.errors;
  
  // Convert Rails-style errors to simple key-value pairs
  if (typeof errors === 'object') {
    const result = {};
    Object.keys(errors).forEach(key => {
      if (Array.isArray(errors[key])) {
        result[key] = errors[key].join(', ');
      } else {
        result[key] = errors[key];
      }
    });
    return result;
  }

  return {};
}

/**
 * Handle error with appropriate action
 * @param {Error|Object} error 
 * @param {Object} options
 */
export function handleError(error, options = {}) {
  const {
    showToast = true,
    logError = true,
    redirectOnAuth = true
  } = options;

  const errorType = getErrorType(error);
  const errorMessage = getErrorMessage(error);

  // Log error
  if (logError) {
    console.error('Error occurred:', {
      type: errorType,
      message: errorMessage,
      error: error
    });
  }

  // Handle authentication errors
  if (errorType === ErrorTypes.AUTHENTICATION && redirectOnAuth) {
    store.dispatch('auth/logout');
    window.location.href = '/login';
    return;
  }

  // Show toast notification
  if (showToast && window.toastr) {
    window.toastr.error(errorMessage);
  }

  // Return formatted error
  return {
    type: errorType,
    message: errorMessage,
    validationErrors: getValidationErrors(error),
    originalError: error
  };
}

/**
 * Setup global error interceptor for Axios
 */
export function setupErrorInterceptor() {
  axios.interceptors.response.use(
    response => response,
    error => {
      // Don't handle cancelled requests
      if (axios.isCancel(error)) {
        return Promise.reject(error);
      }

      // Handle global errors
      const errorType = getErrorType(error);
      
      // Auto logout on authentication error
      if (errorType === ErrorTypes.AUTHENTICATION) {
        handleError(error);
      }

      return Promise.reject(error);
    }
  );
}

/**
 * Error handler mixin for Vue components
 */
export const ErrorHandlerMixin = {
  data() {
    return {
      error: null,
      validationErrors: {},
      loading: false
    };
  },
  methods: {
    async handleRequest(requestFn, options = {}) {
      this.loading = true;
      this.error = null;
      this.validationErrors = {};

      try {
        const result = await requestFn();
        this.loading = false;
        return result;
      } catch (error) {
        this.loading = false;
        const handledError = handleError(error, options);
        
        this.error = handledError.message;
        this.validationErrors = handledError.validationErrors;

        if (options.throwError) {
          throw handledError;
        }

        return null;
      }
    },
    
    clearErrors() {
      this.error = null;
      this.validationErrors = {};
    },

    hasError(field) {
      return !!this.validationErrors[field];
    },

    getError(field) {
      return this.validationErrors[field] || '';
    }
  }
};

/**
 * Retry failed request with exponential backoff
 * @param {Function} requestFn 
 * @param {Object} options 
 */
export async function retryRequest(requestFn, options = {}) {
  const {
    maxRetries = 3,
    initialDelay = 1000,
    maxDelay = 10000,
    shouldRetry = (error) => {
      const errorType = getErrorType(error);
      return errorType === ErrorTypes.NETWORK || errorType === ErrorTypes.SERVER;
    }
  } = options;

  let lastError;
  let delay = initialDelay;

  for (let i = 0; i < maxRetries; i++) {
    try {
      return await requestFn();
    } catch (error) {
      lastError = error;
      
      if (!shouldRetry(error) || i === maxRetries - 1) {
        throw error;
      }

      await new Promise(resolve => setTimeout(resolve, delay));
      delay = Math.min(delay * 2, maxDelay);
    }
  }

  throw lastError;
}

/**
 * Create error boundary component
 */
export const ErrorBoundary = {
  name: 'ErrorBoundary',
  props: {
    fallback: {
      type: String,
      default: 'エラーが発生しました'
    }
  },
  data() {
    return {
      hasError: false,
      error: null
    };
  },
  errorCaptured(error, instance, info) {
    console.error('Error captured:', error, info);
    this.hasError = true;
    this.error = error;
    return false;
  },
  render(h) {
    if (this.hasError) {
      return h('div', {
        class: 'error-boundary alert alert-danger'
      }, [
        h('p', this.fallback),
        h('details', {
          style: { whiteSpace: 'pre-wrap' }
        }, this.error?.toString())
      ]);
    }
    return this.$slots.default[0];
  }
};