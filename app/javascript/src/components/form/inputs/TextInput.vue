<template>
  <Field
    :name="name"
    :rules="rules"
    :label="label"
    v-slot="{ field, errors, meta }"
  >
    <div class="form-group">
      <label v-if="label && !hideLabel" :for="inputId" class="form-label">
        {{ label }}
        <span v-if="required" class="text-danger">*</span>
      </label>
      <input
        :id="inputId"
        v-bind="field"
        :type="type"
        class="form-control"
        :class="{
          'is-invalid': meta.touched && errors.length,
          'is-valid': meta.touched && !errors.length && showValidFeedback
        }"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :autocomplete="autocomplete"
        @blur="field.handleBlur"
      />
      <div v-if="helpText && !errors.length" class="form-text">
        {{ helpText }}
      </div>
      <div v-if="meta.touched && errors.length" class="invalid-feedback">
        {{ errors[0] }}
      </div>
      <div v-if="meta.touched && !errors.length && validFeedback && showValidFeedback" class="valid-feedback">
        {{ validFeedback }}
      </div>
    </div>
  </Field>
</template>

<script setup>
import { Field } from 'vee-validate';
import { computed } from 'vue';

const props = defineProps({
  name: {
    type: String,
    required: true
  },
  label: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'text',
    validator: (value) => ['text', 'email', 'url', 'tel', 'number'].includes(value)
  },
  placeholder: {
    type: String,
    default: ''
  },
  rules: {
    type: [String, Object, Function],
    default: ''
  },
  helpText: {
    type: String,
    default: ''
  },
  disabled: {
    type: Boolean,
    default: false
  },
  readonly: {
    type: Boolean,
    default: false
  },
  autocomplete: {
    type: String,
    default: 'off'
  },
  hideLabel: {
    type: Boolean,
    default: false
  },
  showValidFeedback: {
    type: Boolean,
    default: false
  },
  validFeedback: {
    type: String,
    default: '✓'
  }
});

// Generate unique ID for accessibility
const inputId = computed(() => `${props.name.replace(/[\[\]]/g, '-')}-${Math.random().toString(36).substr(2, 9)}`);

// Check if field is required from rules
const required = computed(() => {
  if (typeof props.rules === 'string') {
    return props.rules.includes('required');
  }
  if (typeof props.rules === 'object' && props.rules.required) {
    return true;
  }
  return false;
});
</script>

<style scoped>
.form-group {
  margin-bottom: 1rem;
}

.form-label {
  font-weight: 500;
  margin-bottom: 0.5rem;
  display: block;
}

.form-text {
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #6c757d;
}

.invalid-feedback,
.valid-feedback {
  margin-top: 0.25rem;
  font-size: 0.875em;
}

.form-control:disabled {
  background-color: #e9ecef;
  opacity: 1;
}
</style>