<template>
  <div class="b-form-tags" :class="{ 'form-control': !noOuterFocus, 'focus': isFocused }">
    <div class="d-flex flex-wrap align-items-center">
      <!-- Tags -->
      <span
        v-for="(tag, index) in tags"
        :key="`tag-${index}`"
        class="badge badge-secondary mr-1 mb-1"
        :class="tagClass"
      >
        <span>{{ tagFormatter ? tagFormatter(tag) : tag }}</span>
        <button
          v-if="!disabled && !readonly"
          type="button"
          class="close ml-1"
          :aria-label="`Remove tag: ${tag}`"
          @click="removeTag(index)"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </span>

      <!-- Input -->
      <input
        v-if="!disabled && !readonly"
        ref="input"
        v-model="inputValue"
        type="text"
        class="b-form-tags-input form-control-plaintext flex-grow-1"
        :placeholder="placeholder"
        :disabled="disabled || tagLimit"
        :required="required && tags.length === 0"
        @keydown="onKeydown"
        @focus="onFocus"
        @blur="onBlur"
        @input="onInput"
        :style="{ minWidth: inputMinWidth }"
      />
    </div>

    <!-- Duplicate warning -->
    <div v-if="duplicateTagText && isDuplicate" class="d-block invalid-feedback">
      {{ duplicateTagText }}
    </div>

    <!-- Invalid feedback -->
    <div v-if="invalidTagText && isInvalid" class="d-block invalid-feedback">
      {{ invalidTagText }}
    </div>

    <!-- Tag limit reached -->
    <small v-if="tagLimit && tags.length >= limit" class="form-text text-muted">
      Tag limit reached
    </small>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick } from 'vue'

const props = defineProps({
  modelValue: {
    type: Array,
    default: () => []
  },
  separator: {
    type: [String, Array],
    default: ' '
  },
  placeholder: {
    type: String,
    default: 'Add tag...'
  },
  duplicateTagText: {
    type: String,
    default: 'Duplicate tag(s)'
  },
  invalidTagText: {
    type: String,
    default: 'Invalid tag(s)'
  },
  limit: {
    type: Number,
    default: null
  },
  limitTagsText: {
    type: String,
    default: 'Tag limit reached'
  },
  addOnChange: {
    type: Boolean,
    default: false
  },
  noAddOnEnter: {
    type: Boolean,
    default: false
  },
  noOuterFocus: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  },
  readonly: {
    type: Boolean,
    default: false
  },
  required: {
    type: Boolean,
    default: false
  },
  tagVariant: {
    type: String,
    default: 'secondary'
  },
  tagClass: {
    type: [String, Array, Object],
    default: null
  },
  tagPills: {
    type: Boolean,
    default: false
  },
  tagFormatter: {
    type: Function,
    default: null
  },
  tagValidator: {
    type: Function,
    default: null
  },
  removeOnDelete: {
    type: Boolean,
    default: false
  },
  inputClass: {
    type: [String, Array, Object],
    default: null
  },
  inputMinWidth: {
    type: String,
    default: '5rem'
  }
})

const emit = defineEmits(['update:modelValue', 'input', 'tag-state'])

const input = ref(null)
const inputValue = ref('')
const isFocused = ref(false)
const isDuplicate = ref(false)
const isInvalid = ref(false)

const tags = computed({
  get: () => props.modelValue || [],
  set: (value) => {
    emit('update:modelValue', value)
    emit('input', value)
  }
})

const tagLimit = computed(() => {
  return props.limit && tags.value.length >= props.limit
})

const separators = computed(() => {
  if (Array.isArray(props.separator)) {
    return props.separator
  }
  return [props.separator]
})

const onKeydown = (event) => {
  const { key } = event
  
  // Handle enter key
  if (key === 'Enter' && !props.noAddOnEnter) {
    event.preventDefault()
    addTag()
  }
  
  // Handle separator keys
  if (separators.value.includes(key)) {
    event.preventDefault()
    addTag()
  }
  
  // Handle backspace/delete
  if ((key === 'Backspace' || (key === 'Delete' && props.removeOnDelete)) && 
      inputValue.value === '' && tags.value.length > 0) {
    removeTag(tags.value.length - 1)
  }
}

const onInput = () => {
  if (props.addOnChange) {
    // Check for separators in the input
    for (const separator of separators.value) {
      if (inputValue.value.includes(separator)) {
        const parts = inputValue.value.split(separator)
        inputValue.value = parts.pop() || ''
        parts.filter(p => p.trim()).forEach(part => addTag(part))
        break
      }
    }
  }
}

const onFocus = () => {
  isFocused.value = true
}

const onBlur = () => {
  isFocused.value = false
  if (props.addOnChange && inputValue.value.trim()) {
    addTag()
  }
}

const addTag = (value = null) => {
  const newTag = (value || inputValue.value).trim()
  
  if (!newTag) return
  
  // Reset states
  isDuplicate.value = false
  isInvalid.value = false
  
  // Check for duplicates
  if (tags.value.includes(newTag)) {
    isDuplicate.value = true
    emit('tag-state', [newTag], [], [newTag])
    return
  }
  
  // Validate tag
  if (props.tagValidator && !props.tagValidator(newTag)) {
    isInvalid.value = true
    emit('tag-state', [], [newTag], [])
    return
  }
  
  // Check limit
  if (props.limit && tags.value.length >= props.limit) {
    return
  }
  
  // Add tag
  const newTags = [...tags.value, newTag]
  tags.value = newTags
  inputValue.value = ''
  
  emit('tag-state', [newTag], [], [])
  
  // Focus back to input
  nextTick(() => {
    if (input.value) {
      input.value.focus()
    }
  })
}

const removeTag = (index) => {
  const removed = tags.value[index]
  const newTags = tags.value.filter((_, i) => i !== index)
  tags.value = newTags
  
  // Focus back to input
  nextTick(() => {
    if (input.value) {
      input.value.focus()
    }
  })
}

// Clear states when input changes
watch(inputValue, () => {
  isDuplicate.value = false
  isInvalid.value = false
})
</script>

<style scoped>
.b-form-tags {
  min-height: calc(1.5em + 0.75rem + 2px);
  padding: 0.25rem 0.5rem;
  display: block;
  width: 100%;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  color: #495057;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #ced4da;
  border-radius: 0.25rem;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.b-form-tags.focus {
  color: #495057;
  background-color: #fff;
  border-color: #80bdff;
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}

.b-form-tags-input {
  border: 0;
  padding: 0;
  margin: 0;
  background: transparent;
  max-width: 100%;
  outline: none;
  flex: 1 1 auto;
  width: auto;
  margin-bottom: 0.25rem;
}

.b-form-tags-input:focus {
  box-shadow: none;
}

.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  font-weight: 700;
}

.badge .close {
  margin-left: 0.25rem;
  font-size: 1.2rem;
  font-weight: 700;
  line-height: 1;
  color: inherit;
  text-shadow: none;
  opacity: 0.8;
  padding: 0;
  background: transparent;
  border: 0;
  cursor: pointer;
}

.badge .close:hover {
  opacity: 1;
}
</style> 