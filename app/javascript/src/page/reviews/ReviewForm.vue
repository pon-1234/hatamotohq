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

      <div
        class="form-group review-question"
        v-for="(question, questionIndex) in questions"
        :key="`question_${question.id}`"
      >
        <h3 class="review-question-title mt-0">
          {{ question.title }} <span class="text-danger" v-if="question.required">*</span>
        </h3>
        <!-- input's name  suitable with nested attributes in rails -->
        <input
          type="hidden"
          :value="question.id"
          :name="`review[review_answers_attributes][${questionIndex}][review_question_id]`"
        />

        <div class="review-answer-options-container" v-if="question.type == 'rating'">
          <ValidationProvider
            :name="`${question.title}の評価`"
            :rules="question.required ? 'required' : ''"
            v-slot="{ errors }"
          >
            <div class="review-answer-options d-flex justify-content-around">
              <template v-for="answerIndex in 10">
                <div
                  class="review-answer-option form-check form-check-inline d-flex flex-column mr-0"
                  :key="`review_answer_${answerIndex}`"
                  v-if="answerIndex >= question.config.min_value && answerIndex <= question.config.max_value"
                >
                  <label
                    class="form-check-label justify-content-center mb-2"
                    :for="`question_${question.id}_answer_${answerIndex}`"
                    >{{ answerIndex }}</label
                  >
                  <input
                    v-model="reviewFormData[`answerOfQuestion${question.id}`]"
                    class="form-check-input mr-0"
                    type="radio"
                    :name="`review[review_answers_attributes][${questionIndex}][answer]`"
                    :id="`question_${question.id}_answer_${answerIndex}`"
                    :value="answerIndex"
                  />
                  <span class="mt-2" v-if="answerIndex === question.config.min_value">{{
                    question.config.min_label
                  }}</span>
                  <span class="mt-2" v-if="answerIndex === question.config.max_value">{{
                    question.config.max_label
                  }}</span>
                </div>
              </template>
            </div>
            <span class="error-explanation">{{ errors[0] }}</span>
          </ValidationProvider>
        </div>

        <div class="review-answer-text mt-3" v-if="question.type == 'text'">
          <ValidationProvider :name="question.title" :rules="question.required ? 'required' : ''" v-slot="{ errors }">
            <textarea
              v-model="reviewFormData[`answerOfQuestion${question.id}`]"
              :name="`review[review_answers_attributes][${questionIndex}][answer]`"
              class="form-control"
              placeholder="回答を入力"
              rows="4"
            />
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
      rootPath: import.meta.env.VITE_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      reviewFormData: {
        answerOfQuestion1: null,
        answerOfQuestion2: null,
        answerOfQuestion3: null,
        answerOfQuestion4: null
      }
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
      questions: state => state.questions
    })
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
    color: #5b5b5b;
    &-title {
      font-size: 14px;
      font-weight: 800;
      color: inherit;
      margin-bottom: 15px;
    }
    .review-answer-options {
      padding-left: 1.5rem;
      padding-right: 1.5rem;
    }
    .review-answer-option {
      input[type="radio"] {
        width: 18px;
        height: 18px;
      }
    }
    &.border {
      border-color: #bcbcbc !important;
    }
    .error-explanation {
      display: block;
      margin-left: 2.5rem;
    }
  }
  .card-footer {
    background-color: unset;
    button.send-review {
      background-color: #495f7e;
      &:hover {
        background-color: #5a759b;
      }
    }
  }

  @media screen and (max-width: 767.98px) {
    .review-question {
      .review-answer-options {
        padding-left: 0.5rem;
        padding-right: 0.5rem;
      }
      .error-explanation {
        margin-left: 0.5rem;
      }
    }
  }
</style>