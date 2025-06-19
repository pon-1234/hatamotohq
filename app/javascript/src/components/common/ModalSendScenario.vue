<template>
  <BaseModal
    id="modalSendScenario"
    title="シナリオ配信を選択してください。"
    size="xl"
    hide-footer
    modal-class="mh-400"
    ref="modalRef"
  >
    <div class="text-sm">
      <div class="table-responsive" v-if="scenarios.length > 0">
        <table class="table table-hover">
          <thead class="thead-light">
            <tr>
              <th>#</th>
              <th class="mw-120">配信方式</th>
              <th class="mw-200">シナリオ名</th>
              <th class="mw-120">メッセージ数</th>
              <th class="mw-150"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(scenario, index) in scenarios" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ scenario.mode === "date" ? "時刻" : "経過時間" }}</td>
              <td>
                <p class="item-name mxw-400 mb-0">{{ scenario.title }}</p>
              </td>
              <td>{{ scenario.scenario_messages_count || 0 }}</td>
              <td class="text-end">
                <button
                  type="button"
                  class="btn btn-info btn-sm"
                  @click="sendScenario(scenario)"
                >
                  送信
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="text-center mt-4" v-else>
        送信できるシナリオはありません。
      </div>
    </div>
  </BaseModal>
</template>

<script setup>
import { ref, computed, watch, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import BaseModal from '../base/BaseModal.vue';

// Emits
const emit = defineEmits(['selectScenario']);

// Store
const store = useStore();

// Refs
const modalRef = ref(null);

// State
const scenarios = ref([]);

// Computed
const activeChannel = computed(() => store.state.channel.activeChannel);

// Methods
const getAvailableScenarios = (channelId) => {
  return store.dispatch('channel/getAvailableScenarios', channelId);
};

const sendScenario = (scenario) => {
  emit('selectScenario', scenario);
  modalRef.value?.hide();
};

const show = () => {
  modalRef.value?.show();
};

const hide = () => {
  modalRef.value?.hide();
};

// Watch
watch(activeChannel, async (newChannel) => {
  if (newChannel?.id) {
    scenarios.value = await getAvailableScenarios(newChannel.id);
  }
});

// Lifecycle
onBeforeMount(async () => {
  if (activeChannel.value?.id) {
    scenarios.value = await getAvailableScenarios(activeChannel.value.id);
  }
});

// Expose methods for parent component access
defineExpose({
  show,
  hide
});
</script>

<style scoped>
.mh-400 {
  max-height: 400px;
}

.text-sm {
  font-size: 0.875rem;
}

.mw-120 {
  min-width: 120px;
}

.mw-150 {
  min-width: 150px;
}

.mw-200 {
  min-width: 200px;
}

.mxw-400 {
  max-width: 400px;
}

.item-name {
  word-break: break-word;
}

.text-end {
  text-align: right !important;
}
</style>