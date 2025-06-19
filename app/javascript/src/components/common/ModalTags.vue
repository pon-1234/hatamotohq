<template>
  <BaseModal
    id="modal-tag"
    title="設定タグ一覧"
    hide-footer
    ref="modalRef"
  >
    <ul class="list-tag list-unstyled mb-0">
      <li class="tag badge badge-secondary" v-for="(item, index) in tags" :key="index">
        {{ item.name }}
      </li>
    </ul>
  </BaseModal>
</template>

<script setup>
import { ref } from 'vue';
import BaseModal from '../base/BaseModal.vue';

// Props
const props = defineProps({
  tags: {
    type: Array,
    default: () => []
  }
});

// Refs
const modalRef = ref(null);

// Methods
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

<style lang="scss" scoped>
.list-tag {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.tag {
  margin: 0;
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}
</style>
