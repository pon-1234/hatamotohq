<template>
  <div class="survey">
    <div class="form-group clearfix d-flex">
      <span class="fw-200">項目名<required-mark /></span>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.text"
          type="text"
          :name="name + '-text'"
          class="form-control"
          maxlength="256"
          placeholder="項目名を入力してください"
          v-validate="'required|max:255'"
          data-vv-as="項目名"
        />
        <error-message :message="errors.first(name + '-text')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <div class="fw-200 d-flex align-items-center">
        <span>補足文</span>
        <div data-bs-toggle="tooltip" data-bs-placement="top" title="回答入力欄の下に表示されます" class="ml-2">
          <i class="text-md far fa-question-circle"></i>
        </div>
      </div>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.sub_text"
          :name="name + '-subtext'"
          type="text"
          class="form-control"
          placeholder="補足文を入力してください"
          maxlength="256"
          v-validate="'max:255'"
          data-vv-as="補足文"
        />
        <error-message :message="errors.first(name + '-subtext')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <span class="fw-200">回答の情報登録</span>
      <div class="flex-grow-1">
        <survey-variable-config
          type="pdf"
          :field="value.variable ? value.variable.name : null"
          :name="name + '-infomation'"
          @input="value.variable = $event"
        ></survey-variable-config>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, inject } from 'vue'

const props = defineProps({
  content: {
    type: Object,
    default: null
  },
  name: {
    type: String,
    required: true
  }
})

const emit = defineEmits(['input'])

const parentValidator = inject('parentValidator', null)

const value = ref(props.content || {
  text: null,
  name: props.name,
  sub_text: null
})

// For vee-validate compatibility
const $validator = ref(null)
const errors = ref({ 
  first: () => null,
  items: [] 
})

const syncObj = () => {
  emit('input', value.value)
}

// Watch for content changes
watch(() => props.content, (val) => {
  value.value = val || {
    name: props.name,
    text: null,
    sub_text: null
  }
})

// Watch value changes to emit
watch(value, () => {
  syncObj()
}, { deep: true })

onMounted(() => {
  $validator.value = parentValidator
  value.value.name = props.name
  syncObj()
  
  // Initialize Bootstrap tooltips
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
})
</script>
