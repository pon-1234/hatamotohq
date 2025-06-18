/**
 * Native Vue Tooltip Directive
 * Replaces Bootstrap-Vue's v-b-tooltip
 */

let tooltipIdCounter = 0;

class TooltipManager {
  constructor() {
    this.tooltips = new Map();
  }

  create(element, options) {
    const tooltipId = `tooltip-${++tooltipIdCounter}`;
    const tooltip = document.createElement('div');
    tooltip.id = tooltipId;
    tooltip.className = 'custom-tooltip';
    tooltip.textContent = options.title || '';
    tooltip.style.cssText = `
      position: absolute;
      background-color: rgba(0, 0, 0, 0.9);
      color: white;
      padding: 0.5rem 0.75rem;
      border-radius: 0.25rem;
      font-size: 0.875rem;
      white-space: nowrap;
      z-index: 9999;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.15s ease-in-out;
      max-width: 300px;
    `;

    // Arrow
    const arrow = document.createElement('div');
    arrow.className = 'tooltip-arrow';
    arrow.style.cssText = `
      position: absolute;
      width: 0;
      height: 0;
      border-style: solid;
    `;
    tooltip.appendChild(arrow);

    document.body.appendChild(tooltip);

    const tooltipData = {
      element,
      tooltip,
      arrow,
      options,
      show: this.show.bind(this, element, tooltip, arrow, options),
      hide: this.hide.bind(this, tooltip),
      update: this.update.bind(this, element, tooltip, arrow, options)
    };

    this.tooltips.set(element, tooltipData);

    // Add event listeners
    if (options.trigger === 'hover' || !options.trigger) {
      element.addEventListener('mouseenter', tooltipData.show);
      element.addEventListener('mouseleave', tooltipData.hide);
    } else if (options.trigger === 'click') {
      element.addEventListener('click', tooltipData.show);
      document.addEventListener('click', (e) => {
        if (!element.contains(e.target) && !tooltip.contains(e.target)) {
          tooltipData.hide();
        }
      });
    } else if (options.trigger === 'focus') {
      element.addEventListener('focus', tooltipData.show);
      element.addEventListener('blur', tooltipData.hide);
    }

    return tooltipData;
  }

  show(element, tooltip, arrow, options) {
    const placement = options.placement || 'top';
    const offset = options.offset || 8;

    // Update content if dynamic
    if (typeof options.title === 'function') {
      tooltip.textContent = options.title();
    } else if (options.title) {
      tooltip.textContent = options.title;
    }

    // Position calculation
    const rect = element.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();

    let top, left;
    const arrowSize = 6;

    switch (placement) {
      case 'top':
        top = rect.top - tooltipRect.height - offset;
        left = rect.left + (rect.width - tooltipRect.width) / 2;
        arrow.style.cssText += `
          bottom: -${arrowSize}px;
          left: 50%;
          transform: translateX(-50%);
          border-width: ${arrowSize}px ${arrowSize}px 0;
          border-color: rgba(0, 0, 0, 0.9) transparent transparent;
        `;
        break;
      case 'bottom':
        top = rect.bottom + offset;
        left = rect.left + (rect.width - tooltipRect.width) / 2;
        arrow.style.cssText += `
          top: -${arrowSize}px;
          left: 50%;
          transform: translateX(-50%);
          border-width: 0 ${arrowSize}px ${arrowSize}px;
          border-color: transparent transparent rgba(0, 0, 0, 0.9);
        `;
        break;
      case 'left':
        top = rect.top + (rect.height - tooltipRect.height) / 2;
        left = rect.left - tooltipRect.width - offset;
        arrow.style.cssText += `
          right: -${arrowSize}px;
          top: 50%;
          transform: translateY(-50%);
          border-width: ${arrowSize}px 0 ${arrowSize}px ${arrowSize}px;
          border-color: transparent transparent transparent rgba(0, 0, 0, 0.9);
        `;
        break;
      case 'right':
        top = rect.top + (rect.height - tooltipRect.height) / 2;
        left = rect.right + offset;
        arrow.style.cssText += `
          left: -${arrowSize}px;
          top: 50%;
          transform: translateY(-50%);
          border-width: ${arrowSize}px ${arrowSize}px ${arrowSize}px 0;
          border-color: transparent rgba(0, 0, 0, 0.9) transparent transparent;
        `;
        break;
    }

    // Adjust position to stay within viewport
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;

    if (left < 0) left = offset;
    if (left + tooltipRect.width > viewportWidth) {
      left = viewportWidth - tooltipRect.width - offset;
    }
    if (top < 0) top = offset;
    if (top + tooltipRect.height > viewportHeight) {
      top = viewportHeight - tooltipRect.height - offset;
    }

    tooltip.style.top = `${top + window.scrollY}px`;
    tooltip.style.left = `${left + window.scrollX}px`;
    tooltip.style.opacity = '1';
  }

