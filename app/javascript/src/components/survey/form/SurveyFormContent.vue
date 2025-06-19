<template>
  <div class="bg-white" v-if="survey">
    <img :src="`${survey.banner_url}`" v-if="survey.banner_url" class="banner mb-1">
    <div class="font-weight-bold">{{ survey.title }}</div>
    <div class="font-12">{{ survey.description }}</div>

    <div class="mt-2" v-for="(question, index) in questions" :key="index">
      <!-- Input text question -->
      <survey-form-text :question="question" :qnum="index + 1" v-if="question.type === 'text'"></survey-form-text>

      <!-- Input multi line text question -->
      <survey-form-textarea
        :question="question"
        :qnum="index + 1"
        v-if="question.type === 'textarea'"
      ></survey-form-textarea>

      <!-- Pulldown question -->
      <survey-form-pulldown
        :question="question"
        :qnum="index + 1"
        v-if="question.type === 'pulldown'"
      ></survey-form-pulldown>

      <!-- Radio button -->
      <survey-form-radio :question="question" :qnum="index + 1" v-if="question.type === 'radio'"></survey-form-radio>

      <!-- Checkbox -->
      <survey-form-checkbox
        :question="question"
        :qnum="index + 1"
        v-if="question.type === 'checkbox'"
      ></survey-form-checkbox>

      <!-- Image picker -->
      <survey-form-image :question="question" :qnum="index + 1" v-if="question.type === 'image'"></survey-form-image>

      <!-- Image picker -->
      <survey-form-pdf :question="question" :qnum="index + 1" v-if="question.type === 'pdf'"></survey-form-pdf>

      <!-- Date picker -->
      <survey-form-date :question="question" :qnum="index + 1" v-if="question.type === 'date'"></survey-form-date>

      <!-- Time picker -->
      <survey-form-time :question="question" :qnum="index + 1" v-if="question.type === 'time'"></survey-form-time>

      <!-- Datetime picker -->
      <survey-form-datetime
        :question="question"
        :qnum="index + 1"
        v-if="question.type === 'datetime'"
      ></survey-form-datetime>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  survey: {
    type: Object,
    required: true
  },
  preview: {
    type: Boolean,
    default: false
  }
})

const questions = computed(() => {
  return props.survey.questions
})
</script>

<style scoped>
  .banner {
    width: 100%;
    height: auto;
    object-fit: contain;
  }
</style>