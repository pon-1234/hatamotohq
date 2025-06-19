<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <div class="form-group mt-2 position-relative">
      <input
        type="datetime-local"
        class="form-control"
        :name="`answers[${qnum}][answer]`"
        v-model="answer"
        :required="isRequired"
        placeholder="日付・時刻を選択してください"
      />
      <i class="dripicons-chevron-down dropdown-icon"></i>
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

const onOptionChanged = () => {
  return 0
}
</script>

<style lang="scss" scoped>
  .dropdown-icon {
    position: absolute;
    top: calc(50% - 10px);
    right: 5px;
  }
</style>