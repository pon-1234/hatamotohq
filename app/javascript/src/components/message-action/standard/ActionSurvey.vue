<template>
  <section>
    <div v-if="showTitle" style="display: contents">
      <label class="mt-2">ラベル<required-mark v-if="requiredLabel" /></label>
      <div>
        <input
          :name="name + '_label'"
          placeholder="ラベルを入力してください"
          type="text"
          maxlength="12"
          v-model.trim="actionData.label"
          class="w-100 form-control"
          @input="changeValue"
          :class="{ 'is-invalid': labelError }"
        />
        <error-message :message="labelError"></error-message>
      </div>
    </div>

    <label class="w-100 mt-2">
      回答フォーム
      <required-mark></required-mark>
    </label>

    <div>
      <div @click="showSurveyModal = true" class="btn btn-secondary" v-if="actionData.content.id">
        <span>{{ actionData.content.name }}</span>
      </div>

      <div @click="showSurveyModal = true" class="btn btn-secondary" v-else>回答フォームを選択する</div>
      <input
        type="hidden"
        v-model="actionData.content.id"
        :name="name + '_survey_code'"
        :class="{ 'is-invalid': surveyError }"
      />
      <error-message :message="surveyError"></error-message>
    </div>
    <modal-select-survey v-model="showSurveyModal" @selectSurvey="selectSurvey($event)"></modal-select-survey>
  </section>
</template>
<script setup>
import { ref, reactive, watch } from 'vue';
import ModalSelectSurvey from '../../common/ModalSelectSurvey.vue';
import RequiredMark from '../../common/RequiredMark.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  name: {
    type: String,
    default: 'action'
  },
  requiredLabel: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['update:modelValue']);

const actionData = reactive({
  type: 'survey',
  label: props.modelValue?.label || null,
  content: {
    id: props.modelValue?.content?.id || null,
    name: props.modelValue?.content?.name || null
  }
});

const showSurveyModal = ref(false);
const labelError = ref('');
const surveyError = ref('');

watch(() => props.modelValue, (newValue) => {
  if (newValue) {
    actionData.label = newValue.label || null;
    actionData.content.id = newValue.content?.id || null;
    actionData.content.name = newValue.content?.name || null;
  }
}, { deep: true });

watch(() => actionData.label, () => {
  validateLabel();
});

watch(() => actionData.content.id, () => {
  validateSurvey();
});

const validateLabel = () => {
  if (props.requiredLabel && props.showTitle && !actionData.label) {
    labelError.value = 'ラベルを入力してください。';
  } else if (actionData.label && actionData.label.length > 12) {
    labelError.value = 'ラベルは12文字以内で入力してください。';
  } else {
    labelError.value = '';
  }
};

const validateSurvey = () => {
  if (!actionData.content.id) {
    surveyError.value = '回答フォームを入力してください。';
  } else {
    surveyError.value = '';
  }
};

const changeValue = () => {
  validateLabel();
  validateSurvey();
  
  emit('update:modelValue', {
    ...props.modelValue,
    type: 'survey',
    label: actionData.label,
    content: {
      id: actionData.content.id,
      name: actionData.content.name
    }
  });
};

const selectSurvey = (survey) => {
  if (!survey) return;
  actionData.content = {
    id: survey.id,
    name: survey.name
  };
  changeValue();
};

defineExpose({
  validate: () => {
    validateLabel();
    validateSurvey();
    return !labelError.value && !surveyError.value;
  }
});
</script>