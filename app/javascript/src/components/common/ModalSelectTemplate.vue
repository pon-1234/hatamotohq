<template>
  <BaseModal
    :id="id || 'modalSelectTemplate'"
    title="テンプレートを選択してください"
    size="lg"
    hide-footer
    modal-class="vh-90"
    ref="modalRef"
  >
    <div class="d-flex" v-if="folders && folders.length">
      <folder-left
        type="template_message"
        :is-preview="true"
        :data="folders"
        :is-pc="isPc"
        :selected-folder="selectedFolder"
        @change-selected-folder="changeSelectedFolderTemplate"
      />
      <div class="flex-grow-1 scroll-table">
        <table class="table table-hover">
          <thead class="thead-light">
            <tr>
              <th>
                <span v-if="folders[selectedFolder]">{{ folders[selectedFolder].name }}</span>
              </th>
            </tr>
          </thead>
          <tbody v-if="folders[selectedFolder]?.templates?.length">
            <tr v-for="(item, index) in folders[selectedFolder].templates" :key="index" class="folder-item">
              <td class="d-flex w-100">
                <div class="box-item-name">
                  <p class="m-0 vw-10 item-name">{{ item.name }}</p>
                </div>
                <button
                  class="btn btn-info btn-sm ms-auto my-auto"
                  @click="selectTemplate(item)"
                  type="button"
                >
                  選択
                </button>
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td class="text-center pt-5">データーがありません</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';
import FolderLeft from '../folder/FolderLeft.vue';

// Props
const props = defineProps({
  id: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['selectTemplate']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const selectedFolder = ref(0);
const isPc = ref(true);

// Computed
const folders = computed(() => store.state.template.folders);

// Methods
const getTemplates = () => store.dispatch('template/getTemplates');

const backToFolder = () => {
  isPc.value = false;
};

const selectTemplate = (template) => {
  const data = JSON.parse(JSON.stringify(template)); // Deep clone
  emit('selectTemplate', data);
  modalRef.value?.hide();
};

const changeSelectedFolderTemplate = (index) => {
  selectedFolder.value = index;
  isPc.value = true;
};

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

// Lifecycle
onBeforeMount(async () => {
  await getTemplates();
});

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

.scroll-table {
  overflow-y: auto;
  max-height: calc(90vh - 200px);
}

.pt-5 {
  padding-top: 3rem !important;
}

.vw-10 {
  width: 10vw;
}

.item-name {
  word-break: break-word;
}

.box-item-name {
  flex: 1;
  min-width: 0;
}
</style>
