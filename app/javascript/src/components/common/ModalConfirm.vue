<template>
  <BaseModal
    :id="id || 'confirmModal'"
    :title="title || 'お知らせ'"
    :ok-text="okButtonText"
    :ok-variant="okButtonVariant"
    :ok-disabled="confirmButtonDisabled"
    cancel-text="キャンセル"
    @ok="handleConfirm"
    ref="modalRef"
  >
    <slot name="content"></slot>
  </BaseModal>
</template>

<script setup>
import { ref, computed } from 'vue';
import BaseModal from '../base/BaseModal.vue';

// Props
const props = defineProps({
  id: {
    type: String,
    default: null
  },
  title: {
    type: String,
    default: null
  },
  type: {
    type: String,
    default: 'delete',
    validator: (value) => ['confirm', 'delete'].includes(value)
  },
  confirmButtonDisabled: {
    type: Boolean,
    default: false
  },
  confirmButtonLabel: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['confirm']);

// Refs
const modalRef = ref(null);

// Computed
const okButtonText = computed(() => {
  if (props.type === 'delete') {
    return '削除';
  }
  return props.confirmButtonLabel || '確認';
});

const okButtonVariant = computed(() => {
  return props.type === 'delete' ? 'danger' : 'info';
});

// Methods
const handleConfirm = () => {
  emit('confirm');
};

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

// Expose methods for parent component access
defineExpose({
  show,
  hide
});
</script>
