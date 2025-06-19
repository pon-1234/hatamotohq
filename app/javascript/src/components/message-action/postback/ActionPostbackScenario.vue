<template>
  <section>
    <label>シナリオ配信</label>
    <div class="btn-template mb20 fz14">
      <div @click="showModal = true" class="btn btn-secondary btn-block">
        {{ currentTemplate.title }}
      </div>
      <input
        type="hidden"
        v-model="currentTemplate.scenario_id"
        :name="name + '_scenario_id'"
        required
      />
      <ErrorMessage v-if="errorMessage" :message="errorMessage" />
    </div>

    <ModalSelectScenario 
      v-model:show="showModal"
      @select-scenario="onSelectScenario" 
      type="normal"
    />
  </section>
</template>

<script setup>
import { ref, watch, computed, onMounted } from 'vue';
import ErrorMessage from '../../common/ErrorMessage.vue';
import ModalSelectScenario from '../../common/ModalSelectScenario.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      scenario_id: null,
      title: 'シナリオ配信一覧から選択'
    })
  },
  name: {
    type: String,
    default: 'postback_action'
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const showModal = ref(false);
const scenarios = ref([]);
const currentTemplate = ref({
  scenario_id: null,
  title: null
});
const current_page_scenario = ref(0);
const total_scenario = ref(0);
const per_page_scenario = ref(10);
const isScenarioLoading = ref(false);

// Computed
const errorMessage = computed(() => {
  if (!currentTemplate.value.scenario_id) {
    return 'シナリオ配信は必須です';
  }
  return null;
});

// Methods
const onSelectScenario = (scenario) => {
  currentTemplate.value = { 
    scenario_id: scenario.id, 
    ...scenario 
  };
  emit('update:modelValue', {
    title: scenario.title,
    scenario_id: scenario.id
  });
};

// Watch
watch(currentTemplate, (val) => {
  if (props.modelValue.scenario_id) {
    emit('update:modelValue', {
      title: val.title,
      scenario_id: props.modelValue.scenario_id
    });
  }
}, { deep: true });

// Lifecycle
onMounted(() => {
  currentTemplate.value = {
    scenario_id: props.modelValue.scenario_id,
    title: props.modelValue.scenario_id == null ? 'シナリオ配信一覧から選択' : props.modelValue.title
  };
});
</script>

<style scoped>
.btn-block {
  cursor: pointer;
}

.mb20 {
  margin-bottom: 20px;
}

.fz14 {
  font-size: 14px;
}
</style>
