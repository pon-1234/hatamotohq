<template>
  <div>
    <label class="mt-4">ラベル<RequiredMark /></label>
    <div>
      <input 
        type="text" 
        maxlength="20" 
        placeholder="ラベルを入力してください" 
        :value="modelValue.label"
        @input="updateLabel"
        class="gw-100 form-control"
        name="action-default"
        required
      />
      <ErrorMessage v-if="errorMessage" :message="errorMessage" />
    </div>
  </div>
</template>

<script setup>
import RequiredMark from '../common/RequiredMark.vue';
import ErrorMessage from '../common/ErrorMessage.vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    required: true
  },
  errorMessage: {
    type: String,
    default: null
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// Methods
const updateLabel = (event) => {
  const updatedValue = {
    ...props.modelValue,
    label: event.target.value
  };
  emit('update:modelValue', updatedValue);
};
</script>

<style lang="scss" scoped>
.gw-100 {
  width: 100%;
}
</style>
