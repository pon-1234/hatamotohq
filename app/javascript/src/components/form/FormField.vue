<template>
  <component
    :is="inputComponent"
    v-bind="$attrs"
    :name="name"
    :label="label"
    :rules="rules"
    :placeholder="placeholder"
    :help-text="helpText"
    :disabled="disabled"
    :readonly="readonly"
    :hide-label="hideLabel"
  />
</template>

<script setup>
import { computed } from 'vue';
import TextInput from './inputs/TextInput.vue';
import EmailInput from './inputs/EmailInput.vue';
import PasswordInput from './inputs/PasswordInput.vue';
// Import other input components as they are created

const props = defineProps({
  type: {
    type: String,
    default: 'text',
    validator: (value) => [
      'text', 'email', 'password', 'textarea', 
      'select', 'checkbox', 'radio', 'file'
    ].includes(value)
  },
  name: {
    type: String,
    required: true
  },
  label: {
    type: String,
    default: ''
  },
  rules: {
    type: [String, Object, Function],
    default: ''
  },
  placeholder: {
    type: String,
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
  }
});

// Map type to component
const inputComponent = computed(() => {
  const componentMap = {
    text: TextInput,
    email: EmailInput,
    password: PasswordInput,
    // Add more mappings as components are created
    // textarea: TextareaInput,
    // select: SelectInput,
    // checkbox: CheckboxInput,
    // radio: RadioInput,
    // file: FileInput
  };
  
  return componentMap[props.type] || TextInput;
});
</script>