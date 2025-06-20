<template>
  <VueDatePicker
    v-model="localValue"
    :format="computedFormat"
    :enable-time-picker="!dateOnly"
    :time-picker="timeOnly"
    :min-date="min"
    :max-date="max"
    :disabled="disabled"
    :placeholder="placeholder"
    :locale="locale"
    :week-start="1"
    :auto-apply="true"
    @update:model-value="handleUpdate"
    @closed="$emit('close')"
    @opened="$emit('open')"
  />
</template>

<script>
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';
import { computed, ref, watch } from 'vue';

export default {
  name: 'Datetime',
  compatConfig: { MODE: 3 },
  components: { VueDatePicker },
  props: {
    modelValue: {
      type: [String, Date, Number],
      default: null
    },
    value: {
      type: [String, Date, Number], 
      default: null
    },
    type: {
      type: String,
      default: 'datetime',
      validator: (value) => ['date', 'datetime', 'time'].includes(value)
    },
    format: {
      type: String,
      default: null
    },
    valueFormat: {
      type: String,
      default: 'YYYY-MM-DD HH:mm:ss'
    },
    min: {
      type: [String, Date],
      default: null
    },
    max: {
      type: [String, Date],
      default: null
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: ''
    },
    locale: {
      type: String,
      default: 'ja'
    }
  },
  emits: ['update:modelValue', 'input', 'close', 'open'],
  setup(props, { emit }) {
    const localValue = ref(props.modelValue || props.value);
    
    const dateOnly = computed(() => props.type === 'date');
    const timeOnly = computed(() => props.type === 'time');
    
    const computedFormat = computed(() => {
      if (props.format) return props.format;
      if (dateOnly.value) return 'yyyy/MM/dd';
      if (timeOnly.value) return 'HH:mm';
      return 'yyyy/MM/dd HH:mm';
    });
    
    watch(() => props.modelValue, (newVal) => {
      localValue.value = newVal;
    });
    
    watch(() => props.value, (newVal) => {
      if (!props.modelValue) {
        localValue.value = newVal;
      }
    });
    
    const handleUpdate = (value) => {
      emit('update:modelValue', value);
      emit('input', value); // For v-model compatibility
    };
    
    return {
      localValue,
      dateOnly,
      timeOnly,
      computedFormat,
      handleUpdate
    };
  }
};
</script>

<style>
/* Override default styles to match vue-datetime appearance */
.dp__input {
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 0.375rem 0.75rem;
  font-size: 1rem;
  line-height: 1.5;
}

.dp__input:focus {
  border-color: #80bdff;
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
}
</style>