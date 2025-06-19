<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <div class="mt-2">
      <div
        class="custom-control custom-radio custom-control-inline d-flex flex-start"
        v-for="(option, index) in options"
        :key="index"
      >
        <input
          type="radio"
          :id="`${prefix}Option${index}`"
          :name="`answers[${qnum}][answer]`"
          class="custom-control-input"
          :value="option.value"
          v-model="answer"
          :required="isRequired && index === 0"
        />
        <label class="custom-control-label" :for="`${prefix}Option${index}`">{{ option.value }}</label>
      </div>
    </div>
    <error-message :message="errorMessage"></error-message>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

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
</script>

<style lang="scss" scoped>
</style>