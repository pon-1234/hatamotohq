<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-body">
        <div class="form-group d-flex align-items-center">
          <label class="fw-300">フォルダー</label>
          <div class="flex-grow-1">
            <select v-model="reminderData.folder_id" class="form-control fw-300">
              <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                {{ folder.name }}
              </option>
            </select>
          </div>
        </div>
        <div class="form-group d-flex">
          <label class="fw-300 mb-auto">リマインダ名<required-mark /></label>
          <div class="flex-grow-1">
            <input
              type="text"
              class="form-control"
              name="reminder_name"
              placeholder="リマインダ名を入力してください"
              v-model.trim="reminderData.name"
              v-validate="'required|max:64'"
              maxlength="65"
              data-vv-as="リマインダ名"
            />
            <error-message :message="errors.first('reminder_name')"></error-message>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
      <div class="card-footer">
        <button class="btn btn-success text-nowrap mr-1" @click="submit()" :disabled="invalid">
          {{ reminder_id ? "リマインダ保存" : "リマインダ登録" }}
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';

export default {
  props: ['reminder_id'],
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      loading: true,
      contentKey: 0,
      reminderData: {
        folder_id: Util.getParamFromUrl('folder_id'),
        name: null
      }
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  async created() {
    if (this.reminder_id) {
      this.reminderData.id = this.reminder_id;
    }
    await this.fetchData();
    this.loading = false;
  },

  computed: {
    ...mapState('reminder', {
      folders: state => state.folders
    })
  },

  methods: {
    ...mapActions('reminder', ['createReminder', 'getReminder', 'getFolders', 'updateReminder']),

    async fetchData() {
      await this.getFolders();
      if (this.reminder_id) {
        const reminder = await this.getReminder(this.reminder_id);
        Object.assign(this.reminderData, reminder);
      }
    },

    async submit() {
      if (this.loading) return;
      this.loading = true;
      const result = await this.$validator.validateAll();
      if (!result) {
        this.loading = false;
        return this.scrollToRequiredField();
      }

      const payload = this.reminderData;
      if (!this.reminder_id) {
        const reminderId = await this.createReminder(payload);
        this.onReceiveCreateReminder(!!reminderId);
      } else {
        const reminderId = await this.updateReminder(payload);
        this.onReceiveUpdateReminder(!!reminderId);
      }
    },

    scrollToRequiredField() {
      return ViewHelper.scrollToRequiredField(false);
    },

    // Handle broadcast creation response
    onReceiveCreateReminder(success) {
      if (success) {
        Util.showSuccessThenRedirect(
          'リマインダの保存は完了しました。',
          `${import.meta.env.VITE_ROOT_PATH}/user/reminders?folder_id=${this.reminderData.folder_id}`
        );
      } else {
        this.loading = false;
        window.toastr.error('リマインダの保存は失敗しました。');
      }
    },
    onReceiveUpdateReminder(success) {
      if (success) {
        Util.showSuccessThenRedirect(
          'リマインダの更新は完了しました。',
          `${import.meta.env.VITE_ROOT_PATH}/user/reminders?folder_id=${this.reminderData.folder_id}`
        );
      } else {
        this.loading = false;
        window.toastr.error('リマインダの更新は失敗しました。');
      }
    }
  }
};
</script>