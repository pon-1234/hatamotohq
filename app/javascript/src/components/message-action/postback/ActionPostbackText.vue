<template>
  <div>
    <label>本文<RequiredMark /></label>
    <textarea
      :name="name + '_postback_text'"
      placeholder="本文を入力してください"
      rows="4"
      v-model="content.text"
      class="form-control"
      @input="changeValue"
      maxlength="1001"
      required
    />
    <ErrorMessage v-if="errorMessage" :message="errorMessage" />
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import RequiredMark from '../../common/RequiredMark.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

// Props
const props = defineProps({
  actionData: {
    type: Object,
    default: () => ({
      text: ''
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const content = ref(JSON.parse(JSON.stringify(props.actionData)));

// Computed
const errorMessage = computed(() => {
  if (!content.value.text) {
    return '本文は必須です';
  }
  if (content.value.text.length > 1000) {
    return '本文は1000文字以内で入力してください';
  }
  return null;
});

// Methods
const changeValue = (event) => {
  content.value.text = event.target.value;
  emit('update:modelValue', { text: event.target.value });
};

// Watch
watch(() => props.actionData, (newVal) => {
  content.value = JSON.parse(JSON.stringify(newVal));
}, { deep: true });
</script>
