<template>
  <section class="config-score-container">
    <div>
      <div class="d-flex align-items-center">
        <div class="select-variable-btn-wrapper">
          <div
            class="btn btn-secondary mw-170 mr-2 mb-auto"
            @click="showVariableModal = true"
          >
            {{ content.variable.name || "友だち情報を選択" }}
          </div>
          <input
            type="hidden"
            :name="name + '_postback_friend_information'"
            v-model="content.variable.id"
            :class="{ 'is-invalid': variableError }"
          />
          <error-message :message="variableError"></error-message>
        </div>
        <div>
          <input
            type="number"
            :name="name + '_postback_score'"
            placeholder="スコアを入力してください"
            v-model="content.value"
            class="form-control mw-200"
            :class="{ 'is-invalid': scoreError }"
          />
          <error-message :message="scoreError"></error-message>
        </div>

        <span class="px-2">を</span>
        <select class="fw-120 form-control" v-model="content.operation">
          <option value="set">← (代入)</option>
          <option value="add">＋ (加算)</option>
          <option value="minus">－ (減算)</option>
          <option value="unset">X (消去)</option>
        </select>
        <span class="text-nowrap pl-2 mr-auto">する</span>
      </div>
    </div>
    <modal-select-variable 
      type="text" 
      v-model="showVariableModal"
      @selectVariable="selectVariable($event)"
    >
    </modal-select-variable>
  </section>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';
import ModalSelectVariable from '../../common/ModalSelectVariable.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

const SCORING_DEFAULT_ACTION_DATA = {
  operation: 'set',
  value: 0,
  variable: {
    id: null,
    name: null
  }
};

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => JSON.parse(JSON.stringify(SCORING_DEFAULT_ACTION_DATA))
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

const emit = defineEmits(['update:modelValue']);

const content = reactive({
  operation: props.modelValue.operation || 'set',
  value: props.modelValue.value || 0,
  variable: {
    id: props.modelValue.variable?.id || null,
    name: props.modelValue.variable?.name || null
  }
});

const showVariableModal = ref(false);
const variableError = ref('');
const scoreError = ref('');

watch(() => props.modelValue, (newValue) => {
  content.operation = newValue.operation || 'set';
  content.value = newValue.value || 0;
  content.variable.id = newValue.variable?.id || null;
  content.variable.name = newValue.variable?.name || null;
}, { deep: true });

watch(content, () => {
  validateForm();
  emit('update:modelValue', {
    operation: content.operation,
    value: content.value,
    variable: {
      id: content.variable.id,
      name: content.variable.name
    }
  });
}, { deep: true });

const validateVariable = () => {
  if (!content.variable.id) {
    variableError.value = '友だち情報を入力してください。';
  } else {
    variableError.value = '';
  }
};

const validateScore = () => {
  if (content.value === null || content.value === undefined || content.value === '') {
    scoreError.value = 'スコアを入力してください。';
  } else {
    scoreError.value = '';
  }
};

const validateForm = () => {
  validateVariable();
  validateScore();
};

const selectVariable = (variable) => {
  content.variable = {
    id: variable.id,
    name: variable.name
  };
};

defineExpose({
  validate: () => {
    validateForm();
    return !variableError.value && !scoreError.value;
  }
});
</script>
