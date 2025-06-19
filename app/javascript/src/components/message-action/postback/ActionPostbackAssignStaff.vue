<template>
  <div>
    <StaffSelection 
      @select="changeValue" 
      :selected="actionData.staff_id"
    />
    <input
      :name="name + '_postback_staff_id'"
      v-model="content.staff_id"
      class="d-none"
      required
    />
    <ErrorMessage v-if="errorMessage" :message="errorMessage" />
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import StaffSelection from '../../common/StaffSelection.vue';
import ErrorMessage from '../../common/ErrorMessage.vue';

// Props
const props = defineProps({
  actionData: {
    type: Object,
    default: () => ({
      staff_id: null
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
const content = ref({ 
  staff_id: null, 
  ...JSON.parse(JSON.stringify(props.actionData)) 
});

// Computed
const errorMessage = computed(() => {
  if (!content.value.staff_id) {
    return '担当者は必須です';
  }
  return null;
});

// Methods
const changeValue = (staffId) => {
  content.value.staff_id = staffId;
  emit('update:modelValue', { staff_id: staffId });
};

// Watch
watch(() => props.actionData, (newVal) => {
  content.value = JSON.parse(JSON.stringify(newVal));
}, { deep: true });
</script>

<style lang="scss" scoped>
:deep(li.multiselect__element) {
  display: block;
}
</style>