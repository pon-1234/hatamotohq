<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid, validated, errors, pending }"
  >
    <b-form
      :id="id"
      :inline="inline"
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
      <b-alert
        v-if="showErrorSummary && Object.keys(errors).length"
        variant="danger"
        :show="true"
        class="mb-4"
      >
        <h6 class="alert-heading">入力エラーがあります</h6>
        <ul class="mb-0 pl-3">
          <li v-for="(error, field) in errors" :key="field">
            {{ error[0] }}
          </li>
        </ul>
      </b-alert>

      <!-- Success Message -->
      <b-alert
        v-if="successMessage"
        variant="success"
        :show="true"
        dismissible
        class="mb-4"
        @dismissed="successMessage = ''"
      >
        {{ successMessage }}
      </b-alert>

      <!-- Form Content -->
      <div class="form-content">
        <slot :errors="errors" :pending="pending" />
      </div>

      <!-- Form Actions -->
      <div v-if="!hideActions" class="form-actions mt-4">
        <slot name="actions" :invalid="invalid" :validated="validated" :pending="pending">
          <b-button
            v-if="showResetButton"
            type="reset"
            variant="outline-secondary"
            :disabled="loading"
            class="mr-2"
          >
            {{ resetText }}
          </b-button>
          <b-button
            type="submit"
            :variant="submitVariant"
            :disabled="loading || (validated && invalid)"
            :class="submitClass"
          >
            <b-spinner v-if="loading" small class="mr-1" />
            {{ loading ? loadingText : submitText }}
          </b-button>
        </slot>
      </div>
    </b-form>
  </validation-observer>
</template>

<script>
export default {
  name: 'BaseForm',
  props: {
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
  },
  data() {
    return {
      successMessage: ''
    };
  },
  methods: {
    async handleSubmit() {
      if (this.loading) return;

      if (this.validateOnSubmit) {
        const isValid = await this.$refs.observer.validate();
        if (!isValid) {
          this.focusFirstError();
          return;
        }
      }

      this.$emit('submit');
    },
    handleReset() {
      this.$refs.observer.reset();
      this.$emit('reset');
    },
    async validate() {
      return await this.$refs.observer.validate();
    },
    reset() {
      this.$refs.observer.reset();
    },
    setErrors(errors) {
      this.$refs.observer.setErrors(errors);
    },
    focusFirstError() {
      this.$nextTick(() => {
        const firstError = this.$el.querySelector('.is-invalid');
        if (firstError) {
          firstError.focus();
          firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      });
    },
    showSuccess(message) {
      this.successMessage = message;
    }
  }
};
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
</style>