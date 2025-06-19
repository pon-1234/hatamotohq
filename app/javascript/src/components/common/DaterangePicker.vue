<template>
  <div class="d-flex">
    <input :name="inputStartName" v-model="dateRange.startDate" type="hidden">
    <input :name="inputEndName" v-model="dateRange.endDate" type="hidden">
    <date-range-picker
      class="flex-grow-1"
      v-model="dateRange"
      :opens="opens || 'right'"
      :ranges="false"
      :locale-data="localeData"
      :minDate="minDate"
      :maxDate="maxDate"
      @update="onChangedDateRange"
    >
    </date-range-picker>
    <button type="button" class="btn btn-light ms-1" @click="clearInput">クリア</button>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import DateRangePicker from 'vue2-daterange-picker';
import 'vue2-daterange-picker/dist/vue2-daterange-picker.css';

// Props
const props = defineProps({
  inputStartName: {
    type: String,
    default: 'start_date'
  },
  inputEndName: {
    type: String,
    default: 'end_date'
  },
  startDate: {
    type: [String, Date],
    default: null
  },
  endDate: {
    type: [String, Date],
    default: null
  },
  minDate: {
    type: [String, Date],
    default: null
  },
  maxDate: {
    type: [String, Date],
    default: null
  },
  opens: {
    type: String,
    default: 'right'
  }
});

// Emits
const emit = defineEmits(['update:startDate', 'update:endDate', 'submitted']);

// Data
const localeData = {
  direction: 'ltr',
  format: 'mm/dd/yyyy',
  separator: ' - ',
  applyLabel: '確定',
  cancelLabel: '閉じる',
  weekLabel: 'W',
  customRangeLabel: 'Custom Range',
  daysOfWeek: ['日', '月', '火', '水', '木', '金', '土'],
  monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
  firstDay: 0
};

const dateRange = reactive({
  startDate: props.startDate,
  endDate: props.endDate
});

// Methods
const onChangedDateRange = () => {
  emit('update:startDate', dateRange.startDate);
  emit('update:endDate', dateRange.endDate);
  if (dateRange.startDate && dateRange.endDate) {
    emit('submitted');
  }
};

const clearInput = () => {
  dateRange.startDate = null;
  dateRange.endDate = null;
  onChangedDateRange();
};
</script>

<style scoped>
.ms-1 {
  margin-left: 0.25rem !important;
}
</style>