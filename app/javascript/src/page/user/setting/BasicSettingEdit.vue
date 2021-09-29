<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">基本設定の編集</h3>
    </div>
    <div class="form-setting">
      <div class="form-group">
        <div class="w-100">
          <label>店舗/会社名<span class="required">*</span></label>
          <div class="btn-close fz14">
            <a :href="route"><i class="fas fa-times-circle"></i>編集</a>
          </div>
        </div>
        <input type="text" class="form-control" placeholder="店舗/会社名を入力してください" v-model="setting.companyName" required>
      </div>
      <div class="form-group">
        <label>住所<span class="required">*</span></label>
        <input type="text" class="form-control" placeholder="住所を入力して下さい。" v-model="setting.address" required>
      </div>
      <div class="form-group">
        <label>営業時間</label>
        <ul class="list-unstyled list-form-business no-mgn">
          <li class="flex ai_center">
            <p class="week no-mgn">月曜日</p>
            <div class="toggle-switch mr-2">
              <input id="mon-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.mon.status" />
              <label for="mon-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.mon.status"
                v-model="setting.businessHours.mon.start"
                input-size="sm"
                :error="!setting.businessHours.mon.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.mon.status"
                v-model="setting.businessHours.mon.end"
                input-size="sm"
                :error="!setting.businessHours.mon.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">火曜日</p>
            <div class="toggle-switch mr-2">
              <input id="tue-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.tue.status" />
              <label for="tue-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.tue.status"
                v-model="setting.businessHours.tue.start"
                input-size="sm"
                :error="!setting.businessHours.tue.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.tue.status"
                v-model="setting.businessHours.tue.end"
                input-size="sm"
                :error="!setting.businessHours.tue.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">水曜日</p>
            <div class="toggle-switch mr-2">
              <input id="wed-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.wed.status"/>
              <label for="wed-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.wed.status"
                v-model="setting.businessHours.wed.start"
                input-size="sm"
                :error="!setting.businessHours.wed.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.wed.status"
                v-model="setting.businessHours.wed.end"
                input-size="sm"
                :error="!setting.businessHours.wed.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">木曜日</p>
            <div class="toggle-switch mr-2">
              <input id="thu-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.thu.status"/>
              <label for="thu-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.thu.status"
                v-model="setting.businessHours.thu.start"
                input-size="sm"
                :error="!setting.businessHours.thu.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.thu.status"
                v-model="setting.businessHours.thu.end"
                input-size="sm"
                :error="!setting.businessHours.thu.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">金曜日</p>
            <div class="toggle-switch mr-2">
              <input id="fri-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.fri.status"/>
              <label for="fri-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.fri.status"
                v-model="setting.businessHours.fri.start"
                input-size="sm"
                :error="!setting.businessHours.fri.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.fri.status"
                v-model="setting.businessHours.fri.end"
                input-size="sm"
                :error="!setting.businessHours.fri.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">土曜日</p>
            <div class="toggle-switch mr-2">
              <input id="sat-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.sat.status"/>
              <label for="sat-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.sat.status"
                v-model="setting.businessHours.sat.start"
                input-size="sm"
                :error="!setting.businessHours.sat.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.sat.status"
                v-model="setting.businessHours.sat.end"
                input-size="sm"
                :error="!setting.businessHours.sat.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
          <li class="flex ai_center">
            <p class="week no-mgn">日曜日</p>
            <div class="toggle-switch mr-2">
              <input id="sun-onoff" class="toggle-input" type="checkbox" v-model="setting.businessHours.sun.status"/>
              <label for="sun-onoff" class="toggle-label" />
              <span></span>
            </div>
            <div class="time flex ai_center">
              <VueCtkDateTimePicker label="00:00"
                :disabled="!setting.businessHours.sun.status"
                v-model="setting.businessHours.sun.start"
                input-size="sm"
                :error="!setting.businessHours.sun.start"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
              &nbsp;～&nbsp;
              <VueCtkDateTimePicker label="23:59"
                :disabled="!setting.businessHours.sun.status"
                v-model="setting.businessHours.sun.end"
                input-size="sm"
                :error="!setting.businessHours.sun.end"
                no-label :only-time="true"
                format="HH:mm"
                formatted="HH:mm" />
            </div>
          </li>
        </ul>
      </div>
      <div class="form-group">
        <label>電話番号<span class="required">*</span></label>
        <input type="tel" class="form-control" placeholder="電話番号を入力して下さい。"
               v-model="setting.phoneNumber" pattern="[0-9]{3}[0-9]{2,5}[0-9]{2,4}" required>
      </div>
      <div class="form-group">
        <label>ウェブサイト<span class="required">*</span></label>
        <input type="text" class="form-control" placeholder="ウェブサイトのURLを入力して下さい。" v-model="setting.website" required>
      </div>
      <div class="form-group">
        <label>メールアドレス<span class="required">*</span></label>
        <input type="email" class="form-control" placeholder="メールアドレスを入力して下さい。" v-model="setting.email" required>
      </div>
      <button type="submit" class="btn btn-save btn-block" @click="editSetting()" :disabled="isSubmit">保存</button>
    </div>
  </div>
