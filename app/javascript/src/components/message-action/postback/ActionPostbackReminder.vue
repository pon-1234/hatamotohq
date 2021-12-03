<template>
  <section>
    <div>
      <label class="w-100 mt-2"> リマインダ設定</label>
      <div class="m-0">
        <div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              :id="`${name}typeSet`"
              :name="`${name}_type`"
              value="set"
              v-model="actionData.type"
              @change="onDataChanged()"
              class="custom-control-input"
            />
            <label class="custom-control-label" :for="`${name}typeSet`">リマインダを開始</label>
          </div>
          <div class="custom-control custom-radio custom-control-inline">
            <input
              type="radio"
              :id="`${name}typeUnset`"
              :name="`${name}_type`"
              value="unset"
              v-model="actionData.type"
              @change="onDataChanged()"
              class="custom-control-input"
            />
            <label class="custom-control-label" :for="`${name}typeUnset`">リマインダをキャンセル</label>
          </div>
        </div>
        <div class="mt-2 d-flex">
          <label class="fw-150">リマインダ選択</label>
          <div class="mw-200 mxw-400">
            <div class="btn btn-secondary w-100" data-toggle="modal" :data-target="`#${name}_selectReminderModal`">
              <span class="max-1-lines">{{
                actionData.reminder.id ? actionData.reminder.name : "リマインダを選択する"
              }}</span>
            </div>
            <input
              type="hidden"
              v-model="actionData.reminder.id"
              :name="name + '_reminder_id'"
              v-validate="'required'"
              data-vv-as="リマインダ"
            />
            <error-message class="w-100" :message="errors.first(name + '_reminder_id')"></error-message>
          </div>
        </div>
        <div class="mt-2 d-flex" v-if="actionData.type === 'set'">
          <label class="fw-150">ゴール日時</label>
          <div class="flex-grow-1">
            <datetime
              v-model="actionData.goal"
              :name="name + '_reminder_goal'"
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
            <error-message :message="errors.first(name + '_reminder_goal')"></error-message>
          </div>
        </div>
      </div>
    </div>
    <modal-select-reminder
      :id="`${name}_selectReminderModal`"
      @selectReminder="onSelectReminder($event)"
    ></modal-select-reminder>
  </section>
</template>

<script>
import moment from 'moment';
import { Datetime } from 'vue-datetime';

export default {
  components: {
    Datetime
  },
  props: {
    actionData: {
      type: Array,
      default: () => {
        return {
          type: 'set', // or 'unset'
          reminder: {
            id: null,
            name: null
          },
          goal: null
        };
      }
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },

  data() {
    return {
      currentDate: moment()
        .tz('Asia/Tokyo')
        .format()
    };
  },
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },

  methods: {
    onSelectReminder(reminder) {
      this.actionData.reminder = _.pick(reminder, ['id', 'name']);
      this.onDataChanged();
    },

    onDataChanged() {
      this.$emit('input', this.actionData);
    }
  }
};
</script>