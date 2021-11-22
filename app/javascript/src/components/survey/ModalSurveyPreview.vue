<template>
  <div
    id="modalSurveyPreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalSurveyPreview"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">回答フォームプレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">
          <survey-form-content :survey="survey" :preview="true"></survey-form-content>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
  <!-- /.modal -->
</template>
<script>
import { mapActions } from 'vuex';
export default {
  props: ['survey_id'],

  data() {
    return {
      survey: null,
      contentKey: 0
    };
  },

  mounted() {
    console.log('----before mount----');
    $(this.$refs.modalSurveyPreview).on('show.bs.modal', this.onShow);
  },

  methods: {
    ...mapActions('survey', ['getSurvey']),

    forceRerender() {
      this.contentKey++;
    },

    async onShow() {
      console.log('------on show preview modal-----');
      this.survey = await this.getSurvey(this.survey_id);
      this.forceRerender();
    }
  }
};
</script>