</template>
<script>
export default {
  props: ['route'],
  data() {
    return {
      locale: 'en',
      isSubmit: true,
      setting: {
        companyName: '',
        lineAccountId: '',
        address: '',
        phoneNumber: '',
        website: '',
        email: '',
        businessHours: {
          mon: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          tue: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          wed: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          thu: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          fri: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          sat: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          },
          sun: {
            start: '',
            end: '',
            status: false,
            isValidate: false
          }
        }
      }
    };
  },

  beforeMount() {
    this.getBasicSetting();
  },

  methods: {
    getBasicSetting() {
      this.$store.dispatch('setting/getSettingBasic').done(res => {
        const data = res;
        this.setting.lineAccountId = data.line_account_id;
        this.setting.companyName = data.company_name;
        this.setting.address = data.address;
        this.setting.businessHours = data.business_hours;
        this.setting.phoneNumber = data.phone_number;
        this.setting.website = data.website;
        this.setting.email = data.email;
      }).fail(e => {
      });
    },

    editSetting() {
      const query = {
        line_account_id: this.setting.lineAccountId,
        company_name: this.setting.companyName,
        address: this.setting.address,
        business_hours: this.setting.businessHours,
        phone_number: this.setting.phoneNumber,
        website: this.setting.website,
        email: this.setting.email
      };

      if (this.isSubmit === true) { return; }

      this.$store.dispatch('setting/putEditSettingBasic', query).done(res => {
        window.toastr.success('', '成功しました');
        window.location.href = this.route;
      }).fail(e => {
        const errorMsg = JSON.parse(e.responseText);
        const msg = Object.keys(errorMsg).map(function(key, _) {
          return errorMsg[key];
        });
        window.toastr.error(msg, 'エラーを発生しました');
      });
    },
    stateDate(day) {
      const today = new Date().toISOString().slice(0, 10);
      day.isValidate = day.status === false ||
          (Date.parse(today + ' ' + day.start) < Date.parse(today + ' ' + day.end));
      return day.isValidate;
    }
  },
  watch: {
    setting: {
      handler(val) {
        const isVali = Object.keys(val.businessHours).find(o => val.businessHours[o].isValidate === false &&
            (val.businessHours[o].status === 'true' || val.businessHours[o].status === true));

        if (!isVali &&
            val.companyName &&
            val.lineAccountId &&
            val.address &&
            val.phoneNumber &&
            val.website &&
            val.email) {
          this.isSubmit = false;
        } else {
          this.isSubmit = true;
        }
      },
      deep: true
    }
  }
};
</script>
<style lang="scss" scoped>
  span.required {
    color: red;
  }

  .btn-close {
    float: right;
  }

  .btn-close a {
    background: #5c5c5c;
    color: #fff;
    padding: 3px 10px;
    border-radius: 5px;
  }

  .form-control.is-invalid, .was-validated .form-control:invalid {
    border-color: #dc3545;
  }
  .text-center {
    text-align: center!important;
  }

  .d-inline-flex {
    display: inline-flex!important;
  }
</style>
