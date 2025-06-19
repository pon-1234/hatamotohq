<template>
  <div class="d-flex">
    <div class="fw-250 radio-group flex-column">
      <div class="radio">
        <label>
          <input
            v-model="is_initial"
            name="is_initial"
            type="radio"
            v-bind:value="true"
            @change="onModeChanged(true)"
          />
          開始時に送信
        </label>
        <label>
          <input
            v-model="is_initial"
            name="is_initial"
            type="radio"
            v-bind:value="false"
            @change="onModeChanged(false)"
          />
          時刻指定
        </label>
      </div>
    </div>
    <div class="flex-grow-1 d-flex flex-column">
      <div class="d-flex align-items-center" style="gap: 5px">
        <!-- MODE: date -->
        <template v-if="!is_initial">
          <template v-if="!zeroday">
            <input
              v-model="date"
              class="form-control"
              min="1"
              style="width: 5em"
              autocomplete="off"
              name="step"
              type="number"
              onblur="this.value = (this.value == 0 ? 1 : this.value);"
              onkeypress="return event.charCode >= 48 && event.charCode <= 57"
              @change="$emit('update:date', date)"
            />
            <span>日前</span>
          </template>
          <template v-else><span class="font-weight-bold">開始当日</span></template>
          <datetime
            style="width: 6em"
            v-model="selectedTime"
            input-class="form-control"
            type="time"
            class="theme-success"
            :phrases="{ ok: '確定', cancel: '閉じる' }"
            value-zone="Asia/Tokyo"
            zone="Asia/Tokyo"
          ></datetime>
          に送信
        </template>
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

<script setup>
import { ref, watch, onBeforeMount } from 'vue'
import Util from '@/core/util'
import { Datetime } from 'vue-datetime'
import moment from 'moment-timezone'

const props = defineProps({
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
})
const emit = defineEmits(['update:is_initial', 'update:date', 'update:time', 'update:order'])

const selectedTime = ref('00:00')
const zeroday = ref(false)
const is_initial = ref(props.is_initial)
const date = ref(props.date)

onBeforeMount(() => {
  zeroday.value = props.date === 0
  selectedTime.value = moment.tz(props.time, 'HH:mm', 'Asia/Tokyo').format()
})

watch(selectedTime, (val) => {
  const timeOnly = Util.formattedTime(val)
  emit('update:time', timeOnly)
})

watch(date, (val) => {
  emit('update:date', date.value)
})

watch(() => props.order, (val) => {
  emit('update:order', val)
})

const onModeChanged = (isInitial) => {
  if (isInitial) {
    date.value = 0
    emit('update:date', date.value)
    emit('update:time', '00:00')
  } else {
    zeroday.value = true
  }
  emit('update:is_initial', isInitial)
}
</script>

<style></style>
