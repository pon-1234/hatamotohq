<template>
  <div class="bg-white">
    <div class="font-weight-bold">{{ survey.title }}</div>
    <div class="font-12">{{ survey.description }}</div>

    <div v-for="(question, index) in questions" :key="index">
      <!-- Input text question -->
      <survey-form-text :question="question" :qnum="index + 1" v-if="question.type === 'text'"></survey-form-text>

      <!-- Input mmulti line text question -->
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

      <!-- RaFile picker -->
      <survey-form-file :question="question" :qnum="index + 1" v-if="question.type === 'file'"></survey-form-file>

      <!-- RaFile picker -->
      <survey-form-date :question="question" :qnum="index + 1" v-if="question.type === 'date'"></survey-form-date>
    </div>
  </div>
</template>

<script>
export default {
  props: ['survey'],

  data() {
    return {
    };
  },

  computed: {
    questions() {
      return this.survey.questions;
    }
  }
};
</script>