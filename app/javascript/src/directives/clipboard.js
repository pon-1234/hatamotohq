import useClipboard from 'vue-clipboard3';

const { toClipboard } = useClipboard();

export const vClipboard = {
  mounted(el, binding) {
    const { value, arg, modifiers } = binding;
    
    // Handle different directive formats
    // v-clipboard:copy="text"
    // v-clipboard:success="handleSuccess"
    // v-clipboard:error="handleError"
    
    if (arg === 'copy' || !arg) {
      el._clipboardValue = value;
      el._clipboardHandler = async (e) => {
        e.preventDefault();
        try {
          await toClipboard(el._clipboardValue);
          if (el._clipboardSuccess) {
            el._clipboardSuccess();
          }
        } catch (error) {
          if (el._clipboardError) {
            el._clipboardError(error);
          }
        }
      };
      el.addEventListener('click', el._clipboardHandler);
    } else if (arg === 'success') {
      el._clipboardSuccess = value;
    } else if (arg === 'error') {
      el._clipboardError = value;
    }
  },
  
  updated(el, binding) {
    const { value, arg } = binding;
    
    if (arg === 'copy' || !arg) {
      el._clipboardValue = value;
    } else if (arg === 'success') {
      el._clipboardSuccess = value;
    } else if (arg === 'error') {
      el._clipboardError = value;
    }
  },
  
  unmounted(el) {
    if (el._clipboardHandler) {
      el.removeEventListener('click', el._clipboardHandler);
      delete el._clipboardHandler;
      delete el._clipboardValue;
      delete el._clipboardSuccess;
      delete el._clipboardError;
    }
  }
};

// Create a plugin for compatibility
export const ClipboardPlugin = {
  install(app) {
    app.directive('clipboard', vClipboard);
  }
};

export default ClipboardPlugin;