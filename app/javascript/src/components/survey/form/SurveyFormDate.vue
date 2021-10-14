<template>
  <div>
    <survey-question-header :question="question" :qnum="qnum"></survey-question-header>
    <div class="form-group mt-1 position-relative">
      <datetime
        :name="`${prefix}DatePicker`"
        input-class="form-control btn border border-light"
        type="datetime"
        :phrases="{ ok: '確定', cancel: '閉じる' }"
        placeholder="日付を選択してください"
        value-zone="Asia/Tokyo"
        v-validate="'required'"
        zone="Asia/Tokyo"
      ></datetime>
      <i class="dripicons-chevron-down dropdown-icon"></i>
    </div>
  </div>
</template>

<script>
import { Datetime } from 'vue-datetime';

export default {
  components: {
    Datetime
  },

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
  .dropdown-icon {
    position: absolute;
    top: calc(50% - 10px);
    right: 5px;
  }
</style>