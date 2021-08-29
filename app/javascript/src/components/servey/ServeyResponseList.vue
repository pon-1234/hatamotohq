<template>
  <section>

    <div v-if="isLoading">
      Loading...
    </div>
    <div v-else-if="isError">
      ERR:ERR
      <button @click="fetchData()"> RETRY</button>
    </div>
    <div v-else>
      <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center" style="overflow-x: scroll">
        <table class="table table-hover table-scenario">
          <thead>
          <tr>
            <th class="">No.</th>
            <th class="w30">回答日時</th>
            <th class="w30">回答者名</th>
            <th class=""></th>
          </tr>
          </thead>
          <tbody v-if="responseLists.length === 0">
          <tr>
            <td colspan="2">
              データなし
            </td>
            <td>
            </td>
          </tr>
          </tbody>
          <tbody v-else>
          <tr v-for="(object, index) of responseLists" :key="index">
            <td>
              {{index + 1}}
            </td>
            <td>
              {{ object.created}}
            </td>

            <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis">
              {{object.display_name || object.line_name}}
            </td>
            <td>
              <div class="btn-edit01">
                <a class="btn-more btn-more-linebot btn-block" @click="showAnswerDetail(data, object.survey_customer_id)">
                  回答表示
                </a>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

  </section>
</template>

<script>

import { mapActions, mapState } from 'vuex';

export default {
  props: ['data', 'route'],

  data() {
    return {
      responseLists: [],
      focus: null,
      isLoading: true,
      isError: false
    };
  },

  beforeMount() {
    console.log(this.data);
    this.fetchData();
  },

  computed: {
    ...mapState('friend', {
      friend: state => state.friend
    })
  },

  methods: {
    ...mapActions('friend', ['getFriendDetail']),
    fetchData() {
      this.isLoading = true;
      this.isError = false;
      this.$store.dispatch('survey/getCustomers', { id: this.data })
        .then((res) => {
          this.responseLists = res;
          this.isLoading = false;
        })
        .catch(() => {
          // show error
          this.isLoading = false;

          this.isError = true;
        });
    },

    async showAnswerDetail(surveyId, answerId) {
      window.location.href = process.env.MIX_ROOT_PATH + '/surveys/' + surveyId + '/answer/' + answerId;
    },

    changeTilteActiveChannel(title) {
      if (this.focus != null) {
        this.responseLists[this.focus].display_name = title;
        // this.blink();
      }
    }

  }
};
</script>
