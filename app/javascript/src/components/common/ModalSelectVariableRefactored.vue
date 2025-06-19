<template>
  <BaseModal
    :id="modalId"
    ref="modalRef"
    title="友達情報名を選択してください"
    size="lg"
    hide-footer
    @shown="reloadVariables"
  >
    <div class="d-flex modal-content-height">
      <folder-left
        type="variable"
        :is-preview="true"
        :data="folders"
        :selected-folder="selectedFolderIndex"
        @change-selected-folder="changeSelectedFolder"
      />
      <div class="flex-grow-1 scroll-table" :key="contentKey">
        <BaseTable
          :items="variables"
          :fields="fields"
          :paginate="false"
          :searchable="true"
          search-placeholder="変数名で検索..."
          :search-fields="['name']"
        >
          <template #cell(actions)="{ item }">
            <button
              class="btn btn-sm btn-light"
              @click="selectVariable(item)"
              type="button"
            >
              選択
            </button>
          </template>
        </BaseTable>
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import BaseTable from '../base/BaseTable.vue';
import FolderLeft from '../folder/FolderLeft.vue';

// Props
const props = defineProps({
  id: {
    type: String,
    default: 'modal-select-variable'
  },
  type: {
    type: String,
    required: true
  }
});

// Emits
const emit = defineEmits(['select-variable']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const contentKey = ref(0);
const folders = ref([]);
const selectedFolderIndex = ref(0);

// Fields configuration
const fields = [
  {
    key: 'name',
    label: '名称',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    class: 'text-right fw-120'
  }
];

// Computed
const modalId = computed(() => props.id || 'modal-select-variable');

const curFolder = computed(() => {
  return folders.value[selectedFolderIndex.value];
});

const variables = computed(() => {
  return curFolder.value 
    ? curFolder.value.variables.filter(v => v.type === props.type) 
    : [];
});

// Methods
const getFolders = (params) => store.dispatch('variable/getFolders', params);

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

const forceRerender = () => {
  contentKey.value++;
};

const reloadVariables = async () => {
  try {
    folders.value = await getFolders({ type: props.type });
  } catch (error) {
    console.error('Failed to load variables:', error);
    // Note: Toast notification would need to be implemented differently in Vue 3
  }
};

const changeSelectedFolder = (index) => {
  selectedFolderIndex.value = index;
  forceRerender();
};

const selectVariable = (variable) => {
  const data = JSON.parse(JSON.stringify(variable)); // Deep clone
  emit('select-variable', data);
  hide();
};

// Expose methods for parent component access
defineExpose({
  show,
  hide
});
</script>

<style scoped>
.modal-content-height {
  min-height: 400px;
}

.scroll-table {
  overflow-y: auto;
  max-height: 500px;
}

.fw-120 {
  width: 120px;
}

:deep(.table) {
  margin-bottom: 0;
}

.text-right {
  text-align: right !important;
}
</style>