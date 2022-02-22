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

      <div class="form-group review-question border" v-for="(question, questionIndex) in questions" :key="`question_${question.id}`">
        <h3 class="review-question-title mt-0">{{question.title}} <span class="text-danger" v-if="question.required">*</span></h3>
        <!-- input's name  suitable with nested attributes in rails -->
        <input type="hidden" :value="question.id" :name="`review[review_answers_attributes][${questionIndex}][review_question_id]`" />

        <div class="review-answer-options-container d-inline-block" v-if="question.type == 'rating'">
          <div class="review-answer-options d-inline-block pl-2">
            <ValidationProvider :name="question.title" :rules="question.required ? 'required' : ''" v-slot="{ errors }">
              <div class="review-answer-option form-check form-check-inline" v-for="answerIndex in 10" :key="`review_answer_${answerIndex}`" v-if="answerIndex >= question.config.min_value && answerIndex <= question.config.max_value">
                <label class="form-check-label justify-content-center" :for="`question_${question.id}_answer_${answerIndex}`">{{answerIndex}}</label>
                <input v-model="reviewFormData[`answerOfQuestion${question.id}`]" class="form-check-input" type="radio" :name="`review[review_answers_attributes][${questionIndex}][answer]`" 
                  :id="`question_${question.id}_answer_${answerIndex}`" :value="answerIndex">
              </div>
              <span class="error-explanation">{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <div class="review-answer-option-labels d-flex justify-content-between mt-1">
            <p class="mb-0">{{question.config.min_label}}</p>
            <p class="mb-0">{{question.config.max_label}}</p>
          </div>
        </div>

        <div class="review-answer-text" v-if="question.type == 'text'">
          <ValidationProvider :name="question.title" :rules="question.required ? 'required' : ''" v-slot="{ errors }">
            <input type="text" v-model="reviewFormData[`answerOfQuestion${question.id}`]" :name="`review[review_answers_attributes][${questionIndex}][answer]`" class="form-control" placeholder="回答を入力">
            <span class="error-explanation">{{ errors[0] }}</span>
          </ValidationProvider>
        </div>
      </div>
      
      <div class="card-footer border-0 text-center py-3">
        <button type="submit" class="btn fw-80 send-review text-white"><strong>送信</strong></button>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </form>
  </ValidationObserver>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util.js';

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
        answerOfQuestion1: null,
        answerOfQuestion2: null,
        answerOfQuestion3: null,
        answerOfQuestion4: null,
      },
    };
  },

  async beforeMount() {
    await this.getQuestions();
    this.loading = false;
  },

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

<style lang="scss" scoped>
  .review-question {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    color: #5B5B5B;
    &-title {
      font-size: 14px;
      font-weight: 800;
      color: inherit;
      margin-bottom: 15px;
    }
    .review-answer-option {
      display: inline-block;
      width: 18px;
      margin-right: 15px;
      input[type='radio'] {
        width: 18px;
        height: 18px;
      }
    }
    &.border {
      border-color: #BCBCBC !important;
    }
    .error-explanation {
      display: block;
    }
  }
  .card-footer {
    background-color: unset;
    button.send-review {
      background-color: #495F7E;
      &:hover {
        background-color: #5a759b;
      }
    }
  }
  

  @media screen and (max-width: 767.98px) {
    .review-question {
      .review-answer-option {
        margin-right: 12px;
      }
    }
  }

  @media screen and (max-width: 402px) {
    .review-question {
      .review-answer-option {
        margin-right: 9px;
      }
    }
  }
</style>