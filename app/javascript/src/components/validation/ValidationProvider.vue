<template>
  <div>
    <slot
      v-bind="{
        errors: errorMessages,
        valid: meta.valid,
        invalid: !meta.valid,
        validated: meta.validated,
        touched: meta.touched,
        dirty: meta.dirty,
        pristine: !meta.dirty,
        pending: meta.pending,
        required: isRequired,
        ariaInput: {
          'aria-invalid': !meta.valid && meta.validated ? 'true' : 'false',
          'aria-required': isRequired ? 'true' : 'false'
        },
        ariaMsg: {
          'aria-live': 'polite',
          'aria-hidden': !errorMessages.length ? 'true' : 'false'
        }
      }"
    />
  </div>
</template>

<script>
import { useField } from 'vee-validate';
import { computed, watch, toRef } from 'vue';

export default {
  name: 'ValidationProvider',
  compatConfig: { MODE: 3 },
  props: {
    name: {
      type: String,
      required: true
    },
    rules: {
      type: [String, Object],
      default: ''
    },
    vid: {
      type: String,
      default: undefined
    },
    immediate: {
      type: Boolean,
      default: false
    },
    tag: {
      type: String,
      default: 'div'
    },
    bails: {
      type: Boolean,
      default: true
    },
    skipIfEmpty: {
      type: Boolean,
      default: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    customMessages: {
      type: Object,
      default: () => ({})
    }
  },
  setup(props) {
    const { value, errors, errorMessage, meta, validate, resetField } = useField(
      props.vid || props.name,
      props.rules,
      {
        label: props.name,
        validateOnValueUpdate: !props.skipIfEmpty,
        bails: props.bails,
        standalone: true
      }
    );

    const errorMessages = computed(() => errors.value);
    const isRequired = computed(() => {
      if (typeof props.rules === 'string') {
        return props.rules.includes('required');
      }
      return props.rules?.required;
    });

    // Watch for immediate validation
    if (props.immediate) {
      validate();
    }

    // Watch for disabled state
    watch(toRef(props, 'disabled'), (isDisabled) => {
      if (isDisabled) {
        resetField();
      }
    });

    return {
      value,
      errors,
      errorMessage,
      errorMessages,
      meta,
      validate,
      resetField,
      isRequired
    };
  }
};
</script>