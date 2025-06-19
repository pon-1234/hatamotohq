<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100 d-flex align-items-center">
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

    <div class="mt-2">
      <label class="d-flex align-items-center">URL<required-mark /></label>
      <input
        :name="name + '_value'"
        type="text"
        maxlength="1000"
        v-model.trim="data.uri"
        placeholder="https://example.com"
        class="w-100 form-control"
        @input="changeValue"
        :class="{ 'is-invalid': urlError }"
      />
      <error-message :message="urlError"></error-message>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, watch } from 'vue';
import Util from '@/core/util';
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
  uri: props.modelValue?.uri || '',
  linkUri: props.modelValue?.linkUri || props.modelValue?.uri || ''
});

const labelError = ref('');
const urlError = ref('');

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    data.label = newValue.label || '';
    data.uri = newValue.uri || '';
    data.linkUri = newValue.linkUri || newValue.uri || '';
  }
}, { deep: true });

watch(() => data.label, () => {
  validateLabel();
});

watch(() => data.uri, () => {
  validateUrl();
});

const validateLabel = () => {
  if (props.requiredLabel && props.showTitle && !data.label) {
    labelError.value = 'ラベルを入力してください。';
  } else {
    labelError.value = '';
  }
};

const validateUrl = () => {
  if (!data.uri) {
    urlError.value = 'URLを入力してください。';
  } else if (!Util.validateUrl(data.uri)) {
    urlError.value = '正しいURL形式で入力してください。';
  } else {
    urlError.value = '';
  }
};

const changeValue = () => {
  validateLabel();
  validateUrl();
  
  data.linkUri = data.uri;
  emit('update:modelValue', {
    ...props.modelValue,
    label: data.label,
    uri: data.uri,
    linkUri: data.uri
  });
};

defineExpose({
  validate: () => {
    validateLabel();
    validateUrl();
    return !labelError.value && !urlError.value;
  }
});
</script>

<style lang="scss" scoped></style>
