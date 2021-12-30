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
          <!-- 氏名 -->
          <div class="form-group row">
            <label class="col-lg-4">氏名<required-mark></required-mark></label>
            <div class="col-lg-8">
              <ValidationProvider name="氏名" :rules="'required|max:255'" v-slot="{ errors }">
                <input
                  type="text"
                  name="inquiry[name]"
                  class="form-control mt-2"
                  placeholder="氏名を入力してください"
                  v-model.trim="inquiryFormData.name"
                />
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>

          <!-- 電話番号 -->
          <div class="form-group row">
            <label class="col-lg-4">電話番号<required-mark></required-mark></label>
            <div class="col-lg-8">
              <ValidationProvider name="電話番号" rules="required|numeric|min:10|max:11" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="inquiry[phone_number]"
                  placeholder="携帯電話を入力してください"
                  maxlength="12"
                  v-model.trim="inquiryFormData.phone_number"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>

          <!-- 予約日時 -->
          <div class="form-group row">
            <label class="col-lg-4">予約日時<required-mark /></label>
            <div class="col-lg-8">
              <ValidationProvider name="予約日時" rules="required" v-slot="{ errors }">
                <datetime
                  input-class="form-control"
                  type="date"
                  :phrases="{ ok: '確定', cancel: '閉じる' }"
                  placeholder="予約日時を選択してください"
                  :min-datetime="currentDate"
                  name="inquiry[date]"
                  value-zone="Asia/Tokyo"
                  zone="Asia/Tokyo"
                  v-model="inquiryFormData.date"
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
        name: null,
        phone_number: null,
        date: null
      }
    };
  },

  async beforeMount() {
    this.loading = false;
  },

  mounted() {
    this.inquiryFormData.date = this.currentDate;
  },

  computed: {
    formAction() {
      return `${this.rootPath}/reservations/inquire/${this.friendLineId}`;
    },

    currentDate() {
      return moment()
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