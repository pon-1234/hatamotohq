<template>
  <base-modal
    :id="modalId"
    ref="modal"
    title="メディア"
    size="xl"
    hide-footer
    @show="handleShow"
    @hide="handleHide"
  >
    <template v-if="visible">
      <base-tabs-slot content-class="mt-3">
        <base-tab title="新規アップロード" active>
          <media-upload
            ref="mediaUpload"
            :types="types"
            @upload="selectMedia"
          />
        </base-tab>
        <base-tab title="メディア一覧">
          <media-index
            ref="modalMediaIndex"
            mode="read"
            :filterable="filterable"
            :types="types"
            @select="selectMedia"
          />
        </base-tab>
      </base-tabs-slot>
    </template>
  </base-modal>
</template>

<script setup>
import { ref, computed } from 'vue'
import BaseModal from '../base/BaseModal.vue'
import MediaUpload from './MediaUpload.vue'
import MediaIndex from './MediaIndex.vue'

const props = defineProps({
  types: {
    type: Array,
    default: () => ['image', 'audio', 'video']
  },
  filterable: {
    type: Boolean,
    default: true
  },
  id: {
    type: String,
    default: 'modal-select-media'
  }
})

const emit = defineEmits(['select'])

const visible = ref(false)
const modal = ref(null)

const modalId = computed(() => props.id || 'modal-select-media')

const show = () => {
  modal.value?.show()
}

const hide = () => {
  modal.value?.hide()
}

const selectMedia = (media) => {
  emit('select', media)
  hide()
}

const handleShow = () => {
  visible.value = true
}

const handleHide = () => {
  visible.value = false
}

defineExpose({
  show,
  hide
})
</script>

<style scoped>
:deep(.modal-body) {
  min-height: 70vh;
}

:deep(.tab-content) {
  padding: 1rem 0;
}

:deep(.nav-tabs) {
  border-bottom: 2px solid #dee2e6;
}

:deep(.nav-link.active) {
  border-color: #dee2e6 #dee2e6 #fff;
  border-bottom: 2px solid #fff;
  margin-bottom: -2px;
}
</style>