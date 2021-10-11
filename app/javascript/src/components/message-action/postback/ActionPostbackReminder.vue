<template>
  <section>
    <div>
      <label class="w-100 mt-2"> リマインダ設定</label>
      <div class="row m-0">
        <div class="col-md-6 d-flex-auto p-0">
          <div>
            <div class="custom-control custom-radio custom-control-inline">
              <input
                type="radio"
                id="typeStart"
                name="type"
                value="start"
                v-model="value.type"
                class="custom-control-input"
              />
              <label class="custom-control-label" for="typeStart">リマインダを開始</label>
            </div>
            <div class="custom-control custom-radio custom-control-inline">
              <input
                type="radio"
                id="typeCancel"
                name="type"
                value="cancel"
                v-model="value.type"
                class="custom-control-input"
              />
              <label class="custom-control-label" for="typeCancel">リマインダをキャンセル</label>
            </div>
          </div>
          <div class="mt-2 d-flex">
            <label class="fw-150">リマインダ選択</label>
            <div class="flex-grow-1">
              <div
                class="btn btn-secondary w-100"
                data-toggle="modal"
                data-target="#modalSelectReminder"
                data-backdrop="static"
              >
                {{ value.reminder.id ? value.reminder.name : "リマインダを選択する" }}
              </div>
              <input
                type="hidden"
                v-model="value.reminder.id"
                :name="name + '_reminder_id'"
                v-validate="'required'"
                data-vv-as="リマインダ"
              />
              <error-message class="w-100" :message="errors.first(name + '_reminder_id')"></error-message>
            </div>
          </div>
          <div class="mt-2 d-flex">
            <label class="fw-150">ゴール日時</label>
            <div class="flex-grow-1">
              <datetime
                v-model="value.goal"
                :name="name + '_reminder_goal'"
                input-class="form-control"
                type="datetime"
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
    </div>
    <modal-select-reminder id="modalSelectReminder" @selectReminder="onSelectReminder($event)"></modal-select-reminder>
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
    value: {
      type: Array,
      default: () => {
        return {
          type: 'start', // or 'cancel'
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
      currentDate: moment().tz('Asia/Tokyo').format()
    };
  },
  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },

  methods: {
    onSelectReminder(reminder) {
      this.value.reminder = _.pick(reminder, ['id', 'name']);
      this.$emit('input', this.value);
    }
  }
};
</script>