<template>
  <div>
    <div class="">
      <div class="col-md-12">
        <label>
          <i class="fa fa-calendar-check-o icon-color" aria-hidden="true"></i>
        </label>
        友だち登録日
        <div class="d-flex align-items-center mb20">
          <VueCtkDateTimePicker label="日付を選択"  v-model="condition.add_friend_date.start_date" locale="ja" :only-date="true" :max-date="condition.add_friend_date.end_date" no-label format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>
          <i class="fas fa-arrows-alt-h"></i>
          <VueCtkDateTimePicker label="日付を選択"  v-model="condition.add_friend_date.end_date" locale="ja" :only-date="true" :min-date="condition.add_friend_date.start_date" no-label format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>
        </div>
      </div>
      <!-- <div class="col-md-6">
        <label>
          <i class="fas fa-male icon-color" ></i>
        </label>
        年齢
        <div class="d-flex align-items-center mb20">
          <input class="input-age form-control" type="number" :max='condition.age.max' min="0" v-model="condition.age.min"/>
          <i class="fas fa-arrows-alt-h"></i>
          <input class="input-age form-control" type="number" :min='condition.age.min' max="100" v-model="condition.age.max"/>
        </div>
      </div> -->
    </div>
    <!-- <div class="row">
      <div class="col-md-6 mb10">
        <label>
          <i class="fas fa-globe-europe icon-color"></i>
        </label>
          都道府県
        <div class="d-flex align-items-center">
          <select v-model="condition.prefecture" class="form-control">
            <option v-for="(item, index) in options_prefecture" :key="index" :value="item.value">
              {{
              item.text
              }}
            </option>
          </select>
        </div>
      </div>
      <div class="col-md-6 mb10">
       <label>
          <i class="fas fa-user-friends icon-color"></i>
        </label>
          性別
        <div class="d-flex align-items-center" >
          <button v-for="(item, index) in options_gender" :key="index" :class="condition.gender == item.value? 'active-button btn btn-outline-success button-condition': 'btn btn-outline-success button-condition'">
            <label class="radio-inline"  >
              <input type="radio" :value="item.value" v-model="condition.gender" :checked="item.value == condition.gender">{{item.text}}
            </label>
          </button>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12">
        <label>
            <i class="fas fa-birthday-cake icon-color"></i>
        </label>
          誕生日月
        <div class="flex start">
          <button :class="condition.month_birthday.includes(item.value)? 'active-button btn btn-outline-success button-condition mb10': 'mb10 btn btn-outline-success button-condition'" v-for="(item, index) in options_month" :key="index" >
            <label class="checkbox-inline">
              <input type="checkbox" :value="item.value" v-model="condition.month_birthday" >{{item.text}}
            </label>
          </button>
        </div>
      </div>
    </div>

    <label>
      <i class="fas fa-envelope icon-color"></i>
    </label>

      未読ユーザーの除外設定
    <div class="d-flex align-items-center mb20" >
      <label class="checkbox-inline" >
        <input type="checkbox" v-model="condition.message_status">
        未読ユーザーの除外する
      </label>
    </div> -->
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['data'],

  data() {
    return {
      options_prefecture: this.Prefecture,
      options_gender: this.Gender,
      options_month: this.MonthBirthday,
      condition: {
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
      }
    };
  },
  created() {
    if (this.data) {
      Object.assign(this.condition, this.data);
    }
  },
  watch: {
    condition: {
      handler(val) {
        if (val.add_friend_date.start_date) {
          val.add_friend_date.start_date = Util.setDefaultFormatDate(val.add_friend_date.start_date);
        }

        if (val.add_friend_date.end_date) {
          val.add_friend_date.end_date = Util.setDefaultFormatDate(val.add_friend_date.end_date);
        }

        this.$emit('input', val);
      },
      deep: true
    }
  }
};
</script>

<style  lang="scss" scoped>
::v-deep {
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
