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

<script>
export default {
  name: 'BaseDropdown',
  props: {
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
  },
  data() {
    return {
      isOpen: false,
      toggleId: `dropdown-toggle-${this._uid}`
    };
  },
  computed: {
    dropdownClasses() {
      return {
        'dropdown': !this.up,
        'dropup': this.up,
        'show': this.isOpen
      };
    },
    toggleClasses() {
      return [
        'btn',
        `btn-${this.variant}`,
        `btn-${this.size}`,
        {
          'dropdown-toggle-split': this.split
        }
      ];
    },
    menuClasses() {
      return {
        'show': this.isOpen,
        'dropdown-menu-right': this.right,
        'dropdown-menu-up': this.up
      };
    }
  },
  mounted() {
    document.addEventListener('click', this.handleClickOutside);
    document.addEventListener('keydown', this.handleKeydown);
  },
  beforeDestroy() {
    document.removeEventListener('click', this.handleClickOutside);
    document.removeEventListener('keydown', this.handleKeydown);
  },
  methods: {
    toggle() {
      if (!this.disabled) {
        this.isOpen = !this.isOpen;
        if (this.isOpen) {
          this.$nextTick(() => {
            this.positionMenu();
            this.focusFirstItem();
          });
        }
      }
    },
    open() {
      if (!this.disabled) {
        this.isOpen = true;
        this.$nextTick(() => {
          this.positionMenu();
          this.focusFirstItem();
        });
      }
    },
    close() {
      this.isOpen = false;
    },
    handleClickOutside(event) {
      if (!this.$el.contains(event.target)) {
        this.close();
      }
    },
    handleKeydown(event) {
      if (!this.isOpen) return;

      switch (event.key) {
        case 'Escape':
          this.close();
          this.$refs.dropdown.querySelector('.dropdown-toggle').focus();
          break;
        case 'ArrowDown':
          event.preventDefault();
          this.focusNextItem();
          break;
        case 'ArrowUp':
          event.preventDefault();
          this.focusPreviousItem();
          break;
        case 'Home':
          event.preventDefault();
          this.focusFirstItem();
          break;
        case 'End':
          event.preventDefault();
          this.focusLastItem();
          break;
      }
    },
    positionMenu() {
      const menu = this.$refs.menu;
      const toggle = this.$refs.dropdown.querySelector('.dropdown-toggle');
      
      if (!menu || !toggle) return;

      const toggleRect = toggle.getBoundingClientRect();
      const menuRect = menu.getBoundingClientRect();
      const viewportHeight = window.innerHeight;
      const viewportWidth = window.innerWidth;

      // Reset position
      menu.style.top = '';
      menu.style.left = '';
      menu.style.right = '';
      menu.style.bottom = '';

      // Calculate position
      let top = toggleRect.bottom + this.offset;
      let left = toggleRect.left;

      // Adjust for right alignment
      if (this.right) {
        left = toggleRect.right - menuRect.width;
      }

      // Adjust for dropup
      if (this.up || (top + menuRect.height > viewportHeight && toggleRect.top > menuRect.height)) {
        top = toggleRect.top - menuRect.height - this.offset;
        menu.classList.add('dropdown-menu-up');
      } else {
        menu.classList.remove('dropdown-menu-up');
      }

      // Keep within viewport
      if (left < 0) left = 0;
      if (left + menuRect.width > viewportWidth) {
        left = viewportWidth - menuRect.width;
      }

      menu.style.position = 'fixed';
      menu.style.top = `${top}px`;
      menu.style.left = `${left}px`;
    },
    getMenuItems() {
      return Array.from(this.$refs.menu.querySelectorAll('.dropdown-item:not(.disabled):not(:disabled)'));
    },
    focusFirstItem() {
      const items = this.getMenuItems();
      if (items.length > 0) {
        items[0].focus();
      }
    },
    focusLastItem() {
      const items = this.getMenuItems();
      if (items.length > 0) {
        items[items.length - 1].focus();
      }
    },
    focusNextItem() {
      const items = this.getMenuItems();
      const currentIndex = items.findIndex(item => item === document.activeElement);
      if (currentIndex < items.length - 1) {
        items[currentIndex + 1].focus();
      } else {
        items[0].focus();
      }
    },
    focusPreviousItem() {
      const items = this.getMenuItems();
      const currentIndex = items.findIndex(item => item === document.activeElement);
      if (currentIndex > 0) {
        items[currentIndex - 1].focus();
      } else {
        items[items.length - 1].focus();
      }
    }
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