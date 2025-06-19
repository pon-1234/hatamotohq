<template>
  <div>
    <div class="btn btn-secondary mw-200" data-bs-toggle="modal" :data-bs-target="`#${name}-modal-select-variable`">
      {{ variable_name || "友だち情報を選択" }}
    </div>
    <modal-select-variable :type="type" :id="`${name}-modal-select-variable`" @selectVariable="selectVariable($event)">
    </modal-select-variable>
  </div>
</template>
<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  name: {
    default: 'text',
    type: String
  },
  field: {
    default: null,
    type: String
  },
  type: {
    default: null,
    type: String
  }
})

const emit = defineEmits(['input'])

const variable_name = ref(props.field)

// Watch for field prop changes
watch(() => props.field, (newField) => {
  variable_name.value = newField
})

const selectVariable = (variable) => {
  variable_name.value = variable.name
  emit('input', {
    id: variable.id,
    name: variable.name
  })
}
</script>
