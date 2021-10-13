<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <select class="form-control w-100" @change="onOptionChanged">
      <option v-for="(option, index) in options" :key="index" :value="option.value">
        {{ option.value }}
      </option>
    </select>
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