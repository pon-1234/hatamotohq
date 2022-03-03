<template>
  <div>
    <div class="card mvh-50">
      <div class="card-header d-flex justify-content-end">
        <div class="d-flex text-nowrap">
          <div class="input-group app-search">
            <input
              type="text"
              class="form-control dropdown-toggle fw-250"
              placeholder="検索..."
              v-model="keyword"
              maxlength="64"
            />
            <span class="mdi mdi-magnify search-icon"></span>
            <div class="input-group-append">
              <div class="btn btn-primary" @click="loadReviews">検索</div>
            </div>
          </div>
        </div>
        <!-- End: Search form -->
      </div>
      <div class="card-body">
        <div>
          <table class="table table-centered mt-2 pc">
            <thead class="thead-light">
              <tr>
                <th>#</th>
                <th class="d-lg-table-cell">お客様名</th>
                <th v-for="question in questions" :key="question.id" class="d-lg-table-cell">{{ question.title }}</th>
                <th class="d-none d-lg-table-cell">評価日時</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(review, index) in reviews" :key="index">
                <td>{{ (curPage - 1) * perPage + index + 1 }}</td>
                <td class="d-lg-table-cell">
                  <p class="m-0">{{ review.line_name }}</p>
                </td>
                <td v-for="answerIndex in questions.length" :key="answerIndex"
                  :class="`d-lg-table-cell ${questions[answerIndex - 1].type == 'text' ? 'other-question' : ''}`">
                  <span>{{ review["answer_of_question" + answerIndex] }}</span>
                  <span v-if="questions[answerIndex - 1].type == 'rating'"> / {{questions[answerIndex - 1].config.max_value}}</span>
                </td>
                <td class="d-none d-lg-table-cell fw-200">{{ review.created_at | formatted_time }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="d-flex justify-content-center mt-4">
          <b-pagination
            v-if="parseInt(totalRows) > parseInt(perPage)"
            :total-rows="totalRows"
            :per-page="perPage"
            v-model="curPage"
            @change="loadReviews"
            aria-controls="my-table"
          ></b-pagination>
        </div>
        <div class="text-center my-5 font-weight-bold" v-if="!loading && totalRows === 0">データはありません。</div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
    </div>
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      loading: true
    };
  },

  async beforeMount() {
    await this.getQuestions();
    await this.getReviews();
    this.loading = false;
  },

  computed: {
    ...mapState('review', {
      questions: state => state.questions,
      reviews: state => state.reviews,
      totalRows: state => state.totalRows,
      perPage: state => state.perPage,
      queryParams: state => state.queryParams
    }),

    curPage: {
      get() {
        return this.queryParams.page;
      },
      set(value) {
        this.setQueryParam({ page: value });
      }
    },

    keyword: {
      get() {
        return this.queryParams.line_friend_line_name_cont;
      },

      set(value) {
        this.setQueryParam({ line_friend_line_name_cont: value });
      }
    }
  },
  methods: {
    ...mapMutations('review', ['setQueryParams', 'setQueryParam']),
    ...mapActions('review', ['getQuestions', 'getReviews']),

    loadReviews() {
      this.$nextTick(async() => {
        this.setQueryParams(this.queryParams);
        this.loading = true;
        this.getReviews();
        this.loading = false;
      });
    }
  }
};
</script>

<style lang="scss" scoped>
  .other-question {
    max-width: 230px;
  }
</style>
