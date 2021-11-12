<template>
  <div class="card">
    <div class="card-body">
      <div class="d-flex">
        <folder-left
          type="reminder"
          :data="folders"
          :isPc="isPc"
          :selectedFolder="selectedFolderIndex"
          @changeSelectedFolder="onSelectedFolderChanged"
          @submitUpdateFolder="submitUpdateFolder"
          @submitCreateFolder="submitCreateFolder"
        />
        <div class="flex-grow-1 folder-right" :key="contentKey">
          <a
            v-if="folders && folders.length && curFolder"
            :href="`${rootPath}/user/reminders/new?folder_id=${curFolder.id}`"
            class="btn btn-primary"
          >
            <i class="uil-plus"></i> 新規作成
          </a>
          <div class="table-responsive mt-2" v-if="curFolder">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="mw-120">リマインダ名</th>
                  <th class="mw-260">操作</th>
                  <th class="mw-150">フォルダー</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(reminder, index) in curFolder.reminders" v-bind:key="reminder.id">
                  <td><p class="item-name">{{ reminder.name }}</p></td>
                  <td>
                    <div class="d-flex">
                      <a
                        role="button"
                        :href="`${rootPath}/user/reminders/${reminder.id}/episodes`"
                        class="btn btn-sm btn-light mr-1"
                        >配信タイミング一覧</a
                      >
                      <div class="btn-group">
                        <button
                          type="button"
                          class="btn btn-light btn-sm dropdown-toggle"
                          data-toggle="dropdown"
                          aria-expanded="false"
                        >
                          操作 <span class="caret"></span>
                        </button>
                        <div class="dropdown-menu">
                          <a role="button" class="dropdown-item" @click="openEdit(reminder)">リマインダを編集する</a>
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalCopyReminder"
                            @click="curReminderIndex = index"
                            >リマインダをコピー</a
                          >
                          <a
                            role="button"
                            class="dropdown-item"
                            data-toggle="modal"
                            data-target="#modalDeleteTemplate"
                            @click="curReminderIndex = index"
                            >リマインダを削除</a
                          >
                        </div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div>{{ curFolder.name }}</div>
                    <div class="text-sm">{{ formattedDate(reminder.created_at) }}</div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="curFolder.reminders.length === 0">
              <b>リマインダはありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>
    <loading-indicator :loading="loading"></loading-indicator>

    <!-- START: Delete folder modal -->
    <modal-confirm
      title="このフォルダーを削除してもよろしいですか？"
      id="modalDeleteFolder"
      type="delete"
      @confirm="submitDeleteFolder"
    >
      <template v-slot:content v-if="curFolder">
        <span>フォルダー名：{{ curFolder.name }}</span>
      </template>
    </modal-confirm>
    <!-- END: Delete folder modal -->

    <!-- START: Delete reminder modal -->
    <modal-confirm
      title="このリマインダを削除してもよろしいですか？"
      id="modalDeleteTemplate"
      type="delete"
      @confirm="submitDeleteReminder"
    >
      <template v-slot:content>
        <div v-if="curReminder">
          リマインダ名：<b>{{ curReminder.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete template modal -->

    <!-- START: Copy template modal -->
    <modal-confirm
      title="このリマインダをコピーしてもよろしいですか？"
      id="modalCopyReminder"
      type="confirm"
      @confirm="submitCopyTemplate"
    >
      <template v-slot:content>
        <div v-if="curReminder">
          リマインダ名：<b>{{ curReminder.name }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy template modal -->
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      isPc: true,
      selectedFolderIndex: 0,
      curReminderIndex: null,
      loading: true,
      contentKey: 0
    };
  },

  async beforeMount() {
    await this.getReminders();
    const folderId = Util.getParamFromUrl('folder_id');
    setTimeout(() => {
      if (folderId) {
        const index = _.findIndex(this.folders, _ => _.id === Number.parseInt(folderId));
        if (index >= 0) {
          this.onSelectedFolderChanged(index);
        }
      }
    }, 0);
    this.loading = false;
  },

  computed: {
    ...mapState('reminder', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolderIndex];
    },

    curReminder() {
      return this.curFolder ? this.curFolder.reminders[this.curReminderIndex] : null;
    }
  },

  methods: {
    ...mapActions('reminder', [
      'getReminders',
      'deleteReminder',
      'copyReminder',
      'deleteFolder',
      'createFolder',
      'updateFolder'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    tags(strtag) {
      return typeof strtag === 'string' ? (strtag.length > 0 ? strtag.split(',') : []) : strtag;
    },

    onSelectedFolderChanged(index) {
      this.selectedFolderIndex = index;
      this.isPc = true;
    },

    async submitUpdateFolder(folder) {
      const response = await this.updateFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの変更は完了しました。');
      } else {
        window.toastr.error('フォルダーの変更は失敗しました。');
      }
    },

    async submitCreateFolder(folder) {
      const response = await this.createFolder(folder);
      if (response) {
        window.toastr.success('フォルダーの作成は完了しました。');
      } else {
        window.toastr.error('フォルダーの作成は失敗しました。');
      }
    },

    async submitDeleteFolder() {
      const response = await this.deleteFolder(this.folders[this.selectedFolderIndex].id);
      if (response) {
        window.toastr.success('フォルダーの削除は完了しました。');
        this.onSelectedFolderChanged(0);
      } else {
        window.toastr.error('フォルダーの削除は失敗しました。');
      }
    },

    async submitDeleteReminder() {
      const response = await this.deleteReminder(this.curReminder.id);
      if (response) {
        window.toastr.success('リマインダの削除は完了しました。');
      } else {
        window.toastr.error('リマインダの削除は失敗しました。');
      }
      this.forceRerender();
    },

    async submitCopyTemplate() {
      const response = await this.copyReminder(this.curReminder.id);
      if (response) {
        Util.showSuccessThenRedirect('リマインダのコピーは完了しました。', window.location.href);
      } else {
        Util.showSuccessThenRedirect('リマインダのコピーは失敗しました。', window.location.href);
      }
      this.forceRerender();
    },

    backToFolder() {
      this.isPc = false;
    },

    openEdit(reminder) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/reminders/${reminder.id}/edit`);
    },

    formattedDate(date) {
      return Util.formattedDate(date);
    }
  }
};
</script>
