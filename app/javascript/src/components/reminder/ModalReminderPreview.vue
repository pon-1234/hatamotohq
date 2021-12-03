<template>
  <div
    id="modalReminderPreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalReminderPreview"
  >
    <div class="modal-dialog modal-xl">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">リマインダプレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body" :key="contentKey">xxx</div>
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
  props: ['reminder_id'],

  data() {
    return {
      reminder: null,
      contentKey: 0
    };
  },

  mounted() {
    $(this.$refs.modalReminderPreview).on('show.bs.modal', this.onShow);
  },

  methods: {
    ...mapActions('reminder', ['getReminder']),

    forceRerender() {
      this.contentKey++;
    },

    async onShow() {
      this.reminder = await this.getReminder(this.reminder_id);
      this.forceRerender();
    }
  }
};
</script>
