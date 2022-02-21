<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <input type="hidden" name="review[friend_line_id]" :value="friendLineId" />

      <div class="form-group review-question" v-for="(question, questionIndex) in questions" :key="`question_${question.id}`">
        <h3>{{question.title}} <span class="text-danger" v-if="question.required">*</span></h3>
        <!-- input's name  suitable with nested attributes in rails -->
        <input type="hidden" :value="question.id" :name="`review[review_answers_attributes][${questionIndex}][review_question_id]`" />

        <div class="review-answer-options" v-if="question.type == 'rating'">
          <div class="form-check form-check-inline" v-for="answerIndex in 10" :key="`review_answer_${answerIndex}`">
            <input class="form-check-input" type="radio" :name="`review[review_answers_attributes][${questionIndex}][answer]`" 
              :id="`question_${question.id}_answer_${answerIndex}`" :value="answerIndex" style="width: 18px; height: 18px">
            <label class="form-check-label" :for="`question_${question.id}_answer_${answerIndex}`">{{answerIndex}}</label>
          </div>
        </div>

        <div class="review-answer-text" v-if="question.type == 'text'">
          <input type="text" :name="`review[review_answers_attributes][${questionIndex}][answer]`" class="form-control">
        </div>
      </div>
      
      <div class="card-footer border-top border-success text-center py-3">
        <button type="submit" class="btn btn-success fw-120">送信</button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </form>
  </ValidationObserver>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util.js';
import moment from 'moment-timezone';

export default {
  props: {
    friendLineId: {
      type: String
    }
  },

  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      reviewFormData: {        
      },
      // questions: [{id: 1, "type": "rating",
      //   "title": "チェックイン",
      //   "description": null,
      //   "config": {"max_label": "Very good", "max_value": 10, "min_label": "Very bad", "min_value": 1},
      //   "sort_order": 1, required: true},
      // {id: 2, "type": "rating",
      //   "title": "料理",
      //   "description": null,
      //   "config": {"max_label": "Very good", "max_value": 10, "min_label": "Very bad", "min_value": 1},
      //   "sort_order": 2, required: true},
      // {id: 3, "type": "rating",
      //   "title": "サービス",
      //   "description": null,
      //   "config": {"max_label": "Very good", "max_value": 10, "min_label": "Very bad", "min_value": 1},
      //   "sort_order": 3, required: true},
      // {id: 4, "type": "text", "title": "その他", "description": null, "config": null, "sort_order": 4, required: false}]
    };
  },

  async beforeMount() {
    await this.getQuestions();
    this.loading = false;
  },

  // mounted() {
  //   // this.inquiryFormData.date_begin = this.currentDate;
  //   // this.inquiryFormData.date_end = this.currentDate;
  // },

  computed: {
    formAction() {
      return `${this.rootPath}/reviews/${this.friendLineId}`;
    },
    ...mapState('review', {
      questions: state => state.questions,
    }),
  },

  methods: {
    ...mapActions('review', ['getQuestions']),

    async onSubmit(e) {
      this.$refs.form.submit();
    }
  }
};
</script>