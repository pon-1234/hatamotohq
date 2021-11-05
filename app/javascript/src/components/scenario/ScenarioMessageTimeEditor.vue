<template>
  <div class="d-flex">
    <div class="fw-250 radio-group flex-column">
      <div class="radio">
        <label class="">
          <input
            v-model="is_initial"
            name="is_initial"
            type="radio"
            v-bind:value="false"
            @change="$emit('update:is_initial', false)"
          />
          {{ mode === "date" ? "時刻指定" : "経過時間指定" }}
        </label>
      </div>
      <div class="radio">
        <label>
          <input
            v-model="is_initial"
            name="is_initial"
            type="radio"
            v-bind:value="true"
            @change="$emit('update:is_initial', true)"
          />
          購読開始直後
        </label>
      </div>
    </div>
    <div class="flex-grow-1 d-flex flex-column">
      <div class="d-flex align-items-center" style="gap: 5px">
        <!-- MODE: date -->
        <template v-if="!is_initial && mode === 'time'">
          <template v-if="!zeroday">
            <input
              v-model="date"
              class="form-control"
              min="1"
              style="width: 5em"
              autocomplete="off"
              name="step"
              type="number"
              @change="$emit('update:date', date)"
            />
            <span>日後</span>
          </template>
          <template v-else><span class="font-weight-bold">開始当日</span></template>
          <datetime
            style="width: 6em"
            v-model="selectedTime"
            input-class="form-control"
            type="time"
            class="theme-success mr-4"
            :phrases="{ ok: '確定', cancel: '閉じる' }"
          ></datetime>
        </template>

        <!-- MODE: ELAPSED TIME -->
        <template v-if="!is_initial && mode === 'elapsed_time'">
          <template v-if="!zeroday">
            <input
              v-model.number="date"
              class="form-control"
              min="1"
              style="width: 5em"
              autocomplete="off"
              name="step"
              type="number"
              onkeypress="return event.charCode >= 48 && event.charCode <= 57"
              @change="$emit('update:date', date)"
            />
            <span>日と</span>
          </template>
          <datetime
            style="width: 6em"
            v-model="selectedTime"
            input-class="form-control"
            type="time"
            class="theme-success"
            :phrases="{ ok: '確定', cancel: '閉じる' }"
          ></datetime>
          <span class="mr-4">時間後</span>
        </template>

        <span>優先順位</span>
        <input
          class="form-control"
          min="1"
          style="width: 5em"
          autocomplete="off"
          type="number"
          v-model.number="order"
          onkeypress="return event.charCode >= 48 && event.charCode <= 57"
          @change="$emit('update:order', order)"
        />
      </div>
      <div class="mt-2" v-if="!is_initial">
        <label role="button" class="d-inline-flex">
          <input
            class="mr-1"
            v-model="zeroday"
            name="zeroday"
            type="checkbox"
            v-bind:value="false"
            @change="date = zeroday ? 0 : 1"
          />
          開始当日
        </label>
      </div>
    </div>
    <div class="col-sm-8" v-if="is_initial === 'true'"></div>
  </div>
</template>

<script>
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';

export default {
  components: {
    Datetime
  },
  props: {
    mode: {
      type: String,
      default: 'time'
    },
    is_initial: {
      type: Boolean,
      default: false
    },
    date: {
      type: Number,
      default: 0
    },
    time: {
      type: String,
      default: '00:00'
    },
    order: {
      type: Number,
      default: 1
    }
  },

  data() {
    return {
      selectedTime: '00:00',
      zeroday: false
    };
  },

  created() {
    this.zeroday = this.date === 0;
    this.selectedTime = this.time || '00:00';
  },

  watch: {
    selectedTime: function(val) {
      const timeOnly = moment(val).format('HH:mm');
      this.$emit('update:time', timeOnly);
    },

    date: function(val) {
      this.$emit('update:date', this.date);
    },

    order: function(val) {
      this.$emit('update:order', this.order);
    }
  }
};
</script>

<style></style>
