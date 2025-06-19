<template>
  <teleport to="body">
    <transition name="modal-fade">
      <div v-if="isVisible" class="modal-backdrop" @click="handleBackdropClick">
        <div 
          class="modal-dialog"
          :class="modalClasses"
          @click.stop
          role="dialog"
          :aria-labelledby="titleId"
          aria-modal="true"
        >
          <div class="modal-content">
            <!-- Header -->
            <div v-if="!hideHeader" class="modal-header">
              <slot name="header">
                <h5 :id="titleId" class="modal-title">{{ title }}</h5>
              </slot>
              <button
                type="button"
                class="btn-close"
                aria-label="Close"
                @click="handleClose"
              ></button>
            </div>

            <!-- Body -->
            <div class="modal-body">
              <slot />
            </div>

            <!-- Footer -->
            <div v-if="!hideFooter" class="modal-footer">
              <slot name="footer" :ok="handleOk" :cancel="handleCancel">
                <button
                  v-if="showCancelButton"
                  type="button"
                  class="btn btn-secondary"
                  @click="handleCancel"
                >
                  {{ cancelText }}
                </button>
                <button
                  v-if="showOkButton"
                  type="button"
                  class="btn"
                  :class="`btn-${okVariant}`"
                  :disabled="okDisabled"
                  @click="handleOk"
                >
                  {{ okText }}
                </button>
              </slot>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';

// Props
const props = defineProps({
  id: {
    type: String,
    required: true
  },
  modelValue: {
    type: Boolean,
    default: false
  },
  title: {
    type: String,
    default: ''
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg', 'xl'].includes(value)
  },
  hideFooter: {
    type: Boolean,
    default: false
  },
  hideHeader: {
    type: Boolean,
    default: false
  },
  noCloseOnBackdrop: {
    type: Boolean,
    default: false
  },
  noCloseOnEsc: {
    type: Boolean,
    default: false
  },
  centered: {
    type: Boolean,
    default: true
  },
  showCancelButton: {
    type: Boolean,
    default: true
  },
  showOkButton: {
    type: Boolean,
    default: true
  },
  cancelText: {
    type: String,
    default: 'キャンセル'
  },
  okText: {
    type: String,
    default: 'OK'
  },
  okVariant: {
    type: String,
    default: 'primary'
  },
  okDisabled: {
    type: Boolean,
    default: false
  }
});

// Emits
const emit = defineEmits(['update:modelValue', 'show', 'shown', 'hide', 'hidden', 'ok', 'cancel']);

// State
const isVisible = ref(false);
const titleId = computed(() => `${props.id}-title`);

// Computed
const modalClasses = computed(() => ({
  [`modal-${props.size}`]: props.size !== 'md',
  'modal-dialog-centered': props.centered
}));

// Methods
const show = () => {
  isVisible.value = true;
  emit('update:modelValue', true);
  emit('show');
  
  // Add body class to prevent scrolling
  document.body.classList.add('modal-open');
  
  // Emit shown after transition
  setTimeout(() => {
    emit('shown');
  }, 150);
};

const hide = () => {
  emit('hide');
  isVisible.value = false;
  emit('update:modelValue', false);
  
  // Remove body class
  document.body.classList.remove('modal-open');
  
  // Emit hidden after transition
  setTimeout(() => {
    emit('hidden');
  }, 150);
};

const handleBackdropClick = () => {
  if (!props.noCloseOnBackdrop) {
    hide();
  }
};

const handleClose = () => {
  hide();
};

const handleOk = () => {
  emit('ok');
  hide();
};

const handleCancel = () => {
  emit('cancel');
  hide();
};

const handleEscKey = (event) => {
  if (event.key === 'Escape' && !props.noCloseOnEsc && isVisible.value) {
    hide();
  }
};

// Watch modelValue for v-model support
watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    show();
  } else {
    hide();
  }
});

// Lifecycle
onMounted(() => {
  document.addEventListener('keydown', handleEscKey);
  
  // Register modal instance for programmatic access
  if (window.BaseModalInstances) {
    window.BaseModalInstances[props.id] = { show, hide };
  } else {
    window.BaseModalInstances = { [props.id]: { show, hide } };
  }
});

onUnmounted(() => {
  document.removeEventListener('keydown', handleEscKey);
  document.body.classList.remove('modal-open');
  
  // Cleanup modal instance
  if (window.BaseModalInstances && window.BaseModalInstances[props.id]) {
    delete window.BaseModalInstances[props.id];
  }
});

// Expose methods for parent component access
defineExpose({ show, hide });
</script>

<style scoped>
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 1050;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 1.75rem;
  overflow-y: auto;
}

.modal-dialog {
  position: relative;
  width: auto;
  margin: 1.75rem auto;
  pointer-events: auto;
  max-width: 500px;
}

.modal-dialog-centered {
  display: flex;
  align-items: center;
  min-height: calc(100% - 3.5rem);
}

.modal-sm {
  max-width: 300px;
}

.modal-lg {
  max-width: 800px;
}

.modal-xl {
  max-width: 1140px;
}

.modal-content {
  position: relative;
  display: flex;
  flex-direction: column;
  width: 100%;
  pointer-events: auto;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-radius: 0.3rem;
  outline: 0;
}

.modal-header {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  justify-content: space-between;
  padding: 1rem;
  border-bottom: 1px solid #dee2e6;
  border-top-left-radius: calc(0.3rem - 1px);
  border-top-right-radius: calc(0.3rem - 1px);
}

.modal-title {
  margin-bottom: 0;
  line-height: 1.5;
}

.btn-close {
  box-sizing: content-box;
  width: 1em;
  height: 1em;
  padding: 0.25em;
  color: #000;
  background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
  border: 0;
  border-radius: 0.25rem;
  opacity: 0.5;
  cursor: pointer;
}

.btn-close:hover {
  opacity: 0.75;
}

.modal-body {
  position: relative;
  flex: 1 1 auto;
  padding: 1rem;
}

.modal-footer {
  display: flex;
  flex-wrap: wrap;
  flex-shrink: 0;
  align-items: center;
  justify-content: flex-end;
  padding: 0.75rem;
  border-top: 1px solid #dee2e6;
  border-bottom-right-radius: calc(0.3rem - 1px);
  border-bottom-left-radius: calc(0.3rem - 1px);
  gap: 0.5rem;
}

/* Transition */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.15s;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-active .modal-dialog,
.modal-fade-leave-active .modal-dialog {
  transition: transform 0.15s;
}

.modal-fade-enter-from .modal-dialog {
  transform: translateY(-50px);
}

.modal-fade-leave-to .modal-dialog {
  transform: translateY(-50px);
}

/* Body class when modal is open */
:global(.modal-open) {
  overflow: hidden;
}
</style>