  hide(tooltip) {
    tooltip.style.opacity = '0';
  }

  update(element, tooltip, arrow, options) {
    if (tooltip.style.opacity === '1') {
      this.show(element, tooltip, arrow, options);
    }
  }

  destroy(element) {
    const tooltipData = this.tooltips.get(element);
    if (tooltipData) {
      const { tooltip, show, hide } = tooltipData;
      
      // Remove event listeners
      element.removeEventListener('mouseenter', show);
      element.removeEventListener('mouseleave', hide);
      element.removeEventListener('click', show);
      element.removeEventListener('focus', show);
      element.removeEventListener('blur', hide);

      // Remove tooltip from DOM
      if (tooltip.parentNode) {
        tooltip.parentNode.removeChild(tooltip);
      }

      this.tooltips.delete(element);
    }
  }

  destroyAll() {
    this.tooltips.forEach((_, element) => {
      this.destroy(element);
    });
  }
}

const tooltipManager = new TooltipManager();

// Vue directive
export default {
  bind(el, binding) {
    const options = {
      title: binding.value || el.getAttribute('title') || '',
      placement: binding.arg || 'top',
      trigger: binding.modifiers.click ? 'click' : 
               binding.modifiers.focus ? 'focus' : 'hover',
      offset: 8
    };

    // Handle object value
    if (typeof binding.value === 'object') {
      Object.assign(options, binding.value);
    }

    // Remove default title to prevent browser tooltip
    if (el.getAttribute('title')) {
      el.removeAttribute('title');
    }

    // Set aria-label for accessibility
    if (options.title && !el.getAttribute('aria-label')) {
      el.setAttribute('aria-label', options.title);
    }

    el._tooltip = tooltipManager.create(el, options);
  },

  update(el, binding) {
    if (el._tooltip) {
      const newOptions = {
        title: binding.value || '',
        placement: binding.arg || 'top'
      };

      if (typeof binding.value === 'object') {
        Object.assign(newOptions, binding.value);
      }

      Object.assign(el._tooltip.options, newOptions);
      
      // Update aria-label
      if (newOptions.title && !el.getAttribute('aria-label')) {
        el.setAttribute('aria-label', newOptions.title);
      }
    }
  },

  unbind(el) {
    tooltipManager.destroy(el);
    delete el._tooltip;
  }
};

// Global styles injection
const styleId = 'vue-tooltip-styles';
if (!document.getElementById(styleId)) {
  const style = document.createElement('style');
  style.id = styleId;
  style.textContent = `
    .custom-tooltip {
      animation: tooltip-fade-in 0.15s ease-in-out;
    }
    
    @keyframes tooltip-fade-in {
      from {
        opacity: 0;
        transform: translateY(-5px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .custom-tooltip.fade-out {
      animation: tooltip-fade-out 0.15s ease-in-out;
    }
    
    @keyframes tooltip-fade-out {
      from {
        opacity: 1;
        transform: translateY(0);
      }
      to {
        opacity: 0;
        transform: translateY(-5px);
      }
    }
  `;
  document.head.appendChild(style);
}