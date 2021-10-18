<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <ValidationProvider name="答え" :rules="{ required: isRequired }" v-slot="{ errors }">
      <div class="form-group">
        <div class="input-group">
          <div class="custom-file">
            <input
              type="file"
              class="custom-file-input"
              id="inputGroupFile04"
              accept="image/*,.pdf"
              :name="`answers[${qnum}][answer]`"
            />
            <label class="custom-file-label" for="inputGroupFile04">ファイルを選択</label>
          </div>
        </div>
      </div>
      <error-message :message="errors[0]"></error-message>
    </ValidationProvider>
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