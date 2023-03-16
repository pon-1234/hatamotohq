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
      <input type="hidden" name="precheckin[friend_line_id]" :value="friendLineId" />
      <div class="card">
        <div class="card-header border-bottom border-success"><h4>事前チェックインフォーム</h4></div>
        <div class="card-body">
          <div v-show="firstStep">
            <ValidationObserver ref="innerObs">
              <!-- お名前 -->
              <div class="form-group row">
                <label class="col-lg-4">お名前<required-mark></required-mark></label>
                <div class="col-lg-8">
                  <ValidationProvider name="お名前" rules="required|max:255" v-slot="{ errors }">
                    <input
                      type="text"
                      class="form-control"
                      name="precheckin[name]"
                      placeholder="お名前を入力してください"
                      v-model.trim="precheckinFormData.name"
                    />
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>

              <!-- 電話番号 -->
              <div class="form-group row">
                <label class="col-lg-4">電話番号<required-mark></required-mark></label>
                <div class="col-lg-8">
                  <ValidationProvider name="電話番号" rules="required|numeric|min:10|max:11" v-slot="{ errors }">
                    <input
                      type="number"
                      class="form-control"
                      name="precheckin[phone_number]"
                      placeholder="電話番号を入力してください"
                      v-model.trim="precheckinFormData.phone_number"
                    />
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>

              <!-- チェックイン日 -->
              <div class="form-group row">
                <label class="col-lg-4">チェックイン日<required-mark /></label>
                <div class="col-lg-8">
                  <ValidationProvider name="チェックイン日" rules="required" v-slot="{ errors }">
                    <datetime
                      input-class="form-control"
                      type="date"
                      :phrases="{ ok: '確定', cancel: '閉じる' }"
                      placeholder="チェックイン日を選択してください"
                      name="precheckin[check_in_date]"
                      value-zone="Asia/Tokyo"
                      zone="Asia/Tokyo"
                      v-model="precheckinFormData.check_in_date"
                      format="yyyy-MM-dd"
                    ></datetime>
                    <error-message :message="errors[0]"></error-message>
                  </ValidationProvider>
                </div>
              </div>

              <!-- 住所 -->
              <div class="form-group row">
                <label class="col-lg-4">住所<required-mark></required-mark></label>
                <div class="col-lg-8">
                  <ValidationProvider name="住所" rules="required|max:255" v-slot="{ errors }">
                    <input
                      type="text"
                      class="form-control"
                      name="precheckin[address]"
                      placeholder="住所を入力してください"
                      maxlength="256"
                      v-model.trim="precheckinFormData.address"
                    />
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                </div>
              </div>
            </ValidationObserver>
          </div>
          <div v-show="!firstStep">
            <!-- 年齢層 -->
            <div class="form-group row">
              <label class="col-lg-4">年齢層<required-mark></required-mark></label>
              <div class="col-lg-8">
                <ValidationProvider name="年齢層" rules="required" v-slot="{ errors }">
                  <select v-model="precheckinFormData.age_group" name="precheckin[age_group]" class="form-control">
                    <option v-for="age in ageOptions" :key="age" :value="age">
                      {{ age }}代
                    </option>
                    <option :key="80" :value="80">80代以上</option>
                  </select>
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>

            <!-- 同伴者 -->
            <div class="form-group row">
              <label class="col-lg-4">同伴者<required-mark></required-mark></label>
              <div class="col-lg-8">
                <ValidationProvider name="同伴者" rules="required" v-slot="{ errors }">
                  <select v-model="precheckinFormData.companion" name="precheckin[companion]" class="form-control">
                    <option v-for="(companion, key) in companionOptions" :key="key" :value="key">
                      {{ companion }}
                    </option>
                  </select>
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>

            <!-- 性別 -->
            <div class="form-group row">
              <label class="col-lg-4">性別<required-mark></required-mark></label>
              <div class="col-lg-8">
                <ValidationProvider name="性別" rules="required" v-slot="{ errors }">
                  <select v-model="precheckinFormData.gender" name="precheckin[gender]" class="form-control">
                    <option v-for="(gender, index) in genders" :key="index" :value="index">
                      {{ gender }}
                    </option>
                  </select>
                  <span class="error-explanation">{{ errors[0] }}</span>
                </ValidationProvider>
              </div>
            </div>
          </div>
        </div>
        <div v-show="firstStep">
          <div class="card-footer border-top border-success text-center py-3">
            <button type="button" class="btn btn-success fw-120" @click="nextStep()">次へ</button>
          </div>
        </div>
        <div v-show="!firstStep">
          <div class="card-footer border-top border-success text-center py-3">
            <button type="button" class="btn btn-success fw-120 back-button" @click="firstStep = !firstStep">戻る</button>
            <button type="submit" class="btn btn-success fw-120">送信</button>
          </div>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </form>
  </ValidationObserver>
</template>

<script>
import Util from '@/core/util.js';
import { Datetime } from 'vue-datetime';

export default {
  props: ['friendLineId', 'precheckinData'],
  components: {
    Datetime
  },

  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      firstStep: true,
      ageOptions: [10, 20, 30, 40, 50, 60, 70],
      genders: ['男性', '女性', 'その他', '回答しない'],
      companionOptions: {
        single: '一人',
        couple: '恋人',
        family: '家族',
        friends: '友達',
        coworker: '同僚'
      },
      precheckinFormData: {
        name: null,
        phone_number: null,
        check_in_date: null,
        address: null,
        age_group: null,
        companion: null,
        gender: null
      }
    };
  },

  async beforeMount() {
    this.loading = false;
  },

  created() {
    Object.assign(this.precheckinFormData, this.precheckinData);
  },

  computed: {
    formAction() {
      return `${this.rootPath}/reservations/precheckin_detail/${this.friendLineId}`;
    }
  },

  methods: {
    async onSubmit(e) {
      this.$refs.form.submit();
    },
    nextStep() {
      this.$refs.innerObs.validate().then(success => {
        if (success) {
          this.firstStep = !this.firstStep;
        }
      });
    }
  }
};
</script>
<style lang="scss" scoped>
  .back-button {
    margin-right: 100px;
  }
</style>