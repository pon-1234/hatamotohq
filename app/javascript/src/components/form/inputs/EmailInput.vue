<template>
  <TextInput
    :name="name"
    :label="label"
    type="email"
    :placeholder="placeholder || 'example@email.com'"
    :rules="computedRules"
    :help-text="helpText"
    :disabled="disabled"
    :readonly="readonly"
    autocomplete="email"
    :hide-label="hideLabel"
    :show-valid-feedback="showValidFeedback"
    :valid-feedback="validFeedback"
  />
</template>

<script setup>
import { computed } from 'vue';
import TextInput from './TextInput.vue';

const props = defineProps({
  name: {
    type: String,
    required: true
  },
  label: {
    type: String,
    default: 'メールアドレス'
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

// Add email validation to existing rules
const computedRules = computed(() => {
  const baseRules = props.rules || '';
  const emailRule = 'custom_email';
  
  if (typeof baseRules === 'string') {
    return baseRules.includes(emailRule) ? baseRules : `${baseRules}|${emailRule}`.replace(/^\|/, '');
  }
  
  return {
    ...baseRules,
    custom_email: true
  };
});
</script>