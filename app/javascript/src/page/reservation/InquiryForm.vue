<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <input type="hidden" name="inquiry[friend_line_id]" :value="friendLineId" />
      <div class="card">
        <div class="card-header border-bottom border-success"><h4>予約フォーム</h4></div>
        <div class="card-body">
          <!-- 部屋数 -->
          <div class="form-group row">
            <label class="col-lg-4">部屋数<required-mark></required-mark></label>
            <div class="col-lg-8">
              <ValidationProvider name="部屋数" rules="required|numeric|min_value:1|max_value:1000" v-slot="{ errors }">
                <input
                  type="number"
                  class="form-control"
                  name="inquiry[num_room]"
                  placeholder="部屋数を入力してください"
                  v-model.trim="inquiryFormData.num_room"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <!-- チェックイン日付 -->
          <div class="form-group row">
            <label class="col-lg-4">チェックイン日付<required-mark /></label>
            <div class="col-lg-8">
              <ValidationProvider name="チェックイン日付" rules="required" v-slot="{ errors }">
                <datetime
                  input-class="form-control"
                  type="date"
                  :phrases="{ ok: '確定', cancel: '閉じる' }"
                  placeholder="チェックイン日付を選択してください"
                  name="inquiry[date_start]"
                  value-zone="Asia/Tokyo"
                  zone="Asia/Tokyo"
                  v-model="inquiryFormData.date_start"
                  format="yyyy-MM-dd"
                ></datetime>
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>

          <!-- チェックアウト日付 -->
          <div class="form-group row">
            <label class="col-lg-4">チェックアウト日付<required-mark /></label>
            <div class="col-lg-8">
              <ValidationProvider name="チェックアウト日付" rules="required" v-slot="{ errors }">
                <datetime
                  input-class="form-control"
                  type="date"
                  :phrases="{ ok: '確定', cancel: '閉じる' }"
                  :min-datetime="inquiryFormData.date_start"
                  placeholder="チェックアウト日付を選択してください"
                  name="inquiry[date_end]"
                  value-zone="Asia/Tokyo"
                  zone="Asia/Tokyo"
                  v-model="inquiryFormData.date_end"
                  format="yyyy-MM-dd"
                ></datetime>
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer border-top border-success text-center py-3">
          <button type="submit" class="btn btn-success fw-120">送信</button>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </form>
  </ValidationObserver>
</template>

<script>
import Util from '@/core/util.js';
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';

export default {
  props: {
    friendLineId: {
      type: String
    }
  },

  components: {
    Datetime
  },

  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      inquiryFormData: {
        friend_line_id: null,
        num_room: null,
        date_start: null,
        date_end: null
      }
    };
  },

  async beforeMount() {
    this.loading = false;
  },

  mounted() {
    this.inquiryFormData.date_start = this.defaultStartDate;
    this.inquiryFormData.date_end = this.defaultEndDate;
  },

  computed: {
    formAction() {
      return `${this.rootPath}/reservations/inquire/${this.friendLineId}`;
    },

    defaultStartDate() {
      return moment()
        .add(1, 'days')
        .tz('Asia/Tokyo')
        .format();
    },

    defaultEndDate() {
      return moment()
        .add(2, 'day')
        .tz('Asia/Tokyo')
        .format();
    }
  },

  methods: {
    async onSubmit(e) {
      this.$refs.form.submit();
    }
  }
};
</script>
