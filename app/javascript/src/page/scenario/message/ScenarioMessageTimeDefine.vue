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
            時刻指定
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
          <template v-if="!is_initial">
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
            <datetime
              style="width:6em;"
              v-model="selectedTime"
              input-class="form-control"
              type="time"
              class="theme-success mr-4"
              :phrases="{ok: '確定', cancel: '閉じる'}"
            ></datetime>
          </template>

          <input
            class="form-control"
            min="1"
            style="width:4em;"
            autocomplete="off"
            type="number"
            value="1"
            v-model="order"
            @change="$emit('update:order', order)"
          />
          <span>通目</span>
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
    is_initial: String,
    date: Number,
    time: String,
    order: Number
  },

  data() {
    return {
      selectedTime: '00:00'
    }
  },

  watch: {
    selectedTime: function (val) {
      const timeOnly = moment(val).format('HH:mm');
      this.$emit('update:time', timeOnly);
    }
  }
};
</script>

<style></style>
