/**
 * DOM Utility Functions
 * Replace jQuery functionality with native JavaScript
 */

/**
 * Scroll to element smoothly
 * @param {HTMLElement|string} element - Element or selector
 * @param {Object} options - Scroll options
 */
export function scrollToElement(element, options = {}) {
  const defaultOptions = {
    behavior: 'smooth',
    block: 'center',
    inline: 'nearest',
    ...options
  };

  const el = typeof element === 'string' 
    ? document.querySelector(element)
    : element;

  if (el) {
    el.scrollIntoView(defaultOptions);
  }
}

/**
 * Get element offset relative to document
 * @param {HTMLElement} element
 * @returns {Object} {top, left}
 */
export function getOffset(element) {
  const rect = element.getBoundingClientRect();
  return {
    top: rect.top + window.scrollY,
    left: rect.left + window.scrollX
  };
}

/**
 * Get element dimensions
 * @param {HTMLElement} element
 * @returns {Object} {width, height}
 */
export function getDimensions(element) {
  return {
    width: element.offsetWidth,
    height: element.offsetHeight
  };
}

/**
 * Add class to element
 * @param {HTMLElement|string} element
 * @param {string} className
 */
export function addClass(element, className) {
  const el = typeof element === 'string' 
    ? document.querySelector(element)
    : element;
  
  if (el) {
    el.classList.add(...className.split(' '));
  }
}

/**
 * Remove class from element
 * @param {HTMLElement|string} element
 * @param {string} className
 */
export function removeClass(element, className) {
  const el = typeof element === 'string' 
    ? document.querySelector(element)
    : element;
  
  if (el) {
    el.classList.remove(...className.split(' '));
  }
}

/**
 * Toggle class on element
 * @param {HTMLElement|string} element
 * @param {string} className
 */
export function toggleClass(element, className) {
  const el = typeof element === 'string' 
    ? document.querySelector(element)
    : element;
  
  if (el) {
    el.classList.toggle(className);
  }
}

/**
 * Check if element has class
 * @param {HTMLElement|string} element
 * @param {string} className
 * @returns {boolean}
 */
export function hasClass(element, className) {
  const el = typeof element === 'string' 
    ? document.querySelector(element)
    : element;
  
  return el ? el.classList.contains(className) : false;
}

/**
 * Fade in element
 * @param {HTMLElement} element
 * @param {number} duration
 */
export function fadeIn(element, duration = 300) {
  element.style.opacity = 0;
  element.style.display = 'block';
  
  const start = performance.now();
  
  const fade = (timestamp) => {
    const elapsed = timestamp - start;
    const progress = elapsed / duration;
    
    element.style.opacity = Math.min(progress, 1);
    
    if (progress < 1) {
      requestAnimationFrame(fade);
    }
  };
  
  requestAnimationFrame(fade);
}

/**
 * Fade out element
 * @param {HTMLElement} element
 * @param {number} duration
 */
export function fadeOut(element, duration = 300) {
  const start = performance.now();
  const initialOpacity = parseFloat(element.style.opacity) || 1;
  
  const fade = (timestamp) => {
    const elapsed = timestamp - start;
    const progress = elapsed / duration;
    
    element.style.opacity = initialOpacity * (1 - progress);
    
    if (progress < 1) {
      requestAnimationFrame(fade);
    } else {
      element.style.display = 'none';
    }
  };
  
  requestAnimationFrame(fade);
}

/**
 * Slide toggle element
 * @param {HTMLElement} element
 * @param {number} duration
 */
export function slideToggle(element, duration = 300) {
  if (window.getComputedStyle(element).display === 'none') {
    slideDown(element, duration);
  } else {
    slideUp(element, duration);
  }
}

/**
 * Slide down element
 * @param {HTMLElement} element
 * @param {number} duration
 */
export function slideDown(element, duration = 300) {
  element.style.display = 'block';
  const height = element.scrollHeight;
  element.style.overflow = 'hidden';
  element.style.height = 0;
  element.style.paddingTop = 0;
  element.style.paddingBottom = 0;
  element.style.marginTop = 0;
  element.style.marginBottom = 0;
  
  const start = performance.now();
  
  const slide = (timestamp) => {
    const elapsed = timestamp - start;
    const progress = elapsed / duration;
    
    element.style.height = (height * progress) + 'px';
    
    if (progress < 1) {
      requestAnimationFrame(slide);
    } else {
      element.style.height = '';
      element.style.overflow = '';
    }
  };
  
  requestAnimationFrame(slide);
}

/**
 * Slide up element
 * @param {HTMLElement} element
 * @param {number} duration
 */
export function slideUp(element, duration = 300) {
  const height = element.scrollHeight;
  element.style.overflow = 'hidden';
  
  const start = performance.now();
  
  const slide = (timestamp) => {
    const elapsed = timestamp - start;
    const progress = elapsed / duration;
    
    element.style.height = (height * (1 - progress)) + 'px';
    
    if (progress < 1) {
      requestAnimationFrame(slide);
    } else {
      element.style.display = 'none';
      element.style.height = '';
      element.style.overflow = '';
    }
  };
  
  requestAnimationFrame(slide);
}

/**
 * Serialize form data
 * @param {HTMLFormElement} form
 * @returns {Object}
 */
export function serializeForm(form) {
  const formData = new FormData(form);
  const data = {};
  
  for (const [key, value] of formData.entries()) {
    if (data[key]) {
      if (!Array.isArray(data[key])) {
        data[key] = [data[key]];
      }
      data[key].push(value);
    } else {
      data[key] = value;
    }
  }
  
  return data;
}

/**
 * Get closest parent element matching selector
 * @param {HTMLElement} element
 * @param {string} selector
 * @returns {HTMLElement|null}
 */
export function closest(element, selector) {
  return element.closest(selector);
}

/**
 * Trigger custom event
 * @param {HTMLElement} element
 * @param {string} eventName
 * @param {Object} detail
 */
export function trigger(element, eventName, detail = {}) {
  const event = new CustomEvent(eventName, {
    bubbles: true,
    cancelable: true,
    detail
  });
  element.dispatchEvent(event);
}