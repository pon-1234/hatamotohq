<template>
  <div>
    <div v-if="showTitle" style="display: contents">
      <label class="w-100 mt20">
        ラベル
        <required-mark v-if="requiredLabel" />
      </label>
      <div class="w-100">
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model.trim="data.label"
          class="w-100 form-control"
          @input="changeValue"
          :class="{ 'is-invalid': labelError }"
        />
        <error-message :message="labelError"></error-message>
      </div>
    </div>
    <label class="w-100 mt-4">本文<required-mark /></label>
    <div>
      <textarea
        :name="name + '_value'"
        placeholder="本文を入力してください"
        type="text"
        maxlength="300"
        v-model.trim="data.text"
        class="w-100 form-control"
        @input="changeValue"
        :class="{ 'is-invalid': textError }"
      />
      <error-message :message="textError"></error-message>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, watch } from 'vue';
import RequiredMark from '../../common/RequiredMark.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  name: {
    type: String,
    default: 'action'
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  requiredLabel: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['update:modelValue']);

const data = reactive({
  label: props.modelValue?.label || '',
  text: props.modelValue?.text || ''
});

const labelError = ref('');
const textError = ref('');

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    data.label = newValue.label || '';
    data.text = newValue.text || '';
  }
}, { deep: true });

watch(() => data.label, () => {
  validateLabel();
});

watch(() => data.text, () => {
  validateText();
});

const validateLabel = () => {
  if (props.requiredLabel && props.showTitle && !data.label) {
    labelError.value = 'ラベルを入力してください。';
  } else {
    labelError.value = '';
  }
};

const validateText = () => {
  if (!data.text) {
    textError.value = '本文を入力してください。';
  } else {
    textError.value = '';
  }
};

const changeValue = () => {
  validateLabel();
  validateText();
  
  emit('update:modelValue', {
    ...props.modelValue,
    label: data.label,
    text: data.text
  });
};

defineExpose({
  validate: () => {
    validateLabel();
    validateText();
    return !labelError.value && !textError.value;
  }
});
</script>
