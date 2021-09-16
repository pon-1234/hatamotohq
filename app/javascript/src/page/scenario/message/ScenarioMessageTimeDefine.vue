<template>
  <div class="card" id="date_define_area">
    <div class="card-body row">
      <div class="col-sm-4 radio-group flex-column">
        <span class="mb-2">配信タイミング</span>
        <div class="radio">
          <label class="">
            <input
              v-model="is_initial"
              name="is_initial"
              type="radio"
              v-bind:value="false"
              @change="$emit('update:is_initial', false)"
            />
            {{ mode === 'date' ? '時刻指定' : '経過時間指定' }}
          </label>
        </div>
        <div class="radio">
          <label class="">
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
      <div class="col-sm-8 d-flex flex-column">
        <span class="mb-2">配信タイミング</span>
        <div class="d-flex align-items-center" style="gap: 5px;">
          <!-- MODE: date -->
          <template v-if="!is_initial && mode === 'time'">
            <template v-if="!zeroday">
              <input
                v-model="date"
                class="form-control"
                min="1"
                style="width:5em;"
                autocomplete="off"
                name="step"
                type="number"
                @change="$emit('update:date', date)"
              />
              <span>日後</span>
            </template>
            <template v-else><span class="font-weight-bold">開始当日</span></template>
            <datetime
              style="width:6em;"
              v-model="selectedTime"
              input-class="form-control"
              type="time"
              class="theme-success mr-4"
              :phrases="{ok: '確定', cancel: '閉じる'}"
            ></datetime>
          </template>

          <!-- MODE: ELAPSED TIME -->
          <template v-if="!is_initial && mode === 'elapsed_time'">
            <template v-if="!zeroday">
              <input
                v-model.number="date"
                class="form-control"
                min="1"
                style="width:5em;"
                autocomplete="off"
                name="step"
                type="number"
                @change="$emit('update:date', date)"
              />
              <span>日と</span>
            </template>
            <datetime
              style="width:6em;"
              v-model="selectedTime"
              input-class="form-control"
              type="time"
              class="theme-success"
              :phrases="{ok: '確定', cancel: '閉じる'}"
            ></datetime>
            <span class="mr-4">時間後</span>
          </template>

          <input
            class="form-control"
            min="1"
            style="width:4em;"
            autocomplete="off"
            type="number"
            v-model.number="order"
            @change="$emit('update:order', order)"
          />
          <span>通目</span>
        </div>
        <div class="mt-2" v-if="!is_initial">
          <label role="button">
            <input
              class="mr-1 mt-1"
              v-model="zeroday"
              name="zeroday"
              type="checkbox"
              v-bind:value="false"
              @change="date = zeroday ? 0 : 1"
            /> 開始当日
          </label>
        </div>
      </div>
      <div class="col-sm-8" v-if="is_initial === 'true'"></div>
    </div>
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
    mode: String,
    is_initial: String,
    date: Number,
    time: String,
    order: Number
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
