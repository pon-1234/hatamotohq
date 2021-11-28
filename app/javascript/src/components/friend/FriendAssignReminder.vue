<template>
  <div class="row" :key="contentKey">
    <div class="col-lg-3">
      <div class="btn btn-secondary ml-1 d-block" data-toggle="modal" data-target="#modalSelectReminder">
        <span class="max-1-lines">{{ reminder.id ? reminder.name : "リマインダを選択する" }}</span>
      </div>
      <div>
        <input type="hidden" v-model="reminder.id" name="reminder_id" v-validate="'required'" data-vv-as="リマインダ" />
        <error-message class="w-100" :message="errors.first('reminder_id')"></error-message>
      </div>
    </div>

    <div class="col-lg-9 d-flex flex-start">
      <div class="flex-grow-1">
        <datetime
          v-model="goal"
          name="reminder_goal"
          class="mr-1"
          input-class="form-control"
          type="date"
          :phrases="{ ok: '確定', cancel: '閉じる' }"
          placeholder="日付を選択してください"
          :min-datetime="currentDate"
          value-zone="Asia/Tokyo"
          v-validate="'required'"
          data-vv-as="ゴール日時"
          zone="Asia/Tokyo"
        ></datetime>
        <error-message :message="errors.first('reminder_goal')"></error-message>
      </div>
      <div class="btn btn-light mr-1 mb-auto" data-toggle="modal" data-target="#modalReminderPreview" hidden>
        プレビュー
      </div>
      <div class="btn btn-success fw-120 mb-auto" @click="submit()">開始</div>
    </div>
    <modal-select-reminder id="modalSelectReminder" @selectReminder="onSelectReminder($event)"></modal-select-reminder>

    <!-- START: modal survey preview -->
    <modal-reminder-preview :reminder_id="reminder.id" v-if="reminder"></modal-reminder-preview>
    <!-- END: modal survey preview -->
  </div>
</template>

<script>
import moment from 'moment';
import { Datetime } from 'vue-datetime';
import { mapActions } from 'vuex';

export default {
  components: {
    Datetime
  },
  props: {
    friend_id: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      contentKey: 0,
      goal: null,
      reminder: {
        id: null,
        name: null
      },
      currentDate: moment()
        .tz('Asia/Tokyo')
        .format()
    };
  },

  methods: {
    ...mapActions('friend', ['setReminder']),

    forceRerender() {
      this.contentKey++;
    },

    async submit() {
      const valid = await this.$validator.validateAll();
      if (!valid) {
        return;
      }
      const payload = {
        friend_id: this.friend_id,
        reminder_id: this.reminder.id,
        goal: this.goal
      };
      const response = await this.setReminder(payload);
      if (response) {
        window.toastr.success('リマインダの設定は完了しました。');
        this.resetData();
      } else {
        window.toastr.error('リマインダの設定は失敗しました。');
      }
    },

    resetData() {
      this.goal = null;
      this.reminder = { id: null, name: null };
      this.forceRerender();
    },

    onSelectReminder(reminder) {
      this.reminder = reminder;
    }
  }
};
</script>

<style>
</style>