// v-click-outside directive for Vue 3
export const vClickOutside = {
  mounted(el, binding) {
    // Store the event handler on the element
    el._clickOutsideHandler = (event) => {
      // Check if click was outside the element
      if (!el.contains(event.target) && el !== event.target) {
        // Call the provided method
        if (binding.value && typeof binding.value === 'function') {
          binding.value(event)
        }
      }
    }

    // Add event listener
    document.addEventListener('click', el._clickOutsideHandler)
    document.addEventListener('touchstart', el._clickOutsideHandler)
  },

  unmounted(el) {
    // Remove event listener and clean up
    if (el._clickOutsideHandler) {
      document.removeEventListener('click', el._clickOutsideHandler)
      document.removeEventListener('touchstart', el._clickOutsideHandler)
      delete el._clickOutsideHandler
    }
  }
}

export default {
  install(app) {
    app.directive('click-outside', vClickOutside)
  }
} 