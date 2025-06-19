<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100">
        ラベル
        <required-mark v-if="requiredLabel" />
      </label>
      <div class="w-100">
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model.trim="label"
          class="w-100 form-control"
          @input="onValueChanged"
          :class="{ 'is-invalid': labelError }"
        />
        <error-message :message="labelError"></error-message>
      </div>
    </div>
    <label class="mt4">
      電話番号
      <required-mark />
    </label>
    <div>
      <input
        :name="name + '_value'"
        type="text"
        maxlength="15"
        v-model="uri"
        placeholder="09044445555"
        class="form-control"
        @blur="onValueChanged"
        :class="{ 'is-invalid': phoneError }"
      />
      <error-message :message="phoneError"></error-message>
    </div>
  </div>
</template>
<script setup>
import { ref, watch, onMounted } from 'vue';
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

const label = ref('');
const uri = ref('');
const labelError = ref('');
const phoneError = ref('');

onMounted(() => {
  if (props.modelValue) {
    label.value = props.modelValue.label || '';
    const linkUri = props.modelValue.linkUri || props.modelValue.uri || '';
    uri.value = linkUri.replace('tel://', '');
  }
});

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    label.value = newValue.label || '';
    const linkUri = newValue.linkUri || newValue.uri || '';
    uri.value = linkUri.replace('tel://', '');
  }
}, { deep: true });

watch(label, () => {
  validateLabel();
});

watch(uri, () => {
  validatePhone();
});

const validateLabel = () => {
  if (props.requiredLabel && props.showTitle && !label.value) {
    labelError.value = 'ラベルを入力してください。';
  } else {
    labelError.value = '';
  }
};

const validatePhone = () => {
  if (!uri.value) {
    phoneError.value = '電話番号を入力してください。';
  } else if (!/^\d+$/.test(uri.value)) {
    phoneError.value = '電話番号は数値で入力してください。';
  } else if (uri.value.length < 10 || uri.value.length > 11) {
    phoneError.value = '電話番号は10〜11桁で入力してください。';
  } else {
    phoneError.value = '';
  }
};

const onValueChanged = () => {
  validateLabel();
  validatePhone();
  
  const data = {
    id: props.modelValue.id,
    label: label.value,
    linkUri: `tel://${uri.value}`,
    uri: `tel://${uri.value}`,
    type: props.modelValue.type
  };
  emit('update:modelValue', data);
};

defineExpose({
  validate: () => {
    validateLabel();
    validatePhone();
    return !labelError.value && !phoneError.value;
  }
});
</script>
