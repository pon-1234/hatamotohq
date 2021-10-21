<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>

    <div class="mt-2">
      <div
        class="custom-control custom-radio custom-control-inline d-flex flex-start"
        v-for="(option, index) in options"
        :key="index"
      >
        <input type="radio" :id="`${prefix}Option${index}`" name="customRadio1" class="custom-control-input" />
        <label class="custom-control-label" :for="`${prefix}Option${index}`">{{ option.value }}</label>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['question', 'qnum'],

  computed: {
    prefix() {
      return `surveyQuestion${this.qnum}`;
    },

    isRequired() {
      return this.question ? this.question.required : false;
    },

    content() {
      return this.question ? this.question.content : '';
    },

    title() {
      return this.content ? this.content.text : '';
    },

    subTitle() {
      return this.content ? this.content.sub_text : '';
    },

    options() {
      return this.content ? this.content.options : [];
    }
  },

  methods: {
    onOptionChanged() {
      return 0;
    }
  }
};
</script>

<style lang="scss" scoped>
</style>