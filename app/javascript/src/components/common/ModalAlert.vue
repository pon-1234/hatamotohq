<template>
  <BaseModal
    :id="id || 'modal-alert'"
    :title="title"
    hide-header
    :show-cancel-button="false"
    ok-text="OK"
    @ok="handleOk"
    ref="modalRef"
  >
    <p class="mb-3">{{ title }}</p>
  </BaseModal>
</template>

<script setup>
import { ref } from 'vue';
import BaseModal from '../base/BaseModal.vue';

// Props
const props = defineProps({
  title: {
    type: String,
    default: ''
  },
  id: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['input']);

// Refs
const modalRef = ref(null);

// Methods
const handleOk = () => {
  emit('input');
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

<style scoped>
.mb-3 {
  margin-bottom: 1rem !important;
}
</style>
