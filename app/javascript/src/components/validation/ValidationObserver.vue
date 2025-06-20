<template>
  <form @submit="handleSubmit">
    <slot
      v-bind="{
        validate: validate,
        reset: reset,
        errors: allErrors,
        valid: isValid,
        invalid: !isValid,
        validated: isValidated,
        passes: handleSubmit,
        failed: isInvalid
      }"
    />
  </form>
</template>

<script>
import { useForm } from 'vee-validate';
import { computed } from 'vue';

export default {
  name: 'ValidationObserver',
  compatConfig: { MODE: 3 },
  props: {
    tag: {
      type: String,
      default: 'form'
    },
    slim: {
      type: Boolean,
      default: false
    }
  },
  setup(props, { emit }) {
    const { errors, meta, validate, resetForm, handleSubmit: veeHandleSubmit, values } = useForm();

    const allErrors = computed(() => errors.value);
    const isValid = computed(() => meta.value.valid);
    const isValidated = computed(() => meta.value.touched);
    const isInvalid = computed(() => !meta.value.valid && meta.value.touched);

    const handleSubmit = (e) => {
      if (e) {
        e.preventDefault();
      }
      
      return veeHandleSubmit((values) => {
        emit('submit', values);
      })();
    };

    const reset = () => {
      resetForm();
    };

    return {
      allErrors,
      isValid,
      isValidated,
      isInvalid,
      validate,
      reset,
      handleSubmit,
      values
    };
  }
};
</script>