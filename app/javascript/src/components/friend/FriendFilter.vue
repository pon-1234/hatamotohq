<template>
  <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
    <div class="box-detail">
      <div class="form-setting">
        <div class="form-group">
          <label>名前</label>
          <input type="text" class="form-control" placeholder="名前を入力してください" v-model="keyword">
        </div>
        <div class="form-group">
          <label>タグ</label>
          <input-tag @input="selectTags" :allTags="true"/>
        </div>
        <div class="form-group">
          <label>フォローした日</label>
          <div class="flex ai_center">
            <VueCtkDateTimePicker label="日付を選択" v-model="date.start" locale="ja" :only-date="true" :max-date="date.end" no-label format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>
            &nbsp;～&nbsp;
            <VueCtkDateTimePicker label="日付を選択" v-model="date.end" locale="ja" :only-date="true" :min-date="date.start" no-label format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>
          </div>
        </div>
        <div class="form-group">
          <label class="mb10">自分が非表示・ブロックした友達を表示</label>
          <div class="flex start ai_center">
            <div class="toggle-switch btn-keyword01">
              <input v-model="find_all" id="keyword-onoff-setting01" class="toggle-input" type="checkbox">
              <label for="keyword-onoff-setting01" class="toggle-label">
                <span></span>
              </label>
            </div>
          </div>
        </div>
      </div>
      <button type="submit" class="btn btn-save btn-block" @click="changeFilter">検索する</button>
    </div>
  </div>
</template>
<script>

export default {
  data() {
    return {
      keyword: '',
      tags: [],
      date: {
        start: null,
        end: null
      },
      find_all: false
    };
  },
  methods: {
    changeFilter() {
      this.$emit('input', {
        keyword: this.keyword,
        start_date: this.date.start,
        end_date: this.date.end,
        tags: this.tags,
        find_all: this.find_all
      });
    },

    selectTags(tags) {
      this.tags = tags.map(item => item.id);
    }
  }
};
</script>
<style lang="scss"  scoped>
  ::v-deep {
    .b-calendar {
      display: inline-flex !important;
    }
    .no-gutters {
      margin-right: 0;
      margin-left: 0;
      display: flex !important;
    }

    .b-calendar .b-calendar-grid .row {
      flex-wrap: nowrap;
    }
    .text-center {
      text-align: center!important;
    }
    .h-auto {
      height: auto!important;
    }
    .no-gutters>.col, .no-gutters>[class*=col-] {
      padding-right: 0;
      padding-left: 0;
    }
    .b-calendar .b-calendar-grid-body .col[data-date] .btn {
      width: 32px;
      height: 32px;
      font-size: 14px;
      line-height: 1;
      margin: 3px auto;
      padding: 9px 0;
    }
    .no-gutters small, .small {
      font-size: 80%;
      font-weight: 400;
    }
    .no-gutters .col {
      width: 100%;
    }
    .flex-fill {
      flex: 1 1 auto!important;
    }
    .b-calendar footer {
      padding: 0px;
    }
    .font-weight-bold {
      font-weight: 700!important;
    }
  }
</style>
