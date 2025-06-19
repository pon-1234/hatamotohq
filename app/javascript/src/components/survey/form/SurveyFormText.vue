<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <input
      type="text"
      :name="`answers[${qnum}][answer]`"
      class="form-control mt-2"
      placeholder="入力してください"
      v-model.trim="answer"
      :required="isRequired"
      maxlength="255"
    />
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

const answer = ref('')
const errorMessage = ref('')

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
</script>

<style lang="scss" scoped>
</style>