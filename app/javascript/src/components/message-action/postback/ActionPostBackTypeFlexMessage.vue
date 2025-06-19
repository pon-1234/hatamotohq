<template>
  <div>
    <label class="w-100">
      コンテンツ
      <required-mark />
    </label>

    <div class="btn-template mb20 fz14">
      <a @click="showFlexMessageModal = true" class="btn-block" v-if="currentTemplate.flex_message_id">
        <span>{{ currentTemplate.title }}</span>
      </a>
      <a @click="showFlexMessageModal = true" class="btn-block" v-else>Flexメッセージから作成</a>
      <input
        type="hidden"
        v-model="currentTemplate.flex_message_id"
        :name="name + '_flex_message_id'"
        :class="{ 'is-invalid': flexMessageError }"
      />
      <span v-if="flexMessageError" class="invalid-box-label">Flexメッセージは必須です</span>
    </div>

    <modal-select-flex-message-template 
      v-model="showFlexMessageModal"
      @selectFlexMessage="selectTemplate" 
    />
  </div>
</template>
<script setup>
import { ref, reactive, watch } from 'vue';
import ModalSelectFlexMessageTemplate from '../../common/ModalSelectFlexMessageTemplate.vue';
import RequiredMark from '../../common/RequiredMark.vue';

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      flex_message_id: null,
      title: 'Flexメッセージから作成'
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

const emit = defineEmits(['update:modelValue']);

const currentTemplate = reactive({
  flex_message_id: props.modelValue.flex_message_id || null,
  title: props.modelValue.title || null
});

const showFlexMessageModal = ref(false);
const flexMessageError = ref('');

watch(() => props.modelValue, (newValue) => {
  currentTemplate.flex_message_id = newValue.flex_message_id || null;
  currentTemplate.title = newValue.title || null;
}, { deep: true });

watch(() => currentTemplate.flex_message_id, () => {
  validateFlexMessage();
});

const validateFlexMessage = () => {
  if (!currentTemplate.flex_message_id) {
    flexMessageError.value = 'Flexメッセージは必須です';
  } else {
    flexMessageError.value = '';
  }
};

const selectTemplate = (flexMessage) => {
  const json = JSON.parse(flexMessage.json_message);
  json.id = flexMessage.id;
  currentTemplate.flex_message_id = flexMessage.id;
  currentTemplate.title = flexMessage.name;
  
  emit('update:modelValue', {
    title: flexMessage.name,
    flex_message_id: flexMessage.id
  });
};

defineExpose({
  validate: () => {
    validateFlexMessage();
    return !flexMessageError.value;
  }
});
</script>

<style scoped>
  .btn-block {
    cursor: pointer;
  }
</style>
