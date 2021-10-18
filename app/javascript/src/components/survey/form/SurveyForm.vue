<template>
  <div class="card">
    <div class="card-body">
      <survey-preview-content :survey="survey"></survey-preview-content>
    </div>
    <div class="card-footer">
      <div class="btn btn-success">送信</div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: {
    id: {
      type: Number
    },
    friend_id: {
      type: String
    }
  },

  data() {
    return {
      loading: true,
      survey: null
    };
  },

  async beforeMount() {
    this.survey = await this.getSurvey(this.id);
    this.loading = false;
  },

  methods: {
    ...mapActions('survey', [
      'getSurvey'
    ])
  }
};
</script>

<style>
</style>