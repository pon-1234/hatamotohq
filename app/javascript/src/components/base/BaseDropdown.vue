<template>
  <div class="base-dropdown" :class="dropdownClasses" ref="dropdown">
    <!-- Dropdown Toggle -->
    <button
      :id="toggleId"
      class="dropdown-toggle"
      :class="toggleClasses"
      :disabled="disabled"
      type="button"
      aria-haspopup="true"
      :aria-expanded="isOpen"
      @click="toggle"
    >
      <slot name="button-content">
        {{ text }}
      </slot>
    </button>

    <!-- Dropdown Menu -->
    <transition name="dropdown-fade">
      <div
        v-show="isOpen"
        class="dropdown-menu"
        :class="menuClasses"
        :aria-labelledby="toggleId"
        ref="menu"
      >
        <slot />
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';

const props = defineProps({
  text: {
    type: String,
    default: ''
  },
  variant: {
    type: String,
    default: 'secondary'
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg'].includes(value)
  },
  disabled: {
    type: Boolean,
    default: false
  },
  right: {
    type: Boolean,
    default: false
  },
  up: {
    type: Boolean,
    default: false
  },
  offset: {
    type: Number,
    default: 0
  },
  boundary: {
    type: String,
    default: 'scrollParent'
  },
  split: {
    type: Boolean,
    default: false
  }
});

// State
const isOpen = ref(false);
const toggleId = `dropdown-toggle-${Math.random().toString(36).substr(2, 9)}`;
const dropdown = ref(null);
const menu = ref(null);

// Computed
const dropdownClasses = computed(() => {
  return {
    'dropdown': !props.up,
    'dropup': props.up,
    'show': isOpen.value
  };
});

const toggleClasses = computed(() => {
  return [
    'btn',
    `btn-${props.variant}`,
    `btn-${props.size}`,
    {
      'dropdown-toggle-split': props.split
    }
  ];
});

const menuClasses = computed(() => {
  return {
    'show': isOpen.value,
    'dropdown-menu-right': props.right,
    'dropdown-menu-up': props.up
  };
});

// Lifecycle
onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  document.addEventListener('keydown', handleKeydown);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
  document.removeEventListener('keydown', handleKeydown);
});

// Methods
const toggle = () => {
  if (!props.disabled) {
    isOpen.value = !isOpen.value;
    if (isOpen.value) {
      nextTick(() => {
        positionMenu();
        focusFirstItem();
      });
    }
  }
};

const open = () => {
  if (!props.disabled) {
    isOpen.value = true;
    nextTick(() => {
      positionMenu();
      focusFirstItem();
    });
  }
};

const close = () => {
  isOpen.value = false;
};

const handleClickOutside = (event) => {
  if (!dropdown.value.contains(event.target)) {
    close();
  }
};

const handleKeydown = (event) => {
  if (!isOpen.value) return;

  switch (event.key) {
    case 'Escape':
      close();
      dropdown.value.querySelector('.dropdown-toggle').focus();
      break;
    case 'ArrowDown':
      event.preventDefault();
      focusNextItem();
      break;
    case 'ArrowUp':
      event.preventDefault();
      focusPreviousItem();
      break;
    case 'Home':
      event.preventDefault();
      focusFirstItem();
      break;
    case 'End':
      event.preventDefault();
      focusLastItem();
      break;
  }
};

