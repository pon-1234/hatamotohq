<template>
  <BaseModal
    :id="id || 'modal-template'"
    title="友達情報名を選択してください"
    size="lg"
    hide-footer
    modal-class="vh-90"
    ref="modalRef"
    @shown="reloadVariables"
  >
    <div class="d-flex">
      <folder-left
        type="variable"
        :is-preview="true"
        :data="folders"
        :selected-folder="selectedFolderIndex"
        @change-selected-folder="changeSelectedFolder"
      />
      <div class="flex-grow-1 scroll-table" :key="contentKey">
        <table class="table">
          <thead class="thead-light">
            <tr>
              <th>名称</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(variable, index) in variables" :key="index">
              <td>{{ variable.name }}</td>
              <td class="fw-120">
                <button
                  @click="selectVariable(variable)"
                  class="btn btn-sm btn-light"
                  type="button"
                >
                  選択
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import FolderLeft from '../folder/FolderLeft.vue';

// Props
const props = defineProps({
  id: {
    type: String,
    default: null
  },
  type: {
    type: String,
    required: true
  }
});

// Emits
const emit = defineEmits(['selectVariable']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const contentKey = ref(0);
const folders = ref([]);
const selectedFolderIndex = ref(0);

// Computed
const curFolder = computed(() => {
  return folders.value[selectedFolderIndex.value];
});

const variables = computed(() => {
  return curFolder.value ? curFolder.value.variables.filter(v => v.type === props.type) : [];
});

// Methods
const forceRerender = () => {
  contentKey.value++;
};

const reloadVariables = async () => {
  folders.value = await store.dispatch('variable/getFolders', { type: props.type });
};

const changeSelectedFolder = (index) => {
  selectedFolderIndex.value = index;
  forceRerender();
};

const selectVariable = (variable) => {
  const data = JSON.parse(JSON.stringify(variable)); // Deep clone
  emit('selectVariable', data);
  modalRef.value?.hide();
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
.vh-90 {
  max-height: 90vh;
}

.fw-120 {
  width: 120px;
}

.scroll-table {
  overflow-y: auto;
  max-height: calc(90vh - 200px);
}
</style>