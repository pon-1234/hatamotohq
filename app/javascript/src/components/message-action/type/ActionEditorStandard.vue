<template>
  <div>
    <ActionObjectSelector
      title="Action Type"
      :model-value="action"
      :supports="supports"
      @update:model-value="changeAction"
      :is-none="isNone"
      :message-type="messageType"
      class="form-group"
    />

    <ActionObjectValue
      :model-value="action"
      :name="'message_action_' + name"
      :required-label="requiredLabel"
      :show-title="showTitle"
      @update:model-value="changeAction"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import ActionObjectSelector from '../standard/ActionObjectSelector.vue';
import ActionObjectValue from '../standard/ActionObjectValue.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  supports: {
    type: Array,
    default: () => []
  },
  requiredLabel: {
    type: Boolean,
    default: true
  },
  isNone: {
    type: Boolean,
    default: false
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  messageType: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// State
const type = ref('basic');
const action = ref({ type: 'none' });

// Methods
const changeType = (newType) => {
  type.value = newType;
};

const changeAction = (value) => {
  action.value = value;
  emit('update:modelValue', value);
};

// Lifecycle
onMounted(() => {
  action.value = JSON.parse(JSON.stringify(props.modelValue));
});
</script>
