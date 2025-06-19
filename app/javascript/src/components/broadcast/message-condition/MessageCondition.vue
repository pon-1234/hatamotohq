<template>
  <div>
    <div>
      <label>
        <i class="mdi mdi-calendar icon-color" aria-hidden="true"></i>友だち登録日
      </label>
      <div class="mt-2">
        <daterange-picker
          class="d-block"
          :start_date.sync="condition.add_friend_date.start_date"
          :end_date.sync="condition.add_friend_date.end_date">
        </daterange-picker>
      </div>
    </div>
  </div>
</template>
<script setup>
import { reactive, watch, onMounted } from 'vue'
import Util from '@/core/util'

const props = defineProps(['data'])
const emit = defineEmits(['input'])

const options_prefecture = window.Prefecture
const options_gender = window.Gender
const options_month = window.MonthBirthday

const condition = reactive({
  type: 'specific',
  add_friend_date: {
    start_date: null,
    end_date: null
  }
  // age: {
  //   min: 0,
  //   max: 100
  // },
  // gender: 'all',
  // prefecture: null,
  // month_birthday: [],
  // message_status: null
})

onMounted(() => {
  if (props.data) {
    Object.assign(condition, props.data)
  }
})

watch(condition, (val) => {
  if (val.add_friend_date.start_date) {
    val.add_friend_date.start_date = Util.setDefaultFormatDate(val.add_friend_date.start_date)
  }

  if (val.add_friend_date.end_date) {
    val.add_friend_date.end_date = Util.setDefaultFormatDate(val.add_friend_date.end_date)
  }

  emit('input', val)
}, { deep: true })
</script>

<style  lang="scss" scoped>
:deep() {
  .fa-arrows-alt-h {
    margin-left: 20px;
    margin-right: 20px;
  }

  .icon-color {
    color: linear-gradient(90deg, #04DC04 0%, #00B900 50%, #00af00 100%);
  }

  .vdp-datepicker {
    flex-grow: 1;
  }

  .button-condition {
    margin-right: 5px;
    background: white;
    border: 1px solid #ccd0d2;
    border-radius: 4px;
  }

  .active-button {
    background:  linear-gradient(90deg, #04DC04 0%, #00B900 50%, #00af00 100%);
    color: white;
  }

  input[type=checkbox], input[type=radio] {
  }
}
</style>
