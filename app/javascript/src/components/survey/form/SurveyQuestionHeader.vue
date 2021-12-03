<template>
  <div>
    <input type="hidden" :value="question.id" :name="`answers[${qnum}][id]`" />
    <p class="w-100">
      <span class="border-success question-title mr-2 font-weight-bold">{{ `Q${qnum}` }}</span
      >{{ title }} <required-mark v-if="isRequired"></required-mark>
    </p>
    <div class="w-100 text-muted text-sm my-1">{{ subTitle }}</div>
  </div>
</template>

<script>
export default {
  props: ['question', 'qnum'],

  computed: {
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
    }
  }
};
</script>

<style lang="scss" scoped>
  .question-title {
    border-bottom: 3px solid #0acf97;
  }

  .text-sm {
    font-size: 0.7rem;
  }
</style>