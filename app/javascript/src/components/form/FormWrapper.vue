<template>
  <Form
    v-slot="{ meta, errors, values }"
    :validation-schema="validationSchema"
    :initial-values="initialValues"
    @submit="handleSubmit"
    @invalid-submit="handleInvalidSubmit"
  >
    <form 
      :id="formId"
      :class="formClass"
      @submit.prevent
    >
      <!-- Error Summary -->
      <div
        v-if="showErrorSummary && Object.keys(errors).length > 0"
        class="alert alert-danger mb-4"
        role="alert"
      >
        <h6 class="alert-heading">{{ errorSummaryTitle }}</h6>
        <ul class="mb-0">
          <li v-for="(error, field) in errors" :key="field">
            {{ error }}
          </li>
        </ul>
      </div>

      <!-- Success Message -->
      <div
        v-if="successMessage"
        class="alert alert-success alert-dismissible fade show mb-4"
        role="alert"
      >
        {{ successMessage }}
        <button
          type="button"
          class="btn-close"
          aria-label="Close"
          @click="$emit('update:successMessage', '')"
        ></button>
      </div>

      <!-- Form Content -->
      <slot 
        :meta="meta" 
        :errors="errors" 
        :values="values"
        :isSubmitting="isSubmitting"
      />

      <!-- Form Actions -->
      <div v-if="!hideActions" class="form-actions mt-4">
        <slot 
          name="actions" 
          :meta="meta" 
          :isSubmitting="isSubmitting"
        >
          <button
            v-if="showCancelButton"
            type="button"
            class="btn btn-outline-secondary me-2"
            :disabled="isSubmitting"
            @click="$emit('cancel')"
          >
            {{ cancelText }}
          </button>
          <button
            type="submit"
            class="btn"
            :class="submitButtonClass"
            :disabled="isSubmitting || (meta.touched && !meta.valid && !allowInvalidSubmit)"
          >
            <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-2" role="status">
              <span class="visually-hidden">Loading...</span>
            </span>
            {{ isSubmitting ? submittingText : submitText }}
          </button>
        </slot>
      </div>
    </form>
  </Form>
</template>

<script setup>
import { Form } from 'vee-validate';
import { computed } from 'vue';

const props = defineProps({
  formId: {
    type: String,
    default: null
  },
  formClass: {
    type: String,
    default: ''
  },
  validationSchema: {
    type: Object,
    default: null
  },
  initialValues: {
    type: Object,
    default: () => ({})
  },
  showErrorSummary: {
    type: Boolean,
    default: true
  },
  errorSummaryTitle: {
    type: String,
    default: '入力エラーがあります'
  },
  successMessage: {
    type: String,
    default: ''
  },
  hideActions: {
    type: Boolean,
    default: false
  },
  showCancelButton: {
    type: Boolean,
    default: false
  },
  submitText: {
    type: String,
    default: '保存'
  },
  submittingText: {
    type: String,
    default: '処理中...'
  },
  cancelText: {
    type: String,
    default: 'キャンセル'
  },
  submitButtonClass: {
    type: String,
    default: 'btn-primary'
  },
  isSubmitting: {
    type: Boolean,
    default: false
  },
  allowInvalidSubmit: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits([
  'submit',
  'invalid-submit',
  'cancel',
  'update:successMessage'
]);

const handleSubmit = (values, actions) => {
  emit('submit', values, actions);
};

const handleInvalidSubmit = ({ values, errors, results }) => {
  emit('invalid-submit', { values, errors, results });
  
  // Focus first error field
  const firstErrorField = Object.keys(errors)[0];
  if (firstErrorField) {
    const element = document.querySelector(`[name="${firstErrorField}"]`);
    if (element) {
      element.focus();
      element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }
};
</script>

<style scoped>
.form-actions {
  border-top: 1px solid #dee2e6;
  padding-top: 1.5rem;
}

.btn-close {
  box-sizing: content-box;
  width: 1em;
  height: 1em;
  padding: 0.25em;
  color: #000;
  background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 011.414 0L8 6.586 14.293.293a1 1 0 111.414 1.414L9.414 8l6.293 6.293a1 1 0 01-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 01-1.414-1.414L6.586 8 .293 1.707a1 1 0 010-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
  border: 0;
  border-radius: 0.375rem;
  opacity: 0.5;
}

.btn-close:hover {
  opacity: 0.75;
}

.me-2 {
  margin-right: 0.5rem !important;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
  border-width: 0.2em;
}
</style>