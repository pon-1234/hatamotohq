<template>
  <div class="input-group">
    <input type="text" class="form-control" :value="text" readonly>
    <div class="input-group-append">
      <button 
        class="btn btn-outline-secondary" 
        type="button" 
        @click="copy"
        :title="copyButtonTitle"
      >
        <i class="mdi mdi-content-copy"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';

// Props
const props = defineProps({
  text: {
    type: String,
    default: ''
  }
});

// Emits
const emit = defineEmits(['copied']);

// State
const copyButtonTitle = ref('クリップボードにコピー');

// Methods
const copy = async () => {
  try {
    await navigator.clipboard.writeText(props.text);
    // Note: toastr would need to be implemented differently in Vue 3
    // For now, we'll emit an event that the parent can handle
    emit('copied', props.text);
    
    // Temporary visual feedback
    copyButtonTitle.value = 'コピーしました！';
    setTimeout(() => {
      copyButtonTitle.value = 'クリップボードにコピー';
    }, 2000);
  } catch (err) {
    console.error('Failed to copy text: ', err);
  }
};
</script>

<style scoped>
.input-group-append .btn {
  border-left: none;
}

input[readonly] {
  background-color: #e9ecef;
}
</style>