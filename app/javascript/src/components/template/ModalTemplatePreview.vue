<template>
  <div
    id="modalTemplatePreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalTemplatePreview"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">テンプレートプレビュー</h5>
          <button type="button" class="close" @click="closeModal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">
          <template-messages></template-messages>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useStore } from 'vuex'

const props = defineProps({
  templateId: {
    type: [String, Number],
    required: true
  },
  modelValue: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

const store = useStore()
const modalTemplatePreview = ref(null)
const template = ref(null)
const contentKey = ref(0)

// Bootstrap modal instance
let modalInstance = null

const forceRerender = () => {
  contentKey.value++
}

const onShow = async () => {
  template.value = await store.dispatch('template/getTemplate', props.templateId)
  await store.dispatch('preview/setMessages', template.value.messages)
  forceRerender()
}

const closeModal = () => {
  if (modalInstance) {
    modalInstance.hide()
  }
  emit('update:modelValue', false)
}

// Watch for modelValue changes to show/hide modal
watch(() => props.modelValue, (newValue) => {
  if (modalInstance) {
    if (newValue) {
      modalInstance.show()
    } else {
      modalInstance.hide()
    }
  }
})

onMounted(() => {
  // Initialize Bootstrap modal
  if (window.bootstrap && modalTemplatePreview.value) {
    modalInstance = new window.bootstrap.Modal(modalTemplatePreview.value)
    
    // Handle Bootstrap modal events
    modalTemplatePreview.value.addEventListener('show.bs.modal', onShow)
    modalTemplatePreview.value.addEventListener('hidden.bs.modal', () => {
      emit('update:modelValue', false)
    })
  }
  
  // Show modal if modelValue is true on mount
  if (props.modelValue && modalInstance) {
    modalInstance.show()
  }
})

onUnmounted(() => {
  // Cleanup modal instance and event listeners
  if (modalTemplatePreview.value) {
    modalTemplatePreview.value.removeEventListener('show.bs.modal', onShow)
    modalTemplatePreview.value.removeEventListener('hidden.bs.modal', () => {
      emit('update:modelValue', false)
    })
  }
  if (modalInstance) {
    modalInstance.dispose()
  }
})
</script>
