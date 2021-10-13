<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <textarea
      rows="3"
      name="survey-name"
      class="form-control mt-2"
      placeholder="入力してください"
      v-validate="'required|max:255'"
      data-vv-as="答え"
    />
  </div>
</template>

<script>
export default {
  props: ['question', 'qnum'],

  computed: {
    isRequired() {
      return this.question ? this.question.required : '';
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
</style>