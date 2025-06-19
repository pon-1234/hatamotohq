<template>
  <BaseModal
    :id="id"
    title="シナリオ配信を選択してください。"
    size="lg"
    hide-footer
    ref="modalRef"
  >
    <div class="text-sm">
      <table class="table table-hover">
        <thead class="thead-light">
          <tr>
            <th>#</th>
            <th class="mw-150">配信方式</th>
            <th class="mw-150">シナリオ名</th>
            <th class="mw-150">メッセージ数</th>
            <th class="mw-120">選択</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(scenario, index) in scenarios" :key="index">
            <td>{{ index + 1 }}</td>
            <td>{{ scenario.mode === "time" ? "時刻" : "経過時間" }}</td>
            <td>
              <p class="item-name mxw-400 mb-0">{{ scenario.title }}</p>
            </td>
            <td>{{ scenario.scenario_messages_count || 0 }}</td>
            <td>
              <button
                type="button"
                class="btn btn-info btn-sm"
                @click="selectScenario(scenario)"
              >
                選択
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';

// Props
const props = defineProps({
  type: {
    type: String,
    default: null
  },
  id: {
    type: String,
    required: true
  }
});

// Emits
const emit = defineEmits(['selectScenario']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const scenarios = ref([]);

// Methods
const getManualScenarios = () => store.dispatch('scenario/getManualScenarios');

const selectScenario = (scenario) => {
  emit('selectScenario', scenario);
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
  const response = await getManualScenarios();
  scenarios.value = response;
});

// Expose methods for parent component access
defineExpose({
  show,
  hide
});
</script>

<style scoped>
.text-sm {
  font-size: 0.875rem;
}

.mw-150 {
  min-width: 150px;
}

.mw-120 {
  min-width: 120px;
}

.mxw-400 {
  max-width: 400px;
}

.item-name {
  word-break: break-word;
}
</style>