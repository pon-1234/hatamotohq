<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <select class="form-control w-100" :name="`answers[${qnum}][answer]`" v-model="answer" :required="isRequired">
      <option v-for="(option, index) in options" :key="index" :value="option.value">
        {{ option.value }}
      </option>
    </select>
    <error-message :message="errorMessage"></error-message>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

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

onMounted(() => {
  answer.value = options.value && options.value.length > 0 ? options.value[0].value : null
})
</script>

<style lang="scss" scoped>
</style>