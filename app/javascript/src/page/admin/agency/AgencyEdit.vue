<template>
  <div>
    <div class="card">
      <div class="card-header"><h4>基本情報</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">メールアドレス<required-mark /></label>
            <div class="col-xl-9">
              <input
                type="text"
                class="form-control"
                name="agency[email]"
                placeholder="入力してください"
                :value="agencyFormData.email"
                maxlength="256"
                disabled
              />
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">代理店名<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="代理店名" rules="required|max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[name]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.name"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">住所</label>
            <div class="col-xl-9">
              <ValidationProvider name="住所" rules="max:255" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[address]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.address"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">電話番号</label>
            <div class="col-xl-9">
              <ValidationProvider name="電話番号" rules="numeric|min:10|max:11" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[phone_number]"
                  placeholder="入力してください"
                  maxlength="12"
                  v-model.trim="agencyFormData.phone_number"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(submitUpdateInfo)">変更</div>
        </div>
      </ValidationObserver>
    </div>

    <div class="card">
      <div class="card-header"><h4>パースワード変更</h4></div>
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-xl-3">パスワード<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード" rules="required|min:8|max:128" v-slot="{ errors }" vid="password">
                <input
                  type="text"
                  class="form-control"
                  name="agency[password]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.password"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-xl-3">パスワード（確認用）<required-mark /></label>
            <div class="col-xl-9">
              <ValidationProvider name="パスワード（確認用）" rules="required|confirmed:password" v-slot="{ errors }">
                <input
                  type="text"
                  class="form-control"
                  name="agency[password_confirmation]"
                  placeholder="入力してください"
                  maxlength="256"
                  v-model.trim="agencyFormData.password_confirmation"
                />
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(submitUpdatePassword)">変更</div>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['agency'],
  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      submitted: false,
      agencyFormData: {
        id: null,
        email: null,
        password: null,
        password_confirmation: null,
        name: null,
        address: null,
        phone_number: null
      }
    };
  },
  created() {
    Object.assign(this.agencyFormData, this.agency);
  },
  methods: {
    ...mapActions('agency', ['updateAgency']),

    submitUpdateInfo(e) {
      this.submitted = true;
      this.updateAgency(_.omit(this.agencyFormData, ['email']))
        .then(_ => {
          Util.showSuccessThenRedirect('代理店情報の変更は完了しました。', `${this.userRootUrl}/admin/agencies`);
        })
        .catch(error => {
          window.toastr.error(error.responseJSON.message);
        });
    },

    submitUpdatePassword() {
      this.submitted = true;
      const formData = _.pick(this.agencyFormData, ['id', 'password', 'password_confirmation']);
      this.updateAgency(formData)
        .then(_ => {
          Util.showSuccessThenRedirect('パースワードの変更は完了しました。', `${this.userRootUrl}/admin/agencies`);
        })
        .catch(_ => {
          window.toastr.error('エラーを発生しました。');
        });
    }
  }
};
</script>