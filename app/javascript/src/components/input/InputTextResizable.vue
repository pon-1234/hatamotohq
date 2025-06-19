<template>
  <textarea
    ref="textareaRef"
    :placeholder="placeholder"
    :value="modelValue"
    @input="onInput"
    @focus="onFocus"
    @keyup="onKeyup"
    @blur="onBlur"
  />
</template>

<script setup>
import { ref, watch, onUnmounted, nextTick } from 'vue';

const TYPING_INDICATOR_IDLE_TIME = 4000;

// Props
const props = defineProps({
  placeholder: {
    type: String,
    default: ''
  },
  modelValue: {
    type: String,
    default: ''
  },
  minHeight: {
    type: Number,
    default: 2
  }
});

// Emits
const emit = defineEmits(['update:modelValue', 'typing-on', 'typing-off', 'focus', 'blur']);

// Refs
const textareaRef = ref(null);

// State
const idleTimer = ref(null);

// Methods
const resizeTextarea = async () => {
  await nextTick();
  if (!textareaRef.value) return;
  
  if (!props.modelValue) {
    textareaRef.value.style.height = `${props.minHeight}rem`;
  } else {
    // Reset height to auto to get the correct scrollHeight
    textareaRef.value.style.height = 'auto';
    textareaRef.value.style.height = `${textareaRef.value.scrollHeight}px`;
  }
};

const onInput = (event) => {
  emit('update:modelValue', event.target.value);
  resizeTextarea();
};

const resetTyping = () => {
  emit('typing-off');
  idleTimer.value = null;
};

const turnOffIdleTimer = () => {
  if (idleTimer.value) {
    clearTimeout(idleTimer.value);
  }
};

const onKeyup = () => {
  if (!idleTimer.value) {
    emit('typing-on');
  }
  turnOffIdleTimer();
  idleTimer.value = setTimeout(
    () => resetTyping(),
    TYPING_INDICATOR_IDLE_TIME
  );
};

const onBlur = () => {
  turnOffIdleTimer();
  resetTyping();
  emit('blur');
};

const onFocus = () => {
  emit('focus');
};

const focus = () => {
  textareaRef.value?.focus();
};

// Watch
watch(() => props.modelValue, () => {
  resizeTextarea();
});

// Cleanup
onUnmounted(() => {
  turnOffIdleTimer();
});

// Expose methods for parent component access
defineExpose({
  focus
});
</script>

<style scoped>
textarea {
  width: 100%;
  resize: none;
  overflow-y: hidden;
  border: 1px solid #ced4da;
  border-radius: 0.25rem;
  padding: 0.375rem 0.75rem;
  font-size: 1rem;
  line-height: 1.5;
  transition: border-color 0.15s ease-in-out;
}

textarea:focus {
  outline: none;
  border-color: #80bdff;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}
</style>
