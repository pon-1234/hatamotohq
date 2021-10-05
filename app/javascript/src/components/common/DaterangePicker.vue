<template>
  <div class="d-flex">
    <input :name="input_start_name" v-model="dateRange.startDate" type="hidden">
    <input :name="input_end_name" v-model="dateRange.endDate" type="hidden">
    <date-range-picker
      class="flex-grow-1"
      v-model="dateRange"
      :opens="opens || 'right'"
      :ranges="false"
      :locale-data="localeData"
      :minDate="min_date"
      :maxDate="max_date"
      @update="onChangedDateRange()"
    >
    </date-range-picker>
    <div class="btn btn-light ml-1" @click="clearInput()">クリア</div>
  </div>
</template>

<script>
import DateRangePicker from 'vue2-daterange-picker';
export default {
  components: { DateRangePicker },
  props: ['input_start_name', 'input_end_name', 'start_date', 'end_date', 'min_date', 'max_date', 'opens'],
  data() {
    return {
      localeData: {
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
      },
      dateRange: {
        startDate: this.start_date,
        endDate: this.end_date
      }
    };
  },
  methods: {
    onChangedDateRange() {
      this.$emit('update:start_date', this.dateRange.startDate);
      this.$emit('update:end_date', this.dateRange.endDate);
      if (this.dateRange.startDate && this.dateRange.endDate) {
        this.$emit('submited');
      }
    },

    clearInput() {
      this.dateRange = {
        startDate: null,
        endDate: null
      };
      this.onChangedDateRange();
    }
  }
};
</script>