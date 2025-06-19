<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <div class="mt-2">
      <div
        class="custom-control custom-checkbox custom-control-inline d-flex flex-start"
        v-for="(option, index) in options"
        :key="index"
      >
        <input
          type="checkbox"
          class="custom-control-input"
          v-model="selectedOptions"
          :id="`${prefix}Option${index}`"
          :value="option.value"
        />
        <label class="custom-control-label" :for="`${prefix}Option${index}`">{{ option.value }}</label>
      </div>

      <input type="hidden" v-model="answer" :name="`answers[${qnum}][answer]`" :required="isRequired" />
      <error-message :message="errorMessage"></error-message>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  question: {
    type: Object,
    required: true
  },
  qnum: {
    type: Number,
    required: true
  }
})

const selectedOptions = ref([])
const answer = ref(null)
const errorMessage = ref('')

const prefix = computed(() => {
  return `surveyQuestion${props.qnum}`
})

const isRequired = computed(() => {
  return props.question ? props.question.required : false
})

const content = computed(() => {
  return props.question ? props.question.content : ''
})

const title = computed(() => {
  return content.value ? content.value.text : ''
})

const subTitle = computed(() => {
  return content.value ? content.value.sub_text : ''
})

const options = computed(() => {
  return content.value ? content.value.options : []
})

const onOptionChanged = () => {
  return 0
}

// Watch selectedOptions and update answer
watch(selectedOptions, (val) => {
  answer.value = val.join(',')
})
</script>

<style lang="scss" scoped>
</style>