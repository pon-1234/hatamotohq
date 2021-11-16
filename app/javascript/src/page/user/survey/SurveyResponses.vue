<template>
  <div>
    <table class="table">
      <thead class="thead-light">
        <tr>
          <th>回答者</th>
          <th>フォームの回答</th>
          <th>回答日</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(response, index) in responses" :key="index">
          <td class="table-user d-flex align-items-center">
            <img
              :src="response.line_friend.avatar_url || '/img/no-image-profile.png'"
              alt="table-user"
              class="mr-2 rounded-circle"
            />
            <p class="m-0 text-truncate">{{ response.line_friend.display_name }}</p>
          </td>
          <td class="mw-400">
            <label>フォームの回答</label>
            <div v-for="(answer, index) in response.survey_answers" :key="index">
              <div class="divider my-2"></div>
              <div class="d-flex border-bottom border-light my-1">
                <div class="mw-200 mr-2">{{ answer.survey_question.content["text"] }}</div>
                <div class="mw-200">
                  <div v-if="answer.survey_question.type === 'image'">
                    <div v-lazy:background-image="answer.file_url" class="fw-120 fh-81 background-cover"></div>
                  </div>
                  <div v-else-if="answer.survey_question.type === 'pdf'" class="d-flex">
                    <img :src="`${rootPath}/images/messages/pdf.png`" class="fw-120 fh-120 background-cover" />
                    <a
                      class="btn btn-sm btn-light my-auto text-nowrap"
                      :href="answer.file_url"
                      download="lineinsight.pdf"
                      >ダウンロード</a
                    >
                  </div>
                  <div v-else>
                    {{ answer.answer || "未設定" }}
                  </div>
                </div>
              </div>
            </div>
          </td>
          <td>{{ response.created_at | formatted_time }}</td>
        </tr>
      </tbody>
    </table>
    <div class="text-center">
      <div>
        <b-pagination
          v-if="totalRows > perPage"
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="loadResponses"
          aria-controls="my-table"
        ></b-pagination>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';

export default {
  props: ['survey_id'],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: true,
      contentKey: 0,
      currentPage: 1
    };
  },

  async beforeMount() {
    await this.getResponses(this.queryParams);
  },

  computed: {
    ...mapState('survey', {
      responses: state => state.responses,
      totalRows: state => state.responsesTotalRows,
      perPage: state => state.responsesPerPage
    }),

    queryParams() {
      return { id: this.survey_id, page: this.currentPage };
    }
  },

  methods: {
    ...mapActions('survey', ['getResponses']),

    loadResponses() {
      console.log('-------');
      this.$nextTick(async() => {
        this.loading = true;
        this.getResponses(this.queryParams);
        this.loading = false;
      });
    }
  }
};
</script>