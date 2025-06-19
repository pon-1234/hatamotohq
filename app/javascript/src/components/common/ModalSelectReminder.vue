<template>
  <BaseModal
    :id="id || 'modalSelectReminder'"
    title="リマインダを選択してください"
    size="lg"
    hide-footer
    modal-class="vh-90"
    ref="modalRef"
  >
    <div class="d-flex" v-if="folders && folders.length">
      <folder-left
        type="reminder"
        :is-preview="true"
        :data="folders"
        :is-pc="isPc"
        :selected-folder="selectedFolder"
        @change-selected-folder="changeSelectedReminder"
      />
      <div class="flex-grow-1">
        <table class="table table-hover">
          <thead class="thead-light">
            <tr>
              <th>
                <span v-if="curFolder">{{ curFolder.name }}</span>
              </th>
            </tr>
          </thead>
          <tbody v-if="curFolder?.reminders?.length">
            <tr v-for="(item, index) in curFolder.reminders" :key="index" class="folder-item">
              <td class="d-flex w-100">
                <div class="me-1">{{ item.name }}</div>
                <button
                  class="btn btn-info btn-sm ms-auto my-auto fw-80"
                  @click="selectReminder(item)"
                  type="button"
                >
                  選択
                </button>
              </td>
            </tr>
          </tbody>
          <tbody v-else>
            <tr>
              <td class="text-center my-5">データーがありません</td>
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
const emit = defineEmits(['selectReminder']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const selectedFolder = ref(0);
const isPc = ref(true);

// Computed
const folders = computed(() => store.state.reminder.folders);
const curFolder = computed(() => {
  return folders.value ? folders.value[selectedFolder.value] : null;
});

// Methods
const getReminders = () => store.dispatch('reminder/getReminders');

const backToFolder = () => {
  isPc.value = false;
};

const selectReminder = (reminder) => {
  const data = JSON.parse(JSON.stringify(reminder)); // Deep clone
  emit('selectReminder', data);
  modalRef.value?.hide();
};

const changeSelectedReminder = (index) => {
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
  await getReminders();
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

.fw-80 {
  min-width: 80px;
}

.my-5 {
  margin-top: 3rem !important;
  margin-bottom: 3rem !important;
}
</style>