const positionMenu = () => {
  const menuEl = menu.value;
  const toggle = dropdown.value.querySelector('.dropdown-toggle');
  
  if (!menuEl || !toggle) return;

  const toggleRect = toggle.getBoundingClientRect();
  const menuRect = menuEl.getBoundingClientRect();
  const viewportHeight = window.innerHeight;
  const viewportWidth = window.innerWidth;

  // Reset position
  menuEl.style.top = '';
  menuEl.style.left = '';
  menuEl.style.right = '';
  menuEl.style.bottom = '';

  // Calculate position
  let top = toggleRect.bottom + props.offset;
  let left = toggleRect.left;

  // Adjust for right alignment
  if (props.right) {
    left = toggleRect.right - menuRect.width;
  }

  // Adjust for dropup
  if (props.up || (top + menuRect.height > viewportHeight && toggleRect.top > menuRect.height)) {
    top = toggleRect.top - menuRect.height - props.offset;
    menuEl.classList.add('dropdown-menu-up');
  } else {
    menuEl.classList.remove('dropdown-menu-up');
  }

  // Keep within viewport
  if (left < 0) left = 0;
  if (left + menuRect.width > viewportWidth) {
    left = viewportWidth - menuRect.width;
  }

  menuEl.style.position = 'fixed';
  menuEl.style.top = `${top}px`;
  menuEl.style.left = `${left}px`;
};

const getMenuItems = () => {
  return Array.from(menu.value.querySelectorAll('.dropdown-item:not(.disabled):not(:disabled)'));
};

const focusFirstItem = () => {
  const items = getMenuItems();
  if (items.length > 0) {
    items[0].focus();
  }
};

const focusLastItem = () => {
  const items = getMenuItems();
  if (items.length > 0) {
    items[items.length - 1].focus();
  }
};

const focusNextItem = () => {
  const items = getMenuItems();
  const currentIndex = items.findIndex(item => item === document.activeElement);
  if (currentIndex < items.length - 1) {
    items[currentIndex + 1].focus();
  } else {
    items[0].focus();
  }
};

const focusPreviousItem = () => {
  const items = getMenuItems();
  const currentIndex = items.findIndex(item => item === document.activeElement);
  if (currentIndex > 0) {
    items[currentIndex - 1].focus();
  } else {
    items[items.length - 1].focus();
  }
};
</script>

<style scoped>
.base-dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
  display: none;
  min-width: 10rem;
  padding: 0.5rem 0;
  margin: 0.125rem 0 0;
  font-size: 0.875rem;
  color: #212529;
  text-align: left;
  list-style: none;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid rgba(0, 0, 0, 0.15);
  border-radius: 0.25rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.175);
}

.dropdown-menu.show {
  display: block;
}

.dropdown-menu-right {
  right: 0;
  left: auto;
}

.dropdown-menu-up {
  top: auto;
  bottom: 100%;
  margin-top: 0;
  margin-bottom: 0.125rem;
}

:deep(.dropdown-item) {
  display: block;
  width: 100%;
  padding: 0.25rem 1.5rem;
  clear: both;
  font-weight: 400;
  color: #212529;
  text-align: inherit;
  white-space: nowrap;
  background-color: transparent;
  border: 0;
  text-decoration: none;
  cursor: pointer;
}

:deep(.dropdown-item:hover),
:deep(.dropdown-item:focus) {
  color: #16181b;
  background-color: #f8f9fa;
}

:deep(.dropdown-item.active),
:deep(.dropdown-item:active) {
  color: #fff;
  background-color: #007bff;
}

:deep(.dropdown-item.disabled),
:deep(.dropdown-item:disabled) {
  color: #6c757d;
  pointer-events: none;
  background-color: transparent;
}

:deep(.dropdown-divider) {
  height: 0;
  margin: 0.5rem 0;
  overflow: hidden;
  border-top: 1px solid #e9ecef;
}

:deep(.dropdown-header) {
  display: block;
  padding: 0.5rem 1.5rem;
  margin-bottom: 0;
  font-size: 0.875rem;
  color: #6c757d;
  white-space: nowrap;
}

/* Transition */
.dropdown-fade-enter-active,
.dropdown-fade-leave-active {
  transition: opacity 0.15s, transform 0.15s;
}

.dropdown-fade-enter,
.dropdown-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

.dropdown-menu-up.dropdown-fade-enter,
.dropdown-menu-up.dropdown-fade-leave-to {
  transform: translateY(10px);
}
</style>