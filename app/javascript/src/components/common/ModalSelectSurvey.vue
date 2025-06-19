<template>
  <BaseModal
    :id="id || 'modalSelectSurvey'"
    title="回答フォームを選択してください"
    size="xl"
    hide-footer
    modal-class="vh-90"
    ref="modalRef"
  >
    <div class="d-flex" v-if="folders && folders.length">
      <folder-left
        type="survey"
        :is-preview="true"
        :data="folders"
        :is-pc="isPc"
        :selected-folder="selectedFolder"
        @change-selected-folder="handleFolderChange"
      />
      <div class="flex-grow-1" :key="contentKey">
        <div class="table-responsive">
          <table class="table table-hover">
            <thead class="thead-light">
              <tr>
                <th>
                  <span v-if="curFolder">{{ curFolder.name }}</span>
                </th>
              </tr>
            </thead>
            <tbody v-if="curFolder?.surveys?.length">
              <tr v-for="(item, index) in curFolder.surveys" :key="index" class="folder-item">
                <td class="d-flex w-100">
                  <div class="item-name me-3">{{ item.name }}</div>
                  <button
                    class="btn btn-info btn-sm ms-auto mw-80 my-auto"
                    @click="selectSurvey(item)"
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
const emit = defineEmits(['selectSurvey']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const contentKey = ref(0);
const selectedFolder = ref(0);
const isPc = ref(true);

// Computed
const folders = computed(() => store.state.survey.folders);
const curFolder = computed(() => {
  return folders.value ? folders.value[selectedFolder.value] : null;
});

// Methods
const getSurveys = () => store.dispatch('survey/getSurveys');

const forceRerender = () => {
  contentKey.value++;
};

const handleFolderChange = (index) => {
  selectedFolder.value = index;
  forceRerender();
};

const selectSurvey = (survey) => {
  const data = JSON.parse(JSON.stringify(survey)); // Deep clone
  emit('selectSurvey', data);
  modalRef.value?.hide();
};

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

// Lifecycle
onBeforeMount(async () => {
  await getSurveys();
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

.pt-5 {
  padding-top: 3rem !important;
}

.mw-80 {
  min-width: 80px;
}

.item-name {
  word-break: break-word;
}
</style>
