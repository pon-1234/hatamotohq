import Viewer from 'viewerjs'
import 'viewerjs/dist/viewer.css'

// v-viewer directive for Vue 3
export const vViewer = {
  mounted(el, binding) {
    // Default options
    const defaultOptions = {
      navbar: true,
      title: true,
      toolbar: true,
      tooltip: true,
      movable: true,
      zoomable: true,
      rotatable: true,
      scalable: true,
      transition: true,
      fullscreen: true,
      keyboard: true
    }

    // Merge with user options
    const options = { ...defaultOptions, ...binding.value }

    // Create viewer instance
    el._viewer = new Viewer(el, options)
  },

  updated(el, binding) {
    // Update viewer if options changed
    if (el._viewer && binding.value !== binding.oldValue) {
      el._viewer.destroy()
      el._viewer = new Viewer(el, binding.value)
    }
  },

  unmounted(el) {
    // Cleanup
    if (el._viewer) {
      el._viewer.destroy()
      delete el._viewer
    }
  }
}

export default {
  install(app) {
    app.directive('viewer', vViewer)
  }
} 