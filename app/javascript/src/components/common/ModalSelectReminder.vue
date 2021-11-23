<template>
  <div
    class="modal fade"
    :id="id ? id : 'modalSelectReminder'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">リマインダを選択してください</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body overflow-hidden">
          <div class="d-flex" v-if="folders && folders.length">
            <folder-left
              type="reminder"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="changeSelectedReminder"
            />
            <div class="flex-grow-1">
              <table class="table table-hover">
                <thead class="thead-light">
                  <tr>
                    <th>
                      <span v-if="curFolder">{{ curFolder.name }}</span>
                    </th>
                  </tr>
                </thead>
                <tbody v-if="curFolder.reminders && curFolder.reminders.length">
                  <tr
                    v-for="(item, index) in curFolder.reminders"
                    :key="index"
                    class="folder-item"
                    data-dismiss="modal"
                  >
                    <td class="d-flex w-100">
                      <div class="mr-1">{{ item.name }}</div>
                      <div class="btn btn-info btn-sm ml-auto my-auto fw-80" @click="selectReminder(item)">選択</div>
                    </td>
                  </tr>
                </tbody>
                <tbody v-else>
                  <tr>
                    <td class="text-center my-5">データーがありません</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';
export default {
  props: ['id'],

  data() {
    return {
      selectedFolder: 0,
      isPc: true
    };
  },

  computed: {
    ...mapState('reminder', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders[this.selectedFolder];
    }
  },

  async beforeMount() {
    await this.getReminders();
  },

  methods: {
    ...mapActions('reminder', ['getReminders']),

    backToFolder() {
      this.isPc = false;
    },

    selectReminder(reminder) {
      const data = _.cloneDeep(reminder);
      this.$emit('selectReminder', data);
    },

    changeSelectedReminder(index) {
      this.selectedFolder = index;
      this.isPc = true;
    }
  }
};
</script>