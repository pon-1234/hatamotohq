<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid, validated, errors, pending }"
  >
    <form
      :id="id"
      :class="{ 'form-inline': inline }"
      :novalidate="novalidate"
      @submit.prevent="handleSubmit"
      @reset.prevent="handleReset"
    >
      <!-- Form Header -->
      <div v-if="title || $slots.header" class="form-header mb-4">
        <h4 v-if="title" class="mb-0">{{ title }}</h4>
        <slot name="header" />
      </div>

      <!-- Form Description -->
      <div v-if="description || $slots.description" class="form-description mb-4">
        <p v-if="description" class="text-muted">{{ description }}</p>
        <slot name="description" />
      </div>

      <!-- Error Summary -->
      <div
        v-if="showErrorSummary && Object.keys(errors).length"
        class="alert alert-danger"
        role="alert"
      >
        <h6 class="alert-heading">入力エラーがあります</h6>
        <ul class="mb-0 pl-3">
          <li v-for="(error, field) in errors" :key="field">
            {{ error[0] }}
          </li>
        </ul>
      </div>

      <!-- Success Message -->
      <div
        v-if="successMessage"
        class="alert alert-success alert-dismissible fade show"
        role="alert"
      >
        {{ successMessage }}
        <button
          type="button"
          class="btn-close"
          aria-label="Close"
          @click="successMessage = ''"
        ></button>
      </div>

      <!-- Form Content -->
      <div class="form-content">
        <slot :errors="errors" :pending="pending" />
      </div>

      <!-- Form Actions -->
      <div v-if="!hideActions" class="form-actions mt-4">
        <slot name="actions" :invalid="invalid" :validated="validated" :pending="pending">
          <button
            v-if="showResetButton"
            type="reset"
            class="btn btn-outline-secondary me-2"
            :disabled="loading"
          >
            {{ resetText }}
          </button>
          <button
            type="submit"
            class="btn"
            :class="[`btn-${submitVariant}`, submitClass]"
            :disabled="loading || (validated && invalid)"
          >
            <BaseSpinner v-if="loading" size="sm" class="me-1" />
            {{ loading ? loadingText : submitText }}
          </button>
        </slot>
      </div>
    </form>
  </validation-observer>
</template>

<script setup>
import { ref, nextTick } from 'vue';
import BaseSpinner from './BaseSpinner.vue';

// Props
const props = defineProps({
  id: {
    type: String,
    default: null
  },
  title: {
    type: String,
    default: ''
  },
  description: {
    type: String,
    default: ''
  },
  inline: {
    type: Boolean,
    default: false
  },
  novalidate: {
    type: Boolean,
    default: true
  },
  loading: {
    type: Boolean,
    default: false
  },
  hideActions: {
    type: Boolean,
    default: false
  },
  showResetButton: {
    type: Boolean,
    default: false
  },
  showErrorSummary: {
    type: Boolean,
    default: true
  },
  submitText: {
    type: String,
    default: '保存'
  },
  loadingText: {
    type: String,
    default: '処理中...'
  },
  resetText: {
    type: String,
    default: 'リセット'
  },
  submitVariant: {
    type: String,
    default: 'primary'
  },
  submitClass: {
    type: String,
    default: ''
  },
  validateOnSubmit: {
    type: Boolean,
    default: true
  }
});

// Emits
const emit = defineEmits(['submit', 'reset']);

// Refs
const observer = ref(null);
const successMessage = ref('');

// Methods
const handleSubmit = async () => {
  if (props.loading) return;

  if (props.validateOnSubmit && observer.value) {
    const isValid = await observer.value.validate();
    if (!isValid) {
      focusFirstError();
      return;
    }
  }

  emit('submit');
};

const handleReset = () => {
  if (observer.value) {
    observer.value.reset();
  }
  emit('reset');
};

const validate = async () => {
  if (observer.value) {
    return await observer.value.validate();
  }
  return true;
};

const reset = () => {
  if (observer.value) {
    observer.value.reset();
  }
};

const setErrors = (errors) => {
  if (observer.value) {
    observer.value.setErrors(errors);
  }
};

const focusFirstError = () => {
  nextTick(() => {
    const form = document.getElementById(props.id) || document.querySelector('form');
    if (form) {
      const firstError = form.querySelector('.is-invalid');
      if (firstError) {
        firstError.focus();
        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }
  });
};

const showSuccess = (message) => {
  successMessage.value = message;
};

// Expose methods for parent component access
defineExpose({
  validate,
  reset,
  setErrors,
  focusFirstError,
  showSuccess
});
</script>

<style scoped>
.form-header {
  border-bottom: 2px solid #e9ecef;
  padding-bottom: 1rem;
}

.form-actions {
  border-top: 1px solid #e9ecef;
  padding-top: 1.5rem;
}

.form-content :deep(.form-group) {
  margin-bottom: 1.25rem;
}

.form-content :deep(.form-label) {
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.form-content :deep(.invalid-feedback) {
  display: block;
  margin-top: 0.25rem;
}

.form-inline {
  display: flex;
  flex-flow: row wrap;
  align-items: center;
}

.form-inline .form-content {
  display: flex;
  align-items: center;
  gap: 0.5rem;
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
}

.btn-close:hover {
  opacity: 0.75;
}

.me-1 {
  margin-right: 0.25rem !important;
}

.me-2 {
  margin-right: 0.5rem !important;
}
</style>