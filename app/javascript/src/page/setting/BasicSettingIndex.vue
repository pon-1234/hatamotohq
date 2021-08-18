<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">基本設定</h3>
    </div>
    <div class="tbl-setting">
      <div class="btn-edit fz14">
        <a :href="route"><i class="fas fa-edit"></i>編集</a>
      </div>
      <table>
        <tbody>
        <tr>
          <th>店舗/会社名</th>
          <td>{{companyName}}</td>
        </tr>
        <tr>
          <th>住所</th>
          <td>{{address}}</td>
        </tr>
        <tr>
          <th>営業時間</th>
          <td>
            <ul class="list-unstyled list-business no-mgn" v-for="day in days" :key="day.key">
              <li v-bind:class="{ business: businessHours[day.key] && businessHours[day.key].status == true ,
                                holiday: businessHours[day.key] && businessHours[day.key].status == false }">
                <dl class="flex start">
                  <dt>{{day.label}}</dt>
                  <dd v-if="businessHours[day.key] && businessHours[day.key].status">
                    {{businessHours[day.key].start ? businessHours[day.key].start.substring(0, 5) : "--:--"}}
                    ～
                    {{businessHours[day.key].end ? businessHours[day.key].end.substring(0, 5) : "--:--"}}
                  </dd>
                  <dd v-else-if="businessHours[day.key]">--:--～--:--</dd>
                  <dd v-else></dd>
                </dl>
              </li>
            </ul>
          </td>
        </tr>
        <tr>
          <th>電話番号</th>
          <td>{{this.phoneNumber}}</td>
        </tr>
        <tr>
          <th>ウェブサイト</th>
          <td>{{this.website}}</td>
        </tr>
        <tr>
          <th>メール<br class="sp-only">アドレス</th>
          <td>{{this.email}}</td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script>
export default {
  props: ['route'],
  data() {
    return {
      days: [
        { key: 'mon', label: '月曜日' },
        { key: 'tue', label: '火曜日' },
        { key: 'wed', label: '水曜日' },
        { key: 'thu', label: '木曜日' },
        { key: 'fri', label: '金曜日' },
        { key: 'sat', label: '土曜日' },
        { key: 'sun', label: '日曜日' }
      ],
      companyName: '',
      lineAccountId: '',
      address: '',
      businessHours: {},
      phoneNumber: '',
      website: '',
      email: ''
    };
  },

  beforeMount() {
    this.getBasicSetting();
  },

  mounted() {

  },

  methods: {
    getBasicSetting() {
      this.$store
        .dispatch('setting/getSettingBasic')
        .done(res => {
          const data = res;
          this.lineAccountId = data.line_account_id;
          this.companyName = data.company_name;
          this.address = data.address;
          this.businessHours = data.business_hours;
          this.phoneNumber = data.phone_number;
          this.website = data.website;
          this.email = data.email;
        })
        .fail(e => {
        });
    }
  }
};
</script>
