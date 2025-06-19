<template>
  <div>
    <div v-if="showTitle">
      <label class="w-100">
        ラベル
        <required-mark v-if="requiredLabel" />
      </label>
      <div class="w-100">
        <input
          type="text"
          name="datetime-label"
          placeholder="ラベルを入力してください"
          maxlength="12"
          v-model="data.label"
          class="w-100 form-control"
          @input="changeValue"
          :class="{ 'is-invalid': labelError }"
        />
        <error-message :message="labelError"></error-message>
      </div>
    </div>
    <label class="w-100 mt20"> モード </label>
    <div class="w-100">
      <select v-model="data.mode" class="form-control w-100 form-control" @change="changeValue">
        <option v-for="(item, index) in modes" :key="index" :value="item.value">
          {{ item.text }}
        </option>
      </select>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, watch, onMounted } from 'vue';
import ErrorMessage from '../../common/ErrorMessage.vue';
import RequiredMark from '../../common/RequiredMark.vue';

const props = defineProps({
  modelValue: {
    type: Object,
    required: true
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

const modes = [
  { text: '日付', value: 'date' },
  { text: '時間', value: 'time' },
  { text: '日付時刻', value: 'datetime' }
];

const data = reactive({
  label: props.modelValue?.label || '',
  mode: props.modelValue?.mode || 'date',
  data: props.modelValue?.data || 'eyJ0eXBlIjoiZGF0ZXRpbWUifQ=='
});

const labelError = ref('');

onMounted(() => {
  if (!props.modelValue?.data) {
    changeValue();
  }
});

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    data.label = newValue.label || '';
    data.mode = newValue.mode || 'date';
    data.data = newValue.data || 'eyJ0eXBlIjoiZGF0ZXRpbWUifQ==';
  }
}, { deep: true });

watch(() => data.label, () => {
  validateLabel();
});

const validateLabel = () => {
  if (props.requiredLabel && props.showTitle && !data.label) {
    labelError.value = 'ラベルを入力してください。';
  } else {
    labelError.value = '';
  }
};

const changeValue = () => {
  validateLabel();
  emit('update:modelValue', {
    label: data.label,
    mode: data.mode,
    data: data.data
  });
};

defineExpose({
  validate: () => {
    validateLabel();
    return !labelError.value;
  }
});
</script>

<style lang="scss" scoped></style>
