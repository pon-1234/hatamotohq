<template>
  <div>
    <label>アクション</label>
    <div>
      <select v-model="postbackType" class="w-100 form-control" @change="changeActionType">
        <option v-for="(val, key) of types" :key="key" :value="key">{{ val }}</option>
      </select>
    </div>
    <div class="mt-2">
      <ActionPostbackText 
        v-if="postbackType === 'text'" 
        :action-data="content" 
        :name="name" 
        @update:model-value="updateContent"
      />

      <ActionPostbackTemplate 
        v-if="postbackType === 'template'" 
        :model-value="content" 
        @update:model-value="updateContent" 
        :name="name"
      />

      <ActionPostbackScenario 
        v-if="postbackType === 'scenario'" 
        :model-value="content" 
        :name="name" 
        @update:model-value="updateContent"
      />

      <ActionPostbackEmail 
        v-if="postbackType === 'email'" 
        :model-value="content" 
        :name="name" 
        @update:model-value="updateContent"
      />

      <ActionPostbackTag 
        v-if="postbackType === 'tag'" 
        :model-value="content" 
        :name="name" 
        @update:model-value="updateContent"
      />

      <ActionPostbackReminder
        v-if="postbackType === 'reminder'"
        :action-data="content"
        :name="name"
        @update:model-value="updateContent"
      />

      <ActionPostbackScoring
        v-if="postbackType === 'scoring'"
        :action-data="content"
        :name="name"
        @update:model-value="updateContent"
      />

      <ActionPostbackAssignStaff
        v-if="postbackType === 'assign_staff'"
        :action-data="content"
        :name="name"
        @update:model-value="updateContent"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import { usePostbackTypes } from '@/composables/useConstants';
import ActionPostbackText from './ActionPostbackText.vue';
import ActionPostbackTemplate from './ActionPostbackTemplate.vue';
import ActionPostbackScenario from './ActionPostbackScenario.vue';
import ActionPostbackEmail from './ActionPostbackEmail.vue';
import ActionPostbackTag from './ActionPostbackTag.vue';
import ActionPostbackReminder from './ActionPostbackReminder.vue';
import ActionPostbackScoring from './ActionPostbackScoring.vue';
import ActionPostbackAssignStaff from './ActionPostbackAssignStaff.vue';

// Props
const props = defineProps({
  modelValue: {
    type: [String, Object],
    default: null
  },
  name: {
    type: String,
    default: 'action'
  },
  showTitle: {
    type: Boolean,
    default: true
  },
  requiredLabel: {
    type: Boolean,
    default: true
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// Composables
const PostbackTypes = usePostbackTypes();

// State
const types = ref(PostbackTypes);
const postbackType = ref(null);
const content = ref(null);

// Methods
const updateContent = (newContent) => {
  content.value = newContent;
  notifyDataChanged();
};

const notifyDataChanged = () => {
  emit('update:modelValue', {
    type: postbackType.value,
    content: content.value
  });
};

const changeActionType = () => {
  content.value = undefined;
  notifyDataChanged();
};

const setupData = () => {
  if (props.modelValue) {
    const data = props.modelValue;
    content.value = data.content;
    postbackType.value = data.type || 'none';
  } else {
    postbackType.value = 'none';
  }
};

// Watch
watch(() => props.modelValue, () => {
  setupData();
}, { deep: true });

// Lifecycle
onMounted(() => {
  setupData();
});
</script>
