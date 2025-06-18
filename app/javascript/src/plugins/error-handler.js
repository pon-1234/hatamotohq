/**
 * Vue Error Handler Plugin
 */

import { handleError, ErrorHandlerMixin, ErrorBoundary } from '../utils/error-handler';

export default {
  install(Vue, options = {}) {
    // Global error handler
    Vue.config.errorHandler = (error, vm, info) => {
      console.error('Vue Error:', error, info);
      
      // Log to error tracking service if configured
      if (options.errorTracker) {
        options.errorTracker.captureException(error, {
          extra: {
            componentName: vm?.$options.name || 'Unknown',
            errorInfo: info
          }
        });
      }

      // Show user-friendly error message
      handleError(error, {
        showToast: true,
        logError: true
      });
    };

    // Global warning handler
    Vue.config.warnHandler = (msg, vm, trace) => {
      console.warn('Vue Warning:', msg, trace);
      
      // Log warnings in development only
      if (process.env.NODE_ENV === 'development') {
        console.trace();
      }
    };

    // Add global error handler method
    Vue.prototype.$handleError = function(error, options = {}) {
      return handleError(error, {
        ...options,
        vm: this
      });
    };

    // Add error handler mixin globally (optional)
    if (options.globalMixin) {
      Vue.mixin(ErrorHandlerMixin);
    }

    // Register ErrorBoundary component
    Vue.component('ErrorBoundary', ErrorBoundary);

    // Add convenient error methods
    Vue.prototype.$showError = function(message, title = 'エラー') {
      if (this.$bvToast) {
        this.$bvToast.toast(message, {
          title,
          variant: 'danger',
          solid: true
        });
      } else if (window.toastr) {
        window.toastr.error(message, title);
      } else {
        console.error(title, message);
      }
    };

    Vue.prototype.$showSuccess = function(message, title = '成功') {
      if (this.$bvToast) {
        this.$bvToast.toast(message, {
          title,
          variant: 'success',
          solid: true
        });
      } else if (window.toastr) {
        window.toastr.success(message, title);
      } else {
        console.log(title, message);
      }
    };

    Vue.prototype.$showWarning = function(message, title = '警告') {
      if (this.$bvToast) {
        this.$bvToast.toast(message, {
          title,
          variant: 'warning',
          solid: true
        });
      } else if (window.toastr) {
        window.toastr.warning(message, title);
      } else {
        console.warn(title, message);
      }
    };

    Vue.prototype.$showInfo = function(message, title = '情報') {
      if (this.$bvToast) {
        this.$bvToast.toast(message, {
          title,
          variant: 'info',
          solid: true
        });
      } else if (window.toastr) {
        window.toastr.info(message, title);
      } else {
        console.info(title, message);
      }
    };

    // Async error wrapper
    Vue.prototype.$tryAsync = async function(asyncFn, options = {}) {
      try {
        return await asyncFn();
      } catch (error) {
        this.$handleError(error, options);
        if (options.rethrow) {
          throw error;
        }
        return null;
      }
    };

    // Form validation helper
    Vue.prototype.$validateForm = function(formRef) {
      return new Promise((resolve, reject) => {
        this.$refs[formRef].validate((valid) => {
          if (valid) {
            resolve(true);
          } else {
            this.$showError('入力内容を確認してください。');
            reject(new Error('Validation failed'));
          }
        });
      });
    };

    // API request wrapper with error handling
    Vue.prototype.$apiRequest = async function(requestFn, options = {}) {
      const {
        loadingKey = 'loading',
        errorKey = 'error',
        successMessage = null,
        errorMessage = null
      } = options;

      // Set loading state
      if (this[loadingKey] !== undefined) {
        this[loadingKey] = true;
      }

      try {
        const result = await requestFn();
        
        // Clear loading state
        if (this[loadingKey] !== undefined) {
          this[loadingKey] = false;
        }

        // Show success message
        if (successMessage) {
          this.$showSuccess(successMessage);
        }

        return result;
      } catch (error) {
        // Clear loading state
        if (this[loadingKey] !== undefined) {
          this[loadingKey] = false;
        }

        // Handle error
        const handledError = this.$handleError(error, {
          showToast: !errorMessage
        });

        // Show custom error message if provided
        if (errorMessage) {
          this.$showError(errorMessage);
        }

        // Set error state
        if (this[errorKey] !== undefined) {
          this[errorKey] = handledError.message;
        }

        // Re-throw if requested
        if (options.rethrow) {
          throw handledError;
        }

        return null;
      }
    };
  }